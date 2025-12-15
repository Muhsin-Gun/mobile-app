require('dotenv').config();
const express = require('express');
const session = require('express-session');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const cors = require('cors');
const https = require('https');
const path = require('path');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = 5000;
const BUILD_DIR = './build/web';

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Initialize database tables
async function initDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255),
        name VARCHAR(255),
        avatar_url TEXT,
        google_id VARCHAR(255) UNIQUE,
        is_premium BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_login TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS user_sessions (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        session_token VARCHAR(255) UNIQUE NOT NULL,
        expires_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS trading_history (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        symbol VARCHAR(50) NOT NULL,
        action VARCHAR(10) NOT NULL,
        price DECIMAL(18, 8),
        quantity DECIMAL(18, 8),
        pnl DECIMAL(18, 8),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS ai_conversations (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        message TEXT NOT NULL,
        response TEXT NOT NULL,
        context JSONB,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('Database tables initialized');
  } catch (error) {
    console.error('Database init error:', error.message);
  }
}

// Middleware
app.use(cors({
  origin: true,
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(session({
  secret: process.env.SESSION_SECRET || 'cryptex-trading-secret-key-2024',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    httpOnly: true,
    maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
  }
}));

app.use(passport.initialize());
app.use(passport.session());

// Passport serialization
passport.serializeUser((user, done) => done(null, user.id));
passport.deserializeUser(async (id, done) => {
  try {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    done(null, result.rows[0] || null);
  } catch (error) {
    done(error, null);
  }
});

// Google OAuth Strategy
if (process.env.GOOGLE_CLIENT_ID && process.env.GOOGLE_CLIENT_SECRET) {
  passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: '/api/auth/google/callback'
  }, async (accessToken, refreshToken, profile, done) => {
    try {
      let result = await pool.query('SELECT * FROM users WHERE google_id = $1', [profile.id]);
      
      if (result.rows.length === 0) {
        result = await pool.query(
          `INSERT INTO users (email, name, avatar_url, google_id) 
           VALUES ($1, $2, $3, $4) 
           ON CONFLICT (email) DO UPDATE SET google_id = $4, avatar_url = $3
           RETURNING *`,
          [profile.emails[0].value, profile.displayName, profile.photos[0]?.value, profile.id]
        );
      }
      
      await pool.query('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [result.rows[0].id]);
      done(null, result.rows[0]);
    } catch (error) {
      done(error, null);
    }
  }));
}

// M-Pesa Configuration
const MPESA_CONSUMER_KEY = process.env.MPESA_CONSUMER_KEY;
const MPESA_CONSUMER_SECRET = process.env.MPESA_CONSUMER_SECRET;
const MPESA_PASSKEY = process.env.MPESA_PASSKEY;
const MPESA_SHORTCODE = process.env.MPESA_SHORTCODE || '174379';
const MPESA_ENV = process.env.MPESA_ENV || 'sandbox';
const MPESA_BASE_URL = MPESA_ENV === 'sandbox' ? 'sandbox.safaricom.co.ke' : 'api.safaricom.co.ke';

// Utility functions
function makeHttpsRequest(options, postData = null) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          resolve({ statusCode: res.statusCode, data: JSON.parse(data) });
        } catch (e) {
          resolve({ statusCode: res.statusCode, data: data });
        }
      });
    });
    req.on('error', reject);
    if (postData) req.write(postData);
    req.end();
  });
}

async function getMpesaAccessToken() {
  const auth = Buffer.from(`${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`).toString('base64');
  const options = {
    hostname: MPESA_BASE_URL,
    path: '/oauth/v1/generate?grant_type=client_credentials',
    method: 'GET',
    headers: { 'Authorization': `Basic ${auth}` }
  };
  const result = await makeHttpsRequest(options);
  if (result.statusCode === 200 && result.data.access_token) {
    return result.data.access_token;
  }
  throw new Error('Failed to get M-Pesa access token');
}

function generateTimestamp() {
  const now = new Date();
  const pad = (n) => n.toString().padStart(2, '0');
  return `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
}

function generatePassword(timestamp) {
  return Buffer.from(`${MPESA_SHORTCODE}${MPESA_PASSKEY}${timestamp}`).toString('base64');
}

// ===== AUTH ROUTES =====

// Email/Password Registration
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password required' });
    }

    const existingUser = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ success: false, message: 'Email already registered' });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (email, password_hash, name) VALUES ($1, $2, $3) RETURNING id, email, name, is_premium',
      [email, passwordHash, name || email.split('@')[0]]
    );

    const user = result.rows[0];
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET || 'cryptex-jwt-secret', { expiresIn: '7d' });

    res.json({
      success: true,
      user: { id: user.id, email: user.email, name: user.name, isPremium: user.is_premium },
      token
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Email/Password Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const user = result.rows[0];
    
    if (!user.password_hash) {
      return res.status(401).json({ success: false, message: 'Please use Google Sign-In for this account' });
    }

    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    await pool.query('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [user.id]);

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET || 'cryptex-jwt-secret', { expiresIn: '7d' });

    res.json({
      success: true,
      user: { id: user.id, email: user.email, name: user.name, avatarUrl: user.avatar_url, isPremium: user.is_premium },
      token
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Google OAuth Routes
app.get('/api/auth/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

app.get('/api/auth/google/callback', 
  passport.authenticate('google', { failureRedirect: '/?auth=failed' }),
  (req, res) => {
    const token = jwt.sign({ userId: req.user.id }, process.env.JWT_SECRET || 'cryptex-jwt-secret', { expiresIn: '7d' });
    res.redirect(`/?auth=success&token=${token}`);
  }
);

// Get current user
app.get('/api/auth/me', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, message: 'Not authenticated' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'cryptex-jwt-secret');
    
    const result = await pool.query(
      'SELECT id, email, name, avatar_url, is_premium, created_at FROM users WHERE id = $1',
      [decoded.userId]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ success: false, message: 'User not found' });
    }

    const user = result.rows[0];
    res.json({
      success: true,
      user: { id: user.id, email: user.email, name: user.name, avatarUrl: user.avatar_url, isPremium: user.is_premium }
    });
  } catch (error) {
    res.status(401).json({ success: false, message: 'Invalid token' });
  }
});

// Logout
app.post('/api/auth/logout', (req, res) => {
  req.logout(() => {
    req.session.destroy();
    res.json({ success: true });
  });
});

// ===== AI TRADING ASSISTANT =====

const GROQ_API_KEY = process.env.GROQ_API_KEY;

async function callGroqAI(messages, systemPrompt) {
  if (!GROQ_API_KEY) {
    return { success: false, message: 'AI service not configured' };
  }

  const payload = JSON.stringify({
    model: 'llama-3.1-70b-versatile',
    messages: [
      { role: 'system', content: systemPrompt },
      ...messages
    ],
    temperature: 0.7,
    max_tokens: 2000
  });

  const options = {
    hostname: 'api.groq.com',
    path: '/openai/v1/chat/completions',
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${GROQ_API_KEY}`,
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload)
    }
  };

  try {
    const result = await makeHttpsRequest(options, payload);
    if (result.statusCode === 200 && result.data.choices) {
      return { success: true, response: result.data.choices[0].message.content };
    }
    return { success: false, message: 'AI request failed' };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

const TRADING_AI_SYSTEM_PROMPT = `You are CrypTex AI, an expert trading assistant specializing in ICT (Inner Circle Trader), SMC (Smart Money Concepts), and advanced technical analysis.

Your knowledge includes:
- Order Blocks, Fair Value Gaps (FVG), Liquidity Sweeps
- Market Structure (BOS, CHoCH, HH/HL, LH/LL)
- Kill Zones (London, New York, Asian sessions)
- SMT Divergence analysis
- DOM (Depth of Market) and Footprint charts
- Risk management and position sizing
- Price action and candlestick patterns
- Fibonacci retracements and extensions

When analyzing trades:
1. Always identify the higher timeframe bias first
2. Look for confluence (multiple factors aligning)
3. Wait for proper entry confirmations
4. Use tight stop losses at logical levels
5. Target liquidity pools for take profit

Provide specific, actionable advice with clear entry/exit levels when possible.
Be concise but thorough. Use trading terminology appropriately.`;

// AI Chat endpoint
app.post('/api/ai/chat', async (req, res) => {
  try {
    const { message, context } = req.body;
    
    if (!message) {
      return res.status(400).json({ success: false, message: 'Message required' });
    }

    const messages = [{ role: 'user', content: message }];
    
    if (context) {
      messages.unshift({ 
        role: 'user', 
        content: `Current market context: ${JSON.stringify(context)}` 
      });
    }

    const result = await callGroqAI(messages, TRADING_AI_SYSTEM_PROMPT);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// AI Trade Analysis endpoint
app.post('/api/ai/analyze', async (req, res) => {
  try {
    const { symbol, price, timeframe, indicators } = req.body;
    
    const analysisPrompt = `Analyze ${symbol} at price ${price} on ${timeframe} timeframe.
${indicators ? `Technical indicators: ${JSON.stringify(indicators)}` : ''}

Provide:
1. Market Structure Analysis (trend, key levels)
2. Order Block & FVG zones to watch
3. Liquidity pools (BSL/SSL)
4. Trade setup if one exists (entry, SL, TP with exact levels)
5. Risk assessment (1-10 scale)
6. Confluence score (how many factors align)`;

    const result = await callGroqAI([{ role: 'user', content: analysisPrompt }], TRADING_AI_SYSTEM_PROMPT);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// AI Signal Generation
app.post('/api/ai/signal', async (req, res) => {
  try {
    const { symbol, currentPrice, recentCandles, structure } = req.body;
    
    const signalPrompt = `Generate a trading signal for ${symbol} at ${currentPrice}.

Market structure: ${structure || 'Unknown'}
Recent price action: ${recentCandles ? JSON.stringify(recentCandles.slice(-5)) : 'Not provided'}

Provide a JSON response with:
{
  "signal": "BUY" or "SELL" or "WAIT",
  "confidence": 0-100,
  "entry": price,
  "stopLoss": price,
  "takeProfit1": price,
  "takeProfit2": price,
  "takeProfit3": price,
  "riskReward": ratio,
  "reasoning": "brief explanation",
  "keyLevels": ["level1", "level2"],
  "warnings": ["any cautions"]
}`;

    const result = await callGroqAI([{ role: 'user', content: signalPrompt }], TRADING_AI_SYSTEM_PROMPT);
    
    if (result.success) {
      try {
        const jsonMatch = result.response.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          const signalData = JSON.parse(jsonMatch[0]);
          res.json({ success: true, signal: signalData, rawAnalysis: result.response });
        } else {
          res.json({ success: true, rawAnalysis: result.response });
        }
      } catch {
        res.json({ success: true, rawAnalysis: result.response });
      }
    } else {
      res.json(result);
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// ===== M-PESA ROUTES =====

async function initiateSTKPush(phoneNumber, amount, accountReference, transactionDesc, callbackUrl) {
  const token = await getMpesaAccessToken();
  const timestamp = generateTimestamp();
  const password = generatePassword(timestamp);

  let formattedPhone = phoneNumber.replace(/\D/g, '');
  if (formattedPhone.startsWith('0')) {
    formattedPhone = '254' + formattedPhone.substring(1);
  } else if (!formattedPhone.startsWith('254')) {
    formattedPhone = '254' + formattedPhone;
  }

  const payload = JSON.stringify({
    BusinessShortCode: MPESA_SHORTCODE,
    Password: password,
    Timestamp: timestamp,
    TransactionType: 'CustomerPayBillOnline',
    Amount: amount,
    PartyA: formattedPhone,
    PartyB: MPESA_SHORTCODE,
    PhoneNumber: formattedPhone,
    CallBackURL: callbackUrl,
    AccountReference: accountReference,
    TransactionDesc: transactionDesc,
  });

  const options = {
    hostname: MPESA_BASE_URL,
    path: '/mpesa/stkpush/v1/processrequest',
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload)
    }
  };

  const result = await makeHttpsRequest(options, payload);
  
  if (result.statusCode === 200 && result.data.ResponseCode === '0') {
    return {
      success: true,
      message: 'STK Push sent successfully',
      checkoutRequestId: result.data.CheckoutRequestID,
      merchantRequestId: result.data.MerchantRequestID,
    };
  } else {
    return {
      success: false,
      message: result.data.errorMessage || result.data.ResponseDescription || 'Payment initiation failed',
    };
  }
}

app.post('/api/mpesa/stk-push', async (req, res) => {
  try {
    const { phoneNumber, amount, accountReference, transactionDesc, callbackUrl } = req.body;
    
    if (!phoneNumber || !amount) {
      return res.status(400).json({ success: false, message: 'Phone number and amount are required' });
    }

    const result = await initiateSTKPush(
      phoneNumber, 
      parseInt(amount), 
      accountReference || 'CrypTex', 
      transactionDesc || 'Payment',
      callbackUrl || 'https://example.com/callback'
    );
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

app.post('/api/mpesa/query', async (req, res) => {
  try {
    const { checkoutRequestId } = req.body;
    const token = await getMpesaAccessToken();
    const timestamp = generateTimestamp();
    const password = generatePassword(timestamp);

    const payload = JSON.stringify({
      BusinessShortCode: MPESA_SHORTCODE,
      Password: password,
      Timestamp: timestamp,
      CheckoutRequestID: checkoutRequestId,
    });

    const options = {
      hostname: MPESA_BASE_URL,
      path: '/mpesa/stkpushquery/v1/query',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload)
      }
    };

    const result = await makeHttpsRequest(options, payload);
    res.json(result.data);
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

app.post('/api/mpesa/callback', (req, res) => {
  console.log('M-Pesa Callback received:', JSON.stringify(req.body, null, 2));
  res.json({ ResultCode: 0, ResultDesc: 'Success' });
});

// ===== STATIC FILE SERVING =====

app.use(express.static(BUILD_DIR, {
  setHeaders: (res) => {
    res.setHeader('Cache-Control', 'no-cache');
  }
}));

app.get('/{*path}', (req, res) => {
  res.sendFile(path.join(__dirname, BUILD_DIR, 'index.html'));
});

// Start server
initDatabase().then(() => {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`CrypTex Trading server running at http://0.0.0.0:${PORT}/`);
    console.log(`Auth endpoints: /api/auth/*`);
    console.log(`AI endpoints: /api/ai/*`);
    console.log(`M-Pesa endpoints: /api/mpesa/*`);
  });
});

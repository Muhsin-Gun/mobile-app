const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = 5000;
const BUILD_DIR = './build/web';

const MPESA_CONSUMER_KEY = process.env.MPESA_CONSUMER_KEY;
const MPESA_CONSUMER_SECRET = process.env.MPESA_CONSUMER_SECRET;
const MPESA_PASSKEY = process.env.MPESA_PASSKEY;
const MPESA_SHORTCODE = process.env.MPESA_SHORTCODE || '174379';
const MPESA_ENV = process.env.MPESA_ENV || 'sandbox';

const MPESA_BASE_URL = MPESA_ENV === 'sandbox' 
  ? 'sandbox.safaricom.co.ke'
  : 'api.safaricom.co.ke';

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.ico': 'image/x-icon',
};

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

async function queryTransaction(checkoutRequestId) {
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

  return await makeHttpsRequest(options, payload);
}

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', (chunk) => { body += chunk; });
    req.on('end', () => {
      try {
        resolve(JSON.parse(body));
      } catch (e) {
        resolve({});
      }
    });
    req.on('error', reject);
  });
}

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, { 
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  });
  res.end(JSON.stringify(data));
}

const server = http.createServer(async (req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;

  if (req.method === 'OPTIONS') {
    res.writeHead(200, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type'
    });
    res.end();
    return;
  }

  if (pathname === '/api/mpesa/stk-push' && req.method === 'POST') {
    try {
      const body = await parseBody(req);
      const { phoneNumber, amount, accountReference, transactionDesc, callbackUrl } = body;
      
      if (!phoneNumber || !amount) {
        sendJson(res, 400, { success: false, message: 'Phone number and amount are required' });
        return;
      }

      const result = await initiateSTKPush(
        phoneNumber, 
        parseInt(amount), 
        accountReference || 'CrypTex', 
        transactionDesc || 'Payment',
        callbackUrl || 'https://example.com/callback'
      );
      sendJson(res, 200, result);
    } catch (error) {
      sendJson(res, 500, { success: false, message: error.message });
    }
    return;
  }

  if (pathname === '/api/mpesa/query' && req.method === 'POST') {
    try {
      const body = await parseBody(req);
      const { checkoutRequestId } = body;
      
      if (!checkoutRequestId) {
        sendJson(res, 400, { success: false, message: 'CheckoutRequestId is required' });
        return;
      }

      const result = await queryTransaction(checkoutRequestId);
      sendJson(res, 200, result.data);
    } catch (error) {
      sendJson(res, 500, { success: false, message: error.message });
    }
    return;
  }

  if (pathname === '/api/mpesa/callback' && req.method === 'POST') {
    const body = await parseBody(req);
    console.log('M-Pesa Callback received:', JSON.stringify(body, null, 2));
    sendJson(res, 200, { ResultCode: 0, ResultDesc: 'Success' });
    return;
  }

  let filePath = path.join(BUILD_DIR, pathname === '/' ? 'index.html' : pathname);
  const ext = path.extname(filePath).toLowerCase();
  const contentType = mimeTypes[ext] || 'application/octet-stream';
  
  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        fs.readFile(path.join(BUILD_DIR, 'index.html'), (err2, content2) => {
          if (err2) {
            res.writeHead(404);
            res.end('Not Found');
          } else {
            res.writeHead(200, { 'Content-Type': 'text/html', 'Cache-Control': 'no-cache' });
            res.end(content2);
          }
        });
      } else {
        res.writeHead(500);
        res.end('Server Error');
      }
    } else {
      res.writeHead(200, { 'Content-Type': contentType, 'Cache-Control': 'no-cache' });
      res.end(content);
    }
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`CrypTex Trading server running at http://0.0.0.0:${PORT}/`);
  console.log(`M-Pesa API endpoints available at /api/mpesa/*`);
});

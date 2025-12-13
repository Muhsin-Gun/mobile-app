import 'package:cryptex_trading/models/education.dart';

class EducationService {
  List<Course> getAllCourses() {
    return [
      _createICTCourse(),
      _createSMCCourse(),
      _createSMTCourse(),
      _createOrderFlowCourse(),
      _createPriceActionCourse(),
      _createQuantCourse(),
      _createFundamentalCourse(),
      _createRiskManagementCourse(),
      _createPsychologyCourse(),
    ];
  }

  Course _createICTCourse() {
    return Course(
      id: 'ict_mastery',
      title: 'ICT Trading Mastery - Complete Course',
      description: 'Master the Inner Circle Trader methodology. Learn how institutional traders move markets and how to trade alongside smart money.',
      category: CourseCategory.ict,
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 1200,
      rating: 4.9,
      enrolledCount: 15420,
      isPremium: true,
      lessons: [
        Lesson(id: 'ict_1', title: 'Introduction to ICT', orderIndex: 1, durationMinutes: 30,
          content: '''The ICT (Inner Circle Trader) methodology is based on understanding how institutional traders operate in the markets. Developed by Michael J. Huddleston, this approach focuses on identifying smart money footprints.

Key Principles:
• Markets are manipulated by large institutional players
• Retail traders often trade against smart money
• Understanding liquidity is the key to profitable trading
• Price action tells the story of institutional activity''',
          type: ContentType.article, keyPoints: ['Smart Money Concept', 'Institutional Trading', 'Liquidity Understanding']),
        
        Lesson(id: 'ict_2', title: 'Liquidity - The Foundation', orderIndex: 2, durationMinutes: 45,
          content: '''Liquidity is where stop losses cluster. Smart money hunts these areas.

BUY-SIDE LIQUIDITY (BSL):
• Located above swing highs
• Where short sellers place stop losses
• Smart money sells into this area
• Creates temporary spike up before reversal

SELL-SIDE LIQUIDITY (SSL):
• Located below swing lows
• Where long traders place stop losses
• Smart money buys into this area
• Creates temporary spike down before reversal

Identification Checklist:
✓ Prior swing highs/lows
✓ Round psychological numbers
✓ Weekly/Monthly highs/lows
✓ Session opening prices
✓ Equal highs/lows (double tops/bottoms)''',
          type: ContentType.article, keyPoints: ['BSL', 'SSL', 'Stop Hunt', 'Liquidity Pools']),

        Lesson(id: 'ict_3', title: 'Order Blocks Explained', orderIndex: 3, durationMinutes: 60,
          content: '''Order Blocks are the last candle before a significant directional move.

BULLISH ORDER BLOCK:
• Last bearish candle before bullish move
• Represents institutional buying zone
• Price often returns to this zone
• Acts as support

BEARISH ORDER BLOCK:
• Last bullish candle before bearish move
• Represents institutional selling zone
• Price often returns to this zone
• Acts as resistance

Order Block Strength Factors:
1. Volume confirmation (high volume = stronger)
2. Displacement power (larger move = stronger)
3. Freshness (untested OB = higher probability)
4. Multi-timeframe alignment
5. Proximity to liquidity''',
          type: ContentType.article, keyPoints: ['Order Block Definition', 'Bullish OB', 'Bearish OB', 'OB Trading']),

        Lesson(id: 'ict_4', title: 'Fair Value Gaps (FVG)', orderIndex: 4, durationMinutes: 50,
          content: '''Fair Value Gaps are price imbalances created by impulsive moves.

DEFINITION:
A three-candle formation where candle 2 creates a gap between candle 1 and candle 3.

BULLISH FVG:
• Gap between candle 1 high and candle 3 low
• Created during upward impulsive move
• Price tends to return and fill the gap
• Acts as support zone

BEARISH FVG:
• Gap between candle 1 low and candle 3 high
• Created during downward impulsive move
• Price tends to return and fill the gap
• Acts as resistance zone

FVG TRADING RULES:
1. Identify FVG after impulsive move
2. Wait for price to return to FVG zone
3. Enter when price enters the gap
4. Stop loss beyond the gap
5. Target next liquidity zone''',
          type: ContentType.article, keyPoints: ['FVG Definition', 'Bullish FVG', 'Bearish FVG', 'Gap Trading']),

        Lesson(id: 'ict_5', title: 'Break of Structure (BOS)', orderIndex: 5, durationMinutes: 40,
          content: '''Break of Structure confirms trend continuation or reversal.

BULLISH BOS:
• Price breaks above previous swing high
• Must close above the level (not just wick)
• Confirms bullish trend continuation
• Look for pullback entries

BEARISH BOS:
• Price breaks below previous swing low
• Must close below the level
• Confirms bearish trend continuation
• Look for pullback entries

BOS STRENGTH INDICATORS:
1. Volume on break (high = strong)
2. Displacement after break
3. Multi-timeframe confirmation
4. Speed of the break''',
          type: ContentType.article, keyPoints: ['BOS', 'Trend Confirmation', 'Structure Break']),

        Lesson(id: 'ict_6', title: 'Change of Character (CHoCH)', orderIndex: 6, durationMinutes: 45,
          content: '''Change of Character signals potential trend reversal.

DEFINITION:
When price behavior changes from one pattern to another, indicating shift in market control.

BULLISH TO BEARISH CHoCH:
• Previous: Higher Highs + Higher Lows
• CHoCH: First Lower Low printed
• Signals potential downtrend beginning
• Wait for confirmation before shorting

BEARISH TO BULLISH CHoCH:
• Previous: Lower Highs + Lower Lows
• CHoCH: First Higher High printed
• Signals potential uptrend beginning
• Wait for confirmation before longing

CHOCH TRADING:
1. Identify current market structure
2. Wait for CHoCH signal
3. Look for Order Block or FVG entry
4. Confirm with volume
5. Enter on retest with tight stop''',
          type: ContentType.article, keyPoints: ['CHoCH', 'Trend Reversal', 'Structure Shift']),

        Lesson(id: 'ict_7', title: 'ICT Kill Zones', orderIndex: 7, durationMinutes: 35,
          content: '''Kill Zones are specific time windows with highest probability setups.

LONDON KILL ZONE:
• Time: 2:00 AM - 5:00 AM EST
• High volatility period
• Major pair movements (EUR, GBP)
• Good for trend initiation

NEW YORK KILL ZONE:
• Time: 7:00 AM - 10:00 AM EST
• Highest volume period
• Best for continuation trades
• Watch for London reversal

ASIAN KILL ZONE:
• Time: 8:00 PM - 11:00 PM EST
• Lower volatility
• Range building period
• Good for JPY pairs

TRADING THE KILL ZONES:
1. Wait for kill zone to begin
2. Identify daily bias
3. Look for liquidity sweeps
4. Enter on Order Block or FVG
5. Target opposite liquidity''',
          type: ContentType.article, keyPoints: ['London Session', 'New York Session', 'Asian Session', 'Timing']),

        Lesson(id: 'ict_8', title: 'Power of Three (AMD)', orderIndex: 8, durationMinutes: 55,
          content: '''Power of Three describes the daily market cycle.

THE THREE PHASES:

1. ACCUMULATION:
• Occurs during Asian session
• Price ranges in tight consolidation
• Smart money building positions
• Low volume, minimal movement

2. MANIPULATION:
• Occurs at London/NY open
• False breakout of Asian range
• Triggers retail stop losses
• Smart money loading positions

3. DISTRIBUTION:
• The real move begins
• Strong directional momentum
• Smart money distributing
• Retail chasing the move

TRADING P03:
1. Mark Asian session range
2. Wait for manipulation sweep
3. Identify Order Block at sweep
4. Enter on reversal from sweep
5. Target opposite side of range (minimum)''',
          type: ContentType.article, keyPoints: ['Accumulation', 'Manipulation', 'Distribution', 'Daily Cycle']),
      ],
    );
  }

  Course _createSMCCourse() {
    return Course(
      id: 'smc_complete',
      title: 'Smart Money Concepts - Full Guide',
      description: 'Understand how banks and institutions trade. Learn to identify and follow smart money footprints in any market.',
      category: CourseCategory.smc,
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 900,
      rating: 4.8,
      enrolledCount: 12350,
      isPremium: false,
      lessons: [
        Lesson(id: 'smc_1', title: 'What is Smart Money?', orderIndex: 1, durationMinutes: 25,
          content: '''Smart Money refers to institutional traders who have significant capital and market influence.

WHO ARE SMART MONEY?
• Central Banks
• Commercial Banks
• Hedge Funds
• Market Makers
• Large Investment Firms

WHY FOLLOW SMART MONEY?
• They have more information
• They move markets
• Retail traders lose against them
• Following them = higher probability

KEY INSIGHT:
Smart Money needs liquidity to fill large orders. They engineer price movements to accumulate this liquidity from retail traders.''',
          type: ContentType.article, keyPoints: ['Institutional Traders', 'Market Makers', 'Liquidity']),

        Lesson(id: 'smc_2', title: 'Market Structure Basics', orderIndex: 2, durationMinutes: 40,
          content: '''Market Structure is the foundation of SMC analysis.

UPTREND STRUCTURE:
• Higher Highs (HH)
• Higher Lows (HL)
• Buyers in control
• Look for long entries on HL

DOWNTREND STRUCTURE:
• Lower Highs (LH)
• Lower Lows (LL)
• Sellers in control
• Look for short entries on LH

RANGING STRUCTURE:
• Equal highs and lows
• No clear direction
• Wait for breakout
• Trade the range edges

IDENTIFYING SWINGS:
1. Mark significant highs
2. Mark significant lows
3. Connect to see structure
4. Identify trend direction''',
          type: ContentType.article, keyPoints: ['HH HL', 'LH LL', 'Trend Structure', 'Swing Points']),

        Lesson(id: 'smc_3', title: 'Supply and Demand Zones', orderIndex: 3, durationMinutes: 50,
          content: '''Supply and Demand zones are areas of institutional interest.

DEMAND ZONE (Bullish OB):
• Area where buying occurred
• Price rallied from this zone
• Unfilled orders remain
• Price returns to fill orders
• Acts as support

SUPPLY ZONE (Bearish OB):
• Area where selling occurred
• Price dropped from this zone
• Unfilled orders remain
• Price returns to fill orders
• Acts as resistance

ZONE QUALITY FACTORS:
1. Strength of move away
2. Time spent at zone
3. Number of tests
4. Volume at zone
5. Fresh vs tested''',
          type: ContentType.article, keyPoints: ['Supply Zones', 'Demand Zones', 'Institutional Orders']),
      ],
    );
  }

  Course _createSMTCourse() {
    return Course(
      id: 'smt_divergence',
      title: 'SMT Divergence Trading',
      description: 'Learn to use multiple correlated instruments to identify smart money direction using SMT Divergence.',
      category: CourseCategory.smt,
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 600,
      rating: 4.7,
      enrolledCount: 8920,
      isPremium: true,
      lessons: [
        Lesson(id: 'smt_1', title: 'Understanding SMT Divergence', orderIndex: 1, durationMinutes: 35,
          content: '''SMT (Smart Money Tool) Divergence reveals smart money intent through correlated instruments.

DEFINITION:
When two normally-correlated instruments show divergent behavior, it signals smart money activity.

CORRELATION PAIRS:
• EURUSD vs GBPUSD (positive ~0.85)
• EURUSD vs USDCHF (negative ~-0.90)
• XAUUSD vs XAUEUR
• ES vs NQ (S&P vs Nasdaq)
• BTC vs ETH

DIVERGENCE TYPES:
1. One makes new high, other doesn't
2. One sweeps liquidity, other respects
3. Opposite movements in correlated pairs''',
          type: ContentType.article, keyPoints: ['Correlation', 'Divergence', 'Multi-Asset Analysis']),
      ],
    );
  }

  Course _createOrderFlowCourse() {
    return Course(
      id: 'order_flow',
      title: 'Order Flow Analysis',
      description: 'Understand the flow of orders in the market. Read the tape like a professional.',
      category: CourseCategory.orderFlow,
      difficulty: DifficultyLevel.expert,
      durationMinutes: 800,
      rating: 4.6,
      enrolledCount: 6540,
      isPremium: true,
      lessons: [
        Lesson(id: 'of_1', title: 'Introduction to Order Flow', orderIndex: 1, durationMinutes: 40,
          content: '''Order Flow analysis examines actual market transactions.

WHAT IS ORDER FLOW?
• Real-time buying and selling activity
• Shows who is in control
• Reveals institutional footprints
• More granular than price action

KEY COMPONENTS:
1. Order Book (Level 2 data)
2. Time and Sales
3. Volume Profile
4. Delta (buy vs sell volume)
5. Footprint Charts

WHY ORDER FLOW MATTERS:
• See beyond candles
• Identify absorption
• Spot aggressive traders
• Confirm other analysis''',
          type: ContentType.article, keyPoints: ['Order Book', 'Volume Delta', 'Footprint']),
      ],
    );
  }

  Course _createPriceActionCourse() {
    return Course(
      id: 'price_action',
      title: 'Pure Price Action Trading',
      description: 'Trade using only price. Master candlestick patterns, chart patterns, and market structure.',
      category: CourseCategory.priceAction,
      difficulty: DifficultyLevel.beginner,
      durationMinutes: 720,
      rating: 4.8,
      enrolledCount: 24680,
      isPremium: false,
      lessons: [
        Lesson(id: 'pa_1', title: 'Candlestick Fundamentals', orderIndex: 1, durationMinutes: 45,
          content: '''Candlesticks are the language of price action.

CANDLESTICK ANATOMY:
• Open: Where price started
• Close: Where price ended
• High: Maximum price reached
• Low: Minimum price reached
• Body: Open to Close range
• Wicks: High/Low extensions

BULLISH VS BEARISH:
• Bullish: Close > Open (green)
• Bearish: Close < Open (red)
• Size of body = strength
• Size of wicks = rejection

KEY PATTERNS:
1. Doji - Indecision
2. Hammer - Bullish reversal
3. Shooting Star - Bearish reversal
4. Engulfing - Strong reversal
5. Pin Bar - Rejection''',
          type: ContentType.article, keyPoints: ['Candlestick Reading', 'Patterns', 'Price Analysis']),
      ],
    );
  }

  Course _createQuantCourse() {
    return Course(
      id: 'quant_trading',
      title: 'Quantitative Trading Strategies',
      description: 'Learn systematic, data-driven trading approaches used by quant funds.',
      category: CourseCategory.quant,
      difficulty: DifficultyLevel.expert,
      durationMinutes: 1000,
      rating: 4.5,
      enrolledCount: 4320,
      isPremium: true,
      lessons: [
        Lesson(id: 'qt_1', title: 'Quantitative Trading Basics', orderIndex: 1, durationMinutes: 50,
          content: '''Quantitative trading uses mathematical models for trading decisions.

WHAT IS QUANT TRADING?
• Systematic approach
• Data-driven decisions
• Removes emotion
• Backtested strategies
• Statistical edge

KEY CONCEPTS:
1. Alpha - Excess returns
2. Beta - Market correlation
3. Sharpe Ratio - Risk-adjusted returns
4. Drawdown - Peak to trough decline
5. Win Rate vs R:R

STRATEGY TYPES:
• Momentum
• Mean Reversion
• Statistical Arbitrage
• Factor Investing
• Machine Learning''',
          type: ContentType.article, keyPoints: ['Systematic Trading', 'Backtesting', 'Statistics']),
      ],
    );
  }

  Course _createFundamentalCourse() {
    return Course(
      id: 'fundamental_analysis',
      title: 'Fundamental Analysis for Traders',
      description: 'Understand economic factors that drive markets. Trade news and data releases effectively.',
      category: CourseCategory.fundamental,
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 650,
      rating: 4.6,
      enrolledCount: 9870,
      isPremium: false,
      lessons: [
        Lesson(id: 'fa_1', title: 'Economic Indicators', orderIndex: 1, durationMinutes: 55,
          content: '''Economic indicators drive currency and market movements.

KEY INDICATORS:

INFLATION:
• CPI (Consumer Price Index)
• PPI (Producer Price Index)
• Core inflation
• Impact: High inflation = rate hikes = currency strength

EMPLOYMENT:
• Non-Farm Payrolls (NFP)
• Unemployment Rate
• Average Hourly Earnings
• Impact: Strong jobs = economy strong = currency strength

GDP:
• Gross Domestic Product
• Quarterly release
• Impact: Growth = bullish for currency

CENTRAL BANKS:
• Interest Rate Decisions
• Policy Statements
• Forward Guidance
• Impact: Hawkish = bullish, Dovish = bearish''',
          type: ContentType.article, keyPoints: ['CPI', 'NFP', 'Interest Rates', 'GDP']),
      ],
    );
  }

  Course _createRiskManagementCourse() {
    return Course(
      id: 'risk_management',
      title: 'Risk Management Mastery',
      description: 'Protect your capital. Learn position sizing, stop losses, and portfolio management.',
      category: CourseCategory.riskManagement,
      difficulty: DifficultyLevel.beginner,
      durationMinutes: 480,
      rating: 4.9,
      enrolledCount: 31250,
      isPremium: false,
      lessons: [
        Lesson(id: 'rm_1', title: 'The Importance of Risk Management', orderIndex: 1, durationMinutes: 30,
          content: '''Risk management is the difference between success and failure.

WHY RISK MANAGEMENT?
• Preserves capital
• Survives losing streaks
• Allows compounding
• Reduces emotional trading

THE 2% RULE:
Never risk more than 2% of account on single trade.

Example:
• Account: \$10,000
• Max risk: \$200 per trade
• Stop loss: 50 pips
• Position size: \$200 / 50 pips = \$4/pip

POSITION SIZING FORMULA:
Position Size = (Account × Risk%) / (Entry - Stop Loss)''',
          type: ContentType.article, keyPoints: ['Position Sizing', '2% Rule', 'Capital Preservation']),
      ],
    );
  }

  Course _createPsychologyCourse() {
    return Course(
      id: 'trading_psychology',
      title: 'Trading Psychology',
      description: 'Master your emotions. Develop the mindset of a professional trader.',
      category: CourseCategory.psychology,
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 540,
      rating: 4.8,
      enrolledCount: 18960,
      isPremium: false,
      lessons: [
        Lesson(id: 'tp_1', title: 'The Trader\'s Mindset', orderIndex: 1, durationMinutes: 35,
          content: '''Your psychology determines your success more than any strategy.

COMMON EMOTIONAL TRAPS:
1. Fear of Missing Out (FOMO)
2. Revenge Trading
3. Overconfidence after wins
4. Fear after losses
5. Greed - moving targets

THE PROFESSIONAL MINDSET:
• Accept losses as part of trading
• Focus on process, not outcomes
• Think in probabilities
• Maintain discipline
• Keep detailed journal

DEVELOPING DISCIPLINE:
1. Create a trading plan
2. Follow rules strictly
3. Review trades regularly
4. Learn from mistakes
5. Stay patient''',
          type: ContentType.article, keyPoints: ['Emotional Control', 'Discipline', 'Trading Plan']),
      ],
    );
  }

  List<TradingConcept> getTradingConcepts() {
    return [
      TradingConcept(
        id: 'liquidity',
        name: 'Liquidity',
        category: 'ICT',
        definition: 'Areas where stop losses cluster, creating pools of orders that institutions target.',
        explanation: 'Smart money needs liquidity to fill their large orders. They engineer price movements to trigger retail stop losses, using this liquidity to enter positions.',
        examples: ['Buy-side liquidity above swing highs', 'Sell-side liquidity below swing lows', 'Equal highs/lows', 'Trend line liquidity'],
        tradingRules: ['Identify liquidity pools before they are swept', 'Wait for sweep before entering', 'Trade in direction after liquidity is taken'],
      ),
      TradingConcept(
        id: 'order_block',
        name: 'Order Block',
        category: 'ICT/SMC',
        definition: 'The last candle before a significant impulsive move, representing institutional order placement.',
        explanation: 'When institutions place large orders, they leave footprints. The order block is where these orders were executed. Price often returns to these zones.',
        examples: ['Bullish OB: Last bearish candle before rally', 'Bearish OB: Last bullish candle before drop', 'Mitigation when price returns'],
        tradingRules: ['Enter at order block zone', 'Stop loss beyond the block', 'Target next liquidity or structure'],
      ),
      TradingConcept(
        id: 'fvg',
        name: 'Fair Value Gap',
        category: 'ICT/SMC',
        definition: 'An imbalance in price created by impulsive moves, leaving a gap between candles.',
        explanation: 'FVGs represent areas where price moved too quickly, leaving unfilled orders. Markets tend to return to fill these gaps, creating trading opportunities.',
        examples: ['Bullish FVG: Gap between candle 1 high and candle 3 low', 'Bearish FVG: Gap between candle 1 low and candle 3 high'],
        tradingRules: ['Mark FVG zone', 'Wait for price to return', 'Enter when gap is tested', 'Stop beyond the gap'],
      ),
    ];
  }
}

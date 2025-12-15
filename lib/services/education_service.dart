import 'package:cryptex_trading/models/education.dart';

class EducationService {
  List<Course> getAllCourses() {
    return [
      _createICTCourse(),
      _createSMCCourse(),
      _createSMTCourse(),
      _createMSNRCourse(),
      _createCRTCourse(),
      _createDOMFootprintCourse(),
      _createSniperEntryCourse(),
      _createExitStrategiesCourse(),
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

        Lesson(id: 'smt_2', title: 'SMT Divergence Entry Techniques', orderIndex: 2, durationMinutes: 50,
          content: '''How to trade SMT divergences for high-probability entries.

BULLISH SMT SETUP:

SCENARIO:
Asset A makes new low (sweeps SSL)
Asset B respects the previous low
= Bullish SMT divergence

TRADE EXECUTION:
1. Identify correlated pair
2. Wait for divergence at key low
3. Confirm with price action (engulfing, pin bar)
4. Enter long on weaker asset (Asset A)
5. Stop below swept low
6. Target previous structure high

BEARISH SMT SETUP:

SCENARIO:
Asset A makes new high (sweeps BSL)
Asset B respects the previous high
= Bearish SMT divergence

TRADE EXECUTION:
1. Identify correlated pair
2. Wait for divergence at key high
3. Confirm with bearish price action
4. Enter short on weaker asset
5. Stop above swept high
6. Target previous structure low

CONFIRMATION FILTERS:
• Kill zone timing
• HTF structure alignment
• Order Block at divergence
• FVG creation after divergence''',
          type: ContentType.article, keyPoints: ['Entry Techniques', 'Bullish SMT', 'Bearish SMT']),

        Lesson(id: 'smt_3', title: 'Crypto SMT: BTC vs ETH Analysis', orderIndex: 3, durationMinutes: 45,
          content: '''BTC and ETH correlation provides excellent SMT opportunities.

BTC/ETH CORRELATION:
• Typically 0.7-0.9 correlation
• BTC often leads, ETH follows
• Divergences signal major moves
• High probability setups

BULLISH CRYPTO SMT:

SETUP:
BTC sweeps low, ETH doesn't
OR ETH sweeps low, BTC doesn't

TRADE:
• Enter long on the one that swept
• It collected liquidity
• Now ready to reverse
• Target previous highs

BEARISH CRYPTO SMT:

SETUP:
BTC sweeps high, ETH doesn't
OR ETH sweeps high, BTC doesn't

TRADE:
• Enter short on the one that swept
• Distribution complete
• Now ready to drop
• Target previous lows

ADDITIONAL PAIRS:
• BTC vs SOL
• ETH vs SOL
• BTC vs total crypto market cap
• Index comparisons

TIMING:
Best during:
• NY session open
• Week open
• After significant moves
• At key weekly/monthly levels''',
          type: ContentType.article, keyPoints: ['BTC/ETH SMT', 'Crypto Divergence', 'Timing']),

        Lesson(id: 'smt_4', title: 'Forex SMT Applications', orderIndex: 4, durationMinutes: 55,
          content: '''Using SMT divergence in Forex markets.

KEY FOREX PAIRS FOR SMT:

EUR/USD vs GBP/USD:
• Positive correlation
• Both move against USD
• Divergence = strong signal
• Trade the sweeper

EUR/USD vs USD/CHF:
• Negative correlation
• Move in opposite directions
• Both should reverse together
• Divergence = opportunity

DXY (Dollar Index):
• Compare individual pairs to DXY
• DXY sweeps but EUR/USD doesn't
• Strong signal for USD reversal

PRACTICAL EXAMPLE:

EUR/USD makes new low
GBP/USD respects low
= Bullish SMT

TRADE:
• Long EUR/USD (it swept liquidity)
• Stop below swept low
• Target previous swing high
• R:R typically 1:3+

MULTI-PAIR CONFIRMATION:
When EUR, GBP, and CHF all show divergence:
• Extremely high probability
• Major USD reversal coming
• Size up accordingly
• Be patient for setup''',
          type: ContentType.article, keyPoints: ['EUR/GBP SMT', 'USD Correlation', 'DXY Analysis']),

        Lesson(id: 'smt_5', title: 'Index SMT: ES vs NQ', orderIndex: 5, durationMinutes: 45,
          content: '''Trading SMT divergences between S&P 500 and Nasdaq futures.

ES vs NQ RELATIONSHIP:
• ES = S&P 500 futures
• NQ = Nasdaq 100 futures
• Usually highly correlated
• NQ more volatile (tech heavy)

DIVERGENCE SIGNIFICANCE:

NQ LEADS:
• Tech sector leading market
• Risk-on sentiment
• Growth stocks favored
• NQ outperforms ES

ES LEADS:
• Defensive rotation
• Value over growth
• More cautious market
• ES outperforms NQ

TRADING THE DIVERGENCE:

BULLISH SETUP:
ES sweeps low, NQ holds
• Market weakness in value
• Tech still strong
• Look for long NQ
• Or long ES at sweep

BEARISH SETUP:
NQ sweeps high, ES doesn't
• Tech overextended
• Value not confirming
• Look for short NQ
• Or fade the sweep

BEST TIMES:
• RTH open (9:30 AM EST)
• First hour of trading
• After major data releases
• End of week/month''',
          type: ContentType.article, keyPoints: ['ES/NQ Divergence', 'Index Trading', 'Sector Rotation']),
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

        Lesson(id: 'of_2', title: 'Time and Sales Analysis', orderIndex: 2, durationMinutes: 45,
          content: '''Time and Sales (T&S) shows every executed trade in real-time.

READING TIME AND SALES:

DATA SHOWN:
• Time of execution
• Price executed at
• Size of the trade
• Direction (buy/sell)

COLOR CODING:
Green = Bought at ask (aggressive buyer)
Red = Sold at bid (aggressive seller)
White/Gray = Between bid/ask

KEY PATTERNS:

LARGE PRINTS:
• Institutional orders
• Watch for clusters
• Often at key levels
• Signals commitment

RAPID FIRE:
• Many small orders quickly
• Algo or HFT activity
• Can precede moves
• Watch the direction

ICEBERG DETECTION:
• Same size repeating
• Large hidden order
• Being filled in chunks
• Important level

SWEEP PATTERNS:
• Multiple prices hit fast
• Aggressive market orders
• Momentum building
• Follow the sweep

USING T&S:
1. Watch at key levels
2. Note large prints
3. Observe speed changes
4. Confirm with price action''',
          type: ContentType.article, keyPoints: ['Tape Reading', 'Large Prints', 'Execution Analysis']),

        Lesson(id: 'of_3', title: 'Volume Delta Interpretation', orderIndex: 3, durationMinutes: 50,
          content: '''Volume Delta reveals buying vs selling pressure.

DELTA BASICS:

CALCULATION:
Delta = Ask Volume - Bid Volume

INTERPRETATION:
Positive Delta = More buying at ask
Negative Delta = More selling at bid

CUMULATIVE DELTA:
Running total throughout session
Shows overall flow direction
Trend in delta matters

DELTA ANALYSIS:

DELTA CONFIRMATION:
Price up + Positive delta = Healthy trend
Price down + Negative delta = Healthy trend
Confirmed moves are stronger

DELTA DIVERGENCE:
Price up + Negative delta = Weakness
Price down + Positive delta = Weakness
Divergence warns of reversal

DELTA EXTREMES:
Extreme positive = Exhaustion possible
Extreme negative = Exhaustion possible
Watch for delta shifts

PRACTICAL APPLICATION:

ENTRY CONFIRMATION:
1. Price at Order Block
2. Delta shifting positive
3. Aggressive buying visible
4. Enter with confirmation

REVERSAL SIGNAL:
1. Price at resistance
2. Delta extremely positive
3. No more buyers left
4. Look for sell setup''',
          type: ContentType.article, keyPoints: ['Delta Calculation', 'Divergence', 'Exhaustion']),

        Lesson(id: 'of_4', title: 'Market Profile Basics', orderIndex: 4, durationMinutes: 55,
          content: '''Market Profile shows price distribution over time.

MARKET PROFILE CONCEPTS:

TPO (Time Price Opportunity):
Each letter = 30 minutes of trading
Shows where price spent time
Builds a profile shape

VALUE AREA:
70% of trading activity
VA High and VA Low
Where "fair value" exists

POC (Point of Control):
Single most traded price
Often acts as magnet
Key reference level

PROFILE SHAPES:

NORMAL/BELL:
• Balanced market
• Fair value established
• Range trading
• Trade edges

B-SHAPED:
• Selling pressure above
• Buyers supporting below
• Bearish bias
• Look for breakdown

P-SHAPED:
• Buying pressure above
• Sellers capping below
• Bullish bias
• Look for breakout

DOUBLE DISTRIBUTION:
• Two value areas
• Trending day
• Trade in direction
• Avoid middle zone

TRADING MARKET PROFILE:
1. Identify profile shape
2. Mark VA High/Low
3. Note POC level
4. Trade based on shape
5. Target opposite VA edge''',
          type: ContentType.article, keyPoints: ['TPO', 'Value Area', 'POC', 'Profile Shapes']),

        Lesson(id: 'of_5', title: 'Absorption Trading', orderIndex: 5, durationMinutes: 50,
          content: '''Absorption occurs when large orders absorb aggressive trading.

WHAT IS ABSORPTION?

DEFINITION:
Large passive orders absorbing
aggressive market orders
Price struggles to move
Buildup before reversal

SIGNS OF ABSORPTION:

HIGH VOLUME, NO MOVEMENT:
• Heavy trading activity
• Price stays in range
• Orders being absorbed
• Big player accumulating

DELTA MISMATCH:
• Strong delta one direction
• Price doesn't follow
• Being absorbed
• Watch for flip

FOOTPRINT STACKING:
• High volume at same level
• Price rejecting repeatedly
• Absorption zone identified
• Trade the reversal

TRADING ABSORPTION:

ABSORPTION REVERSAL:

SETUP:
1. Price at key level (OB, S/R)
2. High volume, minimal movement
3. Delta shows absorption
4. Reversal candle forms

EXECUTION:
1. Wait for absorption complete
2. Enter on reversal confirmation
3. Stop beyond absorption zone
4. Target opposite liquidity

FAILED ABSORPTION:

SETUP:
1. Absorption visible
2. But price breaks through
3. Absorbed orders = fuel
4. Explosive move follows

EXECUTION:
1. Wait for break of absorption level
2. Enter in direction of break
3. Absorption becomes support/resistance
4. Target extension''',
          type: ContentType.article, keyPoints: ['Absorption Definition', 'Volume Analysis', 'Reversal Trading']),
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

  Course _createMSNRCourse() {
    return Course(
      id: 'msnr_mastery',
      title: 'MSNR - Market Structure Narrative & Retail',
      description: 'Master the complete MSNR framework. Understand how market structure, narrative, and retail positioning create high-probability trading opportunities.',
      category: CourseCategory.msnr,
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 1400,
      rating: 4.9,
      enrolledCount: 11240,
      isPremium: true,
      lessons: [
        Lesson(id: 'msnr_1', title: 'Introduction to MSNR Framework', orderIndex: 1, durationMinutes: 45,
          content: '''MSNR (Market Structure, Narrative, Retail) is a comprehensive trading framework that combines technical analysis with market psychology.

THE THREE PILLARS:

1. MARKET STRUCTURE (M):
   • The backbone of price movement
   • Identifies trend direction
   • Reveals institutional activity
   • Provides context for entries

2. NARRATIVE (N):
   • The story the market is telling
   • Fundamental drivers
   • Sentiment analysis
   • News and events impact

3. RETAIL (R):
   • Where retail traders are positioned
   • Where stops are placed
   • Liquidity pools to target
   • Contrarian opportunities

HOW THEY WORK TOGETHER:
When all three align, you have the highest probability setups. Structure shows direction, narrative confirms why, and retail positioning shows where smart money will enter.''',
          type: ContentType.article, keyPoints: ['MSNR Framework', 'Three Pillars', 'Confluence Trading']),

        Lesson(id: 'msnr_2', title: 'Market Structure Deep Dive', orderIndex: 2, durationMinutes: 60,
          content: '''Market Structure is the foundation of MSNR trading.

STRUCTURE TYPES:

BULLISH STRUCTURE:
   • Higher Highs (HH) + Higher Lows (HL)
   • Protected lows (structure points)
   • Aggressive buying on pullbacks
   • Resistance becomes support

BEARISH STRUCTURE:
   • Lower Highs (LH) + Lower Lows (LL)
   • Protected highs (structure points)
   • Aggressive selling on rallies
   • Support becomes resistance

STRUCTURE BREAKS:
1. Break of Structure (BOS) - Trend continuation
2. Change of Character (CHoCH) - Potential reversal
3. Market Structure Shift (MSS) - Confirmed reversal

MULTI-TIMEFRAME STRUCTURE:
   • Higher TF sets the bias
   • Lower TF provides entries
   • Always trade with HTF structure
   • Conflicting structure = no trade

STRUCTURE MAPPING:
1. Start from Weekly/Daily
2. Mark major swing points
3. Identify current structure
4. Note protected levels
5. Look for structure breaks''',
          type: ContentType.article, keyPoints: ['Structure Types', 'Multi-Timeframe', 'BOS vs CHoCH']),

        Lesson(id: 'msnr_3', title: 'Understanding Market Narrative', orderIndex: 3, durationMinutes: 55,
          content: '''Narrative is the WHY behind price movement.

NARRATIVE SOURCES:

FUNDAMENTAL NARRATIVE:
   • Interest rate differentials
   • Economic data releases
   • Central bank policies
   • Geopolitical events

TECHNICAL NARRATIVE:
   • Key level tests
   • Pattern completions
   • Multi-timeframe confluences
   • Indicator divergences

SENTIMENT NARRATIVE:
   • COT (Commitment of Traders) data
   • Retail positioning data
   • Social media sentiment
   • News headlines

BUILDING THE NARRATIVE:
1. What is the fundamental picture?
2. What are technicals suggesting?
3. Where is sentiment positioned?
4. Do they align or conflict?

NARRATIVE ALIGNMENT:
   • All three align = High probability
   • Two align, one conflicts = Medium probability
   • All three conflict = No trade

NARRATIVE SHIFTS:
   • Watch for changing fundamentals
   • Note technical breaks
   • Monitor sentiment extremes
   • Adapt to new information''',
          type: ContentType.article, keyPoints: ['Fundamental Narrative', 'Technical Narrative', 'Sentiment']),

        Lesson(id: 'msnr_4', title: 'Retail Positioning Analysis', orderIndex: 4, durationMinutes: 50,
          content: '''Understanding where retail traders are positioned gives you the smart money perspective.

RETAIL POSITIONING INDICATORS:

STOP LOSS CLUSTERS:
   • Above swing highs (shorts)
   • Below swing lows (longs)
   • At round numbers
   • At obvious support/resistance

RETAIL ENTRY ZONES:
   • Classic pattern breakouts
   • Obvious support/resistance
   • Moving average crosses
   • RSI overbought/oversold

WHERE RETAIL GETS TRAPPED:
   • False breakouts
   • Fakeouts at key levels
   • News spike reversals
   • Late trend entries

USING RETAIL POSITIONING:
1. Identify where stops cluster
2. Expect smart money to hunt these areas
3. Wait for the sweep
4. Enter opposite direction
5. Use swept retail stops as your target

CONTRARIAN TRADING:
   • When everyone is bullish, look for sells
   • When everyone is bearish, look for buys
   • Extreme sentiment = reversal incoming
   • Be patient for confirmation''',
          type: ContentType.article, keyPoints: ['Stop Loss Clusters', 'Retail Traps', 'Contrarian Trading']),

        Lesson(id: 'msnr_5', title: 'MSNR Trade Setup Process', orderIndex: 5, durationMinutes: 65,
          content: '''Combining all MSNR elements into actionable trade setups.

STEP-BY-STEP PROCESS:

STEP 1: STRUCTURE ANALYSIS
   • Identify HTF trend (Weekly/Daily)
   • Map current structure
   • Note key levels (BOS, CHoCH points)
   • Determine bias direction

STEP 2: NARRATIVE CHECK
   • Review fundamental drivers
   • Check upcoming news events
   • Assess current sentiment
   • Confirm narrative supports structure

STEP 3: RETAIL POSITIONING
   • Where are obvious stop losses?
   • What does retail sentiment show?
   • Identify liquidity pools
   • Plan for stop hunts

STEP 4: ENTRY CRITERIA
   • Wait for LTF entry trigger
   • Confirm with price action
   • Use Order Blocks or FVGs
   • Enter after liquidity sweep

STEP 5: RISK MANAGEMENT
   • Stop beyond structure
   • Risk 1-2% maximum
   • Target next liquidity
   • Use proper R:R (minimum 1:2)

EXAMPLE SETUP:
   Structure: Daily bullish (HH, HL)
   Narrative: USD weakness fundamentals
   Retail: Stops below recent HL
   Entry: After HL sweep, enter long
   Stop: Below swept low
   Target: Previous HH''',
          type: ContentType.article, keyPoints: ['Trade Setup Process', 'Entry Criteria', 'Risk Management']),

        Lesson(id: 'msnr_6', title: 'Advanced MSNR Patterns', orderIndex: 6, durationMinutes: 70,
          content: '''Advanced patterns within the MSNR framework.

PREMIUM MSNR SETUPS:

1. THE SWEEP AND FLIP:
   • Structure sweep (takes liquidity)
   • Immediate reversal
   • Strong displacement candle
   • Entry on retest of sweep level

2. THE NARRATIVE SHIFT:
   • Structure consolidates
   • Narrative changes (news/data)
   • Retail positioned wrong
   • Explosive move in new direction

3. THE TRIPLE CONFLUENCE:
   • HTF Order Block
   • LTF structure break
   • Narrative alignment
   • Highest probability setup

4. THE RETAIL TRAP:
   • Obvious pattern forms
   • Retail enters predictably
   • Smart money sweeps
   • Violent reversal follows

5. THE STRUCTURE RECLAIM:
   • Structure breaks (fake)
   • Quick reclaim above/below
   • Trapped traders fuel move
   • Enter on reclaim confirmation

PATTERN RECOGNITION:
   • Study these patterns daily
   • Mark them in hindsight first
   • Then identify in real-time
   • Journal every setup''',
          type: ContentType.article, keyPoints: ['Advanced Patterns', 'Triple Confluence', 'Structure Reclaim']),
      ],
    );
  }

  Course _createCRTCourse() {
    return Course(
      id: 'crt_complete',
      title: 'CRT - Candle Range Theory Complete',
      description: 'Master Candle Range Theory for precision entries. Learn to read individual candles and ranges for optimal trade placement.',
      category: CourseCategory.crt,
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 900,
      rating: 4.8,
      enrolledCount: 9870,
      isPremium: true,
      lessons: [
        Lesson(id: 'crt_1', title: 'Introduction to Candle Range Theory', orderIndex: 1, durationMinutes: 40,
          content: '''Candle Range Theory (CRT) focuses on understanding what happens within individual candles.

WHAT IS CRT?
   • Study of candle formation
   • Understanding price within the range
   • Identifying institutional activity
   • Precision entry technique

KEY CONCEPTS:

CANDLE RANGE:
   • The High to Low of any candle
   • Represents the entire price movement
   • Contains buyer and seller activity
   • Key levels within the range matter

CANDLE BODY:
   • Open to Close range
   • Shows who won the battle
   • Large body = conviction
   • Small body = indecision

WICKS:
   • Rejection from price levels
   • Upper wick = selling pressure
   • Lower wick = buying pressure
   • Long wicks = failed moves

WHY CRT WORKS:
   • Every candle tells a story
   • Institutions leave footprints
   • Price respects candle levels
   • Precision entries possible''',
          type: ContentType.article, keyPoints: ['Candle Range', 'Body Analysis', 'Wick Analysis']),

        Lesson(id: 'crt_2', title: 'The 50% Candle Level', orderIndex: 2, durationMinutes: 50,
          content: '''The 50% level of any candle is a key reference point.

THE 50% RULE:

CALCULATION:
   50% Level = (High + Low) / 2

SIGNIFICANCE:
   • Equilibrium point
   • Often acts as support/resistance
   • Retests frequently
   • Great entry level

BULLISH 50% ENTRY:
   • Bullish candle forms
   • Wait for pullback to 50%
   • Enter long at 50% level
   • Stop below candle low

BEARISH 50% ENTRY:
   • Bearish candle forms
   • Wait for pullback to 50%
   • Enter short at 50% level
   • Stop above candle high

NESTED 50% LEVELS:
   • Daily 50% + 4H 50% alignment
   • Multiple timeframe confluence
   • Higher probability entries
   • Tighter risk possible

USING 50% WITH STRUCTURE:
   1. Identify structure break candle
   2. Calculate 50% level
   3. Wait for pullback to 50%
   4. Enter with structure
   5. Target next liquidity''',
          type: ContentType.article, keyPoints: ['50% Level', 'Entry Technique', 'Nested Levels']),

        Lesson(id: 'crt_3', title: 'Candle Body to Wick Ratio', orderIndex: 3, durationMinutes: 45,
          content: '''Understanding the body to wick ratio reveals market intent.

RATIO ANALYSIS:

LARGE BODY, SMALL WICKS:
   • Strong conviction
   • Trend likely to continue
   • Low rejection
   • Follow the direction

SMALL BODY, LARGE WICKS:
   • Indecision
   • Potential reversal
   • High rejection
   • Wait for confirmation

WICK DOMINANT:
   • Strong rejection
   • Failed move attempt
   • Look for reversal
   • Use wick as entry zone

BODY DOMINANT:
   • Clean move
   • Trend continuation likely
   • Enter on pullbacks
   • Trail stops

MEASURING RATIOS:
   Body Size = |Close - Open|
   Wick Size = High - Low - Body Size
   Ratio = Body Size / (High - Low)

TRADING IMPLICATIONS:
   Ratio > 0.7 = Strong momentum
   Ratio 0.4-0.7 = Moderate
   Ratio < 0.4 = Indecision/rejection''',
          type: ContentType.article, keyPoints: ['Body Wick Ratio', 'Conviction Analysis', 'Rejection Patterns']),

        Lesson(id: 'crt_4', title: 'Range Expansion and Contraction', orderIndex: 4, durationMinutes: 55,
          content: '''Understanding when ranges expand and contract predicts volatility.

RANGE DYNAMICS:

RANGE EXPANSION:
   • Candles getting larger
   • Volatility increasing
   • Trend acceleration
   • Major moves happening

RANGE CONTRACTION:
   • Candles getting smaller
   • Volatility decreasing
   • Consolidation phase
   • Breakout coming

THE CYCLE:
   Contraction → Expansion → Contraction

TRADING RANGE CHANGES:

DURING CONTRACTION:
   • Build positions slowly
   • Place pending orders
   • Prepare for breakout
   • Reduce position size

DURING EXPANSION:
   • Ride the momentum
   • Trail stops aggressively
   • Target extensions
   • Lock in profits

MEASURING RANGE:
   ATR (Average True Range) shows:
   • Rising ATR = Expansion
   • Falling ATR = Contraction
   • Compare to average

BREAKOUT TRADING:
   1. Identify contraction
   2. Mark range boundaries
   3. Wait for expansion candle
   4. Enter on break with volume
   5. Target 1x-2x range size''',
          type: ContentType.article, keyPoints: ['Range Expansion', 'Range Contraction', 'Volatility Cycles']),

        Lesson(id: 'crt_5', title: 'CRT Order Block Entry', orderIndex: 5, durationMinutes: 60,
          content: '''Combining CRT with Order Block theory for precision entries.

CRT + ORDER BLOCK:

THE CONCEPT:
   • Order Block = Institutional zone
   • CRT = Precise level within OB
   • Together = Sniper entry

ENTRY TECHNIQUE:

STEP 1: IDENTIFY ORDER BLOCK
   • Last opposing candle
   • Before impulsive move
   • Mark the entire range

STEP 2: APPLY CRT LEVELS
   • Mark OB candle high/low
   • Calculate 50% of OB
   • Note body levels (open/close)
   • Identify optimal entry

STEP 3: REFINE ENTRY
   Priority Levels:
   1. OB candle body (open or close)
   2. OB 50% level
   3. OB wick extreme (last resort)

STEP 4: EXECUTE
   • Set limit order at CRT level
   • Stop beyond OB
   • Target based on structure

EXAMPLE:
   Bullish OB (bearish candle before rally):
   Entry: 50% of OB candle
   Stop: Below OB low
   Target: Next BSL (buy-side liquidity)

RISK REDUCTION:
   Using CRT within OB reduces:
   • Entry slippage
   • Stop loss size
   • Risk per trade
   • Increases R:R''',
          type: ContentType.article, keyPoints: ['CRT Order Block', 'Precision Entry', 'Risk Reduction']),

        Lesson(id: 'crt_6', title: 'Multi-Timeframe CRT', orderIndex: 6, durationMinutes: 50,
          content: '''Using CRT across multiple timeframes for confluence.

MTF CRT APPROACH:

TIMEFRAME HIERARCHY:
   HTF (Higher Timeframe): Direction/Bias
   MTF (Mid Timeframe): Setup/Structure
   LTF (Lower Timeframe): Entry/Precision

EXAMPLE COMBINATION:
   Daily = Direction
   4H = Setup zone
   1H/15M = CRT entry

CONFLUENCE STACKING:
   • Daily bullish structure
   • 4H at Order Block
   • 1H CRT 50% level
   • Triple confirmation

MTF 50% ALIGNMENT:
   When 50% levels align across TFs:
   • Extremely high probability
   • Tight risk possible
   • Strong reactions expected
   • Must act quickly

PRACTICAL APPLICATION:
   1. Check Daily/Weekly bias
   2. Find 4H structure + OB
   3. Zoom to 1H/15M
   4. Calculate CRT levels
   5. Enter at confluence
   6. Stop below all levels
   7. Target HTF liquidity

JOURNALING MTF CRT:
   • Screenshot all timeframes
   • Note each TF level
   • Record entry precision
   • Track hit rate''',
          type: ContentType.article, keyPoints: ['Multi-Timeframe', 'Level Confluence', 'Precision Trading']),
      ],
    );
  }

  Course _createDOMFootprintCourse() {
    return Course(
      id: 'dom_footprint_mastery',
      title: 'DOM & Footprint Charts Mastery',
      description: 'Master Depth of Market and Footprint chart analysis. See what happens inside each candle and read the order book like a professional.',
      category: CourseCategory.domFootprint,
      difficulty: DifficultyLevel.expert,
      durationMinutes: 1200,
      rating: 4.7,
      enrolledCount: 5430,
      isPremium: true,
      lessons: [
        Lesson(id: 'dom_1', title: 'Introduction to Depth of Market', orderIndex: 1, durationMinutes: 50,
          content: '''Depth of Market (DOM) shows pending orders at different price levels.

WHAT IS DOM?
   • Also called Level 2 data
   • Shows bid and ask orders
   • Reveals pending liquidity
   • Real-time order flow

DOM COMPONENTS:

BID SIDE (Left):
   • Buy orders waiting
   • Price levels descending
   • Size at each level
   • Support zones visible

ASK SIDE (Right):
   • Sell orders waiting
   • Price levels ascending
   • Size at each level
   • Resistance zones visible

KEY METRICS:
   Bid Depth: Total buy orders
   Ask Depth: Total sell orders
   Spread: Ask - Bid
   Imbalance: Bid vs Ask ratio

READING THE DOM:

HEAVY BID (More buys):
   • Support building
   • Potential bounce
   • Buyers defending

HEAVY ASK (More sells):
   • Resistance building
   • Potential rejection
   • Sellers defending

THIN LEVELS:
   • Price moves fast through
   • Little resistance
   • Potential for acceleration''',
          type: ContentType.article, keyPoints: ['Level 2 Data', 'Bid/Ask', 'Order Book']),

        Lesson(id: 'dom_2', title: 'Order Types and Their Impact', orderIndex: 2, durationMinutes: 55,
          content: '''Understanding different order types and how they affect price.

ORDER TYPES:

LIMIT ORDERS:
   • Rest in the book
   • Don't move price immediately
   • Provide liquidity
   • Visible on DOM

MARKET ORDERS:
   • Execute immediately
   • Take liquidity
   • Move price directly
   • Aggressive traders use these

STOP ORDERS:
   • Become market orders when triggered
   • Hidden from DOM
   • Fuel breakouts
   • Located at key levels

ICEBERG ORDERS:
   • Large orders hidden
   • Show small portion only
   • Institutional technique
   • Watch for repeated fills

TRADING ORDER FLOW:

ABSORPTION:
   • Large limit orders absorbing
   • Price struggles to move
   • Eventually breaks or reverses
   • Sign of institutional activity

AGGRESSIVE BUYING:
   • Market orders lifting ask
   • Quick upticks
   • Momentum building
   • Follow the aggression

AGGRESSIVE SELLING:
   • Market orders hitting bid
   • Quick downticks
   • Pressure building
   • Follow the pressure

SPOOFING (Illegal but common):
   • Large orders appear
   • Cancel before filled
   • Trick other traders
   • Be aware it exists''',
          type: ContentType.article, keyPoints: ['Limit Orders', 'Market Orders', 'Absorption']),

        Lesson(id: 'dom_3', title: 'Footprint Charts Explained', orderIndex: 3, durationMinutes: 60,
          content: '''Footprint charts show executed volume at each price within a candle.

FOOTPRINT BASICS:

WHAT THEY SHOW:
   • Volume traded at each price
   • Bid vs Ask separation
   • Delta at each level
   • Inside candle information

FOOTPRINT FORMAT:
   [Bid Volume x Ask Volume]
   Example: [150 x 230]
   Meaning: 150 sold at bid, 230 bought at ask

KEY TERMS:

DELTA:
   Ask Volume - Bid Volume
   Positive = Buying pressure
   Negative = Selling pressure

CUMULATIVE DELTA:
   Running total of delta
   Shows overall flow
   Divergences matter

VOLUME PROFILE (within candle):
   • Where most volume traded
   • Point of Control (POC)
   • Value Area High/Low

READING FOOTPRINTS:

HIGH VOLUME NODES:
   • Heavy activity
   • Important price levels
   • Often act as support/resistance
   • Mark for future reference

LOW VOLUME NODES:
   • Price moves quickly through
   • Gap areas
   • Potential targets

IMBALANCES:
   • 3:1+ ratio at a level
   • Strong directional intent
   • Stack of imbalances = strength''',
          type: ContentType.article, keyPoints: ['Footprint Basics', 'Delta', 'Volume Profile']),

        Lesson(id: 'dom_4', title: 'Reading Delta and Imbalances', orderIndex: 4, durationMinutes: 65,
          content: '''Delta and imbalances reveal institutional activity.

DELTA ANALYSIS:

POSITIVE DELTA:
   • More buying at ask
   • Buyers aggressive
   • Bullish pressure
   • Look for longs

NEGATIVE DELTA:
   • More selling at bid
   • Sellers aggressive
   • Bearish pressure
   • Look for shorts

DELTA DIVERGENCE:
   Price makes new high
   Delta makes lower high
   = Potential reversal
   (Vice versa for lows)

IMBALANCE ANALYSIS:

STACKED IMBALANCES:
   Multiple consecutive imbalances
   Shows strong directional intent
   Indicates institutional activity
   High probability zones

DIAGONAL IMBALANCES:
   Imbalances moving diagonally
   Aggressive price movement
   Strong trend continuation
   Follow the direction

ABSORPTION IMBALANCE:
   High volume, no price movement
   Large orders absorbing
   Potential reversal zone
   Watch for confirmation

TRADING WITH IMBALANCES:

ENTRY TECHNIQUE:
   1. Identify stacked imbalances
   2. Wait for pullback to zone
   3. Enter at imbalance level
   4. Stop beyond the stack
   5. Target next imbalance zone

CONFIRMATION:
   Use imbalances to confirm:
   • Order block entries
   • FVG trades
   • Structure breaks
   • Liquidity sweeps''',
          type: ContentType.article, keyPoints: ['Delta Trading', 'Stacked Imbalances', 'Absorption']),

        Lesson(id: 'dom_5', title: 'Volume Profile Trading', orderIndex: 5, durationMinutes: 55,
          content: '''Volume Profile shows where trading activity occurred.

VOLUME PROFILE CONCEPTS:

POINT OF CONTROL (POC):
   • Price with highest volume
   • Often acts as magnet
   • Key reference level
   • Can act as S/R

VALUE AREA (VA):
   • 70% of volume range
   • Where most trading occurred
   • VA High and VA Low
   • Important boundaries

HIGH VOLUME NODES (HVN):
   • Areas of acceptance
   • Price consolidation zones
   • Can slow price movement
   • Strong support/resistance

LOW VOLUME NODES (LVN):
   • Areas of rejection
   • Price moves quickly through
   • Potential breakout zones
   • Less resistance

TRADING VOLUME PROFILE:

MEAN REVERSION:
   Price extended from POC
   Look for return to POC
   Trade the pullback
   POC acts as magnet

BREAKOUT TRADING:
   Price at VA edge
   Watch for break
   LVN ahead = fast move
   Target opposite VA edge

CONTINUATION:
   POC shifting with trend
   HVN building higher/lower
   Trade pullbacks to POC
   Trend remains intact

SESSION PROFILE:
   Asian, London, NY sessions
   Mark each session's POC
   Trade between levels
   Useful for day trading''',
          type: ContentType.article, keyPoints: ['Point of Control', 'Value Area', 'Volume Nodes']),

        Lesson(id: 'dom_6', title: 'DOM + Footprint Trading Strategies', orderIndex: 6, durationMinutes: 70,
          content: '''Combining DOM and Footprint for complete order flow trading.

INTEGRATED APPROACH:

DOM SHOWS:
   • Where orders are waiting
   • Potential S/R ahead
   • Current market depth
   • Real-time changes

FOOTPRINT SHOWS:
   • What already executed
   • Who was aggressive
   • Delta at each level
   • Historical activity

COMBINED ANALYSIS:

STRATEGY 1: ABSORPTION REVERSAL
   DOM: Large bid/ask building
   Footprint: Selling absorbed (high volume, no drop)
   Action: Look for long entry
   Confirmation: Delta shifts positive

STRATEGY 2: BREAKOUT CONFIRMATION
   DOM: Thin levels ahead
   Footprint: Stacked imbalances building
   Action: Prepare for breakout
   Confirmation: Large market orders hit

STRATEGY 3: FAILED AUCTION
   DOM: Orders pulled (spoofing)
   Footprint: No real volume at level
   Action: Fade the move
   Confirmation: Quick rejection

STRATEGY 4: ICEBERG DETECTION
   DOM: Small visible orders
   Footprint: Massive volume at level
   Action: Large hidden order exists
   Trade: Fade if iceberg absorbed, follow if broken

PRACTICAL WORKFLOW:
   1. Check DOM for structure
   2. Analyze recent footprint
   3. Identify imbalances
   4. Watch for absorption
   5. Execute on confirmation
   6. Manage with order flow''',
          type: ContentType.article, keyPoints: ['Combined Analysis', 'Absorption', 'Breakout Confirmation']),

        Lesson(id: 'dom_7', title: 'Footprint Chart Patterns', orderIndex: 7, durationMinutes: 50,
          content: '''Recognizable patterns in footprint charts.

FOOTPRINT PATTERNS:

1. THE DELTA FLIP:
   • Delta positive at low
   • Price stops falling
   • Delta turns positive
   • Bullish reversal signal

2. STACKED BIDS:
   • Multiple levels of high bid volume
   • Strong support forming
   • Institutions accumulating
   • Look for bounce

3. STACKED OFFERS:
   • Multiple levels of high ask volume
   • Strong resistance forming
   • Institutions distributing
   • Look for rejection

4. EXHAUSTION:
   • Extreme delta at extreme price
   • No follow-through
   • Buyers/sellers exhausted
   • Reversal likely

5. INITIATIVE VS RESPONSIVE:
   Initiative: Aggressive orders moving price
   Responsive: Passive orders absorbing
   Trade with initiative
   Fade responsive failures

6. VOLUME SPIKE + REJECTION:
   • High volume at level
   • Price reverses immediately
   • Strong rejection pattern
   • High probability reversal

PATTERN TRADING:
   1. Identify pattern type
   2. Wait for pattern completion
   3. Confirm with DOM
   4. Enter on trigger
   5. Stop beyond pattern
   6. Target next volume cluster''',
          type: ContentType.article, keyPoints: ['Delta Flip', 'Exhaustion', 'Initiative Trading']),
      ],
    );
  }

  Course _createSniperEntryCourse() {
    return Course(
      id: 'sniper_entries',
      title: 'Sniper Entry Strategies',
      description: 'Master precision entry techniques. Learn to enter trades with minimal risk and maximum reward using confluence and timing.',
      category: CourseCategory.sniperEntry,
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 850,
      rating: 4.9,
      enrolledCount: 14320,
      isPremium: true,
      lessons: [
        Lesson(id: 'sniper_1', title: 'The Sniper Mindset', orderIndex: 1, durationMinutes: 35,
          content: '''Sniper trading is about precision, patience, and discipline.

SNIPER TRADING PHILOSOPHY:

WAIT FOR THE PERFECT SHOT:
   • Quality over quantity
   • One great trade > Ten average trades
   • Patience is your edge
   • Never force trades

PRECISION OVER ACCURACY:
   • Accuracy = How often you win
   • Precision = How tight your entry
   • Focus on entry precision
   • Reduces risk dramatically

THE 3P FRAMEWORK:
   1. PATIENCE - Wait for setup
   2. PRECISION - Enter at optimal level
   3. PROFIT - Target calculated R:R

SNIPER CHARACTERISTICS:
   • Takes few trades
   • High win rate
   • Excellent R:R
   • Low stress trading
   • Compound gains

TRADING LESS = MAKING MORE:
   Overtrading kills accounts
   Quality setups are rare
   One trade per day maximum
   Sometimes zero trades is correct''',
          type: ContentType.article, keyPoints: ['Patience', 'Precision', 'Quality Trading']),

        Lesson(id: 'sniper_2', title: 'OTE - Optimal Trade Entry', orderIndex: 2, durationMinutes: 55,
          content: '''The Optimal Trade Entry (OTE) zone provides the best risk-reward.

WHAT IS OTE?

DEFINITION:
   The Fibonacci zone between 62% and 79% retracement
   Represents institutional accumulation zone
   Highest probability entry area
   Used after structure break

FIBONACCI LEVELS:
   62% - Start of OTE zone
   70.5% - Sweet spot
   79% - Deep OTE (extended)
   Beyond 79% = Setup invalid

HOW TO TRADE OTE:

STEP 1: IDENTIFY STRUCTURE BREAK
   • BOS or CHoCH on your timeframe
   • Clear impulsive move
   • Must have swing points

STEP 2: DRAW FIBONACCI
   • From swing high to swing low (bullish)
   • From swing low to swing high (bearish)
   • Mark 62%, 70.5%, 79% levels

STEP 3: WAIT FOR PULLBACK
   • Price must retrace
   • Enter at OTE zone
   • Confirm with PA trigger

STEP 4: ENTRY EXECUTION
   • Limit order at 70.5%
   • Or market on confirmation
   • Stop beyond 79%/swing

OTE + CONFLUENCE:
   OTE at Order Block = High probability
   OTE at FVG = High probability
   OTE at key level = High probability
   Multiple confluences = Sniper entry''',
          type: ContentType.article, keyPoints: ['Fibonacci OTE', '62-79% Zone', 'Structure Break Entry']),

        Lesson(id: 'sniper_3', title: 'Confluence Stacking', orderIndex: 3, durationMinutes: 60,
          content: '''Stacking multiple confluences creates highest probability entries.

CONFLUENCE TYPES:

STRUCTURAL CONFLUENCE:
   • Order Block
   • FVG (Fair Value Gap)
   • OTE Zone
   • Previous structure level

TIME-BASED CONFLUENCE:
   • Kill Zone timing
   • Session opens
   • News releases
   • Time of day patterns

TECHNICAL CONFLUENCE:
   • Trend line touch
   • Moving average
   • Pivot points
   • Round numbers

MULTI-TIMEFRAME CONFLUENCE:
   • HTF level
   • LTF entry trigger
   • Alignment of structure

CONFLUENCE SCORING:
   Each confluence = 1 point
   Minimum 3 points = Valid setup
   4+ points = High conviction
   5+ points = Maximum size

STACKING EXAMPLE:
   Point 1: Daily Order Block
   Point 2: 4H FVG inside OB
   Point 3: OTE zone (70.5%)
   Point 4: NY Kill Zone timing
   Point 5: Round number
   Score: 5/5 = Sniper entry

ENTRY CHECKLIST:
   [ ] HTF structure aligned
   [ ] LTF trigger present
   [ ] Multiple confluences (3+)
   [ ] Kill zone timing
   [ ] Risk:Reward 1:3+
   [ ] Stop placement logical''',
          type: ContentType.article, keyPoints: ['Confluence Types', 'Scoring System', 'Entry Checklist']),

        Lesson(id: 'sniper_4', title: 'Liquidity Sweep Entries', orderIndex: 4, durationMinutes: 50,
          content: '''Entering after liquidity sweeps provides optimal timing.

LIQUIDITY SWEEP TRADING:

THE CONCEPT:
   • Smart money needs liquidity
   • They sweep obvious levels
   • Retail gets stopped out
   • Price reverses

IDENTIFYING SWEEPS:

BSL SWEEP (Buy-Side Liquidity):
   • Price breaks above highs
   • Wicks above then closes below
   • Triggers long stops
   • Look for shorts after

SSL SWEEP (Sell-Side Liquidity):
   • Price breaks below lows
   • Wicks below then closes above
   • Triggers short stops
   • Look for longs after

ENTRY TECHNIQUE:

STEP 1: MARK LIQUIDITY
   • Equal highs/lows
   • Swing points
   • Trend lines
   • Round numbers

STEP 2: WAIT FOR SWEEP
   • Price must breach level
   • Look for rejection (wick)
   • Volume spike helps

STEP 3: CONFIRM REVERSAL
   • Lower timeframe CHoCH
   • Engulfing candle
   • Order block form
   • FVG creation

STEP 4: ENTER
   • Enter on confirmation
   • Stop beyond sweep high/low
   • Target opposite liquidity

THE TURTLE SOUP SETUP:
   1. Prior high/low formed
   2. Break of level (sweep)
   3. Immediate reversal
   4. Enter on close back inside
   5. Classic liquidity grab trade''',
          type: ContentType.article, keyPoints: ['Liquidity Sweep', 'BSL/SSL', 'Turtle Soup']),

        Lesson(id: 'sniper_5', title: 'Time and Price Confluence', orderIndex: 5, durationMinutes: 45,
          content: '''When time and price align, highest probability occurs.

TIME FACTORS:

KILL ZONES:
   London: 2-5 AM EST
   NY: 7-10 AM EST
   These windows = Highest probability
   Outside KZ = Reduced probability

SESSION BEHAVIOR:
   Asian: Accumulation (range)
   London: Manipulation (sweep)
   NY: Distribution (trend)
   Trade the cycle

HIGH-IMPACT NEWS:
   Major moves during:
   • NFP Friday
   • FOMC Wednesday
   • CPI releases
   • GDP releases

DAILY OPEN:
   • Midnight NY time
   • Week opens Sunday
   • Month opens 1st
   • Key reference points

COMBINING TIME + PRICE:

THE PERFECT SETUP:
   1. Price at key level (OB/FVG)
   2. Kill zone active
   3. Liquidity just swept
   4. Structure aligned
   5. Enter with conviction

TIME FILTER:
   Even great setups fail outside KZ
   Wait for optimal timing
   Patience increases win rate
   Don't rush entries''',
          type: ContentType.article, keyPoints: ['Kill Zones', 'Session Trading', 'Time-Price Confluence']),

        Lesson(id: 'sniper_6', title: 'Sniper Entry Execution', orderIndex: 6, durationMinutes: 55,
          content: '''Executing sniper entries with precision.

EXECUTION METHODS:

LIMIT ORDER ENTRY:
   Advantages:
   • Precise entry
   • Best price
   • No slippage
   Disadvantages:
   • May not fill
   • Can miss move

MARKET ORDER ENTRY:
   Advantages:
   • Guaranteed fill
   • In the trade
   Disadvantages:
   • Slippage
   • Worse price

STOP LIMIT HYBRID:
   • Set stop entry above/below level
   • Triggers when price reaches
   • Good for breakouts
   • Reduces babysitting

POSITION SIZING:

CALCULATE FIRST:
   Risk Amount = Account × Risk %
   Stop Distance = Entry - Stop Loss
   Position Size = Risk / Stop Distance

SCALING IN:
   • 50% at first level
   • 50% at deeper level
   • Average entry improves
   • Risk stays constant

MANAGING THE TRADE:

AFTER ENTRY:
   1. Set stop loss immediately
   2. Set TP levels
   3. Walk away
   4. Let trade work

POSITION MANAGEMENT:
   • Move to breakeven at 1R
   • Take partials at 2R
   • Trail remainder
   • Let winners run

THE SNIPER CHECKLIST:
   [ ] Confluences checked (3+)
   [ ] Kill zone active
   [ ] Risk calculated
   [ ] Stop placed
   [ ] Targets set
   [ ] Execution ready''',
          type: ContentType.article, keyPoints: ['Order Types', 'Position Sizing', 'Trade Management']),
      ],
    );
  }

  Course _createExitStrategiesCourse() {
    return Course(
      id: 'exit_strategies',
      title: 'Exit Strategies - Take Profit Mastery',
      description: 'Master the art of exiting trades. Learn when to take profits, trail stops, and maximize your winners.',
      category: CourseCategory.exitStrategies,
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 720,
      rating: 4.8,
      enrolledCount: 16780,
      isPremium: true,
      lessons: [
        Lesson(id: 'exit_1', title: 'Why Exits Matter More Than Entries', orderIndex: 1, durationMinutes: 40,
          content: '''Your exit determines your profit, not your entry.

EXIT IMPORTANCE:

THE TRUTH:
   Great entry + Poor exit = Loss or breakeven
   Average entry + Great exit = Profit
   Exits determine final P&L

COMMON EXIT MISTAKES:

1. EXITING TOO EARLY:
   • Fear of giving back profits
   • Missing the big move
   • Poor risk:reward

2. EXITING TOO LATE:
   • Greed takes over
   • Profits evaporate
   • Winners become losers

3. NO EXIT PLAN:
   • Making it up as you go
   • Emotional decisions
   • Inconsistent results

4. MOVING TARGETS:
   • Constantly adjusting TP
   • Never satisfied
   • Overcomplicating

PROPER EXIT MINDSET:
   • Plan exits before entry
   • Stick to the plan
   • Accept "leaving money on table"
   • Focus on consistency''',
          type: ContentType.article, keyPoints: ['Exit Importance', 'Common Mistakes', 'Exit Planning']),

        Lesson(id: 'exit_2', title: 'Fixed Target Exit Methods', orderIndex: 2, durationMinutes: 45,
          content: '''Using fixed targets for consistent exits.

FIXED TARGET STRATEGIES:

R:R BASED EXITS:
   1R = Same distance as risk
   2R = 2x risk distance
   3R = 3x risk distance

COMMON SETUPS:
   Conservative: 1:1 R:R
   Standard: 1:2 R:R
   Aggressive: 1:3+ R:R

STRUCTURAL EXITS:
   Target next structure level:
   • Previous swing high/low
   • Order block
   • FVG zone
   • Liquidity pool

LIQUIDITY-BASED TARGETS:
   For longs: Target BSL (highs)
   For shorts: Target SSL (lows)
   Smart money targets liquidity
   Exit before or at liquidity

FIBONACCI EXTENSIONS:
   -27% extension
   -62% extension
   -100% extension
   -127% extension

CHOOSING YOUR METHOD:

SCALPING: 1R target, quick exits
SWING: 2-3R target, structural
POSITION: 5R+ target, major levels

BE CONSISTENT:
   Pick a method
   Test it thoroughly
   Stick with it
   Don't switch mid-trade''',
          type: ContentType.article, keyPoints: ['R:R Targets', 'Structural Exits', 'Fibonacci Extensions']),

        Lesson(id: 'exit_3', title: 'Trailing Stop Methods', orderIndex: 3, durationMinutes: 55,
          content: '''Trailing stops to maximize winners.

TRAILING TECHNIQUES:

1. STRUCTURE-BASED TRAILING:
   Move stop to previous swing
   As new swings form
   Protects profits
   Lets winners run

HOW:
   Long: Trail below each HL
   Short: Trail above each LH
   Only move when new structure forms

2. ATR-BASED TRAILING:
   Use ATR multiplier
   Common: 2x or 3x ATR
   Adapts to volatility
   Systematic approach

FORMULA:
   Long: Trail at Price - (ATR × Multiplier)
   Short: Trail at Price + (ATR × Multiplier)

3. MOVING AVERAGE TRAILING:
   Use MA as trailing stop
   Common: 20 EMA, 50 EMA
   Exit when price closes beyond

4. CHANDELIER EXIT:
   ATR-based from highest high/lowest low
   Popular for trending markets
   Formula: Highest High - (ATR × 3)

5. PERCENTAGE TRAILING:
   Trail by fixed percentage
   Example: 2% below current price
   Simple but effective

WHEN TO USE EACH:

VOLATILE MARKETS: ATR or Chandelier
TRENDING MARKETS: Structure or MA
SCALPING: Fixed R:R (no trailing)
SWING: Structure trailing''',
          type: ContentType.article, keyPoints: ['Structure Trailing', 'ATR Trailing', 'Chandelier Exit']),

        Lesson(id: 'exit_4', title: 'Partial Profit Taking', orderIndex: 4, durationMinutes: 50,
          content: '''Strategic partial exits to lock in profits.

PARTIAL EXIT STRATEGIES:

THE CONCEPT:
   Take some profits early
   Let rest run
   Best of both worlds
   Reduces psychological pressure

COMMON PARTIALS:

1/3 SYSTEM:
   1/3 at 1R
   1/3 at 2R
   1/3 trail to target

1/2 SYSTEM:
   1/2 at fixed target
   1/2 trail with stop

THIRDS STRATEGY:
   First third: Conservative target
   Second third: Standard target
   Final third: Extended/trailing

IMPLEMENTING PARTIALS:

STEP 1: DETERMINE TOTAL POSITION
   Example: 3 lots

STEP 2: ASSIGN TARGETS
   Lot 1: 1R target
   Lot 2: 2R target
   Lot 3: 3R or trail

STEP 3: AFTER FIRST PARTIAL
   Move stop to breakeven
   Remaining position = free trade

PROS AND CONS:

PROS:
   • Locks in profits
   • Reduces risk
   • Peace of mind
   • Higher win rate

CONS:
   • Reduces total profit
   • More complex
   • Potential for leaving money

RECOMMENDED APPROACH:
   Start with partials (safer)
   As skill grows, reduce partials
   Eventually, all-in/all-out possible''',
          type: ContentType.article, keyPoints: ['Partial Exits', 'Position Scaling', 'Profit Locking']),

        Lesson(id: 'exit_5', title: 'Order Block and FVG Exit Strategies', orderIndex: 5, durationMinutes: 45,
          content: '''Using ICT concepts for exits.

ICT-BASED EXITS:

ORDER BLOCK TARGETS:
   Target opposite Order Block
   For longs: Next bearish OB
   For shorts: Next bullish OB
   Natural reaction points

FVG TARGETS:
   Target unfilled FVGs
   Price tends to fill gaps
   Natural magnets for price
   High probability targets

LIQUIDITY AS EXIT:

BSL (Buy-Side Liquidity):
   Swing highs
   Equal highs
   Above resistance
   Target for longs

SSL (Sell-Side Liquidity):
   Swing lows
   Equal lows
   Below support
   Target for shorts

COMBINING CONCEPTS:

PREMIUM ARRAY EXIT:
   When long, exit at:
   1. Nearest BSL
   2. Next bearish OB
   3. Unfilled bearish FVG

DISCOUNT ARRAY EXIT:
   When short, exit at:
   1. Nearest SSL
   2. Next bullish OB
   3. Unfilled bullish FVG

MULTIPLE TARGETS:
   TP1: Nearest liquidity
   TP2: Order Block
   TP3: Extended liquidity

PRACTICAL APPLICATION:
   1. Enter at discount array
   2. First TP at equilibrium
   3. Second TP at premium array
   4. Final TP at extreme liquidity''',
          type: ContentType.article, keyPoints: ['Order Block Exit', 'Liquidity Targets', 'Premium/Discount']),

        Lesson(id: 'exit_6', title: 'Time-Based Exits', orderIndex: 6, durationMinutes: 40,
          content: '''Using time as an exit trigger.

TIME EXIT METHODS:

END OF SESSION EXIT:
   Exit before session close
   Avoid overnight risk
   Day trading standard
   Clean daily trading

END OF KILL ZONE:
   If not in profit by end of KZ
   Exit at breakeven or small loss
   Setups should work quickly
   Don't hold losing trades

FRIDAY CLOSE:
   Close all positions Friday
   Avoid weekend gap risk
   Start fresh Monday
   Common swing trade rule

CANDLE CLOSE EXIT:
   Exit on close above/below level
   Not on wick breach
   More confirmed exit
   Reduces fakeouts

TIME-BASED RULES:

1. TRADE SHOULD WORK QUICKLY
   If entry is good, move happens
   Consolidation after entry = warning
   Consider reducing or exiting

2. MAXIMUM HOLD TIME
   Day trades: Same session
   Swing trades: 3-5 days
   Position: Weeks to months
   Set maximum before entry

3. NEWS TIME EXIT
   Exit before major news
   Or set wide stops
   Volatility can hit stops
   Protect your position

COMBINING TIME + PRICE:
   Use time as filter
   Price target is primary
   Time limit is backup
   Both trigger exit''',
          type: ContentType.article, keyPoints: ['Session Exits', 'Time Limits', 'News Exits']),
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

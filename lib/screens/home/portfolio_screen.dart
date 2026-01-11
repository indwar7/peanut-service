import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:peanut_trading_app/services/api_service.dart';
import 'package:peanut_trading_app/models/models.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ApiService _apiService = ApiService();
  AccountInfo? _accountInfo;
  BonusStatistic? _bonusStats;
  List<Trade> _openTrades = [];
  bool _isLoading = true;
  bool _showPercentage = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final accountData = await _apiService.getAccountInformation();
    final bonusData = await _apiService.getBonusStatistic();
    final tradesData = await _apiService.getOpenTrades();

    setState(() {
      if (accountData != null) _accountInfo = AccountInfo.fromJson(accountData);
      if (bonusData != null) _bonusStats = BonusStatistic.fromJson(bonusData);
      _openTrades = tradesData.map((e) => Trade.fromJson(e)).toList();
      _isLoading = false;
    });
  }

  double get _totalProfit {
    return _openTrades.fold(0.0, (sum, trade) => sum + trade.profit);
  }

  double get _profitPercentage {
    if (_accountInfo == null || _accountInfo!.balance == 0) return 0;
    return (_totalProfit / _accountInfo!.balance) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Portfolio',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showPercentage ? Icons.attach_money : Icons.percent,
              color: Colors.black,
            ),
            onPressed: () => setState(() => _showPercentage = !_showPercentage),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPortfolioValue(),
                    const SizedBox(height: 16),
                    _buildPortfolioChart(),
                    const SizedBox(height: 24),
                    _buildHoldings(),
                    const SizedBox(height: 24),
                    _buildOpenPositions(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPortfolioValue() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_accountInfo?.currencySymbol ?? '\$'}${_accountInfo?.equity.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _totalProfit >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: _totalProfit >= 0 ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${_totalProfit >= 0 ? '+' : ''}${_showPercentage ? _profitPercentage.toStringAsFixed(2) + '%' : _accountInfo?.currencySymbol ?? '\$'}${_showPercentage ? '' : _totalProfit.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _totalProfit >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildValueItem(
                  'Invested',
                  '${_accountInfo?.currencySymbol ?? '\$'}${_accountInfo?.balance.toStringAsFixed(2) ?? '0.00'}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              Expanded(
                child: _buildValueItem(
                  'Returns',
                  '${_totalProfit >= 0 ? '+' : ''}${_accountInfo?.currencySymbol ?? '\$'}${_totalProfit.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _generateChartData(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF00D09C), Color(0xFF00B087)],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00D09C).withOpacity(0.3),
                    const Color(0xFF00D09C).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateChartData() {
    // Generate sample data - replace with real data
    return List.generate(30, (index) {
      return FlSpot(
        index.toDouble(),
        (_accountInfo?.balance ?? 1000) + (index * 10) + (index % 3) * 50,
      );
    });
  }

  Widget _buildHoldings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Holdings (${_openTrades.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildHoldingItem(
                  'Balance',
                  '${_accountInfo?.currencySymbol ?? '\$'}${_accountInfo?.balance.toStringAsFixed(2) ?? '0.00'}',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildHoldingItem(
                  'Equity',
                  '${_accountInfo?.currencySymbol ?? '\$'}${_accountInfo?.equity.toStringAsFixed(2) ?? '0.00'}',
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildHoldingItem(
                  'Margin',
                  '${_accountInfo?.currencySymbol ?? '\$'}${_accountInfo?.freeMargin.toStringAsFixed(2) ?? '0.00'}',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOpenPositions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Open Positions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _openTrades.isEmpty
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'No open positions',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D09C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Start Trading'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _openTrades.length,
                itemBuilder: (context, index) {
                  final trade = _openTrades[index];
                  return _buildPositionCard(trade);
                },
              ),
      ],
    );
  }

  Widget _buildPositionCard(Trade trade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: trade.isProfitable ? Colors.green[100]! : Colors.red[100]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: trade.isProfitable 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  trade.type == 0 ? Icons.trending_up : Icons.trending_down,
                  color: trade.isProfitable ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trade.symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trade.tradeType,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${trade.profit >= 0 ? '+' : ''}${_accountInfo?.currencySymbol ?? '\$'}${trade.profit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: trade.isProfitable ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: trade.isProfitable 
                          ? Colors.green.withOpacity(0.1) 
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${trade.profit >= 0 ? '+' : ''}${((trade.profit / (trade.openPrice * trade.volume)) * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trade.isProfitable ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTradeDetail('Open Price', trade.openPrice.toStringAsFixed(5)),
              ),
              Expanded(
                child: _buildTradeDetail('Volume', trade.volume.toString()),
              ),
              Expanded(
                child: _buildTradeDetail('Swap', trade.swaps.toStringAsFixed(2)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
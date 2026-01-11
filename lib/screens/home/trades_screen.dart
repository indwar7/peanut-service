import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peanut_trading_app/services/api_service.dart';
import 'package:peanut_trading_app/models/models.dart';

class TradesScreen extends StatefulWidget {
  const TradesScreen({Key? key}) : super(key: key);

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  List<Trade> _openTrades = [];
  List<Trade> _closedTrades = [];
  List<BalanceOperation> _balanceHistory = [];

  bool _isLoading = true;
  int _closedTradesOffset = 0;
  final int _closedTradesCount = 20;
  bool _hasMoreClosedTrades = true;

  AccountInfo? _accountInfo;
  double _totalProfit = 0;
  int _profitableTrades = 0;
  int _losingTrades = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final accountData = await _apiService.getAccountInformation();
    final openTradesData = await _apiService.getOpenTrades();
    final closedTradesData = await _apiService.getClosedTrades(
      count: _closedTradesCount,
      offset: _closedTradesOffset,
      from: 0,
      to: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    final balanceData = await _apiService.getBalanceOperationsHistory();

    setState(() {
      if (accountData != null) _accountInfo = AccountInfo.fromJson(accountData);
      _openTrades = openTradesData.map((e) => Trade.fromJson(e)).toList();
      _closedTrades = closedTradesData.map((e) => Trade.fromJson(e)).toList();
      _balanceHistory =
          balanceData.map((e) => BalanceOperation.fromJson(e)).toList();

      _calculateStats();
      _hasMoreClosedTrades = _closedTrades.length == _closedTradesCount;
      _isLoading = false;
    });
  }

  void _calculateStats() {
    _totalProfit = _closedTrades.fold(0.0, (sum, trade) => sum + trade.profit);
    _profitableTrades = _closedTrades.where((t) => t.profit > 0).length;
    _losingTrades = _closedTrades.where((t) => t.profit < 0).length;
  }

  Future<void> _loadMoreClosedTrades() async {
    if (!_hasMoreClosedTrades || _isLoading) return;

    setState(() => _isLoading = true);
    _closedTradesOffset += _closedTradesCount;

    final moreTradesData = await _apiService.getClosedTrades(
      count: _closedTradesCount,
      offset: _closedTradesOffset,
      from: 0,
      to: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    setState(() {
      final moreTrades = moreTradesData.map((e) => Trade.fromJson(e)).toList();
      _closedTrades.addAll(moreTrades);
      _hasMoreClosedTrades = moreTrades.length == _closedTradesCount;
      _calculateStats();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Trades',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF00D09C),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF00D09C),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Open'),
            Tab(text: 'Closed'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatsBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOpenTradesTab(),
                _buildClosedTradesTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total P/L',
              '${_totalProfit >= 0 ? '+' : ''}${_accountInfo?.currencySymbol ?? '\$'}${_totalProfit.toStringAsFixed(2)}',
              _totalProfit >= 0 ? Colors.green : Colors.red,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Win Rate',
              _closedTrades.isEmpty
                  ? '0%'
                  : '${((_profitableTrades / _closedTrades.length) * 100).toStringAsFixed(1)}%',
              Colors.blue,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Trades',
              '${_closedTrades.length}',
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildOpenTradesTab() {
    if (_isLoading && _openTrades.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: _openTrades.isEmpty
          ? _buildEmptyState(
              'No Open Trades',
              'You don\'t have any open positions',
              Icons.trending_up_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _openTrades.length,
              itemBuilder: (context, index) {
                return _buildTradeCard(_openTrades[index], isOpen: true);
              },
            ),
    );
  }

  Widget _buildClosedTradesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        _closedTradesOffset = 0;
        await _loadData();
      },
      child: _closedTrades.isEmpty && !_isLoading
          ? _buildEmptyState(
              'No Closed Trades',
              'Your completed trades will appear here',
              Icons.history_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _closedTrades.length + (_hasMoreClosedTrades ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _closedTrades.length) {
                  return _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : TextButton(
                          onPressed: _loadMoreClosedTrades,
                          child: const Text('Load More'),
                        );
                }
                return _buildTradeCard(_closedTrades[index], isOpen: false);
              },
            ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading && _balanceHistory.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: _balanceHistory.isEmpty
          ? _buildEmptyState(
              'No History',
              'Your transaction history will appear here',
              Icons.receipt_long_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _balanceHistory.length,
              itemBuilder: (context, index) {
                return _buildHistoryCard(_balanceHistory[index]);
              },
            ),
    );
  }

  Widget _buildTradeCard(Trade trade, {required bool isOpen}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: trade.isProfitable
                  ? Colors.green.withOpacity(0.05)
                  : Colors.red.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: trade.type == 0
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    trade.type == 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: trade.type == 0 ? Colors.green : Colors.red,
                    size: 20,
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
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trade.tradeType,
                        style: TextStyle(
                          fontSize: 12,
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
                    if (isOpen)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTradeDetailRow('Ticket', '#${trade.ticket}'),
                const SizedBox(height: 8),
                _buildTradeDetailRow(
                    'Open Price', trade.openPrice.toStringAsFixed(5)),
                if (!isOpen && trade.closePrice > 0) ...[
                  const SizedBox(height: 8),
                  _buildTradeDetailRow(
                      'Close Price', trade.closePrice.toStringAsFixed(5)),
                ],
                const SizedBox(height: 8),
                _buildTradeDetailRow('Volume', trade.volume.toString()),
                const SizedBox(height: 8),
                _buildTradeDetailRow('Swap',
                    '${_accountInfo?.currencySymbol ?? '\$'}${trade.swaps.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildTradeDetailRow(
                  'Open Time',
                  DateFormat('MMM dd, yyyy HH:mm').format(trade.openTime),
                ),
                if (!isOpen && trade.closeTime != null) ...[
                  const SizedBox(height: 8),
                  _buildTradeDetailRow(
                    'Close Time',
                    DateFormat('MMM dd, yyyy HH:mm').format(trade.closeTime!),
                  ),
                ],
                if (trade.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildTradeDetailRow('Comment', trade.comment),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
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

  Widget _buildHistoryCard(BalanceOperation operation) {
    final isDeposit = operation.operationType == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDeposit
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDeposit
                  ? Icons.add_circle_outline
                  : Icons.remove_circle_outline,
              color: isDeposit ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operation.operationTypeText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  operation.paymentSystem,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy HH:mm').format(operation.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isDeposit ? '+' : '-'}${_accountInfo?.currencySymbol ?? '\$'}${operation.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDeposit ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(operation.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  operation.statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(operation.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

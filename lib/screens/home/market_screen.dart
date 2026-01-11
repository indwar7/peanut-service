import 'package:flutter/material.dart';
import 'dart:math' as math;

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Banking',
    'IT',
    'Auto',
    'Pharma',
    'Energy'
  ];

  // Indian Market Indices
  final List<Map<String, dynamic>> _indices = [
    {
      'name': 'NIFTY 50',
      'value': '21,456.75',
      'change': '+234.50',
      'changePercent': '+1.11%',
      'isPositive': true,
    },
    {
      'name': 'SENSEX',
      'value': '71,283.45',
      'change': '+456.30',
      'changePercent': '+0.64%',
      'isPositive': true,
    },
    {
      'name': 'BANK NIFTY',
      'value': '45,678.90',
      'change': '-123.40',
      'changePercent': '-0.27%',
      'isPositive': false,
    },
  ];

  // Top Gainers
  final List<Map<String, dynamic>> _topGainers = [
    {
      'symbol': 'RELIANCE',
      'name': 'Reliance Industries',
      'price': '2,456.75',
      'change': '+5.67%',
      'changeValue': '+131.50',
      'icon': Icons.business,
      'color': Color(0xFF4CAF50),
      'sector': 'Energy',
    },
    {
      'symbol': 'TCS',
      'name': 'Tata Consultancy Services',
      'price': '3,678.90',
      'change': '+4.23%',
      'changeValue': '+149.30',
      'icon': Icons.computer,
      'color': Color(0xFF2196F3),
      'sector': 'IT',
    },
    {
      'symbol': 'HDFCBANK',
      'name': 'HDFC Bank',
      'price': '1,567.80',
      'change': '+3.89%',
      'changeValue': '+58.70',
      'icon': Icons.account_balance,
      'color': Color(0xFFFF9800),
      'sector': 'Banking',
    },
    {
      'symbol': 'INFY',
      'name': 'Infosys',
      'price': '1,432.50',
      'change': '+3.45%',
      'changeValue': '+47.80',
      'icon': Icons.computer,
      'color': Color(0xFF2196F3),
      'sector': 'IT',
    },
    {
      'symbol': 'TATAMOTORS',
      'name': 'Tata Motors',
      'price': '567.30',
      'change': '+2.98%',
      'changeValue': '+16.40',
      'icon': Icons.directions_car,
      'color': Color(0xFF9C27B0),
      'sector': 'Auto',
    },
  ];

  // Top Losers
  final List<Map<String, dynamic>> _topLosers = [
    {
      'symbol': 'ADANIENT',
      'name': 'Adani Enterprises',
      'price': '2,134.20',
      'change': '-4.56%',
      'changeValue': '-101.90',
      'icon': Icons.factory,
      'color': Color(0xFFF44336),
      'sector': 'Energy',
    },
    {
      'symbol': 'BHARTIARTL',
      'name': 'Bharti Airtel',
      'price': '876.45',
      'change': '-3.21%',
      'changeValue': '-29.10',
      'icon': Icons.cell_tower,
      'color': Color(0xFFF44336),
      'sector': 'Telecom',
    },
    {
      'symbol': 'BAJFINANCE',
      'name': 'Bajaj Finance',
      'price': '6,789.10',
      'change': '-2.87%',
      'changeValue': '-200.50',
      'icon': Icons.account_balance,
      'color': Color(0xFFFF9800),
      'sector': 'Banking',
    },
    {
      'symbol': 'SUNPHARMA',
      'name': 'Sun Pharma',
      'price': '1,123.40',
      'change': '-2.34%',
      'changeValue': '-26.90',
      'icon': Icons.local_pharmacy,
      'color': Color(0xFF00BCD4),
      'sector': 'Pharma',
    },
  ];

  // Most Active Stocks
  final List<Map<String, dynamic>> _mostActive = [
    {
      'symbol': 'ICICIBANK',
      'name': 'ICICI Bank',
      'price': '945.60',
      'change': '+1.23%',
      'volume': '45.2M',
      'icon': Icons.account_balance,
      'color': Color(0xFFFF9800),
      'sector': 'Banking',
    },
    {
      'symbol': 'SBIN',
      'name': 'State Bank of India',
      'price': '567.80',
      'change': '+0.89%',
      'volume': '38.7M',
      'icon': Icons.account_balance,
      'color': Color(0xFFFF9800),
      'sector': 'Banking',
    },
    {
      'symbol': 'WIPRO',
      'name': 'Wipro',
      'price': '456.90',
      'change': '-0.45%',
      'volume': '32.1M',
      'icon': Icons.computer,
      'color': Color(0xFF2196F3),
      'sector': 'IT',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF00D09C).withOpacity(0.05),
              Colors.white,
              const Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildIndices(),
              _buildCategoryFilter(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGainersList(),
                    _buildLosersList(),
                    _buildMostActiveList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Market',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00D09C),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live Updates',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Color(0xFF00D09C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  color: Color(0xFF1A1D2E),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndices() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _indices.length,
        itemBuilder: (context, index) {
          final item = _indices[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item['isPositive']
                    ? [
                        const Color(0xFF00D09C),
                        const Color(0xFF00A67E),
                      ]
                    : [
                        const Color(0xFFF44336),
                        const Color(0xFFD32F2F),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (item['isPositive']
                          ? const Color(0xFF00D09C)
                          : const Color(0xFFF44336))
                      .withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['value'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          item['isPositive']
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item['change']} (${item['changePercent']})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20, bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF00D09C), Color(0xFF00A67E)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00D09C).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D09C), Color(0xFF00A67E)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Top Gainers'),
          Tab(text: 'Top Losers'),
          Tab(text: 'Most Active'),
        ],
      ),
    );
  }

  Widget _buildGainersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _topGainers.length,
      itemBuilder: (context, index) {
        return _buildStockCard(_topGainers[index], true);
      },
    );
  }

  Widget _buildLosersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _topLosers.length,
      itemBuilder: (context, index) {
        return _buildStockCard(_topLosers[index], false);
      },
    );
  }

  Widget _buildMostActiveList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _mostActive.length,
      itemBuilder: (context, index) {
        return _buildMostActiveCard(_mostActive[index]);
      },
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock, bool isGainer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: stock['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stock['icon'],
              color: stock['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['symbol'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      stock['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: stock['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        stock['sector'],
                        style: TextStyle(
                          fontSize: 10,
                          color: stock['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${stock['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isGainer
                      ? const Color(0xFF00D09C).withOpacity(0.1)
                      : const Color(0xFFF44336).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      isGainer ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isGainer
                          ? const Color(0xFF00D09C)
                          : const Color(0xFFF44336),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stock['change'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isGainer
                            ? const Color(0xFF00D09C)
                            : const Color(0xFFF44336),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMostActiveCard(Map<String, dynamic> stock) {
    final isPositive = stock['change'].startsWith('+');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: stock['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stock['icon'],
              color: stock['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['symbol'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Vol: ${stock['volume']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${stock['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stock['change'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? const Color(0xFF00D09C)
                      : const Color(0xFFF44336),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/promo_provider.dart';
import '../widgets/promo_card.dart';
import '../utils/theme.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({Key? key}) : super(key: key);

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PromoProvider>(context, listen: false).fetchPromos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
      ),
      body: Consumer<PromoProvider>(
        builder: (context, promoProvider, _) {
          if (promoProvider.isLoading && promoProvider.promos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (promoProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    promoProvider.errorMessage!,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => promoProvider.fetchPromos(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (promoProvider.promos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No promotions available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => promoProvider.fetchPromos(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: promoProvider.promos.length,
              itemBuilder: (context, index) {
                return PromoCard(promo: promoProvider.promos[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
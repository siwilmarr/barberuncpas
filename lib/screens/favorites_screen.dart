import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/favorites_manager.dart';
import '../models/barber.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesManager = FavoritesManager();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ),
      body: ListenableBuilder(
        listenable: favoritesManager,
        builder: (context, child) {
          final favoriteNames = favoritesManager.favoriteShopNames;
          final favoriteShops = mockBarberShops.where((shop) => favoriteNames.contains(shop.name)).toList();

          if (favoriteShops.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.accent),
                  const SizedBox(height: 16),
                  const Text('No favorites yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteShops.length,
            itemBuilder: (context, index) {
              final shop = favoriteShops[index];
              return _buildFavoriteCard(context, shop);
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, BarberShop shop) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(shop: shop)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.asset(
                shop.image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(shop.address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(shop.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('Rp ${shop.price ~/ 1000}k+', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

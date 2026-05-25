import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../models/barber.dart';
import '../data/favorites_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final BarberShop shop;

  const DetailScreen({super.key, required this.shop});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoritesManager _favoritesManager = FavoritesManager();

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll('-', ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMap(String mapsUrl) async {
    final Uri uri = Uri.parse(mapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _favoritesManager,
        builder: (context, child) {
          final isFavorite = _favoritesManager.isFavorite(widget.shop.name);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      widget.shop.image,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _favoritesManager.toggleFavorite(widget.shop.name),
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 20),
                          const Icon(Icons.star, color: AppColors.primary, size: 20),
                          const Icon(Icons.star, color: AppColors.primary, size: 20),
                          const Icon(Icons.star, color: AppColors.primary, size: 20),
                          const Icon(Icons.star, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('${widget.shop.rating} (${widget.shop.reviews} reviews)', style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.shop.name, 
                        style: GoogleFonts.poppins(
                          fontSize: 30, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text(widget.shop.address, style: const TextStyle(color: AppColors.textSecondary))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (widget.shop.phoneNumber != 'not available')
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => _makeCall(widget.shop.phoneNumber),
                            icon: const Icon(Icons.phone),
                            label: Text('Call Now (+62) ${widget.shop.phoneNumber}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      if (widget.shop.phoneNumber == 'not available')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accent),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone_disabled, color: AppColors.textSecondary),
                              SizedBox(width: 12),
                              Text('Phone number not available', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      const Text(
                        'About the Shop', 
                        style: TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFE2E8F0)
                        )
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.shop.description,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF94A3B8), 
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Color(0xFFFDBA74), size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  'OPENING HOURS',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFFDBA74),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildOpeningHourRow('Monday - Sunday', widget.shop.openingHours),
                            const SizedBox(height: 12),
                            _buildOpeningHourRow('Saturday', '10:00 - 18:00'),
                            const SizedBox(height: 12),
                            _buildOpeningHourRow('Sunday', 'Closed', isClosed: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text('Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _openMap(widget.shop.mapsUrl),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=2066&auto=format&fit=crop'),
                              fit: BoxFit.cover,
                              opacity: 0.5,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.location_on, color: AppColors.primary, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOpeningHourRow(String day, String hours, {bool isClosed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day, 
          style: GoogleFonts.poppins(
            color: const Color(0xFFE2E8F0), 
            fontWeight: FontWeight.w500,
            fontSize: 14,
          )
        ),
        Text(
          hours, 
          style: GoogleFonts.poppins(
            color: isClosed ? const Color(0xFFF87171) : const Color(0xFFCBD5E1),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          )
        ),
      ],
    );
  }
}

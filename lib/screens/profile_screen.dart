import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../data/user_store.dart';
import '../data/mock_data.dart';
import '../models/barber.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserStore _userStore = UserStore();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Kompres agar ukuran Base64 tidak terlalu besar
    );
    
    if (image != null) {
      // Baca file sebagai bytes dan ubah ke Base64 agar tersimpan permanen di memori (LocalStorage)
      final bytes = await image.readAsBytes();
      final String base64Image = base64Encode(bytes);
      // Tambahkan prefix agar kita tahu ini adalah data image
      final String persistentUrl = 'data:image/png;base64,$base64Image';
      
      _userStore.updateProfile(photoUrl: persistentUrl);
    }
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: _userStore.currentUser?.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: AppColors.primary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _userStore.updateProfile(name: nameController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _userStore,
      builder: (context, child) {
        final user = _userStore.currentUser;
        final recentHistory = _userStore.recentlyViewedNames;
        
        final List<BarberShop> historyShops = recentHistory
            .map((name) => mockBarberShops.where((shop) => shop.name == name).firstOrNull)
            .whereType<BarberShop>()
            .toList();
        
        ImageProvider getImageProvider(String? url) {
          if (url == null || url.isEmpty) {
            return const NetworkImage('https://i.postimg.cc/9F7mR4nx/blank-profile.png');
          }
          if (url.startsWith('data:image')) {
            // Jika data adalah Base64 (untuk penyimpanan permanen di Web/Chrome)
            return MemoryImage(base64Decode(url.split(',').last));
          }
          if (url.startsWith('http')) {
            return NetworkImage(url);
          }
          if (!kIsWeb) {
            return FileImage(File(url));
          }
          return const NetworkImage('https://i.pravatar.cc/150?img=11');
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Image.asset('assets/image/logo.png', width: 82, height: 82),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text: 'BARBER', style: TextStyle(color: Color(0xFFE69110))),
                      const TextSpan(text: 'U', style: TextStyle(color: Color(0xFFA0522D))),
                      const TextSpan(text: 'NPAS', style: TextStyle(color: Color(0xFFE69110))),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundImage: getImageProvider(user?.photoUrl),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: getImageProvider(user?.photoUrl),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  user?.name ?? 'Guest User',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Member since October 2023',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _buildSectionHeader('ACCOUNT DETAILS'),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  label: 'Email Address',
                  value: user?.email ?? 'Not Logged In',
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('History'),
                const SizedBox(height: 16),
                if (historyShops.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No last seen history', style: TextStyle(color: AppColors.textSecondary)),
                  )
                else
                  ...historyShops.map((shop) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildHistoryItem(shop.image, shop.name, shop.rating),
                  )).toList(),
                const SizedBox(height: 48),
                TextButton.icon(
                  onPressed: () {
                    _userStore.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String imageUrl, String title, double rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isMinLength = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _isMinLength = _passwordController.text.length >= 8;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isSuccess,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF161B2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (isSuccess) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isSuccess ? 'Ke Halaman Login' : 'Mengerti',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSavePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 8) {
      _showStatusDialog(
        title: 'Password Terlalu Pendek',
        message: 'Demi keamanan, password minimal harus memiliki 8 karakter.',
        icon: Icons.lock_outline,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

    if (password != confirmPassword) {
      _showStatusDialog(
        title: 'Password Tidak Cocok',
        message: 'Konfirmasi password baru tidak sesuai dengan password yang Anda masukkan.',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

    // Success logic
    _showStatusDialog(
      title: 'Berhasil!',
      message: 'Password baru Anda telah berhasil disimpan. Silakan login kembali.',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      isSuccess: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color goldenColor = Color(0xFFFFB347);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: goldenColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              const TextSpan(text: 'BARBER', style: TextStyle(color: Color(0xFFE69110))),
              const TextSpan(text: 'U', style: TextStyle(color: Color(0xFFA0522D))),
              const TextSpan(text: 'NPAS', style: TextStyle(color: Color(0xFFE69110))),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Create New Password',
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ensure your password is strong and secure for your premium account.',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            
            // New Password Field
            _buildLabel('New Password'),
            _buildPasswordField(_passwordController, _obscurePassword, () {
              setState(() => _obscurePassword = !_obscurePassword);
            }),
            
            const SizedBox(height: 24),
            
            // Confirm New Password Field
            _buildLabel('Confirm New Password'),
            _buildPasswordField(_confirmPasswordController, _obscureConfirmPassword, () {
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
            }),
            
            const SizedBox(height: 32),
            
            // Security Requirements Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SECURITY REQUIREMENTS',
                    style: GoogleFonts.poppins(
                      color: goldenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _isMinLength ? goldenColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isMinLength ? goldenColor : Colors.white30,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: _isMinLength ? Colors.black : Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Minimum 8 characters',
                        style: GoogleFonts.poppins(
                          color: _isMinLength ? Colors.white : Colors.white54,
                          fontSize: 14,
                          fontWeight: _isMinLength ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSavePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  'SAVE PASSWORD',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool obscure, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: const TextStyle(color: Colors.white24),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white38,
            size: 22,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF0F121F),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFB347), width: 1.5),
        ),
      ),
    );
  }
}

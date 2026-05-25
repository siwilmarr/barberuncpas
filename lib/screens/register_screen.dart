import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/user_store.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  final UserStore _userStore = UserStore();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
                    if (isSuccess) Navigator.pop(context);
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
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                  children: [
                    const TextSpan(text: 'BARBER', style: TextStyle(color: Color(0xFFE69110))),
                    const TextSpan(text: 'U', style: TextStyle(color: Color(0xFFA0522D))),
                    const TextSpan(text: 'NPAS', style: TextStyle(color: Color(0xFFE69110))),
                    const TextSpan(text: ' PREMIUM SERVICE', style: TextStyle(color: Colors.white24)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showStatusDialog(
        title: 'Formulir Belum Lengkap',
        message: 'Mohon isi semua data yang diperlukan sebelum melanjutkan.',
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFFFB347),
      );
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      _showStatusDialog(
        title: 'Email Tidak Valid',
        message: 'Mohon gunakan alamat email @gmail.com yang valid.',
        icon: Icons.email_outlined,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

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
        message: 'Konfirmasi password tidak sesuai dengan password yang Anda masukkan.',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

    if (!_agreeToTerms) {
      _showStatusDialog(
        title: 'Persetujuan Diperlukan',
        message: 'Anda harus menyetujui Syarat dan Ketentuan sebelum mendaftar.',
        icon: Icons.check_box_outline_blank,
        iconColor: const Color(0xFFFFB347),
      );
      return;
    }

    if (_userStore.userExists(email)) {
      _showStatusDialog(
        title: 'Email Sudah Terdaftar',
        message: 'Alamat email ini sudah digunakan. Silakan gunakan email lain atau login.',
        icon: Icons.error_outline,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

    _userStore.registerUser(email, password, name).then((_) {
      if (mounted) {
        _showStatusDialog(
          title: 'Registrasi Berhasil',
          message: 'HOREE Registrasi anda berhasil !!!',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          isSuccess: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color goldenColor = Color(0xFFFFB347);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Column(
            children: [
              Image.asset('assets/image/logo.png', width: 140, height: 140),
              const SizedBox(height: 0),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(text: 'BARBER', style: TextStyle(color: Color(0xFFE69110))),
                    const TextSpan(text: 'U', style: TextStyle(color: Colors.white)),
                    const TextSpan(text: 'NPAS', style: TextStyle(color: Color(0xFFE69110))),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B2E), 
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Create Account', 
                        style: GoogleFonts.poppins(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          color: goldenColor,
                        )
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildLabel('Full Name'),
                    _buildTextField(_nameController, 'John Doe', Icons.person_outline),
                    const SizedBox(height: 20),
                    _buildLabel('Email'),
                    _buildTextField(_emailController, 'john@example.com', Icons.email_outlined),
                    const SizedBox(height: 20),
                    _buildLabel('Password'),
                    _buildPasswordField(_passwordController, _obscurePassword, () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    }),
                    const SizedBox(height: 20),
                    _buildLabel('Confirm Password'),
                    _buildPasswordField(_confirmPasswordController, _obscureConfirmPassword, () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    }),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                          activeColor: AppColors.primary,
                          checkColor: Colors.black,
                          side: const BorderSide(color: Colors.white30, width: 1.5),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(text: 'Terms and Conditions', style: GoogleFonts.poppins(color: goldenColor, fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' and the '),
                                TextSpan(text: 'Privacy Policy', style: GoogleFonts.poppins(color: goldenColor, fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' of '),
                                TextSpan(
                                  children: [
                                    const TextSpan(text: 'BARBER', style: TextStyle(color: Color(0xFFE69110))),
                                    const TextSpan(text: 'U', style: TextStyle(color: Color(0xFFA0522D))),
                                    const TextSpan(text: 'NPAS', style: TextStyle(color: Color(0xFFE69110))),
                                  ],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Register', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: GoogleFonts.poppins(color: Colors.white70)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Log In', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text, 
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        filled: true,
        fillColor: const Color(0xFF0F121F), 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white38, size: 20),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF0F121F),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

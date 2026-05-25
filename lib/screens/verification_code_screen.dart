import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_new_password_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String correctCode;
  const VerificationCodeScreen({super.key, required this.correctCode});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  late String _currentCorrectCode;
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _currentCorrectCode = widget.correctCode;
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      _start = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendCode() {
    // Generate kode baru (simulasi)
    String newCode = (Random().nextInt(900000) + 100000).toString();
    setState(() {
      _currentCorrectCode = newCode;
    });
    
    debugPrint('=========================================');
    debugPrint('KODE VERIFIKASI BARU TELAH DIKIRIM');
    debugPrint('KODE LAMA TELAH DIMATIKAN');
    debugPrint('KODE VERIFIKASI BARU ANDA: $newCode');
    debugPrint('=========================================');

    // Hapus input lama
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    // Mulai ulang timer
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
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
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Mengerti',
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

  void _handleVerify() {
    // Cek apakah waktu sudah habis
    if (_start == 0) {
      _showStatusDialog(
        title: 'Kode Kedaluwarsa',
        message: 'Batas waktu 1 menit telah habis. Silakan kirim ulang kode verifikasi baru.',
        icon: Icons.timer_off_outlined,
        iconColor: const Color(0xFFF87171),
      );
      // Hapus kode yang sudah diisi
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      return;
    }

    String enteredCode = _controllers.map((c) => c.text).join("");

    if (enteredCode.isEmpty) {
      _showStatusDialog(
        title: 'Formulir Kosong',
        message: 'Mohon isi kode verifikasi sebelum melanjutkan.',
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFFFB347),
      );
      return;
    }

    if (enteredCode.length < 6) {
      _showStatusDialog(
        title: 'Kode Belum Lengkap',
        message: 'Mohon masukkan 6-digit kode verifikasi secara lengkap.',
        icon: Icons.error_outline,
        iconColor: const Color(0xFFF87171),
      );
      return;
    }

    if (enteredCode != _currentCorrectCode) {
      _showStatusDialog(
        title: 'Kode Salah',
        message: 'Kode verifikasi yang Anda masukkan tidak sesuai. Silakan coba lagi.',
        icon: Icons.cancel_outlined,
        iconColor: const Color(0xFFF87171),
      );
      
      // HAPUS SEMUA INPUT JIKA SALAH
      setState(() {
        for (var controller in _controllers) {
          controller.clear();
        }
      });
      // Pindahkan fokus kembali ke kotak pertama
      _focusNodes[0].requestFocus();
      return;
    }

    // Success
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNewPasswordScreen()),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB347)),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Form Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
                ),
                child: Column(
                  children: [
                    // Lock Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_open_rounded, color: Color(0xFFFFB347), size: 40),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Verification Code',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the 6-digit code sent to your\nemail',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFB347),
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: const Color(0xFF0F121F),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'VERIFY',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Timer and Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Resend code in ",
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    formatTime(_start),
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (_canResend)
                TextButton(
                  onPressed: _resendCode,
                  child: Text(
                    "Resend Now",
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

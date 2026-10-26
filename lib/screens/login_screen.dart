import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi ulang jika nama sudah tersimpan di state.
    _nameController.text = context.read<UserProvider>().name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nama tidak boleh kosong';
    if (v.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserProvider>().login(_nameController.text);
    context.read<QuizProvider>().reset();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scheme = Theme.of(context).colorScheme;

    // Ukuran dinamis berdasarkan layar.
    final horizontalPadding = (size.width * 0.06).clamp(20.0, 48.0);
    final logoSize = (size.shortestSide * 0.28).clamp(80.0, 140.0);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  // Batasi lebar agar tetap rapi di tablet / web.
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Logo(size: logoSize),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          'Selamat Datang!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masukkan namamu untuk memulai kuis',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        SizedBox(height: size.height * 0.04),
                        CustomTextField(
                          controller: _nameController,
                          label: 'Nama',
                          hint: 'Contoh: Budi Santoso',
                          icon: Icons.person_rounded,
                          validator: _validateName,
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          text: 'Mulai Kuis',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 8,
              right: 12,
              child: ThemeToggleButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final double size;
  const _Logo({required this.size});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            // Fallback ikon jika logo.png belum ditambahkan.
            errorBuilder: (_, __, ___) => Icon(
              Icons.quiz_rounded,
              size: size * 0.55,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

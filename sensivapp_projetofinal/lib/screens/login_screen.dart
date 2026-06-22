import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/ui_helpers.dart';
import '../widgets/auth_background.dart';
import '../widgets/stellar_button.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/api_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService().login(
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );

      if (mounted) {
        SensivSnackBar.show(context, "Bem-vindo(a)!", isError: false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        SensivSnackBar.show(
            context, "Erro: ${e.toString().replaceAll('Exception: ', '')}");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pink = AppTheme.sensivPink;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          Container(
            color: scaffoldBg,
            child: AuthBackground(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_hospital,
                              size: 50, color: pink),
                          const SizedBox(width: 12),
                          const Text(
                            "SensivApp",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w200,
                              color: pink,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Entrar",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: textColor),
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'E-mail',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? "Obrigatório"
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _senhaController,
                                style: TextStyle(color: textColor),
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Senha',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? "Obrigatório"
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : StellarButton(
                                      text: "ENTRAR",
                                      onPressed: _login,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => SensivSnackBar.show(
                                context, "Funcionalidade em desenvolvimento"),
                            child: const Text("Esqueci minha senha",
                                style: TextStyle(color: pink, fontSize: 16)),
                          ),
                          const Text("|", style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: const Text("Cadastre-se",
                                style: TextStyle(
                                    color: pink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 50,
            right: 20,
            child: ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}

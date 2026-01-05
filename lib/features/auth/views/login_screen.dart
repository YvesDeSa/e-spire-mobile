import 'package:flutter/material.dart';
import 'package:mobile/features/auth/views/register_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../components/molecules/custom_input.dart';
import '../../../../components/atoms/social_button.dart';
import '../view_models/login_view_model.dart';
import '../../home/views/home_screen.dart';
import '../../../../core/utils/toast_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscureText = true;
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() => setState(() {}));

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _viewModel.validateEmail(_emailController.text);
      }
    });

    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, color: AppColors.primary, size: 85),
                    SizedBox(width: 2),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Bem-vindo!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Insira seus dados para acessar seus treinos e estante de troféus.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40),

                CustomInput(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  hintText: "E-mail",
                  icon: Icons.person_outline,
                  errorText: _viewModel.emailError,
                  onChanged: (val) {
                    if (_viewModel.emailError != null)
                      _viewModel.emailError = null;
                  },
                ),
                SizedBox(height: 20),

                CustomInput(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  hintText: "Senha",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscureText,
                  onToggleObscure: () =>
                      setState(() => _obscureText = !_obscureText),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  "Entrar com conta social",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      imageUrl:
                          "https://agenciapnz.com/wp-content/uploads/Logo-Google-G.png",
                      onTap: _viewModel.isLoading
                          ? null
                          : () async {
                              bool success = await _viewModel.loginGoogle();

                              if (success) {
                                ToastService.success(
                                  context,
                                  "Login realizado com sucesso!",
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                if (_viewModel.apiError != null) {
                                  ToastService.error(
                                    context,
                                    _viewModel.apiError!,
                                  );
                                } else {
                                  ToastService.error(
                                    context,
                                    "Não foi possível entrar com o Google.",
                                  );
                                }
                              }
                            },
                    ),
                    SizedBox(width: 16),
                    SocialButton(
                      icon: Icons.facebook,
                      iconColor: Color(0xFF1877F2),
                      onTap: () => print("Facebook"),
                    ),
                    SizedBox(width: 16),
                    SocialButton(
                      icon: Icons.apple,
                      iconColor: Colors.white,
                      onTap: () => print("Apple"),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _viewModel.isLoading
                        ? null
                        : () async {
                            bool success = await _viewModel.login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (success) {
                              ToastService.success(
                                context,
                                "Bem-vindo de volta!",
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              if (_viewModel.apiError != null) {
                                ToastService.error(
                                  context,
                                  _viewModel.apiError!,
                                );
                              } else {
                                ToastService.info(
                                  context,
                                  "Verifique seus dados.",
                                );
                              }
                            }
                          },
                    child: _viewModel.isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ainda não tem uma conta? ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

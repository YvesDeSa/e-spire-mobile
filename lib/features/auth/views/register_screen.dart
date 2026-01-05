import 'package:flutter/material.dart';
import 'package:mobile/core/utils/toast_service.dart' show ToastService;
import 'package:mobile/features/auth/views/login_screen.dart' show LoginScreen;
import 'package:mobile/features/home/views/home_screen.dart' show HomeScreen;
import '../../../../core/theme/app_colors.dart';
import '../../../../components/molecules/custom_input.dart';
import '../view_models/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final RegisterViewModel _viewModel = RegisterViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel.addListener(() => setState(() {}));

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) _viewModel.validateName(_nameController.text);
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus)
        _viewModel.validateEmail(_emailController.text);
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        _viewModel.validatePassword(_passwordController.text);
        if (_confirmController.text.isNotEmpty) {
          _viewModel.validateConfirm(
            _passwordController.text,
            _confirmController.text,
          );
        }
      }
    });

    _confirmController.addListener(() {
      _viewModel.validateConfirm(
        _passwordController.text,
        _confirmController.text,
      );
    });

    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
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
                  "Crie sua conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Junte-se à comunidade e comece a treinar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 30),

                CustomInput(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  hintText: "Nome completo",
                  icon: Icons.person_outline,
                  errorText: _viewModel.nameError,
                  onChanged: (val) => _viewModel.nameError = null,
                ),
                SizedBox(height: 20),

                CustomInput(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  hintText: "Seu melhor e-mail",
                  icon: Icons.email_outlined,
                  errorText: _viewModel.emailError,
                  onChanged: (val) => _viewModel.emailError = null,
                ),
                SizedBox(height: 20),

                CustomInput(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  hintText: "Crie uma senha",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  errorText: _viewModel.passwordError,
                  onChanged: (val) => _viewModel.passwordError = null,
                ),
                SizedBox(height: 20),

                CustomInput(
                  controller: _confirmController,
                  focusNode: _confirmFocus,
                  hintText: "Confirme a senha",
                  icon: Icons.lock_reset,
                  isPassword: true,
                  obscureText: _obscureConfirm,
                  onToggleObscure: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  errorText: _viewModel.confirmError,
                  successText: _viewModel.confirmSuccess,
                ),

                SizedBox(height: 40),

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
                            bool success = await _viewModel.register(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _confirmController.text,
                            );

                            if (success) {
                              ToastService.success(
                                context,
                                "Bem-vindo! Cadastro realizado.",
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
                                  "Verifique os campos em vermelho.",
                                );
                              }
                            }
                          },
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já tem uma conta? ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

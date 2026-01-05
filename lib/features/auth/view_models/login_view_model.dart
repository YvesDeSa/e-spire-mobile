import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  String? emailError;
  String? passwordError;
  String? apiError;
  bool isLoading = false;
  
  bool validateEmail(String text) {
    emailError = Validators.validateEmail(text);
    return emailError == null;
  }

  bool validatePassword(String text) {
    passwordError = Validators.validatePassword(text);
    return passwordError == null;
  }

  Future<bool> loginGoogle() async {
    apiError = null;
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.loginWithGoogle();

      isLoading = false;

      if (result['success']) {
        String token = result['token'];
        await _storageService.saveToken(token);
        
        notifyListeners();
        return true;
      } else {
        apiError = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      apiError = "Erro inesperado no Google Login";
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    apiError = null;

    bool isEmailOk = validateEmail(email);
    bool isPassOk = validatePassword(password);
    if (!isEmailOk || !isPassOk) {
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();
    final result = await _authService.login(
      email.trim(),  
      password.trim() 
    );

    isLoading = false;

    if (result['success']) {
      String token = result['token'];
      await _storageService.saveToken(token);

      print("Token salvo com sucesso: $token");
      notifyListeners();
      return true;
    } else {
      apiError = result['message'];
      notifyListeners();
      return false;
    }
  }
}

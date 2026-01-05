import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class RegisterViewModel extends ChangeNotifier {
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmError;
  String? confirmSuccess;

  bool isLoading = false;
  String? apiError;

  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  bool validateName(String text) {
    nameError = Validators.validateName(text);
    notifyListeners(); 
    return nameError == null;
  }

  bool validateEmail(String text) {
    emailError = Validators.validateEmail(text);
    notifyListeners();
    return emailError == null;
  }

  bool validatePassword(String text) {
    passwordError = Validators.validatePassword(text);
    if (confirmError != null || confirmSuccess != null) {
    }
    notifyListeners();
    return passwordError == null;
  }

  bool validateConfirm(String password, String confirm) {
    if (confirm.isEmpty) {
      confirmError = null;
      confirmSuccess = null;
      notifyListeners();
      return false;
    }

    confirmError = Validators.validateConfirmPassword(password, confirm);
    confirmSuccess = confirmError == null ? "Senhas conferem!" : null;
    
    notifyListeners();
    return confirmError == null;
  }

  Future<bool> register(String name, String email, String pass, String confirm) async {
    apiError = null; 
    
    bool n = validateName(name);
    bool e = validateEmail(email);
    bool p = validatePassword(pass);
    bool c = validateConfirm(pass, confirm);

    if (!n || !e || !p || !c) {
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.register(name, email, pass);

      isLoading = false;

      if (result['success']) {
        String token = result['token'];
        await _storageService.saveToken(token);
        
        print("Cadastro com login automático: Token salvo!");
        notifyListeners();
        return true;
      } else {
        apiError = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      apiError = "Erro inesperado: $e";
      notifyListeners();
      return false;
    }
  }
}
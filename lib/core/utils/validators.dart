class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Nome é obrigatório";
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email é obrigatório";
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) return "Email inválido";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return "Mínimo de 6 caracteres";
    return null;
  }

  static String? validateConfirmPassword(String? original, String? confirm) {
    if (confirm == null || confirm.isEmpty) return null; 
    if (original != confirm) return "As senhas não coincidem";
    return null; 
  }
}
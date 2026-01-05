import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '911653921754-a588eqvc2ot53hjlupkodbalqha7jh2a.apps.googleusercontent.com',
    scopes: ['email', 'profile'], 
  );

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'message': 'Login cancelado pelo usuário.'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'success': false, 'message': 'Falha ao obter token do Google.'};
      }

      return _sendGoogleTokenToBackend(idToken);

    } catch (e) {
      print("ERRO CRÍTICO GOOGLE: $e"); 
      return {'success': false, 'message': 'Erro Google: $e'};
    }
  }

  Future<Map<String, dynamic>> _sendGoogleTokenToBackend(String idToken) async {
    final uri = Uri.parse('${baseUrl.replaceAll(RegExp(r'/$'), '')}/auth/google'); 
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': idToken,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true, 
          'token': responseBody['accessToken'] 
        };
      } else {
        return {
          'success': false, 
          'message': responseBody['message'] ?? 'Falha no login social.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão com servidor.'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('${baseUrl.replaceAll(RegExp(r'/$'), '')}/auth/login'); 

    final bodyData = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: bodyData,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'token': responseBody['accessToken']}; 
      } else {
        return {
          'success': false, 
          'message': responseBody['message'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      print("ERRO EXCEPTION: $e");
      return {'success': false, 'message': 'Erro de conexão'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final uri = Uri.parse('${baseUrl.replaceAll(RegExp(r'/$'), '')}/auth/register'); 

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'token': responseBody['accessToken'], 
          'user': responseBody['user'] 
        };
      } 
      else {
        return {
          'success': false, 
          'message': responseBody['message'] ?? 'Erro ao realizar cadastro.'
        };
      }
    } catch (e) {
      print("Erro no registro: $e");
      return {'success': false, 'message': 'Erro de conexão.'};
    }
  }
}
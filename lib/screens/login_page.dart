import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final void Function(int userId) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse(
      'https://apicinephoria-bf9xgq.fly.dev/api/Login/authenticate',
    );

    try {
      print('⏳ Envoi de la requête vers l\'API : $url');
      print(
        '📨 Corps de la requête : ${jsonEncode({'email': _emailCtrl.text, 'password': _passwordCtrl.text})}',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailCtrl.text,
          'password': _passwordCtrl.text,
        }),
      );

      print('✅ Réponse reçue (code ${response.statusCode})');
      print('📦 Corps de la réponse : ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final int userId = responseData['userId']; // récupère l'ID

        // Stocker localement avec shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);

        widget.onLoginSuccess(userId); // <-- bien passer userId ici
      } else {
        setState(() {
          _errorMessage = 'Erreur ${response.statusCode} : ${response.body}';
        });
      }
    } catch (e) {
      print('❌ Erreur pendant la requête : $e');
      setState(() {
        _errorMessage = 'Erreur réseau : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/logo.png', // chemin de ton logo
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),

            // Le formulaire doit être dans la colonne !
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // ne prend pas toute la hauteur
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // bouton largeur max
                children: [
                  TextFormField(
                    cursorColor: Colors.white,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Veuillez entrer un email';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    cursorColor: Colors.white,
                    controller: _passwordCtrl,
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Veuillez entrer un mot de passe';
                      if (v.length < 6) return 'Mot de passe trop court';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: TextStyle(color: Colors.white70),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ],
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF073FA0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Arquivo: lib/auth/password_reset_screen.dart
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "providers/auth_controller.dart";

class PasswordResetScreen extends StatefulWidget {
  static const String routeName = "/password-reset";

  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _message = null;
        _isError = false;
      });

      final authService = Provider.of<AuthController>(context, listen: false);
      final error = await authService.sendPasswordResetEmail(_emailController.text);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (error != null) {
            _message = error;
            _isError = true;
          } else {
            _message =
                "E-mail de redefinição de senha enviado com sucesso! Verifique sua caixa de entrada.";
            _isError = false;
            _emailController.clear();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Redefina sua senha",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Digite seu e-mail abaixo e enviaremos um link para você redefinir sua senha.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor, insira seu e-mail.";
                    }
                    if (!value.contains("@")) {
                      return "Por favor, insira um e-mail válido.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color:
                            _isError
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _sendResetEmail,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                      child: const Text("ENVIAR E-MAIL DE REDEFINIÇÃO"),
                    ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(
                                context,
                              ).pop(); // Volta para a tela de login
                            }
                          },
                  child: const Text("Voltar para o Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

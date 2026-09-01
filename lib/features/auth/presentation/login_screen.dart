import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:meu_app/features/auth/presentation/providers/auth_controller.dart";
import "package:provider/provider.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() { _isLoading = true; _errorMessage = null; });

    debugPrint("1. Antes de chamar login()");
    final authController = context.read<AuthController>();
    final error = await authController.login(
      email: _emailController.text.trim(),
      senha: _passwordController.text.trim(),
    );
    debugPrint("2. Depois de login() — error: $error");

    if (mounted && error != null) {
      debugPrint("3. Widget ainda montado, chamando setState");
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
      debugPrint("4. setState concluído");
    } else {
      debugPrint("3b. Widget JÁ FOI DESMONTADO antes do setState");
    }
  }
}
  void _continueAsVisitor() {
    context.read<AuthController>().entrarComoVisitante();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        automaticallyImplyLeading: false,
      ),
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
                  "Bem-vindo(a) ao AvaliaUBS!",
                  style: Theme.of(context).textTheme.headlineSmall,
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
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor, insira sua senha.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : () => context.push('/reset-senha'),
                    child: const Text("Esqueceu a senha?"),
                  ),
                ),
                const SizedBox(height: 24.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 16.0),
                        ),
                        child: const Text("ENTRAR"),
                      ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Não tem uma conta?"),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.push('/signup'),
                      child: const Text("CADASTRE-SE"),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                OutlinedButton(
                  onPressed: _isLoading ? null : _continueAsVisitor,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12.0)),
                  child: const Text("Continuar como Visitante"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
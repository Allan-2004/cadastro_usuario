import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  // Depois da primeira tentativa de cadastro, os erros passam a ser
  // revalidados enquanto o usuário digita.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Regex para validação de e-mail mais robusta (desafio extra).
  static final RegExp _emailRegExp =
      RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  // ---------------- VALIDADORES ----------------

  String? _validarNome(String? value) {
    final nome = value?.trim() ?? '';
    if (nome.isEmpty) return 'Informe o nome completo';
    if (nome.length < 3) return 'O nome deve ter pelo menos 3 caracteres';
    if (!nome.contains(' ')) return 'Informe nome e sobrenome';
    return null;
  }

  String? _validarEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe o e-mail';
    if (!email.contains('@')) return 'O e-mail deve conter "@"';
    if (!_emailRegExp.hasMatch(email)) return 'Informe um e-mail válido';
    return null;
  }

  String? _validarCpf(String? value) {
    final cpf = value ?? '';
    if (cpf.isEmpty) return 'Informe o CPF';
    if (!RegExp(r'^\d+$').hasMatch(cpf)) return 'O CPF deve conter apenas números';
    if (cpf.length != 11) return 'O CPF deve ter 11 dígitos';
    return null;
  }

  String? _validarTelefone(String? value) {
    final telefone = value ?? '';
    if (telefone.isEmpty) return 'Informe o telefone';
    if (!RegExp(r'^\d+$').hasMatch(telefone)) {
      return 'O telefone deve conter apenas números';
    }
    if (telefone.length < 10) return 'Informe DDD + número (10 ou 11 dígitos)';
    return null;
  }

  String? _validarSenha(String? value) {
    final senha = value ?? '';
    if (senha.isEmpty) return 'Informe a senha';
    if (senha.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
    return null;
  }

  String? _validarConfirmacaoSenha(String? value) {
    final confirmacao = value ?? '';
    if (confirmacao.isEmpty) return 'Confirme a senha';
    if (confirmacao != _senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  // ---------------- AÇÃO DO BOTÃO ----------------

  void _cadastrar() {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();

      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Usuário $nome cadastrado com sucesso!')),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _formKey.currentState!.reset();
      for (final c in [
        _nomeController,
        _emailController,
        _cpfController,
        _telefoneController,
        _senhaController,
        _confirmaSenhaController,
      ]) {
        c.clear();
      }
      setState(() => _autovalidateMode = AutovalidateMode.disabled);
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Corrija os campos destacados em vermelho.')),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ---------------- TELA ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome completo
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: _validarNome,
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'exemplo@email.com',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: _validarEmail,
              ),
              const SizedBox(height: 16),

              // CPF
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente números (11 dígitos)',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: _validarCpf,
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD + número, somente números',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: _validarTelefone,
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Mínimo de 6 caracteres',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(
                      _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                  ),
                ),
                validator: _validarSenha,
              ),
              const SizedBox(height: 16),

              // Confirmação de senha (desafio extra)
              TextFormField(
                controller: _confirmaSenhaController,
                obscureText: _ocultarConfirmacao,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _cadastrar(),
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip:
                        _ocultarConfirmacao ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(
                      _ocultarConfirmacao
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                        () => _ocultarConfirmacao = !_ocultarConfirmacao),
                  ),
                ),
                validator: _validarConfirmacaoSenha,
              ),
              const SizedBox(height: 24),

              // Botão CADASTRAR
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                child: const Text('CADASTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

# Cadastro de Usuário — Atividade 07 (Desenvolvimento Mobile)

Tela de cadastro de usuário em Flutter com captura de dados, filtros de entrada, validação campo a campo e feedback visual via SnackBar.

## Campos e regras

| Campo | Teclado | Filtro de entrada | Validação |
|---|---|---|---|
| Nome completo | `name` | — | Obrigatório, nome e sobrenome |
| E-mail | `emailAddress` | Bloqueia espaços | Obrigatório, contém `@`, formato válido (RegExp) |
| CPF | `number` | `digitsOnly`, máx. 11 | Obrigatório, só números, 11 dígitos |
| Telefone | `phone` | `digitsOnly`, máx. 11 | Obrigatório, só números, 10–11 dígitos |
| Senha | `visiblePassword` | — | Obrigatória, mínimo 6 caracteres |
| Confirmar senha | `visiblePassword` | — | Igual à senha |

## Comportamento

- O botão **CADASTRAR** chama `_formKey.currentState!.validate()`.
- Os erros aparecem abaixo de cada campo inválido; após a primeira tentativa, são revalidados enquanto o usuário digita.
- Formulário válido → SnackBar verde de sucesso e o formulário é limpo.

## Desafios extras implementados

- Campo de confirmação de senha
- Botão mostrar/ocultar senha
- Validação de e-mail com `RegExp`
- SnackBar de erro em vermelho

## Estrutura de widgets

```
Scaffold
└── Form(key: _formKey)
    └── SingleChildScrollView (padding 24)
        └── Column
            ├── TextFormField (nome)
            ├── TextFormField (e-mail)
            ├── TextFormField (CPF)
            ├── TextFormField (telefone)
            ├── TextFormField (senha)
            ├── TextFormField (confirmar senha)
            └── ElevatedButton (CADASTRAR)
```

## Como executar

```bash
flutter create .   # gera as pastas de plataforma (android, ios, web...)
flutter pub get
flutter run
```

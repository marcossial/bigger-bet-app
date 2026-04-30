# Bigger Bet – Flutter Onboarding

## Estrutura dos arquivos gerados

```
lib/
├── main.dart                                   ← Entry point
├── core/
│   └── theme/
│       └── app_theme.dart                      ← Cores e tema global
└── features/
    └── onboarding/
        ├── onboarding_data.dart                ← Conteúdo das 3 páginas
        ├── screens/
        │   └── onboarding_screen.dart          ← Tela principal (PageView)
        └── widgets/
            ├── bigger_bet_logo.dart            ← Logo com borda neon verde
            ├── continue_button.dart            ← Botão "CONTINUAR"
            └── page_indicator.dart             ← Dots indicadores de página
```

## Setup

### 1. Copie os arquivos para o seu projeto

Copie toda a pasta `lib/` e o `pubspec.yaml` para o seu projeto Flutter.

### 2. Adicione as imagens de onboarding

Crie a pasta `assets/images/` na raiz do projeto e coloque:
- `assets/images/onboarding_1.png`
- `assets/images/onboarding_2.png`
- `assets/images/onboarding_3.png`

> As imagens são as que você já tem (Onboarding_1.png, 2, 3).

### 3. (Opcional) Fonte Impact para o logo

A fonte **Impact** deixa o logo idêntico ao design. Para usá-la:
1. Baixe `impact.ttf` (está no Windows em `C:/Windows/Fonts/impact.ttf`)
2. Coloque em `assets/fonts/impact.ttf`
3. Descomente o bloco `fonts:` no `pubspec.yaml`

### 4. Instale as dependências

```bash
flutter pub get
```

### 5. Rode

```bash
flutter run
```

## Navegação após o onboarding

No `main.dart`, dentro do callback `onFinished`, substitua o `debugPrint`
pela navegação para a tela de Login/Cadastro:

```dart
onFinished: () {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
},
```

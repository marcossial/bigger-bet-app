import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:bigger_bet/features/games/utils/finance_manager.dart';
import 'package:bigger_bet/core/database/database_service.dart';
import 'package:bigger_bet/core/services/session_service.dart';

/// TELA DO JOGO: ROleta Sarcástica e Educativa ("Brazilian Roulette")
/// 
/// Esta classe é um [StatefulWidget] porque a tela precisa guardar e atualizar
/// dados dinâmicos em tempo real, como o saldo do usuário, o valor apostado,
/// a animação da roleta girando e as mensagens sarcásticas do algoritmo.
class BrazilianRouletteScreen extends StatefulWidget {
  const BrazilianRouletteScreen({super.key});

  @override
  State<BrazilianRouletteScreen> createState() => _BrazilianRouletteScreenState();
}

/// O Estado da tela estende a classe e mistura (mixin) o [SingleTickerProviderStateMixin]
/// para podermos usar o [AnimationController], que gerencia o tempo e a velocidade da animação.
class _BrazilianRouletteScreenState extends State<BrazilianRouletteScreen>
    with SingleTickerProviderStateMixin {
  
  // ──────────────────────────────────────────────────────────────────────────
  // VARIÁVEIS DE ESTADO (O coração dinâmico da tela)
  // ──────────────────────────────────────────────────────────────────────────
  
  double _saldo = 0.00; // Loaded from DB
  int? _userId;
  double _aposta = 100.00; // Valor da aposta padrão
  bool _girando = false; // Bloqueia cliques novos se a roleta já estiver girando
  String _mensagemAlgoritmo = 'A roleta da felicidade (totalmente honesta) te espera! Aposte já.';

  // Controlador de animação do Flutter
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Controlador do campo de texto da aposta
  final TextEditingController _apostaController = TextEditingController(text: '100');

  // Variáveis matemáticas da roleta
  double _anguloRotacao = 0.0; // Ângulo atual de rotação da roleta em radianos
  int _setorSorteado = 0; // Guardará o índice do setor sorteado pelo algoritmo

  // ──────────────────────────────────────────────────────────────────────────
  // CONFIGURAÇÃO DOS SETORES DA ROLETA
  // ──────────────────────────────────────────────────────────────────────────
  
  // Criamos uma lista simples com os 8 setores da roleta.
  // Cada setor tem um título, uma cor de fundo cyberpunk e se é um setor vencedor (isWin).
  final List<Map<String, dynamic>> _setores = [
    {'titulo': 'PERDEU TUDO', 'cor': const Color(0xFF240A0A), 'isWin': false},
    {'titulo': 'QUASE LÁ!', 'cor': const Color(0xFF1E112A), 'isWin': false},
    {'titulo': 'CEO MAIS RICO', 'cor': const Color(0xFF0F1A1F), 'isWin': false},
    {'titulo': 'MUITO PERTO!', 'cor': const Color(0xFF1B1B1B), 'isWin': false},
    {'titulo': 'GANHOU 100x!', 'cor': AppColors.neonGreen, 'isWin': true}, // O único vencedor!
    {'titulo': 'TAXA EXTRA 99%', 'cor': const Color(0xFF240A1A), 'isWin': false},
    {'titulo': 'TENTE DE NOVO', 'cor': const Color(0xFF111425), 'isWin': false},
    {'titulo': 'QUASE GANHOU!', 'cor': const Color(0xFF101B15), 'isWin': false},
  ];

  // Mensagens irônicas que aparecem ao perder
  final List<String> _mensagensPerda = [
    'Quase! O algoritmo calculou que se você tentar de novo, suas chances sobem em 0.0001%!',
    'Que pena... Mas o nosso CEO comprou uma roda nova para a Lamborghini dele. Obrigado!',
    'Não desanime! 99% dos apostadores desistem logo antes de ganhar uma fortuna!',
    'A física é difícil, a sorte é rara, mas o seu dinheiro agora é nosso de forma 100% legal.',
    'A roleta parou do ladinho do prêmio! Claramente foi por muito pouco. Tente mais uma!',
  ];

  // ──────────────────────────────────────────────────────────────────────────
  // CICLO DE VIDA DO WIDGET
  // ──────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadBalance();

    // 1. Inicializa o controlador da animação durando 3.5 segundos
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 2. Cria uma animação de desaceleração suave (easeOutCubic)
    // Isso simula o atrito físico real da roleta freando
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // 3. Ouve cada pequena mudança no valor da animação para rodar a roleta na tela
    _animationController.addListener(() {
      setState(() {
        _anguloRotacao = _animation.value;
      });
    });

    // 4. Ouve o término da animação para disparar o resultado
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finalizarGiro();
      }
    });
  }

  @override
  void dispose() {
    // É uma boa prática limpar os controladores ao fechar a tela para economizar memória do celular
    _animationController.dispose();
    _apostaController.dispose();
    super.dispose();
  }

  Future<void> _loadBalance() async {
    _userId = await SessionService.getUserId();
    if (_userId != null) {
      final balance = await DatabaseService().getUserBalance(_userId!);
      if (mounted) {
        setState(() {
          _saldo = balance;
        });
      }
    }
  }

  Future<void> _saveBalance() async {
    if (_userId != null) {
      await DatabaseService().updateBalance(_userId!, _saldo);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LÓGICA DO JOGO (Simples e didática)
  // ──────────────────────────────────────────────────────────────────────────

  /// Inicia o giro da roleta calculando a fraude da banca
  void _iniciarGiro() {
    if (_girando) return; // Se já estiver girando, ignora novos cliques

    // Valida se o texto digitado na aposta é um número válido
    final valorDigitado = double.tryParse(_apostaController.text);
    if (valorDigitado == null || valorDigitado <= 0) {
      setState(() {
        _mensagemAlgoritmo = 'Erro: A banca não aceita promessas ou abraços. Insira um valor numérico.';
      });
      return;
    }

    // Valida se o usuário tem saldo suficiente
    if (valorDigitado > _saldo) {
      setState(() {
        _mensagemAlgoritmo = 'Saldo insuficiente! Que tal vender um órgão ou pedir um empréstimo para voltar ao jogo?';
      });
      return;
    }

    setState(() {
      _aposta = valorDigitado;
      _saldo -= _aposta; // Deduz a aposta do saldo atual
      _saveBalance();
      _girando = true;
      _mensagemAlgoritmo = 'Roleta girando... O algoritmo está fingindo que faz sorteios aleatórios...';

      // ──────────────────────────────────────────────────────────────────────
      // ALGORITMO RIGGED (A BANCA SEMPRE VENCE)
      // ──────────────────────────────────────────────────────────────────────
      // Existe uma probabilidade de apenas 0.1% (1 em 1000) de ganhar R$ 0.01 (setor 4).
      // Nos outros 99.9% dos casos, cai em um dos setores de perda.
      // E para prender o usuário psicologicamente, há 40% de chance de dar o setor "QUASE GANHOU" ou "QUASE LÁ".
      final chanceAleatoria = Random().nextDouble();
      
      if (chanceAleatoria < 0.001) {
        _setorSorteado = 4; // Setor "GANHOU R$ 0.01" (Verde neon)
      } else {
        final chanceGatilho = Random().nextDouble();
        if (chanceGatilho < 0.40) {
          _setorSorteado = 7; // "QUASE GANHOU!" (Setor 7)
        } else if (chanceGatilho < 0.70) {
          _setorSorteado = 1; // "QUASE LÁ!" (Setor 1)
        } else {
          // Escolhe qualquer outro setor perdedor de forma aleatória
          final setoresPerdedores = [0, 2, 3, 5, 6];
          _setorSorteado = setoresPerdedores[Random().nextInt(setoresPerdedores.length)];
        }
      }
    });

    // ──────────────────────────────────────────────────────────────────────
    // CÁLCULO MATEMÁTICO DA PARADA (Didático)
    // ──────────────────────────────────────────────────────────────────────
    // A roleta tem 8 fatias. Logo, o tamanho de cada fatia em radianos é 2 * pi / 8 = pi / 4.
    double tamanhoSetor = (2 * pi) / 8;
    
    // Para dar emoção, a roleta deve dar várias voltas inteiras no ar (de 6 a 9 voltas)
    int voltasCompletas = 6 + Random().nextInt(4);
    
    // O ângulo final onde a roleta deve estacionar.
    // Queremos que o setor _setorSorteado pare exatamente apontado para o topo (ponteiro rosa).
    double anguloFinal = (voltasCompletas * 2 * pi) + 
        (2 * pi - (_setorSorteado * tamanhoSetor)) - 
        (tamanhoSetor / 2) - 
        (pi / 2);

    // Adiciona uma pequena variação aleatória de pixels dentro da fatia para parecer mais natural
    double pequenaVariacao = (Random().nextDouble() - 0.5) * (tamanhoSetor * 0.6);
    anguloFinal += pequenaVariacao;

    // Configura e inicia a interpolação da animação
    _animation = Tween<double>(
      begin: _anguloRotacao % (2 * pi), // Começa de onde parou no último giro
      end: anguloFinal,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.reset();
    _animationController.forward(); // Dispara o motor de animação do Flutter!
  }

  /// Chamado automaticamente quando a animação da roleta freia e para por completo
  void _finalizarGiro() {
    setState(() {
      _girando = false;
      final setor = _setores[_setorSorteado];

      if (setor['isWin'] == true) {
        double premioSignificativo = _aposta * 100; // Super prêmio de 100x a aposta!
        _saldo += premioSignificativo;
        _saveBalance();
        _mensagemAlgoritmo = '⚙️ BUG DETECTADO: nossa, parece que voce ganhou desta vez (Faturou R\$ ${premioSignificativo.toStringAsFixed(2)}!)... que tal jogar de novo e dobrar o valor? 💸🔥';
      } else {
        // Seleciona um dos comentários sarcásticos de perda aleatoriamente
        _mensagemAlgoritmo = _mensagensPerda[Random().nextInt(_mensagensPerda.length)];
      }

      if (_saldo <= 0) {
        _mensagemAlgoritmo = '💥 FALÊNCIA CONFIRMADA! Seu saldo foi a zero. Felizmente, nossos órgãos parceiros e agiotas estão prontos para ajudar!';
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // MECÂNICAS ABSURDAS DE RECUPERAÇÃO DE SALDO (Zoeira e conscientização)
  // ──────────────────────────────────────────────────────────────────────────

  void _venderRim() {
    final resultado = FinanceManager.venderRim(_saldo);
    setState(() {
      _saldo = resultado.novoSaldo;
      _saveBalance();
      _mensagemAlgoritmo = resultado.mensagemAlgoritmo;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado.mensagemToast),
        backgroundColor: resultado.corToast,
      ),
    );
  }

  void _pegarAgiota() {
    final resultado = FinanceManager.pegarEmprestimoAgiota(_saldo);
    setState(() {
      _saldo = resultado.novoSaldo;
      _saveBalance();
      _mensagemAlgoritmo = resultado.mensagemAlgoritmo;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado.mensagemToast),
        backgroundColor: resultado.corToast,
      ),
    );
  }

  void _venderPatrimonio() {
    final resultado = FinanceManager.liquidarBens(_saldo);
    setState(() {
      _saldo = resultado.novoSaldo;
      _saveBalance();
      _mensagemAlgoritmo = resultado.mensagemAlgoritmo;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado.mensagemToast),
        backgroundColor: resultado.corToast,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DESENHO DA INTERFACE (WIDGET BUILD)
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ROleta Sarcástica',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. CARTÃO DE EXIBIÇÃO DO SALDO
              _buildCartaoSaldo(),
              const SizedBox(height: 25),

              // 2. A ROLETA VISUAL
              _buildRoletaVisual(),
              const SizedBox(height: 25),

              // 3. PAINEL DE COMENTÁRIOS DA IA / ALGORITMO
              _buildPainelFeedback(),
              const SizedBox(height: 25),

              // 4. ÁREA DE INPUT DE VALOR E BOTÃO DE GIRAR
              _buildAreaAposta(),
              const SizedBox(height: 25),

              // 5. SEÇÃO DE CRÉDITO DE FALÊNCIA (Apenas se o saldo estiver baixo/zerado)
              if (_saldo < 100 || _saldo <= 0) _buildSeccaoFalencia(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PEQUENOS WIDGETS AUXILIARES DA TELA (Clean code)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildCartaoSaldo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBlueDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SEU SALDO ATUAL',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'R\$ ${_saldo.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _girando ? null : _venderPatrimonio,
            icon: const Icon(Icons.home_work_outlined, size: 16),
            label: const Text('VENDER BENS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoletaVisual() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sombra de brilho neon no fundo do disco
        Container(
          width: 265,
          height: 265,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen.withValues(alpha: 0.15),
                blurRadius: 35,
                spreadRadius: 2,
              )
            ],
          ),
        ),
        
        // O corpo da roleta que de fato roda via código!
        Transform.rotate(
          angle: _anguloRotacao,
          child: SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _RoulettePainter(setores: _setores),
            ),
          ),
        ),

        // Círculo central decorativo que não roda (fica fixo)
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neonGreen, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.casino_outlined,
              color: AppColors.neonGreen,
              size: 22,
            ),
          ),
        ),

        // Ponteiro estático no topo para indicar qual setor ganhou
        Positioned(
          top: 0,
          child: Transform.rotate(
            angle: pi,
            child: CustomPaint(
              size: const Size(18, 22),
              painter: _PointerPainter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPainelFeedback() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPink.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: AppColors.neonPink, size: 18),
              const SizedBox(width: 8),
              Text(
                'MENSAGEM DO ALGORITMO',
                style: TextStyle(
                  color: AppColors.neonPink.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _mensagemAlgoritmo,
            style: const TextStyle(
              color: AppColors.textSubtitle,
              fontSize: 13,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaAposta() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VALOR DA SUA APOSTA',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _apostaController,
                  keyboardType: TextInputType.number,
                  enabled: !_girando,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixText: 'R\$ ',
                    prefixStyle: const TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.neonGreen, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _girando ? null : _iniciarGiro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonGreen,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.neonGreen.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _girando ? 0 : 5,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: Text(
                  _girando ? 'GIRANDO...' : 'GIRAR',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Botões de atalho rápido de aposta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBotaoAtalho('Min R\$ 10', 10.0),
              _buildBotaoAtalho('R\$ 100', 100.0),
              _buildBotaoAtalho('R\$ 500', 500.0),
              _buildBotaoAtalho('ALL IN', _saldo),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBotaoAtalho(String label, double valor) {
    return InkWell(
      onTap: _girando
          ? null
          : () {
              if (valor > 0) {
                setState(() {
                  _apostaController.text = valor.toStringAsFixed(0);
                  _aposta = valor;
                  if (valor == _saldo) {
                    _mensagemAlgoritmo = 'ALL IN! Agora sim! O algoritmo já reservou seu lugar debaixo da ponte com muito carinho! ❤️';
                  }
                });
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
          color: AppColors.background,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSeccaoFalencia() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGreenDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonGreenDark.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.healing_outlined, color: AppColors.neonGreen, size: 18),
              SizedBox(width: 8),
              Text(
                'LINHA DE CRÉDITO DE EMERGÊNCIA',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Seu saldo está acabando! Não desista do seu sonho da casa própria agora, você está a apenas um rim de distância da grande vitória!',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _girando ? null : _venderRim,
                  icon: const Icon(Icons.medical_services_outlined, size: 14),
                  label: const Text('VENDER RIM'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.neonGreen,
                    side: const BorderSide(color: AppColors.neonGreen),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _girando ? null : _pegarAgiota,
                  icon: const Icon(Icons.money_off_outlined, size: 14),
                  label: const Text('AGIOTA 450%'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.neonPink,
                    side: const BorderSide(color: AppColors.neonPink),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// DESENHADORES CUSTOMIZADOS (CUSTOM PAINTERS - Gráficos puros de alto nível)
// ──────────────────────────────────────────────────────────────────────────

/// Desenha o disco colorido da roleta com seus 8 setores e os textos curvos explicativos
class _RoulettePainter extends CustomPainter {
  final List<Map<String, dynamic>> setores;

  _RoulettePainter({required this.setores});

  @override
  void paint(Canvas canvas, Size size) {
    final double raio = size.width / 2;
    final Offset centro = Offset(raio, raio);
    
    // O tamanho angular de cada setor (360 graus divididos por 8 setores)
    final double anguloPasso = 2 * pi / setores.length;

    // 1. Varre cada setor desenhando o arco colorido
    for (int i = 0; i < setores.length; i++) {
      final setor = setores[i];
      final double anguloInicio = i * anguloPasso;

      final paint = Paint()
        ..color = setor['cor'] as Color
        ..style = PaintingStyle.fill;

      // Desenha a fatia/pizza
      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: raio),
        anguloInicio,
        anguloPasso,
        true,
        paint,
      );

      // Desenha uma borda preta sutil separando as fatias
      final divisorPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: raio),
        anguloInicio,
        anguloPasso,
        true,
        divisorPaint,
      );

      // 2. Desenha o texto de forma rotacionada dentro da fatia
      _desenharTextoSetor(canvas, centro, raio, anguloInicio, anguloPasso, setor['titulo'] as String);
    }

    // 3. Desenha o aro externo brilhante da roleta (efeito neon)
    final bordaPaint = Paint()
      ..color = AppColors.neonGreen.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(centro, raio, bordaPaint);
  }

  /// Escreve e alinha o texto de forma radial no centro de cada fatia circular
  void _desenharTextoSetor(Canvas canvas, Offset centro, double raio, double anguloInicio, double anguloPasso, String texto) {
    canvas.save(); // Salva o estado atual da tela de pintura
    
    // Calcula o ângulo médio da fatia
    final double anguloMedio = anguloInicio + anguloPasso / 2;
    
    // Translada o ponto de rotação para o centro do círculo e rotaciona o papel virtual
    canvas.translate(centro.dx, centro.dy);
    canvas.rotate(anguloMedio);

    // Cria a formatação estética do texto
    final textSpan = TextSpan(
      text: texto,
      style: TextStyle(
        color: (texto == 'GANHOU 100x!' || texto == 'GANHOU R\$ 0.01') ? Colors.black : Colors.white.withValues(alpha: 0.8),
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    
    // Posiciona o texto a 65% de distância do centro (área intermediária da fatia)
    final double x = raio * 0.65 - textPainter.width / 2;
    final double y = -textPainter.height / 2;

    canvas.translate(x, y);
    textPainter.paint(canvas, const Offset(0, 0)); // Estampa o texto na tela

    canvas.restore(); // Restaura o papel ao alinhamento original
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Desenha o pequeno ponteiro de seta rosa que fica fixo no topo da roleta
class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonPink
      ..style = PaintingStyle.fill;

    // Cria um triângulo desenhando linhas coordenadas
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    // Aplica uma sombra desfocada rosa neon
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.neonPink.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5),
    );

    canvas.drawPath(path, paint); // Desenha a seta final
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

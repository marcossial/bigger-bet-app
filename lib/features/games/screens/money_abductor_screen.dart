import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:bigger_bet/features/games/utils/finance_manager.dart';
import 'package:bigger_bet/core/database/database_service.dart';
import 'package:bigger_bet/core/services/session_service.dart';

/// TELA DO JOGO: Crash Sarcástico ("Money Abductor")
/// 
/// Esta classe é um [StatefulWidget] porque armazena e renderiza estados mutáveis
/// em tempo real, como o multiplicador subindo por segundo, o estado do OVNI
/// voando, a aposta ativa e o saldo da conta.
class MoneyAbductorScreen extends StatefulWidget {
  const MoneyAbductorScreen({super.key});

  @override
  State<MoneyAbductorScreen> createState() => _MoneyAbductorScreenState();
}

class _MoneyAbductorScreenState extends State<MoneyAbductorScreen> {
  // ──────────────────────────────────────────────────────────────────────────
  // VARIÁVEIS DE ESTADO
  // ──────────────────────────────────────────────────────────────────────────
  
  double _saldo = 0.00; // Loaded from DB
  int? _userId;
  double _aposta = 100.00; // Valor da aposta padrão
  double _multiplicador = 1.00; // Multiplicador dinâmico do voo
  
  bool _voando = false; // Indica se o OVNI está no ar subindo
  bool _crashed = false; // Indica se ocorreu o "Crash" (abdução do saldo)
  bool _sacou = false; // Indica se o usuário conseguiu sacar a tempo

  double _pontoDeCrash = 1.00; // Ponto secreto onde o OVNI vai sumir com o dinheiro
  Timer? _timer; // Controla os ticks de atualização de tempo em tempo real
  
  // Controlador de texto e mensagens didáticas
  final TextEditingController _apostaController = TextEditingController(text: '100');
  String _mensagemAlgoritmo = 'Defina sua aposta e clique em "DECOLAR". O OVNI promete (mentira) que não vai te abduzir rápido.';

  @override
  void initState() {
    super.initState();
    _loadBalance();
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

  @override
  void dispose() {
    _timer?.cancel(); // Limpa o timer ao fechar a tela para evitar vazamentos de memória
    _apostaController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LÓGICA DO JOGO (Timer e Aceleração Progressiva)
  // ──────────────────────────────────────────────────────────────────────────

  /// Inicia a decolagem do OVNI e a contagem do multiplicador
  void _decolarUfo() {
    if (_voando) return;

    // 1. Valida o valor digitado para aposta
    final valorDigitado = double.tryParse(_apostaController.text);
    if (valorDigitado == null || valorDigitado <= 0) {
      setState(() {
        _mensagemAlgoritmo = 'Erro: Insira uma aposta válida. Dinheiro físico é necessário.';
      });
      return;
    }

    if (valorDigitado > _saldo) {
      setState(() {
        _mensagemAlgoritmo = 'Saldo insuficiente! Utilize as opções de resgate financeiro abaixo para continuar.';
      });
      return;
    }

    // 2. Deduz o saldo, limpa estados anteriores e define a abdução secreta
    setState(() {
      _aposta = valorDigitado;
      _saldo -= _aposta;
      _saveBalance();
      _voando = true;
      _crashed = false;
      _sacou = false;
      _multiplicador = 1.00;
      _mensagemAlgoritmo = '🛸 OVNI decolando! O multiplicador está subindo! Retire antes que ele ative a dobra espacial!';

      // ──────────────────────────────────────────────────────────────────────
      // CÁLCULO DO PONTO DE CRASH (RIGGED / SARCÁSTICO)
      // ──────────────────────────────────────────────────────────────────────
      // Simula a manipulação de cassinos:
      // * 35% de chance de o OVNI sumir quase imediatamente (entre 1.01x e 1.15x).
      // * Caso contrário, sorteia um número entre 1.15x e 5.00x, com raras chances de passar disso.
      final random = Random();
      final chancePerdaImediata = random.nextDouble();

      if (chancePerdaImediata < 0.35) {
        _pontoDeCrash = 1.01 + (random.nextDouble() * 0.14); // Crash muito rápido
      } else {
        _pontoDeCrash = 1.15 + (random.nextDouble() * 3.85); // Crash normal/médio
        // Raramente dá um multiplicador alto
        if (random.nextDouble() < 0.05) {
          _pontoDeCrash += random.nextDouble() * 10.0;
        }
      }
    });

    // 3. Inicia o loop periódico de atualização a cada 80ms
    _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        // O multiplicador acelera à medida que sobe, simulando ganho de velocidade vertical
        double taxaCrescimento = 0.01 + (_multiplicador * 0.005);
        _multiplicador += taxaCrescimento;

        // ────────────────────────────────────────────────────────────────────
        // DETONAÇÃO (CRASHPOINT ATINGIDO)
        // ────────────────────────────────────────────────────────────────────
        if (_multiplicador >= _pontoDeCrash) {
          timer.cancel();
          _voando = false;
          _crashed = true;
          _mensagemAlgoritmo = '🚨 ABDUZIDO! O OVNI sumiu no espaço profundo com seus R\$ ${_aposta.toStringAsFixed(2)}!';
          _mostrarDialogoAbducao();
        } else {
          // Atualiza a estimativa de lucro do usuário na tela
          double lucroEstimado = _aposta * _multiplicador;
          _mensagemAlgoritmo = 'Subindo... Multiplicador: ${_multiplicador.toStringAsFixed(2)}x. Retorno estimado: R\$ ${lucroEstimado.toStringAsFixed(2)}. Retire agora!';
        }
      });
    });
  }

  /// Realiza o resgate (Cash Out) do valor acumulado multiplicando a aposta
  void _sacarDinheiro() {
    if (!_voando || _crashed || _sacou) return;

    _timer?.cancel(); // Para o cronômetro imediatamente

    final premioGanho = _aposta * _multiplicador;

    setState(() {
      _saldo += premioGanho; // Adiciona o prêmio de volta ao saldo
      _saveBalance();
      _voando = false;
      _sacou = true;
      _mensagemAlgoritmo = '💰 SAQUE EFETUADO! Você escapou com R\$ ${premioGanho.toStringAsFixed(2)} (${_multiplicador.toStringAsFixed(2)}x). A diretoria está desapontada.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dinheiro resgatado com sucesso!'),
        backgroundColor: AppColors.neonGreenDark,
      ),
    );
  }

  /// Exibe um pop-up irônico quando o jogador perde
  void _mostrarDialogoAbducao() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'ABDUÇÃO CONFIRMADA!',
          style: TextStyle(color: AppColors.neonPink, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Os alienígenas abduziram seu dinheiro! Eles disseram que usarão seus reais para estudar a burrice humana de apostar contra a banca.',
          style: TextStyle(color: AppColors.textWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ACEITAR O DESTINO',
                style: TextStyle(color: AppColors.neonGreen)),
          )
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // RECUPERAÇÃO DE SALDO (Sátiras de falência)
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
          'MONEY ABDUCTOR',
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
              // 1. BARRA DE EXIBIÇÃO DO SALDO
              _buildCartaoSaldo(),
              const SizedBox(height: 20),

              // 2. PAINEL GRÁFICO DO VOO DO OVNI
              _buildPainelUfo(),
              const SizedBox(height: 20),

              // 3. MONITOR DE MENSAGENS DO ALGORITMO
              _buildPainelFeedback(),
              const SizedBox(height: 20),

              // 4. CONTROLES DE LANÇAMENTO E SAQUE
              _buildAreaControle(),
              const SizedBox(height: 20),

              // 5. CRÉDITO DE EMERGÊNCIA (Apenas se o saldo estiver crítico)
              if (_saldo < 100 && !_voando) _buildSeccaoFalencia(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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
            onPressed: _voando ? null : _venderPatrimonio,
            icon: const Icon(Icons.home_work_outlined, size: 16),
            label: const Text('LIQUIDAR BENS'),
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

  /// Desenha a área de simulação do voo do disco voador
  Widget _buildPainelUfo() {
    // Calcula a porcentagem do progresso de voo da nave.
    // Usamos um valor base de 5.0x como o "topo do céu" visual da nossa simulação.
    double progresso = min(1.0, (_multiplicador - 1.0) / 4.0);

    // Mapeia o progresso para coordenadas de alinhamento em diagonal (do canto inferior-esquerdo ao topo direito)
    // O eixo X varia de -0.8 a 0.8
    // O eixo Y varia de 0.8 a -0.8
    double x = -0.8 + (1.6 * progresso);
    double y = 0.8 - (1.6 * progresso);

    Color textoColor = AppColors.neonGreen;
    if (_crashed) {
      textoColor = AppColors.neonPink;
    } else if (_sacou) {
      textoColor = AppColors.buttonBlue;
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Stack(
        children: [
          // Linhas de grade estéticas para lembrar um radar futurista
          Positioned.fill(
            child: CustomPaint(
              painter: _RadarGridPainter(),
            ),
          ),

          // Centralizador do Multiplicador Principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_multiplicador.toStringAsFixed(2)}x',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: textoColor,
                    shadows: [
                      BoxShadow(
                        color: textoColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                      )
                    ],
                  ),
                ),
                if (_crashed)
                  const Text(
                    'ABDUZIDO!',
                    style: TextStyle(
                      color: AppColors.neonPink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  )
                else if (_sacou)
                  const Text(
                    'RETIRADO!',
                    style: TextStyle(
                      color: AppColors.buttonBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  )
              ],
            ),
          ),

          // A Nave espacial (OVNI) voando na diagonal!
          if (!_crashed)
            Align(
              alignment: Alignment(x, y),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _sacou ? AppColors.buttonBlue : AppColors.neonGreen,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.rocket_launch,
                    color: _sacou ? AppColors.buttonBlue : AppColors.neonGreen,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
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
              const Icon(Icons.radar_outlined, color: AppColors.neonPink, size: 18),
              const SizedBox(width: 8),
              Text(
                'CENTRAL DE TELEMETRIA',
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

  Widget _buildAreaControle() {
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
          if (!_voando) ...[
            const Text(
              'VALOR DA APOSTA DE LANÇAMENTO',
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
                  onPressed: _decolarUfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text(
                    'DECOLAR',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBotaoAtalho('Min R\$ 10', 10.0),
                _buildBotaoAtalho('R\$ 100', 100.0),
                _buildBotaoAtalho('R\$ 500', 500.0),
                _buildBotaoAtalho('ALL IN', _saldo),
              ],
            )
          ] else ...[
            // Painel ativo durante a decolagem (Permite o Cash Out)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RETORNO DO SAQUE',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${(_aposta * _multiplicador).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Multiplicador atual: ${_multiplicador.toStringAsFixed(2)}x',
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _sacarDinheiro,
                  icon: const Icon(Icons.exit_to_app, color: Colors.black),
                  label: const Text('CASH OUT (SACAR)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildBotaoAtalho(String label, double valor) {
    return InkWell(
      onTap: () {
        if (valor > 0) {
          setState(() {
            _apostaController.text = valor.toStringAsFixed(0);
            _aposta = valor;
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
            'Seu saldo foi abduzido no espaço profundo? Não pare de se aventurar, utilize os fundos de contingência do nosso CEO para reabastecer seus propulsores!',
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
                  onPressed: _venderRim,
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
                  onPressed: _pegarAgiota,
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
// PINTORES CUSTOMIZADOS
// ──────────────────────────────────────────────────────────────────────────

/// Desenha linhas de grade estéticas para simular uma tela de radar futurista
class _RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonGreen.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Desenha linhas horizontais espaçadas a cada 40 pixels
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Desenha linhas verticais espaçadas a cada 40 pixels
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Desenha uma linha diagonal pontilhada para demarcar a rota ideal de decolagem
    final rotaPaint = Paint()
      ..color = AppColors.neonGreen.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), rotaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

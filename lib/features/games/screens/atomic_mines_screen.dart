import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:bigger_bet/features/games/utils/finance_manager.dart';

/// TELA DO JOGO: Campo Minado Sarcástico ("Atomic Mines")
///
/// Esta classe é um [StatefulWidget] porque armazena estados que mudam
/// dinamicamente de acordo com as ações do jogador: saldo, aposta, posição das bombas,
/// casas clicadas e prêmios acumulados na rodada.
class AtomicMinesScreen extends StatefulWidget {
  const AtomicMinesScreen({super.key});

  @override
  State<AtomicMinesScreen> createState() => _AtomicMinesScreenState();
}

class _AtomicMinesScreenState extends State<AtomicMinesScreen> {
  // ──────────────────────────────────────────────────────────────────────────
  // VARIÁVEIS DE ESTADO
  // ──────────────────────────────────────────────────────────────────────────

  double _saldo = 0.00; // Loaded from DB
  double _aposta = 100.00; // Valor da aposta padrão
  double _premioAcumulado =
      0.00; // Prêmio que o usuário acumulou na rodada atual

  bool _jogoAtivo = false; // Indica se uma rodada está em andamento
  bool _gameOver = false; // Indica se o usuário clicou em uma bomba e perdeu

  final int _gridSize = 25; // Grid de 5x5 = 25 casas
  final int _totalBombas = 5; // Quantidade de bombas escondidas no tabuleiro
  int _acertosSeguros =
      0; // Conta quantos cliques seguros foram feitos na rodada

  // Listas de controle para o tabuleiro
  List<bool> _bombaPositions =
      List.filled(25, false); // Guarda onde estão as bombas
  List<bool> _casasReveladas =
      List.filled(25, false); // Guarda quais casas já foram abertas

  // Controlador do campo de texto da aposta e mensagens didáticas
  final TextEditingController _apostaController =
      TextEditingController(text: '100');
  String _mensagemAlgoritmo =
      'Defina sua aposta e clique em "INICIAR JOGO". O algoritmo promete (mentira) que esta rodada é segura!';

  // ──────────────────────────────────────────────────────────────────────────
  // MULTIPLICADORES PROGRESSIVOS (Estilo Cassino)
  // ──────────────────────────────────────────────────────────────────────────
  // A cada casa segura que o usuário revela, o prêmio dele é multiplicado por um fator maior!
  // Como são 5 bombas em 25 casas, o risco aumenta muito rápido, por isso os multiplicadores sobem exponencialmente.
  final List<double> _multiplicadores = [
    1.25,
    1.60,
    2.10,
    2.80,
    3.80,
    5.20,
    7.20,
    10.00,
    14.50,
    21.00,
    32.00,
    50.00,
    80.00,
    135.00,
    240.00,
    450.00,
    900.00,
    2000.00,
    5000.00,
    15000.00
  ];

  @override
  void initState() {
    super.initState();
    _carregarSaldo();
  }

  void _carregarSaldo() async {
    final saldo = await FinanceManager.getSaldo();
    if (mounted) {
      setState(() {
        _saldo = saldo;
      });
    }
  }

  Future<void> _saveBalance() async {
    await FinanceManager.saveSaldo(_saldo);
  }

  @override
  void dispose() {
    _apostaController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LÓGICA DO JOGO (Didática e Limpa)
  // ──────────────────────────────────────────────────────────────────────────

  /// Inicia uma nova rodada de Campo Minado
  void _iniciarJogo() {
    if (_jogoAtivo) return;

    // 1. Valida a aposta digitada
    final valorDigitado = double.tryParse(_apostaController.text);
    if (valorDigitado == null || valorDigitado <= 0) {
      setState(() {
        _mensagemAlgoritmo =
            'Erro: Insira um valor válido de aposta. Não jogamos fiado.';
      });
      return;
    }

    if (valorDigitado > _saldo) {
      setState(() {
        _mensagemAlgoritmo =
            'Saldo insuficiente! Use nossa linha de crédito de emergência abaixo para obter fundos.';
      });
      return;
    }

    // 2. Deduz o saldo, limpa estados anteriores e ativa o jogo
    setState(() {
      _aposta = valorDigitado;
      _saldo -= _aposta;
      _saveBalance();
      _jogoAtivo = true;
      _gameOver = false;
      _acertosSeguros = 0;
      _premioAcumulado = 0.00;
      _mensagemAlgoritmo =
          'Minas ativadas! Escolha a primeira casa. Cuidado onde pisa!';

      // Reseta o estado do tabuleiro
      _casasReveladas = List.filled(_gridSize, false);
      _bombaPositions = List.filled(_gridSize, false);

      // ──────────────────────────────────────────────────────────────────────
      // GERAÇÃO ALEATÓRIA DAS BOMBAS
      // ──────────────────────────────────────────────────────────────────────
      final random = Random();
      int bombasColocadas = 0;
      while (bombasColocadas < _totalBombas) {
        int index = random.nextInt(_gridSize);
        // Se a casa ainda não tem bomba, coloca uma lá
        if (!_bombaPositions[index]) {
          _bombaPositions[index] = true;
          bombasColocadas++;
        }
      }
    });
    FinanceManager.saveSaldo(_saldo);
  }

  /// Gerencia o clique em uma das 25 casas do tabuleiro
  void _clickTile(int index) {
    // Só responde se o jogo estiver ativo e a casa ainda estiver fechada
    if (!_jogoAtivo || _gameOver || _casasReveladas[index]) return;

    setState(() {
      _casasReveladas[index] = true;

      // ──────────────────────────────────────────────────────────────────────
      // CASO 1: CLICOU EM UMA BOMBA (Derrota)
      // ──────────────────────────────────────────────────────────────────────
      if (_bombaPositions[index]) {
        _gameOver = true;
        _jogoAtivo = false;

        // Revela a posição de TODAS as bombas no tabuleiro para o usuário ver onde errou
        for (int i = 0; i < _gridSize; i++) {
          if (_bombaPositions[i]) {
            _casasReveladas[i] = true;
          }
        }

        _mensagemAlgoritmo =
            '💣 BOOM! Explosão atômica detectada! Você perdeu R\$ ${_aposta.toStringAsFixed(2)} e todos os prêmios acumulados!';
        _mostrarDialogoDerrota();
      }
      // ──────────────────────────────────────────────────────────────────────
      // CASO 2: CLICOU EM UMA CASA SEGURA (Vitória Parcial)
      // ──────────────────────────────────────────────────────────────────────
      else {
        _acertosSeguros++;
        // Calcula o prêmio acumulado com base no multiplicador correspondente à quantidade de acertos
        double multiplicador = _multiplicadores[_acertosSeguros - 1];
        _premioAcumulado = _aposta * multiplicador;

        // Se o usuário limpar todas as 20 casas seguras do tabuleiro, ele vence o prêmio máximo!
        if (_acertosSeguros == _gridSize - _totalBombas) {
          _sacarPremio();
          _mensagemAlgoritmo =
              '🏆 INACREDITÁVEL! Você limpou o campo minado inteiro e ganhou R\$ ${_premioAcumulado.toStringAsFixed(2)}! O CEO está investigando se isso foi um hack.';
        } else {
          _mensagemAlgoritmo =
              'Casa limpa! Multiplicador atual: ${multiplicador}x. Seu prêmio acumulado: R\$ ${_premioAcumulado.toStringAsFixed(2)}. Deseja continuar ou prefere sacar?';
        }
      }
    });
  }

  /// Realiza o saque (Cash Out) dos valores acumulados até o momento
  void _sacarPremio() {
    if (!_jogoAtivo || _gameOver || _premioAcumulado <= 0) return;

    setState(() {
      _saldo +=
          _premioAcumulado; // Deposita o prêmio acumulado de volta ao saldo
      _saveBalance();
      _jogoAtivo = false;
      _mensagemAlgoritmo =
          '💰 Retirada efetuada com sucesso! Você levou R\$ ${_premioAcumulado.toStringAsFixed(2)} para casa (e comprou 2 segundos de paz de espírito).';
      _premioAcumulado = 0.00;
    });
    FinanceManager.saveSaldo(_saldo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prêmio sacado com sucesso! Saldo atualizado.'),
        backgroundColor: AppColors.neonGreenDark,
      ),
    );
  }

  /// Diálogo sarcástico exibido ao bater em uma bomba
  void _mostrarDialogoDerrota() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'EXPLOSÃO DETECTADA!',
          style:
              TextStyle(color: AppColors.neonPink, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Inacreditável! Você encontrou uma ogiva nuclear tática. Seu dinheiro foi radioativamente transferido para os bolsos da diretoria.',
          style: TextStyle(color: AppColors.textWhite),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ACEITAR O DESTINO',
                style: TextStyle(color: AppColors.neonGreen)),
          )
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // RECUPERAÇÃO DE SALDO (Sátira de falência)
  // ──────────────────────────────────────────────────────────────────────────

  void _venderRim() {
    final resultado = FinanceManager.venderRim(_saldo);
    setState(() {
      _saldo = resultado.novoSaldo;
      _saveBalance();
      _mensagemAlgoritmo = resultado.mensagemAlgoritmo;
    });
    FinanceManager.saveSaldo(_saldo);
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
    FinanceManager.saveSaldo(_saldo);
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
    FinanceManager.saveSaldo(_saldo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado.mensagemToast),
        backgroundColor: resultado.corToast,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // RENDERIZAÇÃO DA INTERFACE (WIDGET BUILD)
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
          'ATOMIC MINES',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
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
              // 1. CARD DE SALDO E LIQUIDAÇÃO
              _buildCartaoSaldo(),
              const SizedBox(height: 20),

              // 2. GRID 5x5 DO CAMPO MINADO
              _buildMinesGrid(),
              const SizedBox(height: 20),

              // 3. PAINEL DE FEEDBACK DO ALGORITMO
              _buildPainelFeedback(),
              const SizedBox(height: 20),

              // 4. CONTROLES DE APOSTA / SAQUE (CASH OUT)
              _buildAreaControle(),
              const SizedBox(height: 20),

              // 5. CRÉDITO DE FALÊNCIA (Apenas se o saldo estiver crítico)
              if (_saldo < 100 && !_jogoAtivo) _buildSeccaoFalencia(),
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
            onPressed: _jogoAtivo ? null : _venderPatrimonio,
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

  Widget _buildMinesGrid() {
    return AspectRatio(
      aspectRatio: 1.0, // Força o grid a ser um quadrado perfeito (5x5)
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: GridView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // Desabilita rolagem do GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5 colunas
            crossAxisSpacing: 8, // Espaço entre colunas
            mainAxisSpacing: 8, // Espaço entre linhas
          ),
          itemCount: _gridSize,
          itemBuilder: (context, index) {
            final isRevelado = _casasReveladas[index];
            final temBomba = _bombaPositions[index];

            // Determina a cor de fundo com base no estado da casa
            Color tileColor = const Color(0xFF161616); // Cor padrão fechada
            Color borderColor = AppColors.cardBorder;
            Widget tileContent = const Icon(Icons.question_mark,
                color: AppColors.textGrey, size: 16);

            if (isRevelado) {
              if (temBomba) {
                // Revelou bomba
                tileColor = AppColors.neonPink.withValues(alpha: 0.2);
                borderColor = AppColors.neonPink;
                tileContent =
                    const Icon(Icons.bolt, color: AppColors.neonPink, size: 24);
              } else {
                // Revelou casa segura
                tileColor = AppColors.neonGreen.withValues(alpha: 0.15);
                borderColor = AppColors.neonGreen;
                tileContent = const Icon(Icons.monetization_on,
                    color: AppColors.neonGreen, size: 24);
              }
            } else if (_jogoAtivo) {
              // Casa interativa ativa aguardando clique
              borderColor = AppColors.neonGreen.withValues(alpha: 0.3);
            }

            return GestureDetector(
              onTap: () => _clickTile(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: [
                    if (!isRevelado && _jogoAtivo)
                      BoxShadow(
                        color: AppColors.neonGreen.withValues(alpha: 0.05),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                  ],
                ),
                child: Center(child: tileContent),
              ),
            );
          },
        ),
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
              const Icon(Icons.psychology_outlined,
                  color: AppColors.neonPink, size: 18),
              const SizedBox(width: 8),
              Text(
                'MONITOR DO BUNKER',
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
          if (!_jogoAtivo) ...[
            const Text(
              'VALOR DA APOSTA DA RODADA',
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.neonGreen, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _iniciarJogo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  child: const Text(
                    'INICIAR JOGO',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5),
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
            // Painel ativo durante a rodada de jogo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRÊMIO ACUMULADO',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${_premioAcumulado.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '$_acertosSeguros acertos seguros',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 11),
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _premioAcumulado > 0 ? _sacarPremio : null,
                  icon: const Icon(Icons.monetization_on_outlined,
                      color: Colors.black),
                  label: const Text('CASH OUT (SACAR)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[800],
                    disabledForegroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
        border:
            Border.all(color: AppColors.neonGreenDark.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.healing_outlined,
                  color: AppColors.neonGreen, size: 18),
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
            'Bateu em uma mina tática e perdeu tudo? Não tem problema, o bunker da Bigger Bet possui alternativas médicas e de fomento para manter você jogando!',
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

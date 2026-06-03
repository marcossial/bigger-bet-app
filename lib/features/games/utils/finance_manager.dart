import 'package:flutter/material.dart';
import 'package:bigger_bet/core/theme/app_theme.dart';

/// Modelo simples que encapsula o resultado de qualquer transação financeira sarcástica.
/// Ele armazena o novo saldo, a frase que a IA (algoritmo) deve dizer e os dados do SnackBar.
class FinanceResult {
  final double novoSaldo;
  final String mensagemAlgoritmo;
  final String mensagemToast;
  final Color corToast;

  const FinanceResult({
    required this.novoSaldo,
    required this.mensagemAlgoritmo,
    required this.mensagemToast,
    required this.corToast,
  });
}

/// Gerenciador Financeiro Sarcástico Centralizado.
/// 
/// Ele evita a duplicação de lógica (cálculos matemáticos de dinheiro) e de strings de texto
/// satíricos em múltiplas telas de jogos.
class FinanceManager {
  
  /// Realiza a venda expressa do Rim do usuário
  static FinanceResult venderRim(double saldoAtual) {
    return FinanceResult(
      novoSaldo: saldoAtual + 5000.00,
      mensagemAlgoritmo: '⚕️ Cirurgia expressa realizada! Seu rim foi vendido com sucesso por R\$ 5.000,00. Quem precisa de dois filtros afinal? Volte a apostar!',
      mensagemToast: 'Transação: +R\$ 5.000,00 (Rim removido com sucesso)',
      corToast: AppColors.neonGreenDark,
    );
  }

  /// Realiza o empréstimo de agiotagem com taxa diária absurda
  static FinanceResult pegarEmprestimoAgiota(double saldoAtual) {
    return FinanceResult(
      novoSaldo: saldoAtual + 10000.00,
      mensagemAlgoritmo: '💸 R\$ 10.000,00 na conta! O agiota "Zé das Facas" aprovou o seu crédito com juros amigáveis de 450% ao dia. Ele mencionou algo sobre gostar de joelhos, mas ignore!',
      mensagemToast: 'Empréstimo concedido: +R\$ 10.000,00 (Juros: 450% a.d.)',
      corToast: AppColors.neonPink,
    );
  }

  /// Realiza a liquidação total de propriedades (casa e carro)
  static FinanceResult liquidarBens(double saldoAtual) {
    return FinanceResult(
      novoSaldo: saldoAtual + 250000.00,
      mensagemAlgoritmo: '🏠 Escrituras assinadas! Você vendeu seus bens por R\$ 250.000,00. Agora você tem o fôlego financeiro necessário para tentar quebrar a banca! Confia!',
      mensagemToast: 'Patrimônio liquidado: +R\$ 250.000,00',
      corToast: AppColors.buttonBlue,
    );
  }
}

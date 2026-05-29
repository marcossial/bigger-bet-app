import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AtomicMinesScreen extends StatefulWidget {
  const AtomicMinesScreen({super.key});

  @override
  State<AtomicMinesScreen> createState() => _AtomicMinesScreenState();
}

class _AtomicMinesScreenState extends State<AtomicMinesScreen> {
  bool _gameOver = false;
  final int _gridSize = 25; // 5x5

  void _clickTile(int index) {
    if (_gameOver) return;
    setState(() {
      _gameOver = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('BOMBA ATÔMICA!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
            'Inacreditável! Você encontrou uma bomba atômica logo na primeira casa. Tente de novo, quem sabe na próxima você tem sorte!',
            style: TextStyle(color: AppColors.textWhite)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _gameOver = false);
            },
            child: const Text('DEPOSITAR MAIS',
                style: TextStyle(color: AppColors.neonGreen)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Atomic Mines',
            style: TextStyle(color: AppColors.textWhite)),
        iconTheme: const IconThemeData(color: AppColors.neonGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Escolha uma casa segura...',
              style: TextStyle(color: AppColors.textGrey, fontSize: 18),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _gridSize,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _clickTile(index),
                    child: Container(
                      decoration: BoxDecoration(
                          color: _gameOver
                              ? Colors.red.withValues(alpha: 0.3)
                              : const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: _gameOver
                                  ? Colors.red
                                  : AppColors.neonGreen.withValues(alpha: 0.5)),
                          boxShadow: [
                            if (!_gameOver)
                              BoxShadow(
                                color:
                                    AppColors.neonGreen.withValues(alpha: 0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                          ]),
                      child: _gameOver
                          ? const Icon(Icons.bolt, color: Colors.red, size: 30)
                          : const Icon(Icons.question_mark,
                              color: AppColors.textGrey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

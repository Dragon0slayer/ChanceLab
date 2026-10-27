
import 'dart:math';
import 'package:flutter/material.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen>
    with SingleTickerProviderStateMixin {
  final Random random = Random();

  late final AnimationController _controller;

  int selectedFlips = 1;
  int totalFlips = 0;
  int headsCount = 0;
  int tailsCount = 0;

  bool isFlipping = false;
  bool isHeads = true;

  static const Color copper = Color(0xFFC47A45);
  static const Color lightCopper = Color(0xFFF2B77B);
  static const Color darkCopper = Color(0xFF754027);
  static const Color cardColor = Color(0xFF211936);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> flipCoin() async {
    if (isFlipping) return;

    setState(() {
      isFlipping = true;
    });

    // Результати всіх підкидань
    int newHeads = 0;
    int newTails = 0;
    bool lastResult = true;

    for (int i = 0; i < selectedFlips; i++) {
      lastResult = random.nextBool();

      if (lastResult) {
        newHeads++;
      } else {
        newTails++;
      }
    }

    // Анімація перевертання
    await _controller.forward(from: 0);

    if (!mounted) return;

    setState(() {
      isHeads = lastResult;
      headsCount += newHeads;
      tailsCount += newTails;
      totalFlips += selectedFlips;
      isFlipping = false;
    });

    _controller.reset();
  }

  void resetStatistics() {
    if (isFlipping) return;

    setState(() {
      totalFlips = 0;
      headsCount = 0;
      tailsCount = 0;
      isHeads = true;
    });
  }

  double get headsProbability {
    if (totalFlips == 0) return 0;
    return headsCount / totalFlips * 100;
  }

  double get tailsProbability {
    if (totalFlips == 0) return 0;
    return tailsCount / totalFlips * 100;
  }

  // Малюємо мідну монетку без сторонніх пакетів
  Widget buildCoin(bool showHeads) {
    return Container(
      width: 185,
      height: 185,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            lightCopper,
            copper,
            darkCopper,
            copper,
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFFFFD2A3),
          width: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: copper.withValues(alpha: 0.35),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF8A492C),
              width: 3,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showHeads
                      ? Icons.flutter_dash
                      : Icons.auto_awesome,
                  color: const Color(0xFF65341F),
                  size: showHeads ? 66 : 36,
                ),
                if (!showHeads)
                  const Text(
                    'CL',
                    style: TextStyle(
                      color: Color(0xFF65341F),
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                Text(
                  showHeads ? 'ОРЕЛ' : 'CHANCELAB',
                  style: const TextStyle(
                    color: Color(0xFF65341F),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget animatedCoin() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Чотири повних оберти
        final angle = _controller.value * pi * 8;

        // Підйом монетки в середині анімації
        final lift = sin(_controller.value * pi) * 45;

        // Після завершення показуємо останній результат
        final side = _controller.isAnimating
            ? (cos(angle) >= 0 ? isHeads : !isHeads)
            : isHeads;

        return Transform.translate(
          offset: Offset(0, -lift),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: buildCoin(side),
          ),
        );
      },
    );
  }

  Widget probabilityRow(
    String label,
    int count,
    double probability,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label ($count)',
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                '${probability.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalFlips == 0 ? 0 : count / totalFlips,
            minHeight: 13,
            borderRadius: BorderRadius.circular(8),
            color: copper,
            backgroundColor: const Color(0xFF392B4D),
          ),
        ],
      ),
    );
  }

  Widget buildAnalysis() {
    final deviation = (headsProbability - 50).abs();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF45345E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Математичний аналіз',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Теоретична ймовірність:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 5),
          const Text(
            'Орел — 50%   |   Решка — 50%',
            style: TextStyle(
              color: lightCopper,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Експериментальна ймовірність:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 7),
          Text(
            totalFlips == 0
                ? 'Поки немає результатів'
                : 'Орел — ${headsProbability.toStringAsFixed(2)}%\n'
                  'Решка — ${tailsProbability.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 17,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            totalFlips == 0
                ? 'Відхилення: немає даних'
                : 'Відхилення від 50%: '
                  '${deviation.toStringAsFixed(2)} в.п.',
            style: const TextStyle(color: lightCopper),
          ),
          const SizedBox(height: 20),
          const Text(
            'Висновок',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            totalFlips == 0
                ? 'Підкинь монетку, щоб отримати математичний висновок.'
                : 'Після $totalFlips підкидань орел випав '
                  '$headsCount разів, а решка — $tailsCount разів. '
                  'Експериментальна ймовірність орла становить '
                  '${headsProbability.toStringAsFixed(2)}%. '
                  'За законом великих чисел зі збільшенням '
                  'кількості незалежних підкидань відносні '
                  'частоти зазвичай наближаються до 50%.',
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100D1F),
      appBar: AppBar(
        title: const Text('Симулятор монетки'),
        backgroundColor: const Color(0xFF100D1F),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Орел чи решка?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Підкидай мідну монетку та досліджуй ймовірності.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 260,
            child: Center(
              child: animatedCoin(),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            totalFlips == 0
                ? 'Монетка готова!'
                : isFlipping
                    ? 'Монетка обертається...'
                    : 'Результат: ${isHeads ? "Орел" : "Решка"}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: lightCopper,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Кількість підкидань',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              for (final count in [1, 100, 1000])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: ChoiceChip(
                      label: Text('$count'),
                      selected: selectedFlips == count,
                      onSelected: isFlipping
                          ? null
                          : (_) {
                              setState(() {
                                selectedFlips = count;
                              });
                            },
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: isFlipping ? null : flipCoin,
            icon: const Icon(Icons.toll),
            label: Text(
              isFlipping
                  ? 'Підкидання...'
                  : 'Підкинути монетку',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: copper,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(17),
            ),
          ),

          const SizedBox(height: 25),

          Text(
            'Всього підкидань: $totalFlips',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 28),

          const Text(
            'Статистика результатів',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          probabilityRow(
            'Орел',
            headsCount,
            headsProbability,
          ),

          probabilityRow(
            'Решка',
            tailsCount,
            tailsProbability,
          ),

          const SizedBox(height: 12),

          buildAnalysis(),

          const SizedBox(height: 22),

          OutlinedButton.icon(
            onPressed: isFlipping ? null : resetStatistics,
            icon: const Icon(Icons.refresh),
            label: const Text('Скинути статистику'),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

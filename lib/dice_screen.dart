
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final Random random = Random();

  int diceValue = 1;
  int totalRolls = 0;
  int selectedRolls = 1;
  int selectedFace = 1;
  int animationStep = 0;

  bool isRolling = false;

  final List<int> results = List.filled(6, 0);

  static const Color purple = Color(0xFF9255F7);
  static const Color lightPurple = Color(0xFFB78AFF);
  static const Color cardColor = Color(0xFF211936);

  // Виконання кидків з анімацією
  Future<void> rollDice() async {
    if (isRolling) return;

    final rollsToMake = selectedRolls;

    setState(() {
      isRolling = true;
    });

    // Візуальна анімація кубика
    for (int i = 0; i < 10; i++) {
      await Future.delayed(
        const Duration(milliseconds: 70),
      );

      if (!mounted) return;

      setState(() {
        diceValue = random.nextInt(6) + 1;
        animationStep++;
      });
    }

    // Математичне моделювання
    final newResults = List<int>.filled(6, 0);
    int lastResult = diceValue;

    for (int i = 0; i < rollsToMake; i++) {
      lastResult = random.nextInt(6) + 1;
      newResults[lastResult - 1]++;
    }

    if (!mounted) return;

    setState(() {
      diceValue = lastResult;
      animationStep++;

      for (int i = 0; i < 6; i++) {
        results[i] += newResults[i];
      }

      totalRolls += rollsToMake;
      isRolling = false;
    });
  }

  // Скидання статистики
  void resetStatistics() {
    if (isRolling) return;

    setState(() {
      diceValue = 1;
      totalRolls = 0;
      selectedFace = 1;
      animationStep++;

      for (int i = 0; i < 6; i++) {
        results[i] = 0;
      }
    });
  }

  double get experimentalProbability {
    if (totalRolls == 0) return 0;

    return results[selectedFace - 1] / totalRolls * 100;
  }

  double get deviation {
    return (experimentalProbability - 100 / 6).abs();
  }

  // Грань кубика з крапочками
  Widget buildDiceFace() {
    const positions = {
      1: [4],
      2: [0, 8],
      3: [0, 4, 8],
      4: [0, 2, 6, 8],
      5: [0, 2, 4, 6, 8],
      6: [0, 2, 3, 5, 6, 8],
    };

    final activeDots = positions[diceValue]!;

    return Container(
      width: 145,
      height: 145,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF38245F),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: lightPurple,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.18),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeDots.contains(index)
                  ? Colors.white
                  : Colors.transparent,
            ),
          );
        },
      ),
    );
  }

  // Блок з показниками ймовірності
  Widget probabilityCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF302444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Математичний аналіз
  Widget buildAnalysis() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF40305F),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Аналіз ймовірностей',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Вибери грань для порівняння:',
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (int face = 1; face <= 6; face++)
                ChoiceChip(
                  label: Text('$face'),
                  selected: selectedFace == face,
                  onSelected: (_) {
                    setState(() {
                      selectedFace = face;
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              probabilityCard(
                'Теоретична',
                '16,67%',
              ),
              const SizedBox(width: 10),
              probabilityCard(
                'Експериментальна',
                totalRolls == 0
                    ? '—'
                    : '${experimentalProbability.toStringAsFixed(2)}%',
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            totalRolls == 0
                ? 'Відхилення: немає даних'
                : 'Відхилення: ${deviation.toStringAsFixed(2)} в.п.',
            style: const TextStyle(
              color: lightPurple,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Математичний висновок',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            totalRolls == 0
                ? 'Виконай хоча б один кидок, щоб отримати результати.'
                : 'Після $totalRolls кидків грань $selectedFace '
                  'випала ${results[selectedFace - 1]} разів. '
                  'Її експериментальна ймовірність становить '
                  '${experimentalProbability.toStringAsFixed(2)}%. '
                  'Теоретична ймовірність дорівнює 16,67%. '
                  'Відхилення становить '
                  '${deviation.toStringAsFixed(2)} відсоткового пункта. '
                  'За великої кількості незалежних кидків '
                  'експериментальна частота зазвичай наближається '
                  'до теоретичної ймовірності.',
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
      appBar: AppBar(
        title: const Text('Симулятор кубика'),
        backgroundColor: const Color(0xFF100D1F),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Випробуй свою удачу!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Кидай кубик і спостерігай за ймовірностями.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 30),

          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 120),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey(animationStep),
                child: buildDiceFace(),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Кількість кидків',
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
                      selected: selectedRolls == count,
                      onSelected: isRolling
                          ? null
                          : (_) {
                              setState(() {
                                selectedRolls = count;
                              });
                            },
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          FilledButton.icon(
            onPressed: isRolling ? null : rollDice,
            icon: const Icon(Icons.casino),
            label: Text(
              isRolling
                  ? 'Кубик крутиться...'
                  : 'Кинути кубик',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: purple,
              padding: const EdgeInsets.all(17),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Всього кидків: $totalRolls',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 25),

          const Text(
            'Статистика випадань',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          for (int i = 0; i < 6; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Text('${i + 1}'),
                  ),

                  Expanded(
                    child: LinearProgressIndicator(
                      value: totalRolls == 0
                          ? 0
                          : results[i] / totalRolls,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(8),
                      color: lightPurple,
                      backgroundColor: const Color(0xFF302644),
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    width: 65,
                    child: Text(
                      totalRolls == 0
                          ? '0%'
                          : '${(results[i] / totalRolls * 100).toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          const Text(
            'Теоретична ймовірність кожної грані: 1/6 ≈ 16,67%',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 25),

          buildAnalysis(),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: isRolling ? null : resetStatistics,
            icon: const Icon(Icons.refresh),
            label: const Text('Скинути статистику'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

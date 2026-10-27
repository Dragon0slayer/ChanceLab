
import 'package:flutter/material.dart';

class ProbabilityCalculatorScreen extends StatefulWidget {
  const ProbabilityCalculatorScreen({super.key});

  @override
  State<ProbabilityCalculatorScreen> createState() =>
      _ProbabilityCalculatorScreenState();
}

class _ProbabilityCalculatorScreenState
    extends State<ProbabilityCalculatorScreen> {
  static const Color background = Color(0xFF100D1F);
  static const Color card = Color(0xFF211936);
  static const Color purple = Color(0xFF9255F7);
  static const Color lightPurple = Color(0xFFB78AFF);

  final TextEditingController firstController =
      TextEditingController(text: '3');

  final TextEditingController secondController =
      TextEditingController(text: '6');

  int selectedMode = 0;
  double? result;
  String? errorMessage;

  final List<String> modes = [
    'Класична ймовірність',
    'Протилежна подія',
    'Обʼєднання подій',
    'Перетин подій',
  ];

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  String get firstLabel {
    switch (selectedMode) {
      case 0:
        return 'Сприятливі результати (m)';
      case 1:
        return 'Ймовірність події P(A)';
      default:
        return 'Ймовірність P(A)';
    }
  }

  String get secondLabel {
    if (selectedMode == 0) {
      return 'Усі можливі результати (n)';
    }
    return 'Ймовірність P(B)';
  }

  String get formula {
    switch (selectedMode) {
      case 0:
        return 'P(A) = m / n';
      case 1:
        return 'P(не A) = 1 - P(A)';
      case 2:
        return 'P(A ∪ B) = P(A) + P(B) - P(A) × P(B)';
      default:
        return 'P(A ∩ B) = P(A) × P(B)';
    }
  }

  String get explanation {
    switch (selectedMode) {
      case 0:
        return 'Класична ймовірність — це відношення '
            'кількості сприятливих результатів '
            'до кількості всіх рівноможливих результатів.';
      case 1:
        return 'Протилежна подія відбувається, '
            'коли початкова подія не відбулася.';
      case 2:
        return 'Обʼєднання означає, що відбулася '
            'хоча б одна з двох подій. '
            'Тут події вважаються незалежними.';
      default:
        return 'Перетин означає, що відбулися '
            'обидві події. '
            'Тут події вважаються незалежними.';
    }
  }

  void changeMode(int mode) {
    setState(() {
      selectedMode = mode;
      result = null;
      errorMessage = null;

      if (mode == 0) {
        firstController.text = '3';
        secondController.text = '6';
      } else {
        firstController.text = '0.5';
        secondController.text = '0.4';
      }
    });
  }

  double? parseNumber(String text) {
    final value = double.tryParse(
      text.trim().replaceAll(',', '.'),
    );

    if (value == null || !value.isFinite) {
      return null;
    }

    return value;
  }

  void calculate() {
    final a = parseNumber(firstController.text);
    final b = parseNumber(secondController.text);

    setState(() {
      result = null;
      errorMessage = null;

      if (a == null ||
          (selectedMode != 1 && b == null)) {
        errorMessage =
            'Упс! 😅 Введи коректні числа. '
            'Наприклад, 3 або 0.5.';
        return;
      }

      if (selectedMode == 0) {
        if (a < 0 || b! < 0) {
          errorMessage =
              'Відʼємної кількості результатів '
              'не буває 🙂 Спробуй додатні числа.';
          return;
        }

        if (b == 0) {
          errorMessage =
              'Загальна кількість результатів '
              'не може дорівнювати нулю.';
          return;
        }

        if (a != a.roundToDouble() ||
            b != b.roundToDouble()) {
          errorMessage =
              'Кількість результатів має бути '
              'цілим числом. Наприклад, 3 із 6.';
          return;
        }

        if (a > b) {
          errorMessage =
              'Ого! 😄 Сприятливих результатів '
              'не може бути більше, ніж усіх можливих.';
          return;
        }

        result = a / b;
        return;
      }

      if (a < 0 || a > 1) {
        errorMessage =
            'Ймовірність P(A) має бути від 0 до 1. '
            'Наприклад, 0.5 означає 50%.';
        return;
      }

      if (selectedMode == 1) {
        result = 1 - a;
        return;
      }

      if (b! < 0 || b > 1) {
        errorMessage =
            'Ймовірність P(B) теж має бути '
            'від 0 до 1. Спробуй 0.4.';
        return;
      }

      if (selectedMode == 2) {
        result = a + b - a * b;
      } else {
        result = a * b;
      }
    });
  }

  Widget buildInput(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF302444),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: lightPurple,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResult() {
    if (errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF39202D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: Color(0xFFFFA7B2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFFFA7B2),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Введи значення та натисни «Обчислити».',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightPurple),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: lightPurple,
            size: 34,
          ),
          const SizedBox(height: 10),
          const Text(
            'Результат обчислення',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            '${(result! * 100).toStringAsFixed(2)}%',
            style: const TextStyle(
              color: lightPurple,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'P = ${result!.toStringAsFixed(4)}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: result!.clamp(0.0, 1.0),
            minHeight: 13,
            borderRadius: BorderRadius.circular(8),
            color: lightPurple,
            backgroundColor: const Color(0xFF392B4D),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Калькулятор ймовірностей'),
        backgroundColor: background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Обчислюй ймовірності',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Обери формулу, введи значення '
            'та отримай результат.',
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 25),
          const Text(
            'Тип обчислення',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
            ),
            child: RadioGroup<int>(
              groupValue: selectedMode,
              onChanged: (value) {
                if (value != null) {
                  changeMode(value);
                }
              },
              child: Column(
                children: [
                  for (int i = 0; i < modes.length; i++)
                    RadioListTile<int>(
                      title: Text(
                        modes[i],
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: i,
                      activeColor: lightPurple,
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF40305F),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Формула',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  formula,
                  style: const TextStyle(
                    color: lightPurple,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  explanation,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Вхідні дані',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          buildInput(firstLabel, firstController),

          if (selectedMode != 1)
            buildInput(secondLabel, secondController),

          if (selectedMode != 0)
            const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text(
                'Вводь ймовірності від 0 до 1. '
                'Наприклад, 0.5 означає 50%.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(height: 5),

          FilledButton.icon(
            onPressed: calculate,
            icon: const Icon(Icons.calculate),
            label: const Text('Обчислити'),
            style: FilledButton.styleFrom(
              backgroundColor: purple,
              minimumSize: const Size(
                double.infinity,
                54,
              ),
            ),
          ),

          const SizedBox(height: 22),
          buildResult(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

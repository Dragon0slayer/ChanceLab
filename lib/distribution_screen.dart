
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DistributionScreen extends StatefulWidget {
  const DistributionScreen({super.key});

  @override
  State<DistributionScreen> createState() =>
      _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {
  int selectedDistribution = 0;

  double probability = 0.5;
  int trials = 10;
  double mean = 0;
  double deviation = 1;

  static const Color background = Color(0xFF100D1F);
  static const Color cardColor = Color(0xFF211936);
  static const Color purple = Color(0xFF9255F7);
  static const Color lightPurple = Color(0xFFB78AFF);

  final List<String> names = [
    'Бернуллі',
    'Біноміальний',
    'Нормальний',
  ];

  double binomialProbability(int n, int k, double p) {
    double combination = 1;

    for (int i = 1; i <= k; i++) {
      combination *= (n - i + 1) / i;
    }

    return combination *
        math.pow(p, k).toDouble() *
        math.pow(1 - p, n - k).toDouble();
  }

  List<double> getChartValues() {
    if (selectedDistribution == 0) {
      return [1 - probability, probability];
    }

    if (selectedDistribution == 1) {
      return List.generate(
        trials + 1,
        (k) => binomialProbability(trials, k, probability),
      );
    }

    return List.generate(81, (index) {
      final x = mean + (index - 40) * deviation / 10;
      final z = (x - mean) / deviation;

      return math.exp(-0.5 * z * z) /
          (deviation * math.sqrt(2 * math.pi));
    });
  }

  String getExplanation() {
    switch (selectedDistribution) {
      case 0:
        return 'Розподіл Бернуллі описує один випадковий '
            'експеримент із двома можливими результатами: '
            'успіх (1) або невдача (0).\n\n'
            'Ймовірність успіху: '
            '${(probability * 100).toStringAsFixed(0)}%.\n'
            'Ймовірність невдачі: '
            '${((1 - probability) * 100).toStringAsFixed(0)}%.';

      case 1:
        final expected = trials * probability;
        final variance =
            trials * probability * (1 - probability);

        return 'Біноміальний розподіл показує, скільки '
            'успіхів можна отримати за $trials незалежних '
            'випробувань, якщо ймовірність успіху '
            'становить ${(probability * 100).toStringAsFixed(0)}%.\n\n'
            'Математичне сподівання: '
            '${expected.toStringAsFixed(2)}.\n'
            'Дисперсія: ${variance.toStringAsFixed(2)}.';

      default:
        return 'Нормальний розподіл має характерну '
            'дзвоноподібну форму.\n\n'
            'Середнє значення μ = ${mean.toStringAsFixed(1)}.\n'
            'Стандартне відхилення σ = '
            '${deviation.toStringAsFixed(1)}.\n\n'
            'Приблизно 68% значень лежать у межах '
            'одного стандартного відхилення від середнього.';
    }
  }

  Widget buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueText,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            Text(
              valueText,
              style: const TextStyle(
                color: lightPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: purple,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Параметри розподілу',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),

          if (selectedDistribution != 2)
            buildSlider(
              title: 'Ймовірність успіху (p)',
              value: probability,
              min: 0,
              max: 1,
              divisions: 20,
              valueText:
                  '${(probability * 100).toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  probability = value;
                });
              },
            ),

          if (selectedDistribution == 1)
            buildSlider(
              title: 'Кількість випробувань (n)',
              value: trials.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              valueText: '$trials',
              onChanged: (value) {
                setState(() {
                  trials = value.round();
                });
              },
            ),

          if (selectedDistribution == 2) ...[
            buildSlider(
              title: 'Середнє значення (μ)',
              value: mean,
              min: -5,
              max: 5,
              divisions: 20,
              valueText: mean.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  mean = value;
                });
              },
            ),
            buildSlider(
              title: 'Стандартне відхилення (σ)',
              value: deviation,
              min: 0.5,
              max: 3,
              divisions: 10,
              valueText: deviation.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  deviation = value;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildChart() {
    final values = getChartValues();

    return Container(
      padding: const EdgeInsets.all(16),
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
            'Графік розподілу',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedDistribution == 2
                ? 'Щільність ймовірності'
                : 'Ймовірність кожного результату',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 235,
            width: double.infinity,
            child: CustomPaint(
              painter: DistributionChartPainter(
                values: values,
                isCurve: selectedDistribution == 2,
                color: lightPurple,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            selectedDistribution == 0
                ? '0 — невдача                   1 — успіх'
                : selectedDistribution == 1
                    ? 'Кількість успіхів: від 0 до $trials'
                    : 'Значення випадкової величини',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExplanation() {
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
            'Математичне пояснення',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            getExplanation(),
            style: const TextStyle(
              color: Colors.white70,
              height: 1.6,
              fontSize: 14,
            ),
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
        title: const Text('Математичні розподіли'),
        backgroundColor: background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Досліджуй розподіли',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Змінюй параметри та спостерігай, '
            'як змінюється графік.',
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 24),

          const Text(
            'Вибери розподіл',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < names.length; i++)
                ChoiceChip(
                  label: Text(names[i]),
                  selected: selectedDistribution == i,
                  onSelected: (_) {
                    setState(() {
                      selectedDistribution = i;
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 24),
          buildControls(),

          const SizedBox(height: 20),
          buildChart(),

          const SizedBox(height: 20),
          buildExplanation(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class DistributionChartPainter extends CustomPainter {
  final List<double> values;
  final bool isCurve;
  final Color color;

  DistributionChartPainter({
    required this.values,
    required this.isCurve,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const left = 14.0;
    const right = 10.0;
    const top = 12.0;
    const bottom = 28.0;

    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;
    if (values.isEmpty) return;

    final axisPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    final chartBottom = top + chartHeight;

    // Горизонтальні лінії сітки
    for (int i = 0; i <= 4; i++) {
      final y = top + chartHeight * i / 4;

      canvas.drawLine(
        Offset(left, y),
        Offset(left + chartWidth, y),
        gridPaint,
      );
    }

    canvas.drawLine(
      Offset(left, chartBottom),
      Offset(left + chartWidth, chartBottom),
      axisPaint,
    );

    final maxValue = values.reduce(math.max);
    if (maxValue <= 0) return;

    if (isCurve) {
      final path = Path();

      for (int i = 0; i < values.length; i++) {
        final x = left +
            chartWidth * i / (values.length - 1);

        final y = chartBottom -
            (values[i] / maxValue) *
                (chartHeight - 12);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final fillPath = Path.from(path)
        ..lineTo(left + chartWidth, chartBottom)
        ..lineTo(left, chartBottom)
        ..close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..color = color.withValues(alpha: 0.15),
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    } else {
      final slotWidth = chartWidth / values.length;
      final barWidth =
          math.min(slotWidth * 0.68, 70.0);

      final barPaint = Paint()..color = color;

      for (int i = 0; i < values.length; i++) {
        final height =
            values[i] / maxValue * (chartHeight - 12);

        final x = left +
            slotWidth * i +
            (slotWidth - barWidth) / 2;

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            chartBottom - height,
            barWidth,
            height,
          ),
          const Radius.circular(5),
        );

        canvas.drawRRect(rect, barPaint);
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant DistributionChartPainter oldDelegate,
  ) {
    return oldDelegate.values != values ||
        oldDelegate.isCurve != isCurve ||
        oldDelegate.color != color;
  }
}

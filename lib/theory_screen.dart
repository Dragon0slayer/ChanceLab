
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  static const Color background = Color(0xFF100D1F);
  static const Color cardColor = Color(0xFF211936);
  static const Color formulaColor = Color(0xFFB78AFF);

  String search = '';

  final List<TheoryTopic> topics = const [
    TheoryTopic(
      title: 'Випадкова подія',
      icon: Icons.casino,
      formula: r'0 \leq P(A) \leq 1',
      description:
          'Випадкова подія — це подія, яка за певних '
          'умов може відбутися або не відбутися.\n\n'
          'Ймовірність показує, наскільки можливим '
          'є настання події.',
      example:
          'Під час підкидання монети подія '
          '«випав орел» є випадковою.',
      exampleFormula: r'P(A)=\frac{1}{2}=50\%',
    ),
    TheoryTopic(
      title: 'Класична ймовірність',
      icon: Icons.calculate,
      formula: r'P(A)=\frac{m}{n}',
      description:
          'm — кількість сприятливих результатів.\n'
          'n — кількість усіх рівноможливих результатів.\n\n'
          'Класична ймовірність — це відношення '
          'кількості сприятливих результатів '
          'до загальної кількості результатів.',
      example:
          'У звичайного кубика шість граней. '
          'Ймовірність випадання числа 4:',
      exampleFormula: r'P(A)=\frac{1}{6}\approx16.67\%',
    ),
    TheoryTopic(
      title: 'Протилежна подія',
      icon: Icons.swap_horiz,
      formula: r'P(\overline{A})=1-P(A)',
      description:
          'Протилежна подія означає, що подія A '
          'не відбулася.\n\n'
          'Сума ймовірностей події та її '
          'протилежної події дорівнює одиниці.',
      example:
          'Ймовірність не отримати шістку '
          'під час кидання кубика:',
      exampleFormula:
          r'P(\overline{A})=1-\frac{1}{6}=\frac{5}{6}',
    ),
    TheoryTopic(
      title: 'Незалежні події',
      icon: Icons.call_split,
      formula: r'P(A\cap B)=P(A)\cdot P(B)',
      description:
          'Події A і B незалежні, якщо настання '
          'однієї не змінює ймовірність іншої.\n\n'
          'Ймовірність одночасного настання '
          'двох незалежних подій дорівнює '
          'добутку їхніх ймовірностей.',
      example:
          'Двічі підкидаємо чесну монету. '
          'Ймовірність отримати два орли:',
      exampleFormula:
          r'P(A\cap B)=\frac{1}{2}\cdot\frac{1}{2}=\frac{1}{4}',
    ),
    TheoryTopic(
      title: 'Обʼєднання подій',
      icon: Icons.join_inner,
      formula:
          r'P(A\cup B)=P(A)+P(B)-P(A\cap B)',
      description:
          'Обʼєднання означає, що відбулася '
          'хоча б одна з двох подій.\n\n'
          'Формула правильна для будь-яких '
          'двох подій. Якщо вони незалежні, '
          'то P(A ∩ B) = P(A) × P(B).',
      example:
          'Нехай незалежні події мають '
          'ймовірності 0.5 та 0.4.',
      exampleFormula:
          r'P(A\cup B)=0.5+0.4-0.2=0.7',
    ),
    TheoryTopic(
      title: 'Розподіл Бернуллі',
      icon: Icons.toggle_on,
      formula: r'''
P(X=x)=
\begin{cases}
p, & x=1\\
1-p, & x=0
\end{cases}
''',
      description:
          'Розподіл Бернуллі описує один '
          'випадковий експеримент із двома '
          'результатами: успіхом та невдачею.\n\n'
          'p — ймовірність успіху.',
      example:
          'Для чесної монети ймовірності '
          'орла та решки однакові.',
      exampleFormula:
          r'P(X=1)=P(X=0)=\frac{1}{2}',
    ),
    TheoryTopic(
      title: 'Біноміальний розподіл',
      icon: Icons.bar_chart,
      formula:
          r'P(X=k)=\binom{n}{k}p^k(1-p)^{n-k}',
      description:
          'Біноміальний розподіл показує '
          'ймовірність отримати рівно k успіхів '
          'у n незалежних випробуваннях.\n\n'
          'p — ймовірність успіху в одному '
          'випробуванні.',
      example:
          'Тричі підкидаємо чесну монету. '
          'Ймовірність отримати рівно два орли:',
      exampleFormula:
          r'P(X=2)=\binom{3}{2}(0.5)^3=0.375',
    ),
    TheoryTopic(
      title: 'Нормальний розподіл',
      icon: Icons.show_chart,
      formula:
          r'f(x)=\frac{1}{\sigma\sqrt{2\pi}}e^{-\frac{(x-\mu)^2}{2\sigma^2}}',
      description:
          'Нормальний розподіл має симетричну '
          'дзвоноподібну криву.\n\n'
          'μ — середнє значення.\n'
          'σ — стандартне відхилення, σ > 0.\n\n'
          'Площа під усією кривою дорівнює 1.',
      example:
          'Приблизно 68% значень нормального '
          'розподілу лежать у межах одного '
          'стандартного відхилення від середнього.',
      exampleFormula:
          r'P(\mu-\sigma\leq X\leq\mu+\sigma)\approx0.68',
    ),
    TheoryTopic(
      title: 'Математичне сподівання',
      icon: Icons.functions,
      formula:
          r'E(X)=\sum_{i=1}^{n}x_iP(X=x_i)',
      description:
          'Математичне сподівання характеризує '
          'середнє значення випадкової величини.\n\n'
          'Для дискретної випадкової величини '
          'воно обчислюється як сума добутків '
          'значень на їхні ймовірності.',
      example:
          'Середнє значення результату '
          'чесного шестигранного кубика:',
      exampleFormula:
          r'E(X)=\frac{1+2+3+4+5+6}{6}=3.5',
    ),
    TheoryTopic(
      title: 'Дисперсія',
      icon: Icons.analytics,
      formula:
          r'\operatorname{Var}(X)=E[(X-E(X))^2]',
      description:
          'Дисперсія показує, наскільки '
          'значення випадкової величини '
          'розкидані навколо середнього.\n\n'
          'Стандартне відхилення — '
          'це квадратний корінь із дисперсії.',
      example:
          'Для розподілу Бернуллі з p = 0.5:',
      exampleFormula:
          r'\operatorname{Var}(X)=p(1-p)=0.25',
    ),
    TheoryTopic(
      title: 'Закон великих чисел',
      icon: Icons.trending_up,
      formula:
          r'\frac{N_A}{n}\xrightarrow{P}P(A)',
      description:
          'Зі збільшенням кількості незалежних '
          'однаково розподілених випробувань '
          'відносна частота події наближається '
          'до її теоретичної ймовірності.\n\n'
          'Це не означає, що відхилення '
          'зменшується після кожного кидка.',
      example:
          'Для чесного кубика частота '
          'випадання кожної грані за великої '
          'кількості кидків наближається до 1/6.',
      exampleFormula:
          r'\frac{N_A}{n}\approx\frac{1}{6}',
    ),
  ];

  Widget mathBox(String latex) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF302444),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          latex,
          mathStyle: MathStyle.display,
          textStyle: const TextStyle(
            color: formulaColor,
            fontSize: 19,
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTopicCard(TheoryTopic topic) {
    return Card(
      key: ValueKey(topic.title),
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF40305F),
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          topic.icon,
          color: formulaColor,
        ),
        title: Text(
          topic.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        iconColor: formulaColor,
        collapsedIconColor: Colors.white70,
        childrenPadding: const EdgeInsets.fromLTRB(
          16, 0, 16, 18,
        ),
        children: [
          sectionTitle('Формула'),
          const SizedBox(height: 10),
          mathBox(topic.formula),

          const SizedBox(height: 20),
          sectionTitle('Пояснення'),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              topic.description,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 20),
          sectionTitle('Приклад'),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              topic.example,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          mathBox(topic.exampleFormula),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = search.trim().toLowerCase();

    final filtered = topics.where((topic) {
      return topic.title.toLowerCase().contains(query) ||
          topic.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Теорія та формули'),
        backgroundColor: background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Бібліотека знань',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Вивчай теорію ймовірностей '
            'із математичними формулами '
            'та практичними прикладами.',
            style: TextStyle(
              color: Colors.white60,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),

          TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Пошук теми...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 22),
          Text(
            'Знайдено тем: ${filtered.length}',
            style: const TextStyle(
              color: formulaColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Нічого не знайдено 🔎',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),

          for (final topic in filtered)
            buildTopicCard(topic),

          const SizedBox(height: 20),
          const Center(
            child: Text(
              'ChanceLab • Математика стає зрозумілішою',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class TheoryTopic {
  final String title;
  final IconData icon;
  final String formula;
  final String description;
  final String example;
  final String exampleFormula;

  const TheoryTopic({
    required this.title,
    required this.icon,
    required this.formula,
    required this.description,
    required this.example,
    required this.exampleFormula,
  });
}

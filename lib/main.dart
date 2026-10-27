
import 'package:flutter/material.dart';

import 'dice_screen.dart';
import 'coin_screen.dart';
import 'distribution_screen.dart';
import 'probability_calculator_screen.dart';
import 'theory_screen.dart';

void main() {
  runApp(const ChanceLabApp());
}

class ChanceLabApp extends StatelessWidget {
  const ChanceLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChanceLab',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF100D1F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9255F7),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const Color background = Color(0xFF100D1F);
  static const Color surface = Color(0xFF211936);
  static const Color purple = Color(0xFFB78AFF);

  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> openScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );

    if (mounted) {
      setState(() {
        selectedIndex = 0;
      });
    }
  }

  Widget moduleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget screen,
    required Color accent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => openScreen(screen),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF40305F),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: accent,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6335AC),
            Color(0xFF35205D),
            Color(0xFF211936),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF7650AF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              '✦ Твоя лабораторія ймовірностей',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Досліджуй.\nЕкспериментуй.\nВідкривай.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Перетворюй математичні формули '
            'на наочні експерименти.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.auto_graph,
                size: 18,
                color: Color(0xFFD5B8FF),
              ),
              const SizedBox(width: 8),
              const Text(
                '5 інтерактивних модулів',
                style: TextStyle(
                  color: Color(0xFFE5D5FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHomeContent() {
    return FadeTransition(
      opacity: fadeAnimation,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          20, 14, 20, 24,
        ),
        children: [
          buildHeader(),
          const SizedBox(height: 30),
          const Text(
            'Обери експеримент',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Усе для дослідження теорії ймовірностей',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          moduleCard(
            title: 'Симулятор кубика',
            subtitle: 'Кидки, статистика та ймовірності',
            icon: Icons.casino_rounded,
            screen: const DiceScreen(),
            accent: const Color(0xFFB78AFF),
          ),

          moduleCard(
            title: 'Симулятор монетки',
            subtitle: 'Орел, решка та випадковість',
            icon: Icons.monetization_on_rounded,
            screen: const CoinScreen(),
            accent: const Color(0xFFE5A65B),
          ),

          moduleCard(
            title: 'Математичні розподіли',
            subtitle: 'Інтерактивні графіки та параметри',
            icon: Icons.bar_chart_rounded,
            screen: const DistributionScreen(),
            accent: const Color(0xFF65C9DB),
          ),

          moduleCard(
            title: 'Калькулятор ймовірностей',
            subtitle: 'Формули та точні обчислення',
            icon: Icons.calculate_rounded,
            screen: const ProbabilityCalculatorScreen(),
            accent: const Color(0xFF7BD9AC),
          ),

          moduleCard(
            title: 'Теорія та формули',
            subtitle: 'Пояснення, приклади й математичні вирази',
            icon: Icons.menu_book_rounded,
            screen: const TheoryScreen(),
            accent: const Color(0xFFFFB4C8),
          ),

          const SizedBox(height: 18),
          const Center(
            child: Text(
              'ChanceLab • Навчайся через експерименти',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleNavigation(int index) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
      });
    } else if (index == 1) {
      openScreen(const DiceScreen());
    } else if (index == 2) {
      openScreen(const DistributionScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: purple,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              'ChanceLab',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Теорія та формули',
            onPressed: () => openScreen(
              const TheoryScreen(),
            ),
            icon: const Icon(
              Icons.school_outlined,
              color: purple,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: buildHomeContent(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1B1530),
        selectedIndex: selectedIndex,
        onDestinationSelected: handleNavigation,
        indicatorColor: const Color(0xFF503478),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Кубик',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Графіки',
          ),
        ],
      ),
    );
  }
}

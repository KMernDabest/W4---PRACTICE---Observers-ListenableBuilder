import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

enum CardType { red, blue, yellow, green }

extension CardTypeExtension on CardType {
  Color get color {
    switch (this) {
      case CardType.red:
        return Colors.red;
      case CardType.blue:
        return Colors.blue;
      case CardType.yellow:
        return Colors.yellow;
      case CardType.green:
        return Colors.green;
    }
  }
}

class ColorService extends ChangeNotifier {
  int _currentIndex = 0;

  final Map<CardType, int> _tapCounts = {
    for (final type in CardType.values)
      type: 0,
  };

  int get currentIndex => _currentIndex;
  int getTapCount(CardType type) =>
      _tapCounts[type] ?? 0;

  void setTap(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void increment(CardType type) {
    _tapCounts[type] = getTapCount(type) + 1;
    notifyListeners();
  }
}

final colorService = ColorService();

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, _) {
        final index = colorService.currentIndex;

        return Scaffold(
          appBar: AppBar(title: Text(index == 0 ? 'Color Taps' : 'Statistics')),
          body: index == 0 ? const ColorTapsScreen() : const StatisticsScreen(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: colorService.setTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.tap_and_play),
                label: 'Taps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistic',
              ),
            ],
          ),
        );
      },
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final type in CardType.values) ColorTap(type: type),
      ],
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, _) {
        final count = colorService.getTapCount(type);

        return GestureDetector(
          onTap: () => colorService.increment(type),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                'Taps: $count',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final type in CardType.values)
                Text(
                  '${type.name} taps = ${colorService.getTapCount(type)}',
                ),
            ],
          ),
        );
      },
    );
  }
}

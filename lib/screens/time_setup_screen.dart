import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_splitter/providers/time_provider.dart';
import 'package:time_splitter/screens/main_screen.dart';

class TimeSetupScreen extends StatefulWidget {
  const TimeSetupScreen({super.key});

  @override
  State<TimeSetupScreen> createState() => _TimeSetupScreenState();
}

class _TimeSetupScreenState extends State<TimeSetupScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간 설정'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStartTimeStep(),
          _buildTimeUnitStep(),
        ],
      ),
    );
  }

  Widget _buildStartTimeStep() {
    final timeProvider = Provider.of<TimeProvider>(context);
    DateTime currentTime = timeProvider.startTime;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '몇시부터 할 건가요?',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    timeProvider.setStartTime(currentTime.add(const Duration(hours: 1)));
                  } else if (details.delta.dy > 0) {
                    timeProvider.setStartTime(currentTime.subtract(const Duration(hours: 1)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    timeProvider.formatTime(currentTime).split(':')[0],
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const Text(
                ':',
                style: TextStyle(fontSize: 48),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    timeProvider.setStartTime(currentTime.add(const Duration(minutes: 5)));
                  } else if (details.delta.dy > 0) {
                    timeProvider.setStartTime(currentTime.subtract(const Duration(minutes: 5)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    timeProvider.formatTime(currentTime).split(':')[1],
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentStep = 1;
              });
            },
            child: const Text('다음'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnitStep() {
    final timeProvider = Provider.of<TimeProvider>(context);
    Duration currentDuration = timeProvider.timeUnit;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '몇시간 단위로 할 건가요?',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    timeProvider.setTimeUnit(currentDuration + const Duration(hours: 1));
                  } else if (details.delta.dy > 0 && currentDuration.inHours > 1) {
                    timeProvider.setTimeUnit(currentDuration - const Duration(hours: 1));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentDuration.inHours.toString(),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const Text(
                ':',
                style: TextStyle(fontSize: 48),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    timeProvider.setTimeUnit(currentDuration + const Duration(minutes: 5));
                  } else if (details.delta.dy > 0) {
                    timeProvider.setTimeUnit(currentDuration - const Duration(minutes: 5));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    (currentDuration.inMinutes % 60).toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              timeProvider.addTimeCard();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            child: const Text('시작하기'),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_splitter/providers/time_provider.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {}); // 1초마다 화면을 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeProvider = Provider.of<TimeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간 분배'),
      ),
      body: ListView.builder(
        itemCount: timeProvider.timeCards.length,
        itemBuilder: (context, index) {
          final card = timeProvider.timeCards[index];
          final isExpired = card.isExpired();
          final isCurrent = card.isCurrent();
          final remainingTime = card.getRemainingTime();

          return Card(
            margin: const EdgeInsets.all(8.0),
            color: isExpired ? Colors.grey[300] : null,
            child: Container(
              decoration: isCurrent
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    )
                  : null,
              child: ListTile(
                title: Text('시작 시간: ${timeProvider.formatTime(card.startTime)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('기간: ${card.duration.inHours}시간 ${card.duration.inMinutes % 60}분'),
                    if (isCurrent)
                      Text(
                        '남은 시간: ${timeProvider.formatDuration(remainingTime)}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          timeProvider.addTimeCard();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 
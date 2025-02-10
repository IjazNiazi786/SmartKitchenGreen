import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FreezerPage extends StatefulWidget {
  @override
  _FreezerPageState createState() => _FreezerPageState();
}

class _FreezerPageState extends State<FreezerPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool isOn = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: false);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _seconds = 0;
      });
    }
  }

  void _toggleOnOff() {
    setState(() {
      isOn = !isOn;
      if (isOn) {
        _startTimer();
        _controller.repeat();
      } else {
        _stopTimer();
        _controller.stop();
      }
    });
  }

  void _showItemsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Items in Freezer'),
          content: Container(
            height: 150,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Ice Cream'),
                ),
                ListTile(
                  title: Text('Frozen Pizza'),
                ),
                ListTile(
                  title: Text('Frozen Vegetables'),
                ),
                ListTile(
                  title: Text('Ice Cubes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text("Smart Kitchen - Freezer"),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: -10,
              left: 10,
              child: InkWell(
                onTap: _toggleOnOff,
                child: Image.asset(
                  "assets/appliance/${isOn ? "on.png" : "off.png"}",
                  width: 100,
                  height: 100,
                ),
              )),
          Positioned(
            top: 28,
            right: 20,
            child: Text(
              'Time: $_seconds sec',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 100,
            child: ElevatedButton(
              onPressed: _showItemsPopup,
              child: Text(
                'Items',
              ),
            ),
          ),
          if (isOn)
            Positioned(
              bottom: 316,
              child: EvaporationEffect(controller: _controller),
            ),
          Positioned(
            bottom: 40,
            child: Image.asset(
              'assets/appliance/freezer.png', // Ensure this image is added to your assets
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class EvaporationEffect extends StatelessWidget {
  final AnimationController controller;

  EvaporationEffect({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        Random().nextInt(7) + 15, // Randomize number of particles
        (index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  Random().nextDouble() * 300 -
                      150, // Randomize horizontal position
                  -controller.value * 20, // Move upwards
                ),
                child: EvaporationParticle(),
              );
            },
          );
        },
      ),
    );
  }
}

class EvaporationParticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: Random().nextDouble() * 8 + 10, // Randomize size
        height: Random().nextDouble() * 8 + 10, // Randomize size
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

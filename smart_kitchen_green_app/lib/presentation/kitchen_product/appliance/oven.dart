import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class OvenPage extends StatefulWidget {
  @override
  _OvenPageState createState() => _OvenPageState();
}

class _OvenPageState extends State<OvenPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool isOn = true;
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);

    _createAnimations();
  }

  void _createAnimations() {
    _animations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: Offset(Random().nextDouble() * 100 - 50, 0),
        end: Offset(Random().nextDouble() * 100 - 50, -150),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    });
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
        title: Text("Smart Kitchen - Oven"),
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
              bottom: 300,
              child: EvaporationEffect(animations: _animations),
            ),
          Positioned(
            bottom: 40,
            child: Image.asset(
              'assets/appliance/oven.png', // Ensure this image is added to your assets
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
  final List<Animation<Offset>> animations;

  EvaporationEffect({required this.animations});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(animations.length, (index) {
        return AnimatedBuilder(
          animation: animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: animations[index].value,
              child: ZigzagParticle(),
            );
          },
        );
      }),
    );
  }
}

class ZigzagParticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ZigzagPainter(),
    );
  }
}

class ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(10, -10);
    path.lineTo(-10, -20);
    path.lineTo(10, -30);
    path.lineTo(-10, -40);
    path.lineTo(10, -50);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

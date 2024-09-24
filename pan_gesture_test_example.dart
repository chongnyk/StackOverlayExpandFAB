import 'package:flutter/material.dart';

class PanGestureExample extends StatefulWidget {
  @override
  _PanGestureExampleState createState() => _PanGestureExampleState();
}

class _PanGestureExampleState extends State<PanGestureExample> {
  Offset _position = Offset(100, 100); // Starting position of the box

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pan Gesture Example')),
      body: GestureDetector(
        onLongPressStart: (details) {
          print('Long press started');
        },
        onPanStart: (details) {
          print('Pan started at: ${details.localPosition}');
        },
        onPanUpdate: (details) {
          //print('Panning: ${details.delta.dx} ${details.delta.dy}');
          setState(() {
            _position += details.delta; // Update the position based on pan movement
          });
        },
        onPanEnd: (details) {
          print('Pan ended');
        },
        child: Stack(
          children: [
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(
                  child: Text('Drag me', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class FabWithIconsFan extends StatefulWidget {
  const FabWithIconsFan({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  /*
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;

  const FabWithIconsFan({
    Key? key,
    required this.icons,
    required this.onIconTapped,
  }) : super(key: key);
  */

  @override
  State createState() => FabWithIconsFanState();
}

class FabWithIconsFanState extends State<FabWithIconsFan> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late List<Widget> children;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
    children = [];
  }

  /*
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }
  */

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      )
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / count;
    for (var i = 0, angleInDegrees = 60.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: false,//_open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            shape: const CircleBorder(),
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }

  /*
  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).colorScheme.secondary; // Updated for null-safety

    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            1.0 - index / widget.icons.length / 2.0,
            curve: Curves.easeOut,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Toggle',
      child: const Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
  */
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          (directionInDegrees) * (math.pi / 180.0),
          //(directionInDegrees - 180.0) * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        /*
        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * -math.pi / 2,
            child: child,
          ),
        );
        */
        return Positioned(
          right: offset.dx,
          bottom: offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            transformHitTests: true,
            child: child,
          ),
        );

      },
      child: FadeTransition(
        opacity: progress,
        child: this.child,
      ),
    );
  }
}

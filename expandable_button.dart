import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FabWithIcons extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;

  const FabWithIcons({
    super.key,
    required this.icons,
    required this.onIconTapped,
  });

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleQuickSelect() {
    setState(() {
      _open = !_open;
      //print(_open);
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 172.w,
          height: 60.h,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(
                0.0,
                1.0 - 0.25,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              width: 172.w,
              height: 60.h,
              padding: EdgeInsets.symmetric(vertical: 8.h,),
              decoration: BoxDecoration(
                color: Color(0xFFFEFEFE), //TODO: Change color to defined color
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.icons.length, (int index) {
                  return _buildChild(index);
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 13.h),
        _buildFab(),
      ],
    );
  }

  Widget _buildChild(int index) {

    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            1.0 - (widget.icons.length - index) / widget.icons.length / 2.0,
            curve: Curves.easeOut,
          ),
        ),
        child: RawMaterialButton(
          fillColor: Color(0xFFFEFEFE),
          elevation: 0,
          shape: const CircleBorder(),
          constraints: BoxConstraints.tightFor(
            width: 44.w,
            height: 44.h,
          ),
          onPressed: () {
            _onTapped(index);
            _toggleQuickSelect();
          },
          child: Icon(widget.icons[index]),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return RawMaterialButton(
      onPressed: () {
        if(_open){
          _toggleQuickSelect();
        }
        else{
          //TODO: implement function to go to next page
        }
      },
      onLongPress: () {
        _toggleQuickSelect();
      },
      fillColor: Color(0xFFFEFEFE),
      shape: const CircleBorder(),
      elevation: 6.0,
      constraints: BoxConstraints.tightFor(
        width: 56.w,
        height: 56.h,
      ),
      child: (!_open) ? const Icon(Icons.create) : const Icon(Icons.close), //Can replace with Image.asset('path')
    );

    /*
    return FloatingActionButton(
      shape: const CircleBorder(),
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
    */
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}

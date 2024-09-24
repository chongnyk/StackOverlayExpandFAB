import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/bottom/expandable_fab.dart';
import '../components/bottom/expandable_button.dart';
import '../components/bottom/expandable_fab_overlay.dart';
import 'calendar_cards.dart';
import 'calendar_fleet.dart';
import 'calendar_happy_days.dart';

class BottomAppBarTester extends StatefulWidget {
  const BottomAppBarTester({Key? key}) : super(key: key);

  @override
  _BottomAppBarTesterState createState() => _BottomAppBarTesterState();
}

class _BottomAppBarTesterState extends State<BottomAppBarTester>{
  String _lastSelected = 'TAB: 0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom App Bar Tester'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            print('Pressed!');
          },
          child: Text('PRESS ME TO TEST BODY'),
        ),
      ),
      ///*
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.r,
        height: (80).h,
        color: Color(0xFF263238),
        child: Container(
          /*
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          */
        ),
      ),
      //*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildGoodFab(context),
    );
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
      print(_lastSelected);
    });
  }

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoodFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx - 58.w, offset.dy - 71.h,),
          child: ExpandableFab.navPush(
            longPressAction: true,
            pressOption: CalendarHappyDays(),
            longPressOptions: [
              CalendarHappyDays(),
              CalendarFleet(),
              CalendarCards(),
            ],
            pressImage: Image.asset('assets/images/cal_happy_days.png', width: 24.0, height: 24.0,),
            longPressImages:[
              Image.asset('assets/images/cal_happy_days.png', width: 24.0, height: 24.0,),
              Image.asset('assets/images/cal_fleets.png', width: 24.0, height: 24.0,),
              Image.asset('assets/images/cal_cards.png', width: 24.0, height: 24.0,),
            ],
          ),
        );
      },
      child: Container(
        width: 56.w,
        height: 56.h,
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx - 58.w, offset.dy - 71.h,),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: Container(
        width: 56.w,
        height: 56.h,
      ),
    );
  }

  Widget _buildFabFan(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy),
          child: FabWithIconsFan(
            distance: 112,
            children: [
              /*
              Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  mini: true,
                  child: Icon(Icons.format_size, color: Colors.white),
                  onPressed: () => _showAction(context, 0),
                ),
              ),
              */
              ///*
              ActionButton(
                onPressed: () => _showAction(context, 0),
                icon: const Icon(Icons.format_size),
              ),
              //*/
              ActionButton(
                onPressed: () => _showAction(context, 1),
                icon: const Icon(Icons.insert_photo),
              ),
              ActionButton(
                onPressed: () => _showAction(context, 2),
                icon: const Icon(Icons.videocam),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: 56.w,
        height: 56.h,
      ),
      /*
      child: FloatingActionButton(
        onPressed: () { },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      */
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: () {print('Pressed!');},
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

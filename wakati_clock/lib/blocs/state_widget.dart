import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class StateWidget extends StatefulWidget {
  final Widget child;

  StateWidget({@required this.child});

  static StateWidgetState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<_StateDataWidget>()
        .data);
  }

  @override
  State<StatefulWidget> createState() => new StateWidgetState();
}

class StateWidgetState extends State<StateWidget> {
  @override
  void dispose() {
    // remove wake lock
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // lock orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // set to full screen mode
    SystemChrome.setEnabledSystemUIOverlays([]);
    // keep device awake
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StateDataWidget oldWidget) => true;
}

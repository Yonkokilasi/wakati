import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakati_clock/objects/state.dart';
import 'package:wakelock/wakelock.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({@required this.child, this.state});

  static StateWidgetState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<_StateDataWidget>()
        .data);
  }

  @override
  State<StatefulWidget> createState() => new StateWidgetState();
}

class StateWidgetState extends State<StateWidget> {
  StateModel state;
  @override
  void dispose() {
    state.dispose();

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

    // keep device awake
    Wakelock.enable();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StateModel>(
      create: (BuildContext context) => StateModel(),
      child: new _StateDataWidget(
        data: this,
        child: widget.child,
      ),
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

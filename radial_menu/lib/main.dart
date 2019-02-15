import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radial_menu/fluttery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildMenu() {
    return IconButton(icon: Icon(Icons.cancel));
  }

  Widget _buildCenterMenu() {
    return AnchoredRadialMenu(
        child: IconButton(
      icon: Icon(Icons.cancel),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          leading: _buildMenu(),
          actions: [_buildMenu()],
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            Align(alignment: Alignment.center, child: _buildCenterMenu()),
            Align(alignment: Alignment.centerLeft, child: _buildMenu()),
            Align(alignment: Alignment.centerRight, child: _buildMenu()),
            Align(alignment: Alignment.bottomLeft, child: _buildMenu()),
            Align(alignment: Alignment.bottomRight, child: _buildMenu()),
          ],
        ));
  }
}

class AnchoredRadialMenu extends StatefulWidget {
  final Widget child;
  final double radius;
  final double startAngle;
  final double endAngle;
  final Function(String menuItemId) onSelected;

  const AnchoredRadialMenu({
    this.child,
    this.radius = 75.0,
    this.startAngle = -pi / 2,
    this.endAngle = 3 * pi / 2,
    this.onSelected,
  });

  @override
  _AnchoredRadialMenuState createState() => _AnchoredRadialMenuState();
}

class _AnchoredRadialMenuState extends State<AnchoredRadialMenu> {
  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return RadialMenu(anchor: anchor, radius: widget.radius);
      },
      child: widget.child,
    );
  }
}

class RadialMenu extends StatefulWidget {
  final Offset anchor;
  final double radius;

  const RadialMenu({this.anchor, this.radius = 75.0});

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  RadialMenuController _menuController;

  static const Color openBubbleColor = const Color(0xFFAAAAAA);
  static const Color expandedBubbleColor = const Color(0xFF666666);

  @override
  void initState() {
    super.initState();
    _menuController = RadialMenuController(vsync: this)
      ..addListener(() => setState(() {}));
    Timer(Duration(seconds: 2), () {
      _menuController.open();
    });
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  Widget buildCenter() {
    IconData icon;
    Color bubbleColor;
    double scale = 1.0;

    switch (_menuController.state) {
      case RadialMenuState.closed:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 0.0;
        break;
      case RadialMenuState.closing:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1.0 - _menuController.progress;
        break;
      case RadialMenuState.opening:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = _menuController.progress;
        break;
      case RadialMenuState.open:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1.0;
        break;
      default:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        break;
    }
    return Transform(
      transform: Matrix4.identity()..scale(scale, scale),
      child: IconBubble(
        diameter: 50,
        icon: icon,
        bubbleColor: bubbleColor,
        iconColor: Colors.black,
      ),
    );
  }

  Widget buildRadialBubble({
    IconData icon,
    Color iconColor,
    Color bubbleColor,
    double angle,
  }) {
    return PolarPosition(
      origin: widget.anchor,
      coord: PolarCoord(-pi / 2, widget.radius),
      child: IconBubble(
        diameter: 50,
        icon: icon,
        bubbleColor: bubbleColor,
        iconColor: iconColor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CenterAbout(position: widget.anchor, child: buildCenter()),
      PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(-pi / 2, widget.radius),
        child: IconBubble(
          diameter: 50,
          icon: Icons.home,
          bubbleColor: Colors.blue,
          iconColor: Colors.white,
        ),
      ),
      PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(-pi / 2 + (1 * 2 * pi / 5), widget.radius),
        child: IconBubble(
          diameter: 50,
          icon: Icons.search,
          bubbleColor: Colors.green,
          iconColor: Colors.white,
        ),
      ),
      PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(-pi / 2 + (2 * 2 * pi / 5), widget.radius),
        child: IconBubble(
          diameter: 50,
          icon: Icons.alarm,
          bubbleColor: Colors.red,
          iconColor: Colors.white,
        ),
      ),
      PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(-pi / 2 + (3 * 2 * pi / 5), widget.radius),
        child: IconBubble(
          diameter: 50,
          icon: Icons.settings,
          bubbleColor: Colors.purple,
          iconColor: Colors.white,
        ),
      ),
      PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(-pi / 2 + (4 * 2 * pi / 5), widget.radius),
        child: IconBubble(
          diameter: 50,
          icon: Icons.location_on,
          bubbleColor: Colors.orange,
          iconColor: Colors.white,
        ),
      ),
      CenterAbout(
          position: widget.anchor,
          child: CustomPaint(
              painter: ActivationPainter(
                  radius: widget.radius,
                  color: Colors.blue,
                  startAngle: -pi / 2,
                  endAngle: -pi / 2,
                  thickness: 50.0)))
    ]);
  }
}

class IconBubble extends StatelessWidget {
  final IconData icon;
  final double diameter;
  final Color iconColor;
  final Color bubbleColor;

  const IconBubble(
      {this.icon, this.diameter, this.iconColor, this.bubbleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bubbleColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
        ));
  }
}

class PolarPosition extends StatelessWidget {
  final Offset origin;
  final PolarCoord coord;
  final Widget child;

  const PolarPosition({this.origin, this.coord, this.child});

  @override
  Widget build(BuildContext context) {
    final radialPosition = Offset(origin.dx + (cos(coord.angle) * coord.radius),
        origin.dy + (sin(coord.angle) * coord.radius));
    return CenterAbout(position: radialPosition, child: child);
  }
}

class ActivationPainter extends CustomPainter {
  final double radius;
  final double thickness;
  final Color color;
  final double startAngle;
  final double endAngle;
  final Paint activationPaint;

  ActivationPainter(
      {this.radius, this.thickness, this.color, this.startAngle, this.endAngle})
      : activationPaint = new Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2),
        startAngle, endAngle - startAngle, false, activationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class RadialMenuController extends ChangeNotifier {
  final AnimationController _progress;
  RadialMenuState _state = RadialMenuState.closed;

  RadialMenuController({
    @required TickerProvider vsync,
  }) : _progress = AnimationController(vsync: vsync) {
    _progress
      ..addListener(_onProgressUpdate)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _onTransitionCompleted();
        }
      });
  }

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onTransitionCompleted() {
    switch (_state) {
      case RadialMenuState.closing:
        _state = RadialMenuState.closed;
        break;
      case RadialMenuState.opening:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.expanding:
        _state = RadialMenuState.expanded;
        break;
      case RadialMenuState.collapsing:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.activating:
        _state = RadialMenuState.dissipating;
        _progress.duration = Duration(milliseconds: 250);
        _progress.forward(from: 0.0);
        break;
      case RadialMenuState.dissipating:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.closed:
      case RadialMenuState.open:
      case RadialMenuState.expanded:
        throw Exception('Invalid state during a transition: $_state');
        break;
    }
    notifyListeners();
  }

  RadialMenuState get state => _state;
  double get progress => _progress.value;

  void open() {
    if (_state == RadialMenuState.closed) {
      _state = RadialMenuState.opening;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void close() {
    if (_state == RadialMenuState.open) {
      _state = RadialMenuState.closing;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void expand() {
    if (_state == RadialMenuState.open) {
      _state = RadialMenuState.expanding;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void collapse() {
    if (_state == RadialMenuState.expanded) {
      _state = RadialMenuState.collapsing;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void activate(String menuItemId) {
    if (_state == RadialMenuState.expanded) {
      _state = RadialMenuState.activating;
      _progress.duration = Duration(milliseconds: 500);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }
}

enum RadialMenuState {
  closed,
  closing,
  opening,
  open,
  expanding,
  collapsing,
  expanded,
  activating,
  dissipating
}

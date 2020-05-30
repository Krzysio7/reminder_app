import 'package:flutter/material.dart';

class IconToggle extends StatefulWidget {
  final bool isActive;
  final Icon active;
  final Icon deactive;
  final Function(bool) onChanged;

  IconToggle(
      {this.isActive = true,
        @required this.active,
        @required this.deactive,
        this.onChanged})
      : assert(isActive != null),
        assert(active != null),
        assert(deactive != null);

  @override
  _IconToggleState createState() => _IconToggleState();
}

class _IconToggleState extends State<IconToggle> {
  bool isActive = false;

  _showIcon() {
    print("showIcon");
    return isActive ? widget.active : widget.deactive;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isActive = widget.isActive;
  }
  /*_toggle() {
    print("toggle");
    setState(() {
      widget.isActive = !widget.isActive;
      if (widget.onChanged != null) widget.onChanged(widget.isActive);
    });
  }*/

  @override
  void didUpdateWidget(IconToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget ${isActive}");
    isActive = !isActive;
    if (widget.onChanged != null) widget.onChanged(isActive);
  }

  @override
  Widget build(BuildContext context) {
    return _showIcon();
  }
}

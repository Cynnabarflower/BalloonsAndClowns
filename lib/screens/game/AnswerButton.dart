import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:psycho_app/custom_widgets/keyboard/Keyboard.dart';

class AnswerButton extends StatefulWidget {
  AssetImage image;
  Color backgroundColor;
  Color shapeColor;
  BoxShape shape;
  Function tapped;
  bool enabled;
  IconData icon;

  @override
  State<StatefulWidget> createState() {
    return _AnswerButtonState();
  }

  AnswerButton(
      {this.image,
        this.icon,
      this.backgroundColor,
      this.shapeColor,
      this.shape,
      this.tapped,
      this.enabled});
}

class _AnswerButtonState extends State<AnswerButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? widget.tapped : ()=>{},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: widget.shape == null ? Container() : Container(
            padding: EdgeInsets.all(32),
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: widget.shapeColor.withOpacity(widget.enabled ? 0.6 : 0.3), shape: widget.shape),
              child: widget.image == null && widget.icon == null ? Container() : LayoutBuilder(
                builder: (context, constraints) =>
                widget.image == null ?
                    Icon(
                      widget.icon,
                      color: widget.backgroundColor,
                      size: min(constraints.maxWidth, constraints.maxHeight),
                    ):
                    Image(
                  width: min(constraints.maxWidth, constraints.maxHeight) * 0.9,
                    height: min(constraints.maxWidth, constraints.maxHeight) * 0.9,
                    color: widget.backgroundColor,
                    fit: BoxFit.fill,
                    image: widget.image),
              ),

          ),
      ),
    );
  }
}

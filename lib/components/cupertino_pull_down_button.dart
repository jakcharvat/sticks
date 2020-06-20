import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CupertinoPullDownButton<T> extends StatefulWidget {
  @override
  _CupertinoPullDownButtonState createState() => _CupertinoPullDownButtonState<T>();

  final List<T> options;
  final T currentOption;
  final void Function(T newValue) onChanged;
  final bool disabled;

  CupertinoPullDownButton({
    @required this.options,
    @required this.currentOption,
    @required this.onChanged,
    this.disabled = false,
  }) :
    assert(options != null && options.isNotEmpty, "Pull down button requires a list of options that is not null"),
    assert(options.contains(currentOption), "currentOption ($currentOption) must always be a member of the options List ($options)");
}

class _CupertinoPullDownButtonState<T> extends State<CupertinoPullDownButton> with SingleTickerProviderStateMixin<CupertinoPullDownButton> {

  bool _frostedGlassEffect = false;
  OverlayEntry _overlayEntry;
  final double _height = 32.0;

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double overlayHeight = (_height * widget.options.length) + 10.0;

    double overlayOffsetTop = widget.options.indexOf(widget.currentOption) * _height + 4.0;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: GestureDetector(
          onTap: () {
            _overlayEntry.remove();
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: offset.dy - overlayOffsetTop,
                    left: offset.dx - 4.0,
                    width: size.width,
                    height: overlayHeight,
                    child: Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: _frostedGlassEffect ? 20.0 : 0.0,
                            sigmaY: _frostedGlassEffect ? 20.0 : 0.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              gradient: LinearGradient(
                                colors: _frostedGlassEffect ? [
                                  _buttonBorderColor.withOpacity(0.1),
                                  _buttonBorderColor.withOpacity(0.3),
                                ] : [
                                  _buttonColor.withOpacity(0.95),
                                  _buttonColor.withOpacity(1.0),
                                ],
                                begin: Alignment(0.5, 0),
                                end: Alignment(0.4, 1)
                              ),
                              border: Border.all(
                                color: _buttonBorderColor.withOpacity(0.5),
                                width: 1.0
                              ),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: widget.options.length + 2,
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0 || index == widget.options.length + 1
                                  ? SizedBox(height: 4.0,)
                                  : _CupertinoPullDownButtonMenuItem(
                                      onItemClicked: () {
                                        widget.onChanged(widget.options[index - 1]);
                                      },
                                      currentOption: widget.options[index - 1],
                                      overlayEntry: _overlayEntry,
                                      isSelected:  widget.options[index - 1] == widget.currentOption,
                                      height: _height,
                                    );
                              },
                            ),
                          )
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            if (!widget.disabled) {
              _overlayEntry = _createOverlayEntry();
              Overlay.of(context).insert(_overlayEntry);
            }
          },
          child: Container(
            height: _height,
            width: 200.0,
            decoration: BoxDecoration(
              color: widget.disabled ? _buttonDisabledColor : _buttonColor,
              border: Border.all(
                color: widget.disabled ? _buttonDisabledColor : _buttonBorderColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 8.0,),
                        Text(
                          "${widget.currentOption}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.disabled ? _buttonDisabledTextColor : Colors.white,
                            fontSize: 17.0,
                            textBaseline: TextBaseline.alphabetic
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 16.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.disabled ? [
                        _buttonDisabledColor,
                        _buttonDisabledColor
                      ] : [
                        _blueButtonArrowBackgroundLightColor,
                        _blueButtonArrowBackgroundDarkColor
                      ],
                      begin: Alignment(0.5, 0),
                      end: Alignment(0.5, 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildUpDownArrows(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }


  List<Widget> _buildUpDownArrows() {
    final arrows = <Widget>[];
    final index = widget.options.indexOf(widget.currentOption);
    final lastIndex = widget.options.length - 1;

    if (index != 0) {
      arrows.add(
        Icon(
          Icons.keyboard_arrow_up,
          size: 11.0,
          color: widget.disabled ? _buttonDisabledTextColor : Colors.white,
        ),
      );
    }

    if (index != lastIndex) {
      arrows.add(
        Icon(
          Icons.keyboard_arrow_down,
          size: 11.0,
          color: widget.disabled ? _buttonDisabledTextColor : Colors.white,
        ),
      );
    }

    return arrows;
  }
}

class _CupertinoPullDownButtonMenuItem extends StatefulWidget {

  final VoidCallback onItemClicked;
  final String currentOption;
  final OverlayEntry overlayEntry;
  final bool isSelected;
  final double height;

  _CupertinoPullDownButtonMenuItem({
    @required this.onItemClicked,
    @required this.currentOption,
    @required this.overlayEntry,
    @required this.height,
    this.isSelected = false,
  });

  @override
  __CupertinoPullDownButtonMenuItemState createState() => __CupertinoPullDownButtonMenuItemState();
}

class __CupertinoPullDownButtonMenuItemState extends State<_CupertinoPullDownButtonMenuItem> {

  bool _shouldBeBlue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: widget.height,
      decoration: BoxDecoration(gradient: LinearGradient(
        colors: _shouldBeBlue ? [
          _blueButtonArrowBackgroundLightColor,
          _blueButtonArrowBackgroundDarkColor,
        ] : [Colors.transparent, Colors.transparent],
        begin: Alignment(1, 0),
        end: Alignment(-1, 1),
      )),
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            SizedBox(width: 36.0, child: widget.isSelected ? Icon(
              Icons.done,
              color: Colors.white,
              size: 20.0,
            ) : Container(),),
            Text(
              "${widget.currentOption}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
            Spacer()
          ],
        ),
        onTap: () async {
          if (!_shouldBeBlue) {
            setState(() {
              _shouldBeBlue = true;
            });

            await Future.delayed(Duration(milliseconds: 100));
          }

          setState(() {
            _shouldBeBlue = false;
          });
          await Future.delayed(Duration(milliseconds: 50));
          setState(() {
            _shouldBeBlue = true;
          });
          await Future.delayed(Duration(milliseconds: 100));

          widget.overlayEntry.remove();

          widget.onItemClicked();
        },
        onHover: (bool isHovered) => setState(() => _shouldBeBlue = isHovered),
      ),
    );
  }
}


const Color _buttonColor = Color(0xFF6b6968);
const Color _buttonBorderColor = Color(0xFF7d7b79);
const Color _buttonDisabledColor = Color(0xFF575450);
const Color _buttonDisabledTextColor = Color(0xFF7f7c7a);
const Color _blueButtonArrowBackgroundLightColor = Color(0xFF3268dd);
const Color _blueButtonArrowBackgroundDarkColor = Color(0xFF2c5dc6);
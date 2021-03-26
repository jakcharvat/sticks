import 'dart:ui' as ui;
import 'dart:math' as Math;

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

  static const String _fontFamily = "Roboto Slab";
  static const bool _frostedGlassEffect = true;
  static const double _height = 32.0;
  OverlayEntry _overlayEntry;

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double overlayOffsetTop = offset.dy - (widget.options.indexOf(widget.currentOption) * _height + 5.0);
    double overlayHeight = (_height * widget.options.length) + 10.0;

    return OverlayEntry(
      builder: (BuildContext context) => _CupertinoPullDownButtonOverlay<T>(
        options: widget.options,
        overlayEntry: _overlayEntry,
        offset: offset,
        overlayOffsetTop: overlayOffsetTop,
        size: size,
        overlayHeight: overlayHeight,
        frostedGlassEffect: _frostedGlassEffect,
        onChanged: widget.onChanged,
        height: _height,
        fontFamily: _fontFamily,
        currentOption: widget.currentOption,
        mediaQuery: MediaQuery.of(context),
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
                            fontFamily: _fontFamily,
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

class _CupertinoPullDownButtonOverlay<T> extends StatefulWidget {

  final List<T> options;
  final OverlayEntry overlayEntry;
  final Offset offset;
  final double overlayOffsetTop;
  final Size size;
  final double overlayHeight;
  final bool frostedGlassEffect;
  final void Function(T newValue) onChanged;
  final double height;
  final String fontFamily;
  final T currentOption;
  final MediaQueryData mediaQuery;

  _CupertinoPullDownButtonOverlay({
    this.options,
    this.overlayEntry,
    this.offset,
    this.overlayOffsetTop,
    this.size,
    this.overlayHeight,
    this.frostedGlassEffect,
    this.onChanged,
    this.height,
    this.fontFamily,
    this.currentOption,
    this.mediaQuery,
  });

  @override
  __CupertinoPullDownButtonOverlayState createState() => __CupertinoPullDownButtonOverlayState<T>();
}

class __CupertinoPullDownButtonOverlayState<T> extends State<_CupertinoPullDownButtonOverlay> {

  ScrollController _scrollController;
  bool _isOpaque = true;

  double _normalizedOffsetTop;
  double _normalizedOverlayHeight;

  int listenerCount = 0;
  double _topPadding = 0;
  double _lastOffset = 0.0;
  bool  _shouldScroll = true;
  
  bool _canExtendUp = false;
  bool _canExtendDown = false;

  VoidCallback get _listener => () {
    _canExtendUp = _normalizedOffsetTop > 8.0;
    
    if (_canExtendUp) {
      setState(() {
        _normalizedOffsetTop -= (_scrollController.offset - _lastOffset);
        _normalizedOverlayHeight += (_scrollController.offset - _lastOffset);

        _topPadding += (_scrollController.offset - _lastOffset);

        _lastOffset = _scrollController.offset;

        if (_scrollController.offset / _scrollController.position.maxScrollExtent == 1) {
          _shouldScroll = false;
        }
      });
    }

    _canExtendDown = _normalizedOffsetTop + _normalizedOverlayHeight < widget.mediaQuery.size.height - 16.0;

    if (_canExtendDown) {
      _normalizedOverlayHeight += (Math.max(0, _lastOffset - _scrollController.offset));

      _lastOffset = _scrollController.offset;

      if (_scrollController.offset / _scrollController.position.maxScrollExtent == 0) {
        _shouldScroll = false;
      }
      setState(() {});
    }

    if (!_canExtendUp && !_canExtendDown) {
      if (_scrollController.offset / _scrollController.position.maxScrollExtent == 1) {
        setState(() {
          _topPadding = 0.0;
        });
      }
    }
  };

  @override
  void initState() {
    _normalizedOffsetTop = Math.max(widget.overlayOffsetTop, 8.0);
    _normalizedOverlayHeight = Math.min(widget.overlayHeight, widget.mediaQuery.size.height - widget.overlayOffsetTop - 8.0) + Math.min(widget.overlayOffsetTop - 8.0, 0);

    _scrollController = ScrollController(initialScrollOffset: widget.overlayOffsetTop > 8.0 ? 0.0 : widget.overlayHeight - _normalizedOverlayHeight);

    super.initState();
    _scrollController.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: _isOpaque ? 1.0 : 0.0,
          child: GestureDetector(
            onTap: () {
              widget.overlayEntry.remove();
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: _normalizedOffsetTop,
                    left: widget.offset.dx - 5.0,
                    width: widget.size.width,
                    height: _normalizedOverlayHeight,
                    child: Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: widget.frostedGlassEffect ? 20.0 : 0.0,
                              sigmaY: widget.frostedGlassEffect ? 20.0 : 0.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                gradient: LinearGradient(
                                    colors: widget.frostedGlassEffect ? [
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
                                physics: _shouldScroll ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: _shouldScroll ? widget.options.length + 3 : widget.options.length + 2,
                                itemBuilder: (BuildContext context, int index) => _buildDropDownItem(index),
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  // TODO: All of this logic is insanely wonky
  Widget _buildDropDownItem(int index) {

    if (index == 0) {
      return SizedBox(height: 4.0 + _topPadding);
    }

    if (_shouldScroll) {
      if (_canExtendUp && index == 1) {
        return Icon(Icons.keyboard_arrow_up, color: Colors.white);
      }

      if (_canExtendDown && index == widget.options.length + 2) {
        return Icon(Icons.keyboard_arrow_down, color: Colors.white);
      }

      if (_canExtendDown && index == widget.options.length + 3) {
        return SizedBox(height: 4.0);
      }
    }

    if (index == widget.options.length + 2) {
      return SizedBox(height: 4.0);
    }

    Widget returnWidget;

    try {
      returnWidget = _CupertinoPullDownButtonMenuItem<T>(
        onItemClicked: () async {
          setState(() {
            _isOpaque = false;
          });
          widget.onChanged(widget.options[_shouldScroll && _canExtendUp ? index - 2 : index - 1]);

          await Future.delayed(Duration(milliseconds: 100));

          widget.overlayEntry.remove();
        },
        currentOption: widget.options[_shouldScroll && _canExtendUp ? index - 2 : index - 1],
        overlayEntry: widget.overlayEntry,
        isSelected:  widget.options[_shouldScroll && _canExtendUp ? index - 2 : index - 1] == widget.currentOption,
        height: widget.height,
        fontFamily: widget.fontFamily,
      );
    } catch (e) {
      print(e);
      print(widget.options.length);
      print(index);
      print(_shouldScroll);
      print(_canExtendUp);

      returnWidget = Container();
    }

    return returnWidget;
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}


class _CupertinoPullDownButtonMenuItem<T> extends StatefulWidget {

  final VoidCallback onItemClicked;
  final T currentOption;
  final OverlayEntry overlayEntry;
  final bool isSelected;
  final double height;
  final String fontFamily;

  _CupertinoPullDownButtonMenuItem({
    @required this.onItemClicked,
    @required this.currentOption,
    @required this.overlayEntry,
    @required this.height,
    this.isSelected = false,
    this.fontFamily,
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
                fontFamily: widget.fontFamily,
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

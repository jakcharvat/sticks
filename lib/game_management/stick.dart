class Stick {
  bool _isHovered = false;
  bool _isRemoved = false;
  bool _isDoubleHovered = false;

  hover(bool shouldBeHovered) {
    if (shouldBeHovered) {
      if (isHovered) {
        _isDoubleHovered = true;
      } else {
        _isHovered = true;
      }
    } else {
      if (_isDoubleHovered) {
        _isDoubleHovered = false;
      } else {
        _isHovered = false;
      }
    }
  }

  remove() {
    _isRemoved = true;
  }

  bool get isRemoved => _isRemoved;
  bool get isHovered => _isHovered;

  @override
  String toString() {
    return _isRemoved ? " " : isHovered ? "H" : "I";
  }
}
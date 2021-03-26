class AlternateStick {
  bool _isHovered = false;
  bool _isRemoved = false;

  hover(bool shouldBeHovered) {
    _isHovered = shouldBeHovered;
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
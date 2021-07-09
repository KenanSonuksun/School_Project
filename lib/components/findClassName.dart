class FindClassName {
  static final FindClassName _findClassName =
      FindClassName._intializerFunction();

  String _className;
  int _index;

  String get className => _className;
  int get index => _index;

  void setClassName(String value) {
    _className = value;
  }

  void setIndex(int value) {
    _index = value;
  }

  factory FindClassName() {
    return _findClassName;
  }

  FindClassName._intializerFunction() {
    print("initialized");
  }
}

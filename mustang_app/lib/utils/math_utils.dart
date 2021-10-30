class MathUtils {
  static int roundUp(int n) {
    bool isNegative = n < 0;

    return isNegative ? -(((n.abs() + 4) ~/ 5) * 5) : (((n + 4) ~/ 5) * 5);
  }

  static int roundDown(int n) {
    bool isNegative = n < 0;

    return isNegative ? roundUp(n) : (((n) ~/ 5) * 5);
  }
}

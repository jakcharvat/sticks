import 'dart:math' as Math;

class Binary {

  final List<int> _binaryList = [];
  int decimal;

  Binary(this.decimal) {

    if (decimal == 0) {
      _binaryList.add(0);
      return;
    }

    // This whole thing converts the number into a binary array of 0s and 1s

    int firstIndex = Math.pow(2, (Math.log(decimal) / Math.log(2)).floor());

    _binaryList.add(1);
    bool shouldContinue = true;
    int index = firstIndex;
    int currentNumber = decimal - firstIndex;

    while (shouldContinue) {
      index = (index / 2).floor();

      if (index == 0) {
        shouldContinue = false;
        continue;
      }

      if (currentNumber >= index) {
        _binaryList.add(1);
        currentNumber = currentNumber - index;
      } else {
        _binaryList.add(0);
      }
    }
  }

  Binary.fromList(List<int> list) {
    list.forEach((bit) => _binaryList.add(bit));
  }

  List<int> get asList => _binaryList;

  int operator [](int index) {
    double inverseArrayIndex = Math.log(index) / Math.log(2);

    if (inverseArrayIndex != inverseArrayIndex.floor()) {
      throw("Binary [] operator was provided an illegal index. You must provide a number representing "
          "a binary digit value. The offending index is $index. Two closest legal indices are "
          "${Math.pow(2, inverseArrayIndex.floor())} and ${Math.pow(2, inverseArrayIndex.floor() + 1)}");
    }

    int arrayIndex = _binaryList.length - inverseArrayIndex.floor() - 1;
    int bit;
    try {
      bit = _binaryList[arrayIndex];
    } catch (_) {
      bit = 0;
    }

    return bit;
  }

  bool get isEven {
    bool isEven = true;

    _binaryList.forEach((int bit) {
      if (bit % 2 == 1) {
        isEven = false;
      }
    });

    return isEven;
  }

  Binary operator +(Binary otherBinary) {
    List<int> original = _binaryList;
    List<int> other = otherBinary.asList;

    int higherLength = Math.max(original.length, other.length);

    List<int> result = List.generate(higherLength, (int index) {
      int originalArrayIndex = original.length - higherLength + index;
      int otherArrayIndex = other.length - higherLength + index;

      int number = 0;

      if (originalArrayIndex >= 0) {
        number += original[originalArrayIndex];
      }
      if (otherArrayIndex >= 0) {
        number += other[otherArrayIndex];
      }

      return number;
    });

    return Binary.fromList(result);
  }

  int get asInt {
    int total = 0;
    _binaryList.asMap().forEach((index, bit) {
      if (bit == 1 && total != null) {
        int exponent = _binaryList.length - index - 1;
        total += Math.pow(2, exponent);
      } else if (bit != 0) {
        total = null;
      }
    });

    return total;
  }

  @override
  String toString() {
    String binaryString = "";

    _binaryList.asMap().forEach((int index, int bit) {
      binaryString += "${index == 0 ? "" : " "}$bit";
    });

    return binaryString;
  }
}
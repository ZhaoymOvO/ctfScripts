import 'dart:math';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

void main(List<String> args) {
  // String result;
  var n = 98554799767;
  for (int i = 2; i < sqrt(n); i++) {
    if (n % i == 0) {
      var factor1 = i;
      var factor2 = n ~/ i;
      print("factor1: $factor1, factor2: $factor2");
      // result = "$factor1$factor2";
      break;
    }
  }
  // result = md5.convert(utf8.encode(result)).toString();
  // print(result);
}

import 'dart:io';
import 'dart:typed_data';
import 'package:fast_gbk/fast_gbk.dart';

class QuWeiDecoder {
  /// 將 4 位數字符串的區位碼解碼為漢字
  /// 例如輸入 "1601" 返回 "啊"
  static String? decode(String quweiCode) {
    // 1. 基本驗證：長度必須為 4
    if (quweiCode.length != 4) {
      print('錯誤：區位碼長度必須為 4 位');
      return null;
    }

    try {
      // 2. 解析區號和位號
      int qu = int.parse(quweiCode.substring(0, 2));
      int wei = int.parse(quweiCode.substring(2, 4));

      // 3. 驗證範圍 (區和位通常在 01-94 之間)
      if (qu < 1 || qu > 94 || wei < 1 || wei > 94) {
        print('錯誤：區號或位號超出範圍 (01-94)');
        return null;
      }

      // 4. 計算 GBK 字節
      // GB2312 規定：高字節 = 區號 + 0xA0，低字節 = 位號 + 0xA0
      int highByte = qu + 0xA0;
      int lowByte = wei + 0xA0;

      // 5. 使用 fast_gbk 進行解碼
      List<int> bytes = [highByte, lowByte];

      // Uint8List 是處理字節流的標準格式
      return gbk.decode(Uint8List.fromList(bytes));
    } catch (e) {
      print('解碼發生錯誤: $e');
      return null;
    }
  }
}

void main() {
  List<String> quweiCodeList = [];
  while (true) {
    stdout.write('input qu wei code> ');
    String userInput = stdin.readLineSync() ?? '';
    if (userInput == '') {
      print('[e] input was empty');
      continue;
    } else if (userInput == 'r') {
      break;
    } else if (userInput.length != 4) {
      print('[e] wrong input length');
      continue;
    }
    int qu = int.parse(userInput.substring(0, 2));
    int wei = int.parse(userInput.substring(2, 4));
    if (qu < 1 || qu > 94 || wei < 1 || wei > 94) {
      print('[e] wrong input range');
      continue;
    } else {
      quweiCodeList.add(userInput);
    }
  }
  for (String quweiCode in quweiCodeList) {
    String? decodedChar = QuWeiDecoder.decode(quweiCode);
    if (decodedChar != null) {
      print('$quweiCode -> $decodedChar');
    }
  }
}

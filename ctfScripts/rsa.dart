import 'dart:convert';
import 'dart:io';

// 輔助函數：讀取輸入並轉為 BigInt (處理去空和錯誤)
BigInt readInput(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? line = stdin.readLineSync();
    if (line != null && line.trim().isNotEmpty) {
      try {
        // 去除可能的冒號或空格
        String cleanLine = line.replaceAll(':', '').replaceAll(' ', '').trim();
        return BigInt.parse(cleanLine);
      } catch (e) {
        print("輸入格式錯誤，請輸入整數。");
      }
    }
  }
}

class RSAEngine {
  late BigInt n;
  late BigInt e;
  late BigInt d;

  RSAEngine(BigInt p, BigInt q, this.e) {
    n = p * q;
    BigInt phi = (p - BigInt.one) * (q - BigInt.one);
    try {
      d = e.modInverse(phi);
    } catch (err) {
      throw Exception('無效的 e 值。');
    }
    print("--- RSA 初始化完成 ---");
    print("n (模數): $n");
    print("d (私鑰): $d");
    print("----------------------");
  }

  BigInt encrypt(BigInt message) => message.modPow(e, n);
  BigInt decrypt(BigInt cipher) => cipher.modPow(d, n);

  // --- 改進後的解密顯示邏輯 ---
  void decryptAndPrint(BigInt cipher) {
    BigInt m = decrypt(cipher);

    // 1. 打印原始十進制 (有時候 flag 就是這個數字)
    print('\n[Decrypted Result]');
    print('Decimal: $m');

    List<int> bytes = _bigIntToBytes(m);

    // 2. 打印 Hex 十六進制 (CTF 常見格式)
    String hexString = bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join('');
    print('Hex    : 0x$hexString');

    // 3. 嘗試解析為 UTF-8 字符串
    try {
      String text = utf8.decode(bytes);
      print('String : $text');
    } catch (e) {
      print('String : (無法解碼為有效的 UTF-8 文本)');
      // 如果不是 UTF-8，有可能是 ASCII 但包含不可見字符，嘗試寬鬆解碼
      String asciiAttempt = bytes
          .map((b) => (b >= 32 && b <= 126) ? String.fromCharCode(b) : '.')
          .join('');
      print('ASCII Dump: $asciiAttempt');
    }
  }

  // 將字節列表轉換為 BigInt
  // 修正點：這裡的返回類型必須是 BigInt
  // BigInt _bytesToBigInt(List<int> bytes) {
  //   BigInt result = BigInt.zero;
  //   for (var byte in bytes) {
  //     result = (result << 8) | BigInt.from(byte);
  //   }
  //   return result;
  // }

  List<int> _bigIntToBytes(BigInt number) {
    if (number == BigInt.zero) return [0];
    List<int> bytes = [];
    BigInt temp = number;
    while (temp > BigInt.zero) {
      bytes.add((temp & BigInt.from(0xFF)).toInt());
      temp = temp >> 8;
    }
    return bytes.reversed.toList();
  }
}

void main() {
  try {
    // 這裡使用 readInput 處理輸入
    BigInt p = readInput('p> ');
    BigInt q = readInput('q> ');
    BigInt e = readInput('e> ');

    RSAEngine rsa = RSAEngine(p, q, e);

    while (true) {
      stdout.write('\nmode (e/d)> ');
      String? mode = stdin.readLineSync();

      if (mode?.trim().toLowerCase() == 'e') {
        BigInt m = readInput('m (decimal)> ');
        BigInt c = rsa.encrypt(m);
        print('c = $c');
      } else if (mode?.trim().toLowerCase() == 'd') {
        BigInt c = readInput('c (decimal)> ');
        // 改用新的安全打印方法
        rsa.decryptAndPrint(c);
      }
    }
  } catch (e) {
    print("發生錯誤: $e");
  }
}

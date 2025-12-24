import 'dart:io';

// 輔助函數：讀取輸入
BigInt readInput(String label) {
  stdout.write('$label: ');
  String? input = stdin.readLineSync();
  if (input != null && input.isNotEmpty) {
    try {
      return BigInt.parse(input);
    } catch (e) {
      print('輸入錯誤，請輸入整數。');
      exit(1);
    }
  }
  return BigInt.zero;
}

void main() {
  print('--- RSA Key Finder (Find d) ---');

  // 1. 獲取輸入 P, Q, E
  // 根據你的題目：
  // P = 473398607161
  // Q = 4511491
  // E = 17
  BigInt p = readInput('Enter P');
  BigInt q = readInput('Enter Q');
  BigInt e = readInput('Enter e');

  // 2. 計算必要的變數
  BigInt n = p * q;
  BigInt phi = (p - BigInt.one) * (q - BigInt.one); // 歐拉函數 φ(n)

  print('\n-----------------------------------');
  print('n = $n');
  print('phi(n) = $phi');
  print('e = $e');
  print('-----------------------------------\n');

  // 3. 計算 d (私鑰指數)
  // d 是 e 在模 phi 下的乘法反元素
  // 數學公式: (d * e) % phi == 1
  try {
    BigInt d = e.modInverse(phi);

    print('===================================');
    print('私鑰 d (你的 Flag):');
    print(d);
    print('===================================');
  } catch (exception) {
    print("錯誤: 無法計算 d。請確認 e 和 phi(n) 是否互質 (gcd(e, phi) 必須為 1)。");
  }
}

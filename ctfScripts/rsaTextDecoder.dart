import 'dart:convert';

void main() {
  // --- 1. Define Parameters from the image ---
  final String pStr =
      "9648423029010515676590551740010426534945737639235739800643989352039852507298491399561035009163427050370107570733633350911691280297777160200625281665378483";
  final String qStr =
      "11874843837980297032092405848653656852760910154543380907650040190704283358909208578251063047732443992230647903887510065547947313543299303261986053486569407";
  final String cStr =
      "83208298995174604174773590298203639360540024871256126892889661345742403314929861939100492666605647316646576486526217457006376842280869728581726746401583705899941768214138742259689334840735633553053887641847651173776251820293087212885670180367406807406765923638973161375817392737747832762751690104423869019034";
  final int eInt = 65537;

  // --- 2. Parse into BigInt ---
  BigInt p = BigInt.parse(pStr);
  BigInt q = BigInt.parse(qStr);
  BigInt c = BigInt.parse(cStr);
  BigInt e = BigInt.from(eInt);

  // --- 3. Perform RSA Decryption ---

  // Calculate n (Modulus)
  BigInt n = p * q;

  // Calculate phi(n) = (p-1)*(q-1)
  BigInt phi = (p - BigInt.one) * (q - BigInt.one);

  // Calculate d (Private Key)
  // d = modular inverse of e mod phi
  BigInt d = e.modInverse(phi);

  // Decrypt the message
  // m = c^d mod n
  BigInt m = c.modPow(d, n);

  print("Decrypted Integer: $m");

  // --- 4. Convert BigInt to String ---
  try {
    String message = bigIntToString(m);
    print("--------------------------------------------------");
    print("SECRET MESSAGE:");
    print(message);
    print("--------------------------------------------------");
  } catch (e) {
    print("Error decoding message: $e");
  }
}

// Helper function to convert a BigInt to a UTF-8 string
String bigIntToString(BigInt input) {
  // Convert to hex string first
  String hex = input.toRadixString(16);

  // Add leading zero if length is odd
  if (hex.length % 2 != 0) {
    hex = '0$hex';
  }

  // Convert hex pairs to integer bytes
  List<int> bytes = [];
  for (int i = 0; i < hex.length; i += 2) {
    String part = hex.substring(i, i + 2);
    bytes.add(int.parse(part, radix: 16));
  }

  // Decode bytes to string
  return utf8.decode(bytes);
}

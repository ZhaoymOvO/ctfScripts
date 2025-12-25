"""
RSA Key Pair Utility Module for CTF Challenges

This module provides a class to manage and calculate various components of
the RSA cryptosystem, including private/public keys and CRT parameters.
"""

import gmpy2
import libnum
# import Crypto


class rsaKeyPair:
    """
    A class to represent and calculate RSA key pair components.

    Attributes:
        p (int): The first prime factor.
        q (int): The second prime factor.
        e (int): Public exponent.
        n (int): Modulus (p * q).
        d (int): Private exponent.
        phiN (int): Euler's totient function of n.
        dp (int): CRT exponent for p (d mod (p-1)).
        dq (int): CRT exponent for q (d mod (q-1)).
    """

    p: int | None = None
    q: int | None = None
    e: int | None = None
    n: int | None = None
    d: int | None = None
    phiN: int | None = None
    dp: int | None = None
    dq: int | None = None

    def stat(self) -> dict[str, int | None]:
        """
        Return the current state of all RSA parameters.

        Returns:
            dict[str, int | None]: A dictionary containing p, q, e, n, d, phiN, dp, and dq.
        """
        return {
            "p": self.p,
            "q": self.q,
            "e": self.e,
            "n": self.n,
            "d": self.d,
            "phiN": self.phiN,
            "dp": self.dp,
            "dq": self.dq,
        }

    def setP(self, p: int):
        """
        set self.p

        Args:
            p (int): self.p
        """
        self.p = p

    def setQ(self, q: int):
        """
        set self.q

        Args:
            q (int): self.q
        """
        self.q = q

    def setE(self, e: int):
        """
        set self.e

        Args:
            e (int): self.e
        """
        self.e = e

    def setN(self, n: int):
        """
        set self.n

        Args:
            n (int): self.n
        """
        self.n = n

    def setDp(self, dp: int):
        """
        set self.dp

        Args:
            dp (int): self.dp
        """
        self.dp = dp

    def setDq(self, dq: int):
        """
        set self.dq

        Args:
            dq (int): self.dq
        """
        self.dq = dq

    def calculateEFromDpAndDq(self):
        """
        Calculate the public exponent e using dp, dq, and the primes.

        Raises:
        ValueError: If dp or dq is not set.

        Note: This is an unusual recovery method based on CRT properties.
        """
        if not ((self.dp and self.p) or (self.dq and self.q)):
            raise ValueError("Need (dp and p) OR (dq and q) to calculate e")

        # 尝试从 p 侧恢复 e
        if self.dp and self.p:
            try:
                # e * dp = 1 mod (p-1) => e = invert(dp, p-1)
                self.e = int(gmpy2.invert(self.dp, self.p - 1))
            except ZeroDivisionError as e:
                raise ValueError("d_p is not invertible mod (p-1)") from e

        # 如果 p 侧不行，尝试从 q 侧恢复，或者用于校验
        elif self.dq and self.q:
            try:
                self.e = int(gmpy2.invert(self.dq, self.q - 1))
            except ZeroDivisionError as e:
                raise ValueError("d_q is not invertible mod (q-1)") from e

        # 如果 p 和 q 都在，计算 n
        if self.p and self.q:
            self.n = self.p * self.q

    def caculatePQFromENDp(self):
        """
        caculate p and q from e, n and dp

        Raises:
            ValueError: when e, n and/or dp are/is not set
            ValueError: when cannot found p and q
        """
        if not self.e or not self.n or not self.dp:
            raise ValueError("e, n, dp are required")
        e, n, dp = self.e, self.n, self.dp
        p: int | None = None
        q: int | None = None
        for k in range(1, e):
            if (dp * e - 1) % k == 0:
                pCandidate = (dp * e - 1) // k + 1
                if n % pCandidate == 0:
                    p = pCandidate
                    q = n // p
                    break
        if q:
            self.p = p
            self.q = q
        else:
            raise ValueError("cannot found p and q")

    def calculateKeyPair(self):
        """
        Calculate all remaining RSA parameters (n, phiN, d, dp, dq)
        based on the currently set p, q, and e.

        Raises:
            ValueError: If the public exponent e has not been set.
        """
        if not self.e:
            raise ValueError("e is not set")
        if not self.p or not self.q:
            raise ValueError("p or q is not set")

        self.n = self.p * self.q
        self.phiN = (self.p - 1) * (self.q - 1)

        try:
            self.d = int(gmpy2.invert(self.e, self.phiN))
        except ZeroDivisionError as e:
            raise ZeroDivisionError(
                f"e ({self.e}) is not coprime to phiN, modular inverse does not exist."
            ) from e

        self.dp = int(gmpy2.invert(self.e, self.p - 1))
        self.dq = int(gmpy2.invert(self.e, self.q - 1))

    def encrypt(self, msg: int) -> int:
        """
        encrypt message

        Args:
            msg (int): message to encrypt

        Raises:
            ValueError: if e and/or n is/are not set

        Returns:
            int: encrypted message
        """
        if not self.e or not self.n:
            raise ValueError("e and n are required for encryption")
        return int(gmpy2.powmod(msg, self.e, self.n))

    def decrypt(self, msg: int) -> int:
        """
        decrypt message

        Args:
            msg (int): message to decrypt

        Raises:
            ValueError: when d and n not set

        Returns:
            int: decrypted message
        """
        if not self.d or not self.n:
            raise ValueError("d and n are required for decryption")
        return int(gmpy2.powmod(msg, self.d, self.n))

    def decryptToString(self, msg: int) -> str:
        """
        decrypt message and convert to string

        Args:
            msg (int): message to decrypt

        Raises:
            ValueError: when d and n not set

        Returns:
            str: decrypted message
        """
        return str(libnum.n2s(self.decrypt(msg)))


if __name__ == "__main__":
    key = rsaKeyPair()
    helpText = """h -> str                print help text
bye                     exit program
p <p:int>               set prime p
q <q:int>               set prime q
e <e:int>               set public exponent
n <n:int>               set n
dp <dp:int>             set dp
dq <dq:int>             set dq
s -> dict               print all parameters
ce                      calculate e from dp and dq
ck                      calculate n, phiN, d, dp, dq
cpq                     calculate p, q from e, n, dp
enc <msg:int> -> int    encrypt msg
dec <msg:int> -> int    decrypt msg
dec2s <msg:int> -> str  decrypt msg to string"""
    while 1:
        userInput = input("rsa tool> ").lower().strip().split()
        mode = userInput[0] if len(userInput) > 0 else None
        arg = int(userInput[1]) if len(userInput) > 1 else None
        if not mode:
            continue
        try:
            match mode:
                case "bye":
                    break
                case "h":
                    print(helpText)
                case "p":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setP(arg)
                case "q":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setQ(arg)
                case "e":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setE(arg)
                case "n":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setN(arg)
                case "dp":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setDp(arg)
                case "dq":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    key.setDq(arg)
                case "s":
                    print(key.stat())
                case "ce":
                    key.calculateEFromDpAndDq()
                case "ck":
                    key.calculateKeyPair()
                case "cpq":
                    key.caculatePQFromENDp()
                case "enc":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    print(key.encrypt(arg))
                case "dec":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    print("\n" + str(key.decrypt(arg)))
                case "dec2s":
                    if not arg:
                        print("[!] missing argument")
                        continue
                    print(key.decryptToString(arg))
                case _:
                    print("[!] unknown command")
        except ValueError as e:
            print(f"[!] {e}")
        except ZeroDivisionError as e:
            print(f"[!] {e}")

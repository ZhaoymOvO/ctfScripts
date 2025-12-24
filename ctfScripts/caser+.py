import sys

# encryptedString = "afZ_r9VYfScOeO_UL^RWUc"
encryptedString = "MTHJ{CUBCGXGUGXWREXIPOYAOEYFIGXWRXCHTKHFCOHCFDUCGTXZOHIXOEOWMEHZO}"
encryptedString = encryptedString.lower()
sys.stdout.writelines(encryptedString)
sys.stdout.write("\n")
for i in range(len(encryptedString)):
    sys.stdout.write(f"{ord(encryptedString[i])}, ")
sys.stdout.write("\n\n")
for i in "flag{":
    sys.stdout.write(f"{ord(i)}, ")
# sys.stdout.write("\n")
# for i in range(len(encryptedString)):
#     sys.stdout.write(f"{chr(ord(encryptedString[i])+i+5)}")


print('640E11012805F211B0AB24FF02A1ED09'.lower())

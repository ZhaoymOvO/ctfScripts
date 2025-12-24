import sys

text = "61666374667B317327745F73305F333435797D"
for i in range(0, len(text), 2):
    sys.stdout.write(chr(int(text[i : i + 2], 16)))
sys.stdout.write("\n")
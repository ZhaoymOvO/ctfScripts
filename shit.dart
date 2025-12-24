import 'dart:io';

class IronMan {
  void state1() {
    print('   囧');
    print('口 ◻  口');
    print('   ◻ ');
  }

  void state2() {
    print('   囧');
    print(' ◻ 口 ◻');
    print('   口 ');
  }

  void cleanUp() {
    stdout.write('\x1b[A\x1b[K\x1b[A\x1b[K\x1b[A\x1b[K');
  }

  void fxxk([int delay = 200]) {
    while (true) {
      state1();
      sleep(Duration(milliseconds: 500));
      cleanUp();
      state2();
      sleep(Duration(milliseconds: 500));
      cleanUp();
    }
  }
}

void main() {
  IronMan ironMan = IronMan();
  ironMan.fxxk();
}

#import('dart:html');

// branch s00a

class MagicBoxes {

  MagicBoxes() {
  }

  void run() {
    write("Hello World!");
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new MagicBoxes().run();
}

import 'dart:html';

import 'package:model_concepts/model_concepts.dart';

// See the style guide: http://www.dartlang.org/articles/style-guide/ .

// See the basics canvas tutorial: http://dev.opera.com/articles/view/html-5-canvas-the-basics/ .
// See the canvas painting tutorial: http://dev.opera.com/articles/view/html5-canvas-painting/ .

// For debugging use print() and CTRL+SHIFT+J to open the console in Chrome.

void main() {
  // Get a reference to the canvas.
  CanvasElement canvas = document.querySelector('#canvas') as CanvasElement;
  Board board = new Board(canvas);
}

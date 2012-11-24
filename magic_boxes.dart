library magic_boxes;

import 'dart:html';
import 'dart:isolate';
import 'dart:json';

part 'box.dart';
part 'board.dart';
part 'tool_bar.dart';
part 'line.dart';
part 'menu_bar.dart';
part 'item.dart';
part 'json_panel.dart';
part 'png_panel.dart';

// See the style guide: http://www.dartlang.org/articles/style-guide/ .

// See the basics canvas tutorial: http://dev.opera.com/articles/view/html-5-canvas-the-basics/ .
// See the canvas painting tutorial: http://dev.opera.com/articles/view/html5-canvas-painting/ .

// For debugging use print() and CTRL+SHIFT+J to open the console in Chrome.

void main() {
  // Get a reference to the canvas.
  CanvasElement canvas = document.query('#canvas');
  Board board = new Board(canvas);
}

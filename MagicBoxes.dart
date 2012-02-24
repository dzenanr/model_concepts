#import('dart:html');
#source('Box.dart');
#source('Board.dart');

// branch s01a

// See the style guide: http://www.dartlang.org/articles/style-guide/.

void main() {
  // Get a reference to the canvas.
  CanvasElement canvas = document.query('#canvas');
  Board board = new Board(canvas);
}

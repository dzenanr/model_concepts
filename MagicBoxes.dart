#import('dart:html');
#source('Box.dart');
#source('Board.dart');

// branch s03a

// See the style guide: http://www.dartlang.org/articles/style-guide/.
// See the canvas tutorial: http://dev.opera.com/articles/view/html5-canvas-painting/

void main() {
  // Get a reference to the canvas.
  CanvasElement canvas = document.query('#canvas');
  Board board = new Board(canvas);
}

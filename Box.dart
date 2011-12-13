class Box {
  
  Board board;
  
  int x;
  int y;
  int width;
  int height;
  
  Box(this.board, this.x, this.y, this.width, this.height) {
    draw();
    document.on.mouseMove.add(onMouseMove);
  }
  
  void draw() {
    board.context.beginPath();
    board.context.rect(x, y, width, height);
    board.context.closePath();
    board.context.stroke();
  }
  
  bool isPointInside(int px, int py) {
    if ((px > x && px < x + width) && (py > y && py < y + height))
      return true;
  }
  
  // Change a position of the box with mouse mouvements.  
  void onMouseMove(MouseEvent event) {
    if (isPointInside(event.offsetX, event.offsetY)) {
      x = event.offsetX - width / 2;
      if (x < 0) x = 1;
      if (x > board.width - width) x = board.width - width - 1;
      y = event.offsetY - height / 2;
      if (y < 0) y = 1;
      if (y > board.height - height) y = board.height - height - 1;
    }
  }

}

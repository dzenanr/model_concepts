class Box {
  
  Board board;
  
  int x;
  int y;
  int width;
  int height;
  
  Box(this.board, this.x, this.y, this.width, this.height) {
    draw();
  }
  
  void draw() {
    board.context.beginPath();
    board.context.rect(x, y, width, height);
    board.context.closePath();
    board.context.stroke();
  }

}

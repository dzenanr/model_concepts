class Line {
  
  final Board board;
  
  Box box1;
  Box box2;
  
  Line(this.board, this.box1, this.box2) {
    draw();
  }
  
  void draw() {
    board.context.beginPath();
    board.context.moveTo(box1.x + box1.width / 2, box1.y + box1.height / 2);
    board.context.lineTo(box2.x + box2.width / 2, box2.y + box2.height / 2);
    board.context.stroke();
    board.context.closePath();
  }

}

class Box {
  
  static final SSS = 6; // selection square size
  
  final Board board;
  
  int x;
  int y;
  int width;
  int height;
  
  bool selected = false;
  
  Box(this.board, this.x, this.y, this.width, this.height) {
    draw();
    document.on.mouseDown.add(onMouseDown);
    document.on.mouseUp.add(onMouseUp);
    document.on.mouseMove.add(onMouseMove);
  }
  
  void draw() {
    board.context.beginPath();
    board.context.rect(x, y, width, height);
    if (isSelected()) {
      board.context.rect(x, y, SSS, SSS);
      board.context.rect(x + width - SSS, y, SSS, SSS);
      board.context.rect(x + width - SSS, y + height - SSS, SSS, SSS);
      board.context.rect(x, y + height - SSS, SSS, SSS);
    } 
    board.context.stroke();
    board.context.closePath();
  }
  
  void select() {
    selected = true;
  }
  
  void deselect() {
    selected = false;
  }
  
  void toggleSelection() {
    selected = !selected;
  }
  
  bool isSelected() {
    return selected;
  }
  
  bool contains(int px, int py) {
    if ((px >= x && px <= x + width) && (py >= y && py <= y + height)) return true;
  }
  
  void onMouseDown(MouseEvent event) {
    // if (contains(event.offsetX, event.offsetY)) toggleSelection();
  }
  
  void onMouseUp(MouseEvent event) {
    if (contains(event.offsetX, event.offsetY)) toggleSelection();
  }
  
  // Change a position of the box with mouse mouvements.  
  void onMouseMove(MouseEvent event) {
    if (isSelected() && contains(event.offsetX, event.offsetY)) {
      x = event.offsetX - width / 2;
      if (x < 0) x = 1;
      if (x > board.width - width) x = board.width - width - 1;
      y = event.offsetY - height / 2;
      if (y < 0) y = 1;
      if (y > board.height - height) y = board.height - height - 1;
    }
  }

}

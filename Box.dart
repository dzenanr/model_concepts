class Box {
  
  static final SSS = 6; // selection square size
  static final TBH = 20; // title box height
  static final TOS = 4; // text offset size
  static final IOS = TBH - TOS; // item offset size
  
  final Board board;
  
  int x;
  int y;
  int width;
  int height;
  
  String textFontSize = 12;
  String title = "Box";
  int titleNo;
  String item = "Item";
  
  // bool default is false.
  bool _selected; 
  bool _mouseDown; 
  
  Box(this.board, this.x, this.y, this.width, this.height) {
    titleNo = board.nextBoxNo;
    draw();
    document.on.mouseDown.add(onMouseDown);
    document.on.mouseUp.add(onMouseUp);
    document.on.mouseMove.add(onMouseMove);
  }
  
  void draw() {
    board.context.beginPath();
    board.context.rect(x, y, width, height);
    board.context.moveTo(x, y + TBH);
    board.context.lineTo(x + width, y + TBH);
    board.context.font = "bold " + textFontSize + "px sans-serif";
    board.context.textAlign = "start";
    board.context.textBaseline = "top";
    // board.context.fillText(title + " " + titleNo, x + TOS, y + TOS, width - TOS);
    board.context.fillText(toString(), x + TOS, y + TOS, width - TOS);
    board.context.fillText(item + 1, x + TOS, y + TOS + TBH, width - TOS);
    board.context.fillText(item + 2, x + TOS, y + TOS + TBH + IOS, width - TOS);
    board.context.fillText(item + 3, x + TOS, y + TOS + TBH + 2 * IOS, width - TOS);
    board.context.fillText(item + 4, x + TOS, y + TOS + TBH + 3 * IOS, width - TOS);
    if (isSelected()) {
      board.context.rect(x, y, SSS, SSS);
      board.context.rect(x + width - SSS, y, SSS, SSS);
      board.context.rect(x + width - SSS, y + height - SSS, SSS, SSS);
      board.context.rect(x, y + height - SSS, SSS, SSS);
    } 
    board.context.stroke();
    board.context.closePath();
  }
  
  select() => _selected = true;
  deselect() => _selected = false;
  toggleSelection() => _selected = !_selected;
  bool isSelected() => _selected;
  
  String toString() => '$title$titleNo ($x, $y)';
  
  bool contains(int px, int py) {
    if ((px > x && px < x + width) && (py > y && py < y + height)) return true;
  }
  
  void onMouseDown(MouseEvent event) {
    if (contains(event.offsetX, event.offsetY)) toggleSelection();
    _mouseDown = true;
  }
  
  void onMouseUp(MouseEvent event) {
    _mouseDown = false;
  }
  
  // Change a position of the box with mouse mouvements.  
  void onMouseMove(MouseEvent event) {
    int ex = event.offsetX; 
    int ey = event.offsetY;
    // if (contains(ex, ey) && isSelected() && mouseDown) {
    if (contains(ex, ey) && isSelected() && _mouseDown && board.countSelectedBoxesThatContain(ex, ey) < 2) {
      x =  ex - width / 2;
      if (x < 0) x = 1;
      if (x > board.width - width) x = board.width - width - 1;
      y = ey - height / 2;
      if (y < 0) y = 1;
      if (y > board.height - height) y = board.height - height - 1;
    }
  }

}

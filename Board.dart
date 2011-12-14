class Board {
  
  final int INTERVAL = 8; // ms
  
  int width;
  int height;
  
  CanvasRenderingContext2D context;
  
  List<Box> boxes;
  
  Board(CanvasElement canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    border();
    boxes = new List();
    document.on.mouseDown.add(onMouseDown);
    // Redraw every INTERVAL ms.
    document.window.setInterval(redraw, INTERVAL);
  }
  
  void border() {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.closePath();
    context.stroke();
  }
  
  void clear() {
    context.clearRect(0, 0, width, height);
    border();
  } 
  
  void redraw() {
    clear(); 
    for (Box box in boxes) {
      box.draw();
    }
  }
  
  /*
  int get nextBoxNo() {
    return boxes.length + 1;
  }
  */
  int get nextBoxNo() => boxes.length + 1;
  
  int countSelectedBoxesThatContain(int px, int py) {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected() && box.contains(px, py)) count++;
    }
    return count;
  }
  
  // Create a box in the position of the mouse click on the board, but not on an existing box.
  void onMouseDown(MouseEvent event) {
    Box box = new Box(this, event.offsetX, event.offsetY, 100, 100);
    bool clickedOnExistingBox = false; 
    for (Box box in boxes) {
      if (box.contains(event.offsetX, event.offsetY)) {
        clickedOnExistingBox = true;
        break;
      }
    }
    if (!clickedOnExistingBox) {
      if (event.offsetX + box.width > width) box.x = width - box.width - 1;
      if (event.offsetY + box.height > height) box.y = height - box.height - 1;
      boxes.add(box);
    }
  }

}

class Board {
  
  final int INTERVAL = 10; // ms
  
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
  
  // Create a box in the position of the mouse click on the board, but not on an existing box.
  void onMouseDown(MouseEvent event) {
    Box box = new Box(this, event.offsetX, event.offsetY, 60, 100);
    bool clickedOnExistingBox = false;
    for (Box box in boxes) {
      if (box.contains(event.offsetX, event.offsetY)) {
        clickedOnExistingBox = true;
        break;
      }
    }
    if (!clickedOnExistingBox) {
      if (event.offsetX + box.width > width) box.x = width - box.width;
      if (event.offsetY + box.height > height) box.y = height - box.height;
      boxes.add(box);
    }
  }

}

class Board {
  
  final int INTERVAL = 8; // ms
  
  CanvasRenderingContext2D context;
  
  int width;
  int height;
  
  List<Box> boxes;
  ToolBar toolBar;
  
  Board(CanvasElement canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    border();
 
    boxes = new List();
    toolBar = new ToolBar(this);
    
    // Canvas event.
    document.query('#canvas').on.mouseDown.add(onMouseDown);
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
  
  void createBoxes(int n) {
    int x = 0; int y = 0;
    for (int i = 0; i < n; i++) {  
      boxes.add(new Box(this, x, y, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT));
      x = x + Box.DEFAULT_WIDTH;
      y = y + Box.DEFAULT_HEIGHT;
    }
  }
  
  void deleteBoxes() {
    boxes.clear();
  }
  
  void selectBoxes() {
    for (Box box in boxes) {
      box.select();
    }
  }
  
  void deselectBoxes() {
    for (Box box in boxes) {
      box.deselect();
    }
  }
  
  int get nextBoxNo() => boxes.length + 1;
  
  int countSelectedBoxesContain(int pointX, int pointY) {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected() && box.contains(pointX, pointY)) {
        count++;
      }
    }
    return count;
  }
  
  // Create a box in the position of the mouse click on the board, but not on an existing box.
  void onMouseDown(MouseEvent e) {
    bool clickedOnBox = false; 
    for (Box box in boxes) {
      if (box.contains(e.offsetX, e.offsetY)) {
        clickedOnBox = true;
        break;
      }
    }
    
    if (toolBar.isSelectToolOn()) {
      if (!clickedOnBox) {
        deselectBoxes();
      }
    } else if (toolBar.isBoxToolOn()) {
      if (!clickedOnBox) {
        Box box = new Box(this, e.offsetX, e.offsetY, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        if (e.offsetX + box.width > width) {
          box.x = width - box.width - 1;
        }
        if (e.offsetY + box.height > height) {
          box.y = height - box.height - 1;
        }
        boxes.add(box);
        toolBar.selectToolOn();
      }
    } 
  }

}

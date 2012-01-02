class Board {
  
  // The acceptable delta error in pixels for clicking on a line between two boxes.
  static final int DELTA = 8; 
  // The board is redrawn every INTERVAL ms.
  static final int INTERVAL = 8; 
  
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  
  int width;
  int height;
  
  List<Box> boxes;
  List<Line> lines;
  
  Box beforeLastBoxClicked;
  Box lastBoxClicked;
  Box lastBoxSelected;
  Line lastLineSelected;
  
  MenuBar menuBar; 
  ToolBar toolBar;
  
  num defaultLineWidth;
  
  Board(this.canvas) {
    context = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    defaultLineWidth = context.lineWidth;
    border();
 
    boxes = new List();
    lines = new List();
    
    menuBar = new MenuBar(this);
    toolBar = new ToolBar(this);
    
    // Canvas event.
    document.query('#canvas').on.mouseDown.add(onMouseDown);
    // Redraw every INTERVAL ms.
    document.window.setInterval(redraw, INTERVAL);
  }
  
  void border() {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.setLineWidth(defaultLineWidth);
    context.stroke();
    context.closePath();
  }
  
  void clear() {
    context.clearRect(0, 0, width, height);
    border();
  } 
  
  void redraw() {
    clear(); 
    for (Line line in lines) {
      line.draw();
    }
    for (Box box in boxes) {
      box.draw();
    }
  }
  
  void printBoxNames() {
    for (Box box in boxes) {
      print(box.title);
    }
  }
  
  void saveAsPng() {
    ImageElement modelImage = document.query('#modelImage');
    modelImage.src = canvas.toDataURL("image/png");
  }
  
  void createBoxesInDiagonal() {
    int x = 0; int y = 0;
    while (true) {
      if (x <= width - Box.DEFAULT_WIDTH && y <= height - Box.DEFAULT_HEIGHT) {
        Box box = new Box(this, x, y, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        boxes.add(box);
        x = x + Box.DEFAULT_WIDTH;
        y = y + Box.DEFAULT_HEIGHT;
      } else {
        return;
      }
    }
  }
  
  void createBoxesAsTiles() {
    int x = 0; int y = 0;
    while (true) {
      if (x <= width - Box.DEFAULT_WIDTH) {
        Box box = new Box(this, x, y, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        boxes.add(box);
        x = x + Box.DEFAULT_WIDTH * 2;
      } else {
        x = 0;
        y = y + Box.DEFAULT_HEIGHT * 2;
        if (y > height - Box.DEFAULT_HEIGHT) {
          return;
        }
      }
    }
  }
  
  void deleteBoxes() {
    boxes.clear();
  }
  
  void deleteLines() {
    lines.clear();
  }
  
  void delete() {
    deleteLines();
    deleteBoxes();
    toolBar.backToSelectAsFixedTool();
  }
  
  void deleteBox(Box boxToDelete) {
    for (Box box in boxes) {
      if (box == boxToDelete) {
        int index = boxes.indexOf(box, 0);
        boxes.removeRange(index, 1);
        if (box == beforeLastBoxClicked) {
          beforeLastBoxClicked == null;
        } else if (box == lastBoxClicked) {
          lastBoxClicked == null;
        }
        return;
      }
    }
  }
  
  void deleteLine(Line lineToDelete) {
    for (Line line in lines) {
      if (line == lineToDelete) {
        int index = lines.indexOf(line, 0);
        lines.removeRange(index, 1);
        return;
      }
    }
  }
  
  void deleteSelectedBoxes() {
    if (countSelectedBoxes() == 0) {
      return;
    }
    for (Box box in boxes) {
      if (box.isSelected()) {
        deleteBox(box);
      }
    }
    deleteSelectedBoxes();
  }
  
  void deleteSelectedLines() {
    if (countSelectedLines() == 0) {
      return;
    }
    for (Line line in lines) {
      if (line.isSelected()) {
        deleteLine(line);
      }
    }
    deleteSelectedLines();
  }
  
  void deleteSelection() {
    deleteSelectedLines();
    deleteSelectedBoxes();
    if (isEmpty()) {
      toolBar.backToSelectAsFixedTool();
    }
  }
  
  bool isEmpty() {
    if (boxes.length == 0 && lines.length == 0) {
      return true;
    }
    return false;
  }
  
  void selectBoxes() {
    for (Box box in boxes) {
      box.select();
    }
  }
  
  void selectLines() {
    for (Line line in lines) {
      line.select();
    }
  }
  
  void select() {
    selectBoxes();
    selectLines();
  }
  
  void deselectBoxes() {
    for (Box box in boxes) {
      box.deselect();
    }
  }
  
  void deselectLines() {
    for (Line line in lines) {
      line.deselect();
    }
  }
  
  void deselect() {
    deselectBoxes();
    deselectLines();
  }
  
  void increaseHeightOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.height = box.height + Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void decreaseHeightOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.height = box.height - Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void increaseWidthOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.width = box.width + Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void decreaseWidthOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.width = box.width - Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void increaseSizeOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.height = box.height + Box.DEFAULT_INCREMENT;
        box.width = box.width + Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void decreaseSizeOfSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.height = box.height - Box.DEFAULT_INCREMENT;
        box.width = box.width - Box.DEFAULT_INCREMENT;
      }
    }
  }
  
  void hideSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.hide();
      }
    }
  }
  
  void hideSelectedLines() {
    for (Line line in lines) {
      if (line.isSelected()) {
        line.hide();
      }
    }
  }
  
  void hideSelection() {
    hideSelectedBoxes();
    hideSelectedLines();
  }
  
  void showHiddenBoxes() {
    for (Box box in boxes) {
      if (box.isHidden()) {
        box.show();
      }
    }
  }
  
  void showHiddenLines() {
    for (Line line in lines) {
      if (line.isHidden()) {
        line.show();
      }
    }
  }
  
  void showHiddenSelection() {
    showHiddenBoxes();
    showHiddenLines();
  }
  
  int countSelectedBoxes() {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected()) {
        count++;
      }
    }
    return count;
  }
  
  int countSelectedLines() {
    int count = 0;
    for (Line line in lines) {
      if (line.isSelected()) {
        count++;
      }
    }
    return count;
  }
  
  int countSelectedBoxesContain(int pointX, int pointY) {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected() && box.contains(pointX, pointY)) {
        count++;
      }
    }
    return count;
  }
  
  int countSelectedLinesContain(int pointX, int pointY) {
    Point delta = new Point(DELTA, DELTA);
    int count = 0;
    for (Line line in lines) {
      if (line.isSelected() && line.contains(new Point(pointX, pointY), delta)) {
        count++;
      }
    }
    return count;
  }
  
  Line _lineContains(Point point) {
    Point delta = new Point(DELTA, DELTA);
    for (Line line in lines) {
      if (line.contains(point, delta)) {
        return line;
      }
    }
  }
  
  bool _boxExists(Box box) {
    for (Box b in boxes) {
      if (b == box) {
        return true;
      }
    }
    return false;
  }
  
  void onMouseDown(MouseEvent e) {
    bool clickedOnBox = false; 
    for (Box box in boxes) {
      if (box.contains(e.offsetX, e.offsetY)) {
        // Clicked on the existing box.
        clickedOnBox = true;
        break;
      }
    }
    
    if (!clickedOnBox) {
      if (toolBar.isSelectToolOn()) {
        Point clickedPoint = new Point(e.offsetX, e.offsetY);
        Line line = _lineContains(clickedPoint);
        if (line != null) {
          // Select or deselect the existing line.
          line.toggleSelection();
        } else {
          // Deselect all.
          deselect();
        }
      } else if (toolBar.isBoxToolOn()) {
        // Create a box in the position of the mouse click on the board, but not on an existing box.
        Box box = new Box(this, e.offsetX, e.offsetY, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        if (e.offsetX + box.width > width) {
          box.x = width - box.width - 1;
        }
        if (e.offsetY + box.height > height) {
          box.y = height - box.height - 1;
        }
        boxes.add(box);
      } else if (toolBar.isLineToolOn()) {
        // Create a line between the last two clicked boxes.
        if (beforeLastBoxClicked != null && lastBoxClicked != null && 
            _boxExists(beforeLastBoxClicked) && _boxExists(lastBoxClicked)) {  
          Line line = new Line(this, beforeLastBoxClicked, lastBoxClicked);
          lines.add(line);
        }
      }
      toolBar.backToFixedTool();
    }
  }

}

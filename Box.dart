class Box {
  
  static final int DEFAULT_WIDTH = 120;
  static final int DEFAULT_HEIGHT = 120;
  static final int DEFAULT_INCREMENT = 20;
  
  static final int SSS = 6; // selection square size
  static final int TBH = 20; // title box height
  static final int TOS = 4; // text offset size
  static final int IOS = TBH - TOS; // item offset size
  
  final Board board;
  
  String _name = '';
  bool entry = false;
  int x;
  int y;
  int width;
  int height;
  
  List<Item> items;
  
  bool _selected = false;
  bool _hidden = false;
  bool _mouseDown = false;
  
  Box(this.board, this.x, this.y, this.width, this.height) {
    items = new List();
    
    draw();
    // Box events (actually, canvas events).
    document.query('#canvas').on.mouseDown.add(onMouseDown);
    document.query('#canvas').on.mouseUp.add(onMouseUp);
    document.query('#canvas').on.mouseMove.add(onMouseMove);
  }
  
  void draw() {
    if (!isHidden()) {
      board.context.beginPath();
      board.context.clearRect(x, y, width, height);
      board.context.rect(x, y, width, height);
      board.context.moveTo(x, y + TBH);
      board.context.lineTo(x + width, y + TBH);
      board.context.font = 'bold ' + Board.DEFAULT_FONT_SIZE + 'px sans-serif';
      board.context.textAlign = 'start';
      board.context.textBaseline = 'top';
      if (entry) {
        board.context.fillText('|| ' + title, x + TOS, y + TOS, width - TOS);
      } else {
        board.context.fillText(title, x + TOS, y + TOS, width - TOS);
      }
      sortItemsBySequence();
      int i = 0;
      for (Item item in items) {
        if (item.category == 'attribute') {
          board.context.font = 
            '' + Board.DEFAULT_FONT_SIZE + 'px sans-serif';
          board.context.fillText(item.name, x + TOS, y + TOS + TBH + i * IOS, 
            width - TOS);
        } else if (item.category == 'guid') {
          board.context.font = 
            'italic ' + Board.DEFAULT_FONT_SIZE + 'px sans-serif';
          board.context.fillText(item.name, x + TOS, y + TOS + TBH + i * IOS, 
            width - TOS);
        } else if (item.category == 'identifier') {
          board.context.font = 
            'bold italic ' + Board.DEFAULT_FONT_SIZE + 'px sans-serif';
          board.context.fillText(item.name, x + TOS, y + TOS + TBH + i * IOS, 
            width - TOS);
        } else if (item.category == 'required') {
          board.context.font = 
            'bold ' + Board.DEFAULT_FONT_SIZE + 'px sans-serif';
          board.context.fillText(item.name, x + TOS, y + TOS + TBH + i * IOS, 
            width - TOS);
        }
        i++;
      }
      if (isSelected()) {
        board.context.rect(x, y, SSS, SSS);
        board.context.rect(x + width - SSS, y, SSS, SSS);
        board.context.rect(x + width - SSS, y + height - SSS, SSS, SSS);
        board.context.rect(x, y + height - SSS, SSS, SSS);
      } 
      board.context.lineWidth = Board.DEFAULT_LINE_WIDTH;
      board.context.strokeStyle = Board.DEFAULT_LINE_COLOR;
      
      board.context.stroke();
      board.context.closePath();
    }
  }
  
  void select() {
    _selected = true;
    board.lastBoxSelected = this;
    board.toolBar.bringSelectedBox();
  }
  
  void deselect() {
    _selected = false;
    board.lastBoxSelected = null;
  }
  
  void toggleSelection() { 
    if (isSelected()) {
      deselect();
    } else {
      select();
    }
  }
  
  bool isSelected() => _selected;
  
  hide() => _hidden = true;
  show() => _hidden = false;
  bool isHidden() => _hidden;
  
  void set title(String name) {
    _name = name;
  }
  
  String get title() {
    return _name;
  }
  
  Map<String, Object> toJson() {
    Map<String, Object> boxMap = new Map<String, Object>();
    boxMap["name"] = title;
    boxMap["entry"] = entry;
    boxMap["x"] = x;
    boxMap["y"] = y;
    boxMap["width"] = width;
    boxMap["height"] = height;
    boxMap["items"] = itemsToJson();
    return boxMap;
  }
  
  List<Map<String, Object>> itemsToJson() {
    List<Map<String, Object>> itemsList = new List<Map<String, Object>>();
    for (Item item in items) {
      itemsList.add(item.toJson());
    }
    return itemsList;
  }
  
  int findLastItemSequence() {
    if (items.isEmpty()) {
      return 0;
    } else {
      Item item = items.last();
      return item.sequence;
    }
  }
  
  Item findItem(String name) {
    for (Item item in items) {
      if (item.name == name) {
        return item;
      }
    }
    return null;
  }
  
  Item findFirstItem() {
    if (items.isEmpty()) {
      return null;
    } else {
      return items[0];
    }
  }
  
  Item findPreviousItem(Item currentItem) {
    sortItemsBySequence();
    for (Item item in items) {
      if (item == currentItem) {
        int ix = items.indexOf(item, 0);
        if (ix > 0) {
          return items[ix - 1];
        } 
      }
    }
    return null;
  } 
  
  Item findNextItem(Item currentItem) {
    sortItemsBySequence();
    for (Item item in items) {
      if (item == currentItem) {
        int ix = items.indexOf(item, 0);
        if (ix < items.length - 1) {
          return items[ix + 1];
        } 
      }
    }
    return null;
  } 
  
  bool removeItem(Item item) {
    if (item != null) {
      int index = items.indexOf(item, 0);
      if (index >= 0) {
        items.removeRange(index, 1);
        return true;
      }
    }
    return false;
  } 
  
  void sortItemsBySequence() {
    items.sort(compare(Item i1, Item i2) {
      if (i1.sequence == i2.sequence) {
        return 0;
      } else if (i1.sequence > i2.sequence) {
        return 1;
      } else {
        return -1;
      }
    });
  }
  
  String toString() => '$title ($x, $y)';
  
  Point center() {
    int centerX = x + width / 2;
    int centerY = y + height / 2;
    return new Point(centerX, centerY);
  }
  
  Point twin1() {
    int twinX = x + width / 4;
    int twinY = y + height / 4;
    return new Point(twinX, twinY);
  }
  
  Point twin2() {
    int twinX = x + (width / 4) * 3;
    int twinY = y + (height / 4) * 3;
    return new Point(twinX, twinY);
  }
  
  Point reflexive1() {
    int reflexiveX = x;
    int reflexiveY = y - height / 2;
    return new Point(reflexiveX, reflexiveY);
  }
  
  Point reflexive2() {
    int reflexiveX = x + width;
    int reflexiveY = y - height / 2;
    return new Point(reflexiveX, reflexiveY);
  }
  
  bool contains(int pointX, int pointY) {
    if ((pointX > x && pointX < x + width) && (pointY > y && pointY < y + height)) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Return the intersection point of the line between the begin <x1,y1> 
   * and end <x2,y2> points with this box;
   * <x1,y1> is inside the box, <x2,y2> may be inside or outside. 
   * Fast algorithm.
   */
  Point getIntersectionPoint(Point lineBeginPoint, Point lineEndPoint) {
    int x1 = lineBeginPoint.x;
    int y1 = lineBeginPoint.y;
    int x2 = lineEndPoint.x;
    int y2 = lineEndPoint.y;
    if (x2 == x1) /* vertical line */
      return new Point(x2, (y2 < y1 ? this.y : this.y + this.height));
    if (y2 == y1) /* horizontal line */
      return new Point((x2 < x1 ? this.x : this.x + this.width), y2);

    double m = (y2 - y1) / (x2 - x1);
    int x = (x2 < x1 ? this.x : this.x + this.width);
    double fy = m * (x - x2) + y2;
    int y;
    /* float comparison, because fy may be bigger than the biggest integer */
    if (fy >= this.y && fy <= this.y + this.height) {
      y = fy.toInt();
    } else {
      y = (y2 < y1 ? this.y : this.y + this.height);
      x = ((fy - y2) / m).toInt() + x2;
    }
    return new Point(x, y);
  }
  
  void onMouseDown(MouseEvent e) {
    _mouseDown = true;
    if (board.toolBar.isSelectToolOn() && contains(e.offsetX, e.offsetY)) {
      toggleSelection();
    }
    if (contains(e.offsetX, e.offsetY)) {
      if (board.lastBoxClicked != null && board.lastBoxClicked != this) {
        board.beforeLastBoxClicked = board.lastBoxClicked;
      }
      board.lastBoxClicked = this;
    }
  }
  
  void onMouseUp(MouseEvent e) {
    _mouseDown = false;
  }
  
  /** Change a position of the box with mouse mouvements. */
  void onMouseMove(MouseEvent e) {
    if (contains(e.offsetX, e.offsetY) && _mouseDown && 
        board.countBoxesContain(e.offsetX, e.offsetY) < 2) {
      x =  e.offsetX - width / 2;
      if (x < 0) {
        x = 1;
      }
      if (x > board.width - width) {
        x = board.width - width - 1;
      }
      y = e.offsetY - height / 2;
      if (y < 0) {
        y = 1;
      }
      if (y > board.height - height) {
        y = board.height - height - 1;
      }
    }
  }

}

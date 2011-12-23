class Line {
  
  final Board board;
  
  Box box1;
  Box box2;
  
  bool _selected = false;
  bool _hidden = false;
  
  num defaultLineWidth;
  
  Line(this.board, this.box1, this.box2) {
    draw();
    // Line event (actually, canvas event).
    defaultLineWidth = board.context.lineWidth;
    draw();
  }
  
  void draw() {
    if (!isHidden()) {
      board.context.beginPath();
      board.context.moveTo(box1.x + box1.width / 2, box1.y + box1.height / 2);
      board.context.lineTo(box2.x + box2.width / 2, box2.y + box2.height / 2);
      if (isSelected()) {
        board.context.setLineWidth(defaultLineWidth + 2);
      } else {
        board.context.setLineWidth(defaultLineWidth);
      }
      board.context.stroke();
      board.context.closePath();
    }
  }
  
  select() => _selected = true;
  deselect() => _selected = false;
  toggleSelection() => _selected = !_selected;
  bool isSelected() => _selected;
  
  hide() => _hidden = true;
  show() => _hidden = false;
  bool isHidden() => _hidden;
  
  /**
   * Returns true if the point is on the line (between centers of the two boxes)
   * with the error of delta in pixels.
   */
  bool contains(Point point, Point delta) {
    if (box1.contains(point.x, point.y) || box2.contains(point.x, point.y)) {
      return false;
    }
    
    Point pointDif = new Point(0, 0);
    bool inLineRectX, inLineRectY, inLineRect;
    double coord;
    
    Point beginPoint = box1.center();
    Point endPoint = box2.center();
    
    pointDif.x = endPoint.x - beginPoint.x;
    pointDif.y = endPoint.y - beginPoint.y;
    
    // Rapid test: Verify if the point is in the line rectangle.
    if (pointDif.x > 0) {
      inLineRectX = (point.x >= (beginPoint.x - delta.x)) && (point.x <= (endPoint.x + delta.x));
    } else {
      inLineRectX = (point.x >= (endPoint.x - delta.x)) && (point.x <= (beginPoint.x + delta.x));
    }
    if (pointDif.y > 0) {
      inLineRectY = (point.y >= (beginPoint.y - delta.y)) && (point.y <= (endPoint.y + delta.y));
    } else {
      inLineRectY = (point.y >= (endPoint.y - delta.y)) && (point.y <= (beginPoint.y + delta.y));
    }
    inLineRect = inLineRectX && inLineRectY;
    if (!inLineRect) {
      return false;
    }
    
    // If the line is horizontal or vertical there is no need to continue.
    if ((pointDif.x == 0) || (pointDif.y == 0)) {
        return true;
    }
    
    if (pointDif.x.abs() > pointDif.y.abs()) {
      coord = beginPoint.y + (((point.x - beginPoint.x) * pointDif.y) / pointDif.x) - point.y;
      return coord.abs() <= delta.y;
    } else {
      coord = beginPoint.x + (((point.y - beginPoint.y) * pointDif.x) / pointDif.y) - point.x;
      return coord.abs() <= delta.x;
    }
  }

}

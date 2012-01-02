class Line {
  
  final Board board;
  
  Box box1; // line begin box
  Box box2; // line end box
  
  String box1box2Name; // name from box1 to box2
  String box1box2Min; // min cardinality from box1 to box2
  String box1box2Max; // max cardinality from box1 to box2
  bool box1box2Id; // id from box1 to box2 
  
  String box2box1Name; // name from box2 to box1
  String box2box1Min; // min cardinality from box2 to box1
  String box2box1Max; // max cardinality from box2 to box1
  bool box2box1Id; // id from box2 to box1 
  
  bool _selected = false;
  bool _hidden = false;
  
  String textFontSize = 12;
  num defaultLineWidth;
  
  Line(this.board, this.box1, this.box2) {
    box1box2Name = '';
    box1box2Min = '0';
    box1box2Max = 'N';
    box1box2Id = false;
    box2box1Name = '';
    box2box1Min = '1';
    box2box1Max = '1';
    box2box1Id = false;
    draw();
    // Line event (actually, canvas event).
    defaultLineWidth = board.context.lineWidth;
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
      Point box1box2MinMaxPoint = calculateMinMaxPointCloseToBeginBox(box1, box2);
      Point box2box1MinMaxPoint = calculateMinMaxPointCloseToBeginBox(box2, box1);
      Point box1box2NamePoint = calculateNamePointCloseToBeginBox(box1, box2);
      Point box2box1NamePoint = calculateNamePointCloseToBeginBox(box2, box1);
      String box1box2MinMax = box1box2Min + '..' + box1box2Max;
      String box2box1MinMax = box2box1Min + '..' + box2box1Max;
      if (box1box2Id) {
        board.context.font = 'bold italic ' + textFontSize + 'px sans-serif';
      } else if (box1box2Min != '0') {
        board.context.font = 'bold ' + textFontSize + 'px sans-serif';
      } else {
        board.context.font = '' + textFontSize + 'px sans-serif';
      }
      board.context.fillText(box1box2MinMax, box1box2MinMaxPoint.x, box1box2MinMaxPoint.y);
      board.context.fillText(box1box2Name, box1box2NamePoint.x, box1box2NamePoint.y);
      if (box2box1Id) {
        board.context.font = 'bold italic ' + textFontSize + 'px sans-serif';
      } else if (box2box1Min != '0') {
        board.context.font = 'bold ' + textFontSize + 'px sans-serif';
      } else {
        board.context.font = '' + textFontSize + 'px sans-serif';
      }
      board.context.fillText(box2box1MinMax, box2box1MinMaxPoint.x, box2box1MinMaxPoint.y);
      board.context.fillText(box2box1Name, box2box1NamePoint.x, box2box1NamePoint.y);
      board.context.stroke();
      board.context.closePath();
    }
  }
  
  void select() {
    _selected = true;
    board.lastLineSelected = this;
  }
  
  void deselect() {
    _selected = false;
    board.lastLineSelected = null;
  }
  
  void toggleSelection() { 
    _selected = !_selected;
    if (_selected) {
      board.lastLineSelected = this;
    } else {
      board.lastLineSelected = null;
    }
  }
  
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
  
  Point calculateMinMaxPointCloseToBeginBox(Box beginBox, Box endBox) {
    int x = 0;
    int y = 0;
    
    Point lineBeginPoint = beginBox.center();
    Point lineEndPoint = endBox.center();
    Point beginPoint = beginBox.getIntersectionPoint(lineBeginPoint, lineEndPoint);
    Point endPoint = endBox.getIntersectionPoint(lineEndPoint, lineBeginPoint);
    
    int x1 = beginPoint.x;
    int y1 = beginPoint.y;
    int x2 = endPoint.x;
    int y2 = endPoint.y;
    
    if (x1 <= x2) {
      x = x1 + 1 * ((x2 - x1) / 8);
      if (y1 <= y2) {
        y = y1 + 1 * ((y2 - y1) / 8);
      } else {
        y = y2 + 7 * ((y1 - y2) / 8);
      }
    } else {
      x = x2 + 7 * ((x1 - x2) / 8);
      if (y1 <= y2) {
        y = y1 + 1 * ((y2 - y1) / 8);
      } else {
        y = y2 + 7 * ((y1 - y2) / 8);
      }
    }
    return new Point(x, y);
  }
  
  Point calculateNamePointCloseToBeginBox(Box beginBox, Box endBox) {
    int x = 0;
    int y = 0;
    
    Point lineBeginPoint = beginBox.center();
    Point lineEndPoint = endBox.center();
    Point beginPoint = beginBox.getIntersectionPoint(lineBeginPoint, lineEndPoint);
    Point endPoint = endBox.getIntersectionPoint(lineEndPoint, lineBeginPoint);
    
    int x1 = beginPoint.x;
    int y1 = beginPoint.y;
    int x2 = endPoint.x;
    int y2 = endPoint.y;
    
    if (x1 <= x2) {
      x = x1 + 3 * ((x2 - x1) / 8);
      if (y1 <= y2) {
          y = y1 + 3 * ((y2 - y1) / 8);
      } else {
          y = y2 + 5 * ((y1 - y2) / 8);
      }
    } else {
      x = x2 + 5 * ((x1 - x2) / 8);
      if (y1 <= y2) {
          y = y1 + 3 * ((y2 - y1) / 8);
      } else {
          y = y2 + 5 * ((y1 - y2) / 8);
      }
    }
    return new Point(x, y);
  }

}

part of magic_boxes;

class Line {

  final Board board;

  Box box1; // line begin box
  Box box2; // line end box

  String _category; // relationship, inheritance, reflexive, twin
  bool internal = true;

  bool _twin1 = false;
  bool _twin2 = false;

  String box1box2Name = ''; // name from box1 to box2
  String box1box2Min; // min cardinality from box1 to box2
  String box1box2Max; // max cardinality from box1 to box2
  bool box1box2Id; // id from box1 to box2

  String box2box1Name = ''; // name from box2 to box1
  String box2box1Min; // min cardinality from box2 to box1
  String box2box1Max; // max cardinality from box2 to box1
  bool box2box1Id; // id from box2 to box1

  bool _selected = false;
  bool _hidden = false;

  Line(this.board, this.box1, this.box2) {
    category = 'relationship';
    draw();
    select();
  }

  void draw() {
    if (!isHidden()) {
      board.context.beginPath();
      if (twin1) {
        board.context.moveTo(box1.twin1().x, box1.twin1().y);
        board.context.lineTo(box2.twin1().x, box2.twin1().y);
      } else if (twin2) {
        board.context.moveTo(box1.twin2().x, box1.twin2().y);
        board.context.lineTo(box2.twin2().x, box2.twin2().y);
      } else if (reflexive) {
        board.context.moveTo(box1.center().x, box1.center().y);
        board.context.lineTo(box1.reflexive1().x, box2.reflexive1().y);
        board.context.lineTo(box1.reflexive2().x, box2.reflexive2().y);
        board.context.lineTo(box1.center().x, box2.center().y);
      } else {
        board.context.moveTo(box1.center().x, box1.center().y);
        board.context.lineTo(box2.center().x, box2.center().y);
      }
      Point box1box2MinMaxPoint;
      Point box2box1MinMaxPoint;
      Point box1box2NamePoint;
      Point box2box1NamePoint;
      if (reflexive) {
        box1box2MinMaxPoint = calculateMinMaxPoint1(box1);
        box2box1MinMaxPoint = calculateMinMaxPoint2(box1);
        box1box2NamePoint = calculateNamePoint1(box1);
        box2box1NamePoint = calculateNamePoint2(box1);
      } else {
        box1box2MinMaxPoint = calculateMinMaxPointCloseToBeginBox(box1, box2);
        box2box1MinMaxPoint = calculateMinMaxPointCloseToBeginBox(box2, box1);
        box1box2NamePoint = calculateNamePointCloseToBeginBox(box1, box2);
        box2box1NamePoint = calculateNamePointCloseToBeginBox(box2, box1);
      }

      String box1box2MinMax = '$box1box2Min..$box1box2Max';
      String box2box1MinMax = '$box2box1Min..$box2box1Max';
      int dfs = Board.DEFAULT_FONT_SIZE;
      if (box1box2Id) {
        board.context.font = 'bold italic ${dfs}px sans-serif';
      } else if (box1box2Min != '0') {
        board.context.font = 'bold ${dfs}px sans-serif';
      } else {
        board.context.font = '${dfs}px sans-serif';
      }
      board.context.fillText(box1box2MinMax, box1box2MinMaxPoint.x,
        box1box2MinMaxPoint.y);
      board.context.fillText(box1box2Name, box1box2NamePoint.x,
        box1box2NamePoint.y);
      if (box2box1Id) {
        board.context.font = 'bold italic ${dfs}px sans-serif';
      } else if (box2box1Min != '0') {
        board.context.font = 'bold ${dfs}px sans-serif';
      } else {
        board.context.font = '${dfs}px sans-serif';
      }
      board.context.fillText(box2box1MinMax, box2box1MinMaxPoint.x,
        box2box1MinMaxPoint.y);
      board.context.fillText(box2box1Name, box2box1NamePoint.x,
        box2box1NamePoint.y);

      if (!internal) {
        board.context.strokeStyle = Board.SOFT_LINE_COLOR;
      } else {
        board.context.strokeStyle = Board.DEFAULT_LINE_COLOR;
      }
      if (isSelected()) {
        board.context.lineWidth = Board.DEFAULT_LINE_WIDTH + 2;
        board.context.strokeStyle = Board.SELECTION_COLOR;
      } else {
        board.context.lineWidth = Board.DEFAULT_LINE_WIDTH;
      }

      board.context.stroke();
      board.context.closePath();
    }
  }

  void set category(String category) {
    _category = category;
    if (category == 'relationship') {
      box1box2Name = '';
      box1box2Min = '0';
      box1box2Max = 'N';
      box1box2Id = false;

      box2box1Name = '';
      box2box1Min = '1';
      box2box1Max = '1';
      box2box1Id = false;

      _twin1 = false;
      _twin2 = false;
    } else if (category == 'inheritance') {
      box1box2Name = 'as';
      box1box2Min = '0';
      box1box2Max = '1';
      box1box2Id = false;

      box2box1Name = 'is';
      box2box1Min = '1';
      box2box1Max = '1';
      box2box1Id = true;

      _twin1 = false;
      _twin2 = false;
    } else if (category == 'reflexive') {
      box2 = box1;
      internal = true;

      box1box2Name = _putInEnglishPlural(box1.title.toLowerCase());
      box1box2Min = '0';
      box1box2Max = 'N';
      box1box2Id = false;

      box2box1Name = box1.title.toLowerCase();
      box2box1Min = '0';
      box2box1Max = '1';
      box2box1Id = false;

      _twin1 = false;
      _twin2 = false;
    }  else if (category == 'twin') {
      Line twinLine = board.findTwinLine(this);
      if (twinLine != null) {
        if (twinLine.twin) {
          _twin1 = false;
          _twin2 = true;
          twinLine.twin1 = true;
          twinLine.twin2 = false;
        } else {
          _twin1 = true;
          _twin2 = false;
          twinLine.twin1 = false;
          twinLine.twin2 = true;
          twinLine._category = 'twin';
          twinLine.internal = false;
        }
      }
    }
  }

  String get category => _category;

  bool get relationship => category == 'relationship';
  bool get inheritance => category == 'inheritance';
  bool get reflexive => category == 'reflexive';
  bool get twin => category == 'twin';

  void set twin1(bool twin1) {
    _twin1 = twin1;
  }

  bool get twin1 => _twin1;

  void set twin2(bool twin2) {
    _twin2 = twin2;
  }

  bool get twin2 => _twin2;

  Map<String, Object> toJson() {
    Map<String, Object> lineMap = new Map<String, Object>();
    lineMap["box1Name"] = box1.title;
    lineMap["box2Name"] = box2.title;
    lineMap["category"] = category;
    lineMap["internal"] = internal;

    lineMap["box1box2Name"] = box1box2Name;
    lineMap["box1box2Min"] = box1box2Min;
    lineMap["box1box2Max"] = box1box2Max;
    lineMap["box1box2Id"] = box1box2Id;

    lineMap["box2box1Name"] = box2box1Name;
    lineMap["box2box1Min"] = box2box1Min;
    lineMap["box2box1Max"] = box2box1Max;
    lineMap["box2box1Id"] = box2box1Id;

    return lineMap;
  }

  void select() {
    _selected = true;
    board.lastLineSelected = this;
    board.toolBar.bringSelectedLine();
  }

  void deselect() {
    _selected = false;
    board.lastLineSelected = null;
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

  String _putInEnglishPlural(String text) {
    String plural = null;
    try {
      if (text.length > 0) {
        String lastCharacterString = text.substring(text.length - 1,
            text.length);
        if (lastCharacterString == 'x') {
          plural = '${text}es';
        } else if (lastCharacterString == 'z') {
          plural = '${text}zes';
        } else if (lastCharacterString == 'y') {
          String withoutLast = _dropEnd(text, lastCharacterString);
          plural = '${withoutLast}ies';
        } else {
          plural = '${text}s';
        }
      }
    } on Exception catch (e) {
      return text;
    }
    return plural;
  }

  String _dropEnd(String text, String end) {
    String withoutEnd = text;
    int endPosition = text.lastIndexOf(end);
    if (endPosition > 0) {
      // Drop the end.
      withoutEnd = text.substring(0, endPosition);
    }
    return withoutEnd;
  }

  /**
   * Returns true if the point is on the line (between centers of the two boxes)
   * with the error of delta in pixels.
   */
  bool contains(Point point, Point delta) {
    if (box1.contains(point.x.toInt(), point.y.toInt()) || box2.contains(point.x.toInt(), point.y.toInt())) {
      return false;
    }

    num pointDifX;
    num pointDifY;
    bool inLineRectX, inLineRectY, inLineRect;
    double coord;

    Point beginPoint;
    Point endPoint;
    if (twin1) {
      beginPoint = box1.twin1();
      endPoint = box2.twin1();
    } else if (twin2) {
      beginPoint = box1.twin2();
      endPoint = box2.twin2();
    } else if (reflexive) {
      beginPoint = box1.reflexive1();
      endPoint = box1.reflexive2();
    } else {
      beginPoint = box1.center();
      endPoint = box2.center();
    }
    pointDifX = endPoint.x - beginPoint.x;
    pointDifY = endPoint.y - beginPoint.y;

    // Rapid test: Verify if the point is in the line rectangle.
    if (pointDifX > 0) {
      inLineRectX = (point.x >= (beginPoint.x - delta.x)) &&
      (point.x <= (endPoint.x + delta.x));
    } else {
      inLineRectX = (point.x >= (endPoint.x - delta.x)) &&
      (point.x <= (beginPoint.x + delta.x));
    }
    if (pointDifY > 0) {
      inLineRectY = (point.y >= (beginPoint.y - delta.y)) &&
      (point.y <= (endPoint.y + delta.y));
    } else {
      inLineRectY = (point.y >= (endPoint.y - delta.y)) &&
      (point.y <= (beginPoint.y + delta.y));
    }
    inLineRect = inLineRectX && inLineRectY;
    if (!inLineRect) {
      return false;
    }

    // If the line is horizontal or vertical there is no need to continue.
    if ((pointDifX == 0) || (pointDifY == 0)) {
        return true;
    }

    if (pointDifX.abs() > pointDifY.abs()) {
      coord = beginPoint.y +
      (((point.x - beginPoint.x) * pointDifY) / pointDifX) - point.y;
      return coord.abs() <= delta.y;
    } else {
      coord = beginPoint.x +
      (((point.y - beginPoint.y) * pointDifX) / pointDifY) - point.x;
      return coord.abs() <= delta.x;
    }
  }

  Point calculateMinMaxPointCloseToBeginBox(Box beginBox, Box endBox) {
    int x = 0;
    int y = 0;

    Point lineBeginPoint;
    Point lineEndPoint;
    if (twin1) {
      lineBeginPoint = beginBox.twin1();
      lineEndPoint = endBox.twin1();
    } else if (twin2) {
      lineBeginPoint = beginBox.twin2();
      lineEndPoint = endBox.twin2();
    } else {
      lineBeginPoint = beginBox.center();
      lineEndPoint = endBox.center();
    }
    Point beginPoint = beginBox.getIntersectionPoint(lineBeginPoint,
      lineEndPoint);
    Point endPoint = endBox.getIntersectionPoint(lineEndPoint, lineBeginPoint);

    int x1 = beginPoint.x.toInt();
    int y1 = beginPoint.y.toInt();
    int x2 = endPoint.x.toInt();
    int y2 = endPoint.y.toInt();

    if (x1 <= x2) {
      x = (x1 + 1 * ((x2 - x1) / 8)).toInt();
      if (y1 <= y2) {
        y = (y1 + 1 * ((y2 - y1) / 8)).toInt();
      } else {
        y = (y2 + 7 * ((y1 - y2) / 8)).toInt();
      }
    } else {
      x = (x2 + 7 * ((x1 - x2) / 8)).toInt();
      if (y1 <= y2) {
        y = (y1 + 1 * ((y2 - y1) / 8)).toInt();
      } else {
        y = (y2 + 7 * ((y1 - y2) / 8)).toInt();
      }
    }
    return new Point(x, y);
  }

  Point calculateNamePointCloseToBeginBox(Box beginBox, Box endBox) {
    if (reflexive) {
      return new Point(beginBox.reflexive1().x + 30,
        beginBox.reflexive1().y + 30);
    }

    num x = 0;
    num y = 0;

    Point lineBeginPoint;
    Point lineEndPoint;
    if (twin1) {
      lineBeginPoint = beginBox.twin1();
      lineEndPoint = endBox.twin1();
    } else if (twin2) {
      lineBeginPoint = beginBox.twin2();
      lineEndPoint = endBox.twin2();
    } else {
      lineBeginPoint = beginBox.center();
      lineEndPoint = endBox.center();
    }
    Point beginPoint = beginBox.getIntersectionPoint(lineBeginPoint,
      lineEndPoint);
    Point endPoint = endBox.getIntersectionPoint(lineEndPoint, lineBeginPoint);

    num x1 = beginPoint.x;
    num y1 = beginPoint.y;
    num x2 = endPoint.x;
    num y2 = endPoint.y;

    if (x1 <= x2) {
      x = (x1 + 3 * ((x2 - x1) / 8));
      if (y1 <= y2) {
          y = (y1 + 3 * ((y2 - y1) / 8));
      } else {
          y = (y2 + 5 * ((y1 - y2) / 8));
      }
    } else {
      x = (x2 + 5 * ((x1 - x2) / 8));
      if (y1 <= y2) {
          y = (y1 + 3 * ((y2 - y1) / 8));
      } else {
          y = (y2 + 5 * ((y1 - y2) / 8));
      }
    }
    return new Point(x, y);
  }

  Point calculateMinMaxPoint1(Box box) {
    return new Point(box.reflexive1().x - 30, box.reflexive1().y + 30);
  }

  Point calculateMinMaxPoint2(Box box) {
    return new Point(box.reflexive2().x + 10, box.reflexive2().y + 30);
  }

  Point calculateNamePoint1(Box box) {
    return new Point(box.reflexive1().x - 20, box.reflexive1().y - 20);
  }

  Point calculateNamePoint2(Box box) {
    return new Point(box.reflexive2().x + 10, box.reflexive2().y);
  }

}

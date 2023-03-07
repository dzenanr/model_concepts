part of model_concepts;

class Line {

  final Board board;

  Box from; // line begin box
  Box to; // line end box

  String _category; // relationship, inheritance, reflexive, twin
  bool internal = true;

  bool _twin1 = false;
  bool _twin2 = false;

  String fromToName = ''; // name from from to to
  String fromToMin = '0'; // min cardinality from from to to
  String fromToMax = 'N'; // max cardinality from from to to
  bool fromToId = false; // id from from to to

  String toFromName = ''; // name from to to from
  String toFromMin = '1'; // min cardinality from to to from
  String toFromMax = '1'; // max cardinality from to to from
  bool toFromId = false; // id from to to from

  bool _selected = false;
  bool _hidden = false;

  Line(this.board, this.from, this.to) {
    category = 'relationship';
    to.entry = false;
    var alreadyInternal = false;
    for (Line l in board.lines) {
      if (l.to == to) {
        if (l != this && l.internal) {
          alreadyInternal = true;
        }
      }
    }
    if (alreadyInternal) {
      internal = false;
    } 
    draw();
    select();
  }
  
  bool get external => !internal;

  void draw() {
    if (!isHidden()) {
      board.context.beginPath();
      if (twin1) {
        board.context.moveTo(from.twin1().x, from.twin1().y);
        board.context.lineTo(to.twin1().x, to.twin1().y);
      } else if (twin2) {
        board.context.moveTo(from.twin2().x, from.twin2().y);
        board.context.lineTo(to.twin2().x, to.twin2().y);
      } else if (reflexive) {
        board.context.moveTo(from.center().x, from.center().y);
        board.context.lineTo(from.reflexive1().x, to.reflexive1().y);
        board.context.lineTo(from.reflexive2().x, to.reflexive2().y);
        board.context.lineTo(from.center().x, to.center().y);
      } else {
        board.context.moveTo(from.center().x, from.center().y);
        board.context.lineTo(to.center().x, to.center().y);
      }
      Point fromToMinMaxPoint;
      Point toFromMinMaxPoint;
      Point fromToNamePoint;
      Point toFromNamePoint;
      if (reflexive) {
        fromToMinMaxPoint = calculateMinMaxPoint1(from);
        toFromMinMaxPoint = calculateMinMaxPoint2(from);
        fromToNamePoint = calculateNamePoint1(from);
        toFromNamePoint = calculateNamePoint2(from);
      } else {
        fromToMinMaxPoint = calculateMinMaxPointCloseToBeginBox(from, to);
        toFromMinMaxPoint = calculateMinMaxPointCloseToBeginBox(to, from);
        fromToNamePoint = calculateNamePointCloseToBeginBox(from, to);
        toFromNamePoint = calculateNamePointCloseToBeginBox(to, from);
      }

      String fromToMinMax = '$fromToMin..$fromToMax';
      String toFromMinMax = '$toFromMin..$toFromMax';
      int dfs = Board.DEFAULT_FONT_SIZE;
      if (fromToId) {
        board.context.font = 'bold italic ${dfs}px sans-serif';
      } else if (fromToMin != '0') {
        board.context.font = 'bold ${dfs}px sans-serif';
      } else {
        board.context.font = '${dfs}px sans-serif';
      }
      board.context.fillText(fromToMinMax, fromToMinMaxPoint.x,
        fromToMinMaxPoint.y);
      board.context.fillText(fromToName, fromToNamePoint.x,
        fromToNamePoint.y);
      if (toFromId) {
        board.context.font = 'bold italic ${dfs}px sans-serif';
      } else if (toFromMin != '0') {
        board.context.font = 'bold ${dfs}px sans-serif';
      } else {
        board.context.font = '${dfs}px sans-serif';
      }
      board.context.fillText(toFromMinMax, toFromMinMaxPoint.x,
        toFromMinMaxPoint.y);
      board.context.fillText(toFromName, toFromNamePoint.x,
        toFromNamePoint.y);

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
      //fromToName = '';
      fromToName = putInEnglishPlural(to.title.toLowerCase());
      fromToMin = '0';
      fromToMax = 'N';
      fromToId = false;

      //toFromName = '';
      toFromName = from.title.toLowerCase();
      toFromMin = '1';
      toFromMax = '1';
      toFromId = false;

      _twin1 = false;
      _twin2 = false;
    } else if (category == 'inheritance') {
      fromToName = 'as${to.title}';
      fromToMin = '0';
      fromToMax = '1';
      fromToId = false;

      toFromName = 'is${from.title}';
      toFromMin = '1';
      toFromMax = '1';
      toFromId = true;

      _twin1 = false;
      _twin2 = false;
    } else if (category == 'reflexive') {
      to = from;
      internal = true;

      fromToName = putInEnglishPlural(from.title.toLowerCase());
      fromToMin = '0';
      fromToMax = 'N';
      fromToId = false;

      toFromName = from.title.toLowerCase();
      toFromMin = '0';
      toFromMax = '1';
      toFromId = false;

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
        fromToName = '${putInEnglishPlural(to.title.toLowerCase())}1';
        toFromName = '${from.title.toLowerCase()}2';
        twinLine.fromToName = '${putInEnglishPlural(to.title.toLowerCase())}2';
        twinLine.toFromName = '${from.title.toLowerCase()}1';
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
    lineMap["from"] = from.title;
    lineMap["to"] = to.title;
    lineMap["category"] = category;
    lineMap["internal"] = internal;

    lineMap["fromToName"] = fromToName;
    lineMap["fromToMin"] = fromToMin;
    lineMap["fromToMax"] = fromToMax;
    lineMap["fromToId"] = fromToId;

    lineMap["toFromName"] = toFromName;
    lineMap["toFromMin"] = toFromMin;
    lineMap["toFromMax"] = toFromMax;
    lineMap["toFromId"] = toFromId;

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

  String putInEnglishPlural(String text) {
    String plural = '';
    try {
      if (text.length > 0) {
        String lastCharacterString = text.substring(text.length - 1,
            text.length);
        if (lastCharacterString == 'x') {
          plural = '${text}es';
        } else if (lastCharacterString == 'z') {
          plural = '${text}zes';
        } else if (lastCharacterString == 'y') {
          String withoutLast = dropEnd(text, lastCharacterString);
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

  String dropEnd(String text, String end) {
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
    if (from.contains(point.x.toInt(), point.y.toInt()) || to.contains(point.x.toInt(), point.y.toInt())) {
      return false;
    }

    num pointDifX;
    num pointDifY;
    bool inLineRectX, inLineRectY, inLineRect;
    double coord;

    Point beginPoint;
    Point endPoint;
    if (twin1) {
      beginPoint = from.twin1();
      endPoint = to.twin1();
    } else if (twin2) {
      beginPoint = from.twin2();
      endPoint = to.twin2();
    } else if (reflexive) {
      beginPoint = from.reflexive1();
      endPoint = from.reflexive2();
    } else {
      beginPoint = from.center();
      endPoint = to.center();
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

part of model_concepts;

class Board {
  static const int MIN_WIDTH = 990;
  static const int MIN_HEIGHT = 580;
  static const int DEFAULT_LINE_WIDTH = 1;
  static const int DEFAULT_FONT_SIZE = 12;
  static const String DEFAULT_LINE_COLOR = '#000000'; // black
  static const String SOFT_LINE_COLOR = '#999493'; // gray; old: 736f6e
  // static const String SOFT_LINE_COLOR = '#c0c0c0'; // silver
  static const String SELECTION_COLOR = '#000000'; // black

  // The acceptable delta error in pixels for clicking on a line between two boxes.
  static const int DELTA = 8;

  static const String FILE_NAME = 'model.txt';

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  num _width;
  num _height;

  List<Box> boxes;
  List<Line> lines;

  Box beforeLastBoxSelected;
  Box lastBoxSelected;
  Line lastLineSelected;

  MenuBar menuBar;
  ToolBar toolBar;
  JsonPanel jsonPanel;
  PngPanel pngPanel;

  Board(this.canvas) {
    context = canvas.getContext('2d');
    _width = canvas.width;
    _height = canvas.height;
    border();

    boxes = new List<Box>();
    lines = new List<Line>();

    menuBar = new MenuBar(this);
    toolBar = new ToolBar(this);
    jsonPanel = new JsonPanel(this);
    pngPanel = new PngPanel(this);

    document.querySelector('#canvas').onMouseDown.listen(onMouseDown);
    window.animationFrame.then(redrawLoop);
  }

  void redrawLoop(num delta) {
    redraw();
    window.animationFrame.then(redrawLoop);
  }

  void set width(num width) {
    _width = width;
    canvas.width = width.toInt();
  }

  num get width {
    return _width;
  }

  void set height(num height) {
    _height = height;
    canvas.height = height.toInt();
  }

  num get height {
    return _height;
  }

  void openModel(String name) {
    String json = window.localStorage[name];
    if (json != null) {
      fromJson(json);
    }
  }

  void saveModel(String name) {
    String json = toJson();
    if (json != null) {
      window.localStorage[name] = json;
    }
  }

  void closeModel() {
    delete();
    jsonPanel.clearJson();
    jsonPanel.clearPrettyJson();
    pngPanel.hide();
  }

  String toJson() {
    Map<String, Object> boardMap = new Map<String, Object>();
    boardMap["width"] = width;
    boardMap["height"] = height;
    boardMap["boxes"] = boxesToJson();
    boardMap["lines"] = linesToJson();
    return JSON.encode(boardMap);
  }

  void fromJson(String json) {
    if (json != null && json.trim() != '') {
      Map<String, Object> boardMap = JSON.decode(json);
      width = boardMap["width"];
      height = boardMap["height"];
      List<Map<String, Object>> boxesList = boardMap["boxes"];
      boxesFromJson(boxesList);
      List<Map<String, Object>> linesList = boardMap["lines"];
      linesFromJson(linesList);
    }
  }

  List<Map<String, Object>> boxesToJson() {
    List<Map<String, Object>> boxesList = new List<Map<String, Object>>();
    for (Box box in boxes) {
      if (!box.isHidden()) {
        boxesList.add(box.toJson());
      }
    }
    return boxesList;
  }

  List<Map<String, Object>> linesToJson() {
    List<Map<String, Object>> linesList = new List<Map<String, Object>>();
    for (Line line in lines) {
      if (!line.isHidden()) {
        linesList.add(line.toJson());
      }
    }
    return linesList;
  }

  void boxesFromJson(List<Map<String, Object>> boxesList) {
    boxes = new List<Box>();
    for (Map<String, Object> jsonBox in boxesList) {
      boxes.add(boxFromJson(jsonBox));
    }
  }

  Box boxFromJson(Map<String, Object> boxMap) {
    num x = boxMap["x"];
    num y = boxMap["y"];
    num width = boxMap["width"];
    num height = boxMap["height"];
    Box box = new Box(this, x, y, width, height);
    box.title = boxMap["name"];
    box.entry = boxMap["entry"];
    List<Map<String, Object>> itemsList = boxMap["items"];
    for (Map<String, Object> jsonItem in itemsList) {
      itemFromJson(box, jsonItem);
    }
    return box;
  }

  Item itemFromJson(Box box, Map<String, Object> itemMap) {
    String name = itemMap["name"];
    String category = itemMap["category"];
    Item item = new Item(box, name, category);
    int sequence = itemMap["sequence"];
    item.sequence = sequence;
    item.type = itemMap["type"];
    item.init = itemMap["init"];
    item.essential = itemMap["essential"];
    item.sensitive = itemMap["sensitive"];
    return item;
  }

  void linesFromJson(List<Map<String, Object>> linesList) {
    lines = new List<Line>();
    for (Map<String, Object> jsonLine in linesList) {
      Line line = lineFromJson(jsonLine);
      if (line != null) {
        lines.add(line);
      }
    }
  }

  Line lineFromJson(Map<String, Object> lineMap) {
    String box1Name = lineMap["box1Name"];
    String box2Name = lineMap["box2Name"];
    Box box1 = findBox(box1Name);
    Box box2 = findBox(box2Name);
    if (box1 != null && box2 != null) {
      Line line = new Line(this, box1, box2);
      line.category = lineMap["category"];
      line.internal = lineMap["internal"];

      String box1box2Name = lineMap["box1box2Name"];
      String box1box2Min = lineMap["box1box2Min"];
      String box1box2Max = lineMap["box1box2Max"];
      bool box1box2Id = lineMap["box1box2Id"];

      line.box1box2Name = box1box2Name;
      line.box1box2Min = box1box2Min;
      line.box1box2Max = box1box2Max;
      line.box1box2Id = box1box2Id;

      String box2box1Name = lineMap["box2box1Name"];
      String box2box1Min = lineMap["box2box1Min"];
      String box2box1Max = lineMap["box2box1Max"];
      bool box2box1Id = lineMap["box2box1Id"];

      line.box2box1Name = box2box1Name;
      line.box2box1Min = box2box1Min;
      line.box2box1Max = box2box1Max;
      line.box2box1Id = box2box1Id;

      return line;
    }
    return null;
  }

  void border() {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.lineWidth = DEFAULT_LINE_WIDTH;
    context.strokeStyle = DEFAULT_LINE_COLOR;
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

  void deleteSelectedBoxes() {
    var listCopy = boxes.toList();
    for (Box box in listCopy) {
      if (box.isSelected()) {
        boxes.remove(box);
        if (box == beforeLastBoxSelected) {
          beforeLastBoxSelected == null;
        } else if (box == lastBoxSelected) {
          lastBoxSelected == null;
        }
      }
    }
  }

  void deleteSelectedLines() {
    lines.removeWhere((l) => l.isSelected());
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

  void selectBoxLines() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        for (Line line in lines) {
          if (line.box1 == box || line.box2 == box) {
            line.select();
          }
        }
      }
    }
  }

  void selectLinesBetweenBoxes() {
    for (Line line in lines) {
      if (line.box1.isSelected() && line.box2.isSelected()) {
        line.select();
      }
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

  void showHidden() {
    showHiddenBoxes();
    showHiddenLines();
  }

  void hideNonSelection() {
    for (Box box in boxes) {
      if (!box.isSelected()) {
        box.hide();
      }
    }
    for (Line line in lines) {
      if (!line.isSelected()) {
        line.hide();
      }
    }
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

  int countBoxesContain(int pointX, int pointY) {
    int count = 0;
    for (Box box in boxes) {
      if (box.contains(pointX, pointY)) {
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

  int countLinesBetween(Box box1, Box box2) {
    int count = 0;
    for (Line line in lines) {
      if ((line.box1 == box1 && line.box2 == box2) ||
          (line.box1 == box2 && line.box2 == box1)) {
        count++;
      }
    }
    return count;
  }

  Box findBox(String boxName) {
    for (Box box in boxes) {
      if (box.title == boxName) {
        return box;
      }
    }
    return null;
  }

  Line findTwinLine(Line twin) {
    for (Line line in lines) {
      if (line != twin && line.box1 == twin.box1 && line.box2 == twin.box2) {
        return line;
      }
    }
    return null;
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
      if (box.contains(e.offset.x, e.offset.y)) {
        // Clicked on the existing box.
        clickedOnBox = true;
        break;
      }
    }

    if (!clickedOnBox) {
      if (toolBar.isSelectToolOn()) {
        Point clickedPoint = new Point(e.offset.x, e.offset.y);
        Line line = _lineContains(clickedPoint);
        if (line != null) {
          // Select or deselect the existing line.
          line.toggleSelection();
        } else {
          // Deselect all.
          deselect();
        }
      } else if (toolBar.isBoxToolOn()) {
        // Create a box in the position of the mouse click on the board,
        // but not on an existing box.
        Box box = new Box(this, e.offset.x, e.offset.y,
          Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        if (e.offset.x + box.width > width) {
          box.x = width - box.width - 1;
        }
        if (e.offset.y + box.height > height) {
          box.y = height - box.height - 1;
        }
        boxes.add(box);
      } else if (toolBar.isLineToolOn()) {
        // Create a line between the last two selected boxes.
        if (beforeLastBoxSelected != null && lastBoxSelected != null &&
          _boxExists(beforeLastBoxSelected) && _boxExists(lastBoxSelected) &&
          countLinesBetween(beforeLastBoxSelected, lastBoxSelected) < 2) {
          Line line = new Line(this, beforeLastBoxSelected, lastBoxSelected);
          lines.add(line);
        }
      }
      toolBar.backToFixedTool();
    }
  }

}

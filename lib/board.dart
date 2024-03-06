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
  late CanvasRenderingContext2D context;

  num _width = Board.MIN_WIDTH;
  num _height = Board.MIN_HEIGHT;

  late List<Box> boxes;
  late List<Line> lines;

  Box? beforeLastBoxSelected;
  Box? lastBoxSelected;
  Line? lastLineSelected;

  late MenuBar menuBar;
  late ToolBar toolBar;
  late JsonPanel jsonPanel;
  late PngPanel pngPanel;

  Board(this.canvas) {
    context = canvas.getContext('2d') as CanvasRenderingContext2D;
    _width = canvas.width as num;
    _height = canvas.height as num;
    border();

    boxes = List<Box>.empty();
    lines = new List<Line>.empty();

    menuBar = new MenuBar(this);
    toolBar = new ToolBar(this);
    jsonPanel = new JsonPanel(this);
    pngPanel = new PngPanel(this);

    document.querySelector('#canvas')?.onMouseDown.listen(onMouseDown);
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

  void openModel(String? name) {
    String? json = window.localStorage[name];
    if (json != null) {
      fromJson(json);
    }
  }

  void saveModel(String? name) {
    String? json = toJson();
    if (json != null && name != null) {
      window.localStorage[name] = json;
    }
  }

  void closeModel() {
    delete();
    jsonPanel.clearJson();
    jsonPanel.clearPrettyJson();
    pngPanel.hide();
  }

  String? toJson() {
    Map<String, Object> boardMap = new Map<String, Object>();
    boardMap["width"] = width;
    boardMap["height"] = height;
    boardMap["concepts"] = boxesToJson();
    boardMap["relations"] = linesToJson();
    return jsonEncode(boardMap);
  }

  void fromJson(String? json) {
    if (json != null && json.trim() != '') {
      Map<String, Object> boardMap = jsonDecode(json);
      width = boardMap["width"] as num;
      height = boardMap["height"] as num;
      List<Map<String, Object>> boxesList =
          boardMap["concepts"] as List<Map<String, Object>>;
      boxesFromJson(boxesList);
      List<Map<String, Object>> linesList =
          boardMap["relations"] as List<Map<String, Object>>;
      linesFromJson(linesList);
    }
  }

  List<Map<String, Object>> boxesToJson() {
    List<Map<String, Object>> boxesList = List<Map<String, Object>>.empty();
    for (Box box in boxes) {
      if (!box.isHidden()) {
        boxesList.add(box.toJson());
      }
    }
    return boxesList;
  }

  List<Map<String, Object>> linesToJson() {
    List<Map<String, Object>> linesList = List<Map<String, Object>>.empty();
    for (Line line in lines) {
      if (!line.isHidden()) {
        linesList.add(line.toJson());
      }
    }
    return linesList;
  }

  void boxesFromJson(List<Map<String, Object>> boxesList) {
    boxes = List<Box>.empty();
    for (Map<String, Object> jsonBox in boxesList) {
      boxes.add(boxFromJson(jsonBox));
    }
  }

  Box boxFromJson(Map<String, Object> boxMap) {
    num x = boxMap["x"] as num;
    num y = boxMap["y"] as num;
    num width = boxMap["width"] as num;
    num height = boxMap["height"] as num;
    Box box = new Box(this, x, y, width, height);
    box.title = boxMap["name"] as String;
    box.entry = boxMap["entry"] as bool;
    List<Map<String, Object>> itemsList =
        boxMap["attributes"] as List<Map<String, Object>>;
    for (Map<String, Object> jsonItem in itemsList) {
      itemFromJson(box, jsonItem);
    }
    return box;
  }

  Item itemFromJson(Box box, Map<String, Object> itemMap) {
    String name = itemMap["name"] as String;
    String category = itemMap["category"] as String;
    Item item = new Item(box, name, category);
    int sequence = itemMap["sequence"] as int;
    item.sequence = sequence;
    item.type = itemMap["type"] as String;
    item.init = itemMap["init"] as String;
    item.essential = itemMap["essential"] as bool;
    item.sensitive = itemMap["sensitive"] as bool;
    return item;
  }

  void linesFromJson(List<Map<String, Object>> linesList) {
    lines = List<Line>.empty();
    for (Map<String, Object> jsonLine in linesList) {
      Line? line = lineFromJson(jsonLine);
      if (line != null) {
        lines.add(line);
      }
    }
  }

  Line? lineFromJson(Map<String, Object> lineMap) {
    String? fromString = lineMap["from"] as String?;
    String? toString = lineMap["to"] as String?;
    Box? from = findBox(fromString);
    Box? to = findBox(toString);
    if (from != null && to != null) {
      Line line = new Line(this, from, to);
      line.category = lineMap["category"] as String;
      line.internal = lineMap["internal"] as bool;

      String fromToName = lineMap["fromToName"] as String;
      String fromToMin = lineMap["fromToMin"] as String;
      String fromToMax = lineMap["fromToMax"] as String;
      bool fromToId = lineMap["fromToId"] as bool;

      line.fromToName = fromToName;
      line.fromToMin = fromToMin;
      line.fromToMax = fromToMax;
      line.fromToId = fromToId;

      String toFromName = lineMap["toFromName"] as String;
      String toFromMin = lineMap["toFromMin"] as String;
      String toFromMax = lineMap["toFromMax"] as String;
      bool toFromId = lineMap["toFromId"] as bool;

      line.toFromName = toFromName;
      line.toFromMin = toFromMin;
      line.toFromMax = toFromMax;
      line.toFromId = toFromId;

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
    int x = 0;
    int y = 0;
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
    int x = 0;
    int y = 0;
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
          beforeLastBoxSelected = null;
        } else if (box == lastBoxSelected) {
          lastBoxSelected = null;
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
          if (line.from == box || line.to == box) {
            line.select();
          }
        }
      }
    }
  }

  void selectLinesBetweenBoxes() {
    for (Line line in lines) {
      if (line.from.isSelected() && line.to.isSelected()) {
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
      if (line.isSelected() &&
          line.contains(new Point(pointX, pointY), delta)) {
        count++;
      }
    }
    return count;
  }

  int countLinesBetween(Box? from, Box? to) {
    int count = 0;
    for (Line line in lines) {
      if ((line.from == from && line.to == to) ||
          (line.from == to && line.to == from)) {
        count++;
      }
    }
    return count;
  }

  Box? findBox(String? boxName) {
    for (Box box in boxes) {
      if (box.title == boxName) {
        return box;
      }
    }
    return null;
  }

  Line? findTwinLine(Line twin) {
    for (Line line in lines) {
      if (line != twin && line.from == twin.from && line.to == twin.to) {
        return line;
      }
    }
    return null;
  }

  Line? _lineContains(Point point) {
    Point delta = new Point(DELTA, DELTA);
    for (Line line in lines) {
      if (line.contains(point, delta)) {
        return line;
      }
    }
    return null;
  }

  bool _boxExists(Box? box) {
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
      if (box.contains(e.offset.x.toInt(), e.offset.y.toInt())) {
        // Clicked on the existing box.
        clickedOnBox = true;
        break;
      }
    }

    if (!clickedOnBox) {
      if (toolBar.isSelectToolOn()) {
        Point clickedPoint = new Point(e.offset.x, e.offset.y);
        Line? line = _lineContains(clickedPoint);
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
        Box box = new Box(this, e.offset.x, e.offset.y, Box.DEFAULT_WIDTH,
            Box.DEFAULT_HEIGHT);
        if (e.offset.x + box.width > width) {
          box.x = width - box.width - 1;
        }
        if (e.offset.y + box.height > height) {
          box.y = height - box.height - 1;
        }
        boxes.add(box);
      } else if (toolBar.isLineToolOn()) {
        // Create a line between the last two selected boxes.
        if (beforeLastBoxSelected != null &&
            lastBoxSelected != null &&
            _boxExists(beforeLastBoxSelected) &&
            _boxExists(lastBoxSelected) &&
            countLinesBetween(beforeLastBoxSelected, lastBoxSelected) < 2) {
          Line line = new Line(this, beforeLastBoxSelected!, lastBoxSelected!);
          lines.add(line);
        }
      }
      toolBar.backToFixedTool();
    }
  }
}

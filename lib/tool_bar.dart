part of model_concepts;

class ToolBar {

  static const int SELECT = 1;
  static const int BOX = 2;
  static const int LINE = 3;

  final Board board;

  int _onTool;
  int _fixedTool;

  ButtonElement selectButton;
  ButtonElement boxButton;
  ButtonElement lineButton;
  InputElement canvasWidthInput;
  InputElement canvasHeightInput;

  InputElement boxNameInput;
  InputElement boxEntryCheckbox;
  InputElement itemNameInput;
  SelectElement itemCategorySelect;
  SelectElement itemTypeSelect;
  InputElement itemInitInput;
  InputElement itemEssentialCheckbox;
  InputElement itemSensitiveCheckbox;
  ButtonElement getItemButton;
  ButtonElement getNextItemButton;
  ButtonElement getPreviousItemButton;
  ButtonElement moveDownItemButton;
  ButtonElement moveUpItemButton;
  ButtonElement removeItemButton;

  Item currentItem;

  SelectElement lineSelect;
  InputElement lineInternalCheckbox;

  LabelElement line12Box1Label;
  LabelElement line12Box2Label;
  InputElement line12MinInput;
  InputElement line12MaxInput;
  InputElement line12IdCheckbox;
  InputElement line12NameInput;

  LabelElement line21Box2Label;
  LabelElement line21Box1Label;
  InputElement line21MinInput;
  InputElement line21MaxInput;
  InputElement line21IdCheckbox;
  InputElement line21NameInput;

  ToolBar(this.board) {
    selectButton = document.query('#select');
    boxButton = document.query('#box');
    lineButton = document.query('#line');

    // Tool bar events.
    selectButton.onClick.listen((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton.onDoubleClick.listen((MouseEvent e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });

    boxButton.onClick.listen((MouseEvent e) {
      onTool(BOX);
    });boxEntryCheckbox = document.query('#boxEntry');
    boxEntryCheckbox.onChange.listen((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox.checked;
      }
    });
    boxButton.onDoubleClick.listen((MouseEvent e) {
      onTool(BOX);
      _fixedTool = BOX;
    });

    lineButton.onClick.listen((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.onDoubleClick.listen((MouseEvent e) {
      onTool(LINE);
      _fixedTool = LINE;
    });

    onTool(SELECT);
    _fixedTool = SELECT;

    canvasWidthInput = document.query('#canvasWidth');
    canvasHeightInput = document.query('#canvasHeight');
    canvasWidthInput.valueAsNumber = board.width;
    canvasWidthInput.onChange.listen((Event e) {
      board.width = canvasWidthInput.valueAsNumber;
    });
    canvasHeightInput.valueAsNumber = board.height;
    canvasHeightInput.onChange.listen((Event e) {
      board.height = canvasHeightInput.valueAsNumber;
    });

    boxNameInput = document.query('#boxName');
    boxNameInput.onChange.listen((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        String boxName = boxNameInput.value.trim();
        if (boxName != '') {
          Box otherBox = board.findBox(boxName);
          if (otherBox == null) {
            box.title = boxName;
            itemNameInput.focus();
          }
        }
      }
    });

    boxEntryCheckbox = document.query('#boxEntry');
    boxEntryCheckbox.onChange.listen((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox.checked;
      }
    });

    itemNameInput = document.query('#itemName');
    itemNameInput.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode != KeyCode.ENTER) return;
      Box box = board.lastBoxSelected;
      if (box != null) {
        String itemName = itemNameInput.value.trim();
        if (itemName != '') {
          if (currentItem != null) {
            if (currentItem.box == box) {
              String itemName = itemNameInput.value.trim();
              Item item = box.findItem(itemName);
              if (item == null) {
                currentItem.name = itemName;
              }
              itemNameInput.select();
            }
          } else {
            Item item = box.findItem(itemName);
            if (item == null) {
              Item newItem = new Item(box, itemName, itemCategorySelect.value);
              newItem.type = itemTypeSelect.value;
              newItem.init = itemInitInput.value.trim();
              if (newItem.category == 'identifier') {
                itemEssentialCheckbox.checked = true;
              }
              newItem.essential = itemEssentialCheckbox.checked;
              newItem.sensitive = itemSensitiveCheckbox.checked;
              itemNameInput.value = '';
              //currentItem = newItem;
              //itemNameInput.select();
            } else {
              itemNameInput.value = item.name;
              itemCategorySelect.value = item.category;
              itemTypeSelect.value = item.type;
              itemInitInput.value = item.init;
              itemEssentialCheckbox.checked = item.essential;
              itemSensitiveCheckbox.checked = item.sensitive;
              currentItem = item;
              itemNameInput.select();
            }
          }
        }
      }
    });

    itemCategorySelect = document.query('#itemCategory');
    itemCategorySelect.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem.category = itemCategorySelect.value;
        itemNameInput.select();
        if (currentItem.category == 'identifier') {
          itemEssentialCheckbox.checked = true;
        }
      } else {
        itemNameInput.focus();
      }
    });

    itemTypeSelect = document.query('#itemType');
    itemTypeSelect.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem.type = itemTypeSelect.value;
        itemNameInput.select();
      } else {
        itemNameInput.focus();
      }
    });

    itemInitInput = document.query('#itemInit');
    itemInitInput.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem.init = itemInitInput.value.trim();
        itemNameInput.select();
      } else {
        itemNameInput.focus();
      }
    });

    itemEssentialCheckbox = document.query('#itemEssential');
    itemEssentialCheckbox.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem.essential = itemEssentialCheckbox.checked;
        itemNameInput.select();
      } else {
        itemNameInput.focus();
      }
    });

    itemSensitiveCheckbox = document.query('#itemSensitive');
    itemSensitiveCheckbox.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem.sensitive = itemSensitiveCheckbox.checked;
        itemNameInput.select();
      } else {
        itemNameInput.focus();
      }
    });

    getNextItemButton = document.query('#getNextItem');
    getNextItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            currentItem = nextItem;
            itemNameInput.value = nextItem.name;
            itemCategorySelect.value = nextItem.category;
            itemTypeSelect.value = nextItem.type;
            itemInitInput.value = nextItem.init;
            itemEssentialCheckbox.checked = nextItem.essential;
            itemSensitiveCheckbox.checked = nextItem.sensitive;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategorySelect.value = 'attribute';
            itemTypeSelect.value = 'String';
            itemInitInput.value = '';
            itemEssentialCheckbox.checked = false;
            itemSensitiveCheckbox.checked = false;
          }
        } else {
          if (!box.items.isEmpty) {
            Item firstItem = box.findFirstItem();
            currentItem = firstItem;
            itemNameInput.value = firstItem.name;
            itemCategorySelect.value = firstItem.category;
            itemTypeSelect.value = firstItem.type;
            itemInitInput.value = firstItem.init;
            itemEssentialCheckbox.checked = firstItem.essential;
            itemSensitiveCheckbox.checked = firstItem.sensitive;
            itemNameInput.select();
          }
        }
      }
    });

    getPreviousItemButton = document.query('#getPreviousItem');
    getPreviousItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            currentItem = previousItem;
            itemNameInput.value = previousItem.name;
            itemCategorySelect.value = previousItem.category;
            itemTypeSelect.value = previousItem.type;
            itemInitInput.value = previousItem.init;
            itemEssentialCheckbox.checked = previousItem.essential;
            itemSensitiveCheckbox.checked = previousItem.sensitive;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategorySelect.value = 'attribute';
            itemTypeSelect.value = 'String';
            itemInitInput.value = '';
            itemEssentialCheckbox.checked = false;
            itemSensitiveCheckbox.checked = false;
          }
        } else {
          if (!box.items.isEmpty) {
            Item lastItem = box.findLastItem();
            currentItem = lastItem;
            itemNameInput.value = lastItem.name;
            itemCategorySelect.value = lastItem.category;
            itemTypeSelect.value = lastItem.type;
            itemInitInput.value = lastItem.init;
            itemEssentialCheckbox.checked = lastItem.essential;
            itemSensitiveCheckbox.checked = lastItem.sensitive;
            itemNameInput.select();
          }
        }
      }
    });

    moveDownItemButton = document.query('#moveDownItem');
    moveDownItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            int nextSequence = nextItem.sequence;
            int currentSequence = currentItem.sequence;
            currentItem.sequence = nextSequence;
            nextItem.sequence = currentSequence;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategorySelect.value = 'attribute';
            itemTypeSelect.value = 'String';
            itemInitInput.value = '';
            itemEssentialCheckbox.checked = false;
            itemSensitiveCheckbox.checked = false;
          }
        }
      }
    });

    moveUpItemButton = document.query('#moveUpItem');
    moveUpItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            int previousSequence = previousItem.sequence;
            int currentSequence = currentItem.sequence;
            currentItem.sequence = previousSequence;
            previousItem.sequence = currentSequence;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategorySelect.value = 'attribute';
            itemTypeSelect.value = 'String';
            itemInitInput.value = '';
            itemEssentialCheckbox.checked = false;
            itemSensitiveCheckbox.checked = false;
          }
        }
      }
    });

    removeItemButton = document.query('#removeItem');
    removeItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          if (box.removeItem(currentItem)) {
            currentItem = null;
            itemNameInput.value = '';
            itemCategorySelect.value = 'attribute';
            itemTypeSelect.value = 'String';
            itemInitInput.value = '';
            itemEssentialCheckbox.checked = false;
            itemSensitiveCheckbox.checked = false;
          }
        }
      }
    });

    lineSelect = document.query('#lineCategory');
    lineSelect.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null && line.box1.title != '' && line.box2.title != '') {
        if (line.category == 'relationship') {
          if (lineSelect.value == 'inheritance' ||
              lineSelect.value == 'reflexive') {
            line.category = lineSelect.value;
          } else if (lineSelect.value == 'twin') {
            if (board.findTwinLine(line) != null) {
              line.category = lineSelect.value;
            } else {
              lineSelect.value = 'relationship';
            }
          }
        } else if (line.category == 'inheritance') {
          if (lineSelect.value == 'relationship') {
            line.category = lineSelect.value;
          } else {
            lineSelect.value = 'inheritance';
          }
        } else if (line.category == 'reflexive') {
          lineSelect.value = 'reflexive';
        } else if (line.category == 'twin') {
          if (lineSelect.value == 'relationship') {
            if (board.findTwinLine(line) == null) {
              line.category = lineSelect.value;
            } else {
              lineSelect.value = 'twin';
            }
          } else {
            lineSelect.value = 'twin';
          }
        }
      } else {
        lineSelect.value = 'relationship';
      }
    });

    lineInternalCheckbox = document.query('#lineInternal');
    lineInternalCheckbox.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.internal = lineInternalCheckbox.checked;
      }
    });

    line12Box1Label = document.query('#line12Box1');
    line12Box2Label = document.query('#line12Box2');

    line12MinInput = document.query('#line12Min');
    line12MinInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Min = line12MinInput.value.trim();
      }
    });

    line12MaxInput = document.query('#line12Max');
    line12MaxInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Max = line12MaxInput.value.trim();
      }
    });

    line12IdCheckbox = document.query('#line12Id');
    line12IdCheckbox.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        if (line.box1box2Min == '1' && line.box1box2Max == '1') {
          line.box1box2Id = line12IdCheckbox.checked;
        } else {
          line12IdCheckbox.checked = false;
          line.box1box2Id = false;
        }
      }
    });

    line12NameInput = document.query('#line12Name');
    line12NameInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Name = line12NameInput.value.trim();
        line21NameInput.focus();
      }
    });

    line21Box2Label = document.query('#line21Box2');
    line21Box1Label = document.query('#line21Box1');

    line21MinInput = document.query('#line21Min');
    line21MinInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box2box1Min = line21MinInput.value.trim();
      }
    });

    line21MaxInput = document.query('#line21Max');
    line21MaxInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box2box1Max = line21MaxInput.value.trim();
      }
    });

    line21IdCheckbox = document.query('#line21Id');
    line21IdCheckbox.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        if (line.box2box1Min == '1' && line.box2box1Max == '1') {
          line.box2box1Id = line21IdCheckbox.checked;
        } else {
          line21IdCheckbox.checked = false;
          line.box2box1Id = false;
        }
      }
    });

    line21NameInput = document.query('#line21Name');
    line21NameInput.onChange.listen((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box2box1Name = line21NameInput.value.trim();
      }
    });
  }

  void bringSelectedBox() {
    Box box = board.lastBoxSelected;
    if (box != null) {
      boxNameInput.value = box.title;
      boxEntryCheckbox.checked = box.entry;
      currentItem = null;
      itemNameInput.value = '';
      // the following code does not focus on indicated fields!?
      /*
      if (box.title == '') {
        boxNameInput.focus();
      } else {
        itemNameInput.focus();
      }
      */
    }
  }

  void bringSelectedLine() {
    Line line = board.lastLineSelected;
    if (line != null) {
      lineSelect.value = line.category;
      lineInternalCheckbox.checked = line.internal;

      line12Box1Label.text = line.box1.title;
      line12Box2Label.text = line.box2.title;
      line12MinInput.value = line.box1box2Min;
      line12MaxInput.value = line.box1box2Max;
      line12IdCheckbox.checked = line.box1box2Id;
      line12NameInput.value = line.box1box2Name;

      line21Box2Label.text = line.box2.title;
      line21Box1Label.text = line.box1.title;
      line21MinInput.value = line.box2box1Min;
      line21MaxInput.value = line.box2box1Max;
      line21IdCheckbox.checked = line.box2box1Id;
      line21NameInput.value = line.box2box1Name;
      // the following code does not focus on indicated fields!?
      /*
      if (line.box1box2Name == '') {
        line12NameInput.focus();
      } else {
        line21NameInput.focus();
      }
      */
    }
  }

  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton.style.borderColor = Board.DEFAULT_LINE_COLOR;
      boxButton.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == BOX) {
      selectButton.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton.style.borderColor = Board.DEFAULT_LINE_COLOR;
      lineButton.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == LINE) {
      selectButton.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton.style.borderColor = Board.DEFAULT_LINE_COLOR;
    }
  }

  bool isSelectToolOn() {
    if (_onTool == SELECT) {
      return true;
    }
    return false;
  }

  bool isBoxToolOn() {
    if (_onTool == BOX) {
      return true;
    }
    return false;
  }

  bool isLineToolOn() {
    if (_onTool == LINE) {
      return true;
    }
    return false;
  }

  void backToFixedTool()  {
      onTool(_fixedTool);
  }

  void backToSelectAsFixedTool()  {
    onTool(SELECT);
    _fixedTool = SELECT;
  }

}

class ToolBar {
  
  static final int SELECT = 1;
  static final int BOX = 2;
  static final int LINE = 3;
  
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
  OptionElement itemCategoryOption;
  OptionElement itemTypeOption;
  InputElement itemInitInput;
  ButtonElement addItemButton;
  ButtonElement getPreviousItemButton;
  ButtonElement getItemButton;
  ButtonElement getNextItemButton;
  ButtonElement moveUpItemButton;
  ButtonElement moveDownItemButton;
  ButtonElement removeItemButton;
  
  Item currentItem;
  
  OptionElement lineOption;
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
    selectButton.on.click.add((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton.on.doubleClick.add((MouseEvent e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });
    
    boxButton.on.click.add((MouseEvent e) {
      onTool(BOX);
    });
    boxButton.on.doubleClick.add((MouseEvent e) {
      onTool(BOX);
      _fixedTool = BOX;
    });
    
    lineButton.on.click.add((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.on.doubleClick.add((MouseEvent e) {
      onTool(LINE);
      _fixedTool = LINE;
    });
    
    onTool(SELECT);
    _fixedTool = SELECT;
    
    canvasWidthInput = document.query('#canvasWidth');
    canvasHeightInput = document.query('#canvasHeight');
    canvasWidthInput.valueAsNumber = board.width;
    canvasWidthInput.on.input.add((Event e) {
      board.width = canvasWidthInput.valueAsNumber;
    });
    canvasHeightInput.valueAsNumber = board.height;
    canvasHeightInput.on.input.add((Event e) {
      board.height = canvasHeightInput.valueAsNumber;
    });
    
    boxNameInput = document.query('#boxName');
    boxNameInput.on.input.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        String boxName = boxNameInput.value.trim();
        if (boxName != '') {
          Box otherBox = board.findBox(boxName);
          if (otherBox == null) {
            box.title = boxName;
          }
        }
      }
    });
    
    boxEntryCheckbox = document.query('#boxEntry');
    boxEntryCheckbox.on.change.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox.checked;
      }
    });
    
    itemNameInput = document.query('#itemName');
    itemNameInput.on.input.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          String itemName = itemNameInput.value.trim();
          if (itemName != '') {
            Item otherItem = box.findItem(itemName);
            if (otherItem == null) {
              currentItem.name = itemName;
            }
          }
          itemNameInput.select();
        }
      }
    });
    
    itemCategoryOption = document.query('#itemCategory');
    itemCategoryOption.on.change.add((MouseEvent e) {
      if (currentItem != null) {
        currentItem.category = itemCategoryOption.value;
        itemNameInput.select();
      } 
    });
    
    itemTypeOption = document.query('#itemType');
    itemTypeOption.on.change.add((MouseEvent e) {
      if (currentItem != null) {
        currentItem.type = itemTypeOption.value;
        itemNameInput.select();
      } 
      itemInitInput.value = '';
    });
    
    itemInitInput = document.query('#itemInit');
    itemInitInput.on.input.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          currentItem.init = itemInitInput.value.trim();
          itemNameInput.select();
        }
      }
    });
    
    addItemButton = document.query('#addItem');
    addItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        String itemName = itemNameInput.value.trim();
        if (itemName != '') {
          Item otherItem = box.findItem(itemName);
          if (otherItem == null) {
            Item item = new Item(box, itemName, itemCategoryOption.value);
            item.type = itemTypeOption.value;
            item.init = itemInitInput.value.trim();
          }
        }
      }
    });
    
    getPreviousItemButton = document.query('#getPreviousItem');
    getPreviousItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            currentItem = previousItem;
            itemNameInput.value = previousItem.name;
            itemCategoryOption.value = previousItem.category;
            itemTypeOption.value = previousItem.type;
            itemInitInput.value = previousItem.init;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategoryOption.value = 'attribute';
            itemTypeOption.value = 'String';
            itemInitInput.value = '';
          }
        } else {
          if (!box.items.isEmpty()) {
            Item lastItem = box.findLastItem();
            currentItem = lastItem;
            itemNameInput.value = lastItem.name;
            itemCategoryOption.value = lastItem.category;
            itemTypeOption.value = lastItem.type;
            itemInitInput.value = lastItem.init;
            itemNameInput.select();
          }
        } 
      }
    });
    
    getItemButton = document.query('#getItem');
    getItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        Item item = box.findItem(itemNameInput.value);
        if (item != null) {
          currentItem = item;
          itemNameInput.value = item.name;
          itemCategoryOption.value = item.category;
          itemTypeOption.value = item.type;
          itemInitInput.value = item.init;
          itemNameInput.select();
        } else {
          currentItem = null;
        }
      }
    });
    
    getNextItemButton = document.query('#getNextItem');
    getNextItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            currentItem = nextItem;
            itemNameInput.value = nextItem.name;
            itemCategoryOption.value = nextItem.category;
            itemTypeOption.value = nextItem.type;
            itemInitInput.value = nextItem.init;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemCategoryOption.value = 'attribute';
            itemTypeOption.value = 'String';
            itemInitInput.value = '';
          }
        } else {
          if (!box.items.isEmpty()) {
            Item firstItem = box.findFirstItem();
            currentItem = firstItem;
            itemNameInput.value = firstItem.name;
            itemCategoryOption.value = firstItem.category;
            itemTypeOption.value = firstItem.type;
            itemInitInput.value = firstItem.init;
            itemNameInput.select();
          }
        } 
      }
    });
    
    moveUpItemButton = document.query('#moveUpItem');
    moveUpItemButton.on.click.add((MouseEvent e) {
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
            itemCategoryOption.value = 'attribute';
            itemTypeOption.value = 'String';
            itemInitInput.value = '';
          }
        } 
      }
    });
    
    moveDownItemButton = document.query('#moveDownItem');
    moveDownItemButton.on.click.add((MouseEvent e) {
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
            itemCategoryOption.value = 'attribute';
            itemTypeOption.value = 'String';
            itemInitInput.value = '';
          }
        }
      }
    });
    
    removeItemButton = document.query('#removeItem');
    removeItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          if (box.removeItem(currentItem)) {
            currentItem = null;
            itemNameInput.value = '';
            itemCategoryOption.value = 'attribute';
            itemTypeOption.value = 'String';
            itemInitInput.value = '';
          }
        }
      }
    });
    
    lineOption = document.query('#lineCategory');
    lineOption.on.change.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.category = lineOption.value;
      }
    });
    
    lineInternalCheckbox = document.query('#lineInternal');
    lineInternalCheckbox.on.change.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.internal = lineInternalCheckbox.checked;
      }
    });
    
    line12Box1Label = document.query('#line12Box1');
    line12Box2Label = document.query('#line12Box2');
    
    line12MinInput = document.query('#line12Min');
    line12MinInput.on.input.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Min = line12MinInput.value.trim();
      }
    });
    
    line12MaxInput = document.query('#line12Max');
    line12MaxInput.on.input.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Max = line12MaxInput.value.trim();
      }
    });
    
    line12IdCheckbox = document.query('#line12Id');
    line12IdCheckbox.on.change.add((Event e) {
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
    line12NameInput.on.input.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Name = line12NameInput.value.trim();
      }
    });
    
    line21Box2Label = document.query('#line21Box2');
    line21Box1Label = document.query('#line21Box1');
    
    line21MinInput = document.query('#line21Min');
    line21MinInput.on.input.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box2box1Min = line21MinInput.value.trim();
      }
    });
    
    line21MaxInput = document.query('#line21Max');
    line21MaxInput.on.input.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box2box1Max = line21MaxInput.value.trim();
      }
    });
    
    line21IdCheckbox = document.query('#line21Id');
    line21IdCheckbox.on.change.add((Event e) {
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
    line21NameInput.on.input.add((Event e) {
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
    }
  }
  
  void bringSelectedLine() {
    Line line = board.lastLineSelected;
    if (line != null) {
      lineOption.value = line.category;
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

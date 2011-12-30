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
  
  InputElement boxNameInput;
  InputElement itemNameInput;
  OptionElement itemOption;
  ButtonElement addItemButton;
  ButtonElement getItemButton;
  ButtonElement setItemButton;
  ButtonElement removeItemButton;
  
  Item currentItem;
  
  LabelElement line12Box1Label;
  LabelElement line12Box2Label;
  InputElement line12MinInput;
  InputElement line12MaxInput;
  InputElement line12IdCheckbox;
  
  ToolBar(this.board) {
    selectButton = document.query('#select');
    boxButton = document.query('#box');
    lineButton = document.query('#line');
    
    // Tool bar events.
    selectButton.on.click.add((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton.on.dblClick.add((MouseEvent e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });
    
    boxButton.on.click.add((MouseEvent e) {
      onTool(BOX);
    });
    boxButton.on.dblClick.add((MouseEvent e) {
      onTool(BOX);
      _fixedTool = BOX;
    });
    
    lineButton.on.click.add((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.on.dblClick.add((MouseEvent e) {
      onTool(LINE);
      _fixedTool = LINE;
    });
    
    onTool(SELECT);
    _fixedTool = SELECT;
    
    boxNameInput = document.query('#boxName');
    boxNameInput.on.focus.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        boxNameInput.value = box.title;
      }
    });
    boxNameInput.on.input.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.title = boxNameInput.value;
      }
    });
    
    itemNameInput = document.query('#itemName');
    
    itemOption = document.query('#itemCategory');
    
    addItemButton = document.query('#addItem');
    addItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        currentItem = new Item(box, itemNameInput.value, itemOption.value);
        itemNameInput.select();
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
          itemNameInput.select();
        } else {
          currentItem = null;
        }
      }
    });
    
    setItemButton = document.query('#setItem');
    setItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          currentItem.name = itemNameInput.value;
          itemNameInput.select();
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
          }
        }
      }
    });
    
    line12Box1Label = document.query('#line12Box1');
    line12Box2Label = document.query('#line12Box2');
    line12IdCheckbox = document.query('#line12Id');
    line12IdCheckbox.on.click.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line12Box1Label.text = line.box1.title;
        line12Box2Label.text = line.box2.title;
      }
    });
  }
  
  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton.style.borderColor = '#000000'; // black
      boxButton.style.borderColor = '#808080'; // grey
      lineButton.style.borderColor = '#808080'; // grey
    } else if (_onTool == BOX) {
      selectButton.style.borderColor = '#808080'; // grey
      boxButton.style.borderColor = '#000000'; // black
      lineButton.style.borderColor = '#808080'; // grey
    } else if (_onTool == LINE) {
      selectButton.style.borderColor = '#808080'; // grey
      boxButton.style.borderColor = '#808080'; // grey
      lineButton.style.borderColor = '#000000'; // black
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

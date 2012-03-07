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
  InputElement itemNameInput;
  OptionElement itemOption;
  InputElement itemSequenceInput;
  ButtonElement addItemButton;
  ButtonElement getItemButton;
  ButtonElement setItemButton;
  ButtonElement removeItemButton;
  
  Item currentItem;
  
  OptionElement lineOption;
  ButtonElement getLineButton;
  ButtonElement setLineButton;
  
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
    boxNameInput.on.focus.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        boxNameInput.value = box.title;
        currentItem = null;
        itemSequenceInput.valueAsNumber = 0;
        itemNameInput.value = '';
        itemOption.value = 'attribute';
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
    itemOption.on.change.add((MouseEvent e) {
      if (currentItem != null) {
        currentItem.name = itemNameInput.value;
        currentItem.category = itemOption.value;
        itemNameInput.select();
      }
    });
    
    itemSequenceInput = document.query('#itemSequence');
    
    addItemButton = document.query('#addItem');
    addItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        Item item = new Item(box, itemNameInput.value, itemOption.value);
        itemSequenceInput.valueAsNumber = item.sequence;
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
          itemOption.value = item.category;
          itemSequenceInput.valueAsNumber = item.sequence;
          itemNameInput.select();
        } else {
          currentItem = null;
          itemSequenceInput.valueAsNumber = 0;
        }
      }
    });
    
    setItemButton = document.query('#setItem');
    setItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          currentItem.name = itemNameInput.value;
          currentItem.category = itemOption.value;
          currentItem.sequence = itemSequenceInput.valueAsNumber;
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
            itemSequenceInput.valueAsNumber = 0;
            itemNameInput.value = '';
            itemOption.value = 'attribute';
          }
        }
      }
    });
    
    lineOption = document.query('#lineCategory');
    lineOption.on.change.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.category = lineOption.value;
        
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
    });
    
    getLineButton = document.query('#getLine');
    getLineButton.on.click.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        lineOption.value = line.category;
        
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
    });
    
    setLineButton = document.query('#setLine');
    setLineButton.on.click.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {   
        line.box1box2Min = line12MinInput.value.trim();
        line.box1box2Max = line12MaxInput.value.trim();
        if (line.box1box2Min == '1' && line.box1box2Max == '1') {
          line.box1box2Id = line12IdCheckbox.checked;
        } else {
          line12IdCheckbox.checked = false;
          line.box1box2Id = false;
        }
        line.box1box2Name = line12NameInput.value.trim();
        
        line.box2box1Min = line21MinInput.value.trim();
        line.box2box1Max = line21MaxInput.value.trim();
        if (line.box2box1Min == '1' && line.box2box1Max == '1') {
          line.box2box1Id = line21IdCheckbox.checked;
        } else {
          line21IdCheckbox.checked = false;
          line.box2box1Id = false;
        }  
        line.box2box1Name = line21NameInput.value.trim();
      }
    });
    
    line12Box1Label = document.query('#line12Box1');
    line12Box2Label = document.query('#line12Box2');
    line12MinInput = document.query('#line12Min');
    line12MaxInput = document.query('#line12Max');
    line12IdCheckbox = document.query('#line12Id');
    line12NameInput = document.query('#line12Name');
    
    line21Box2Label = document.query('#line21Box2');
    line21Box1Label = document.query('#line21Box1');
    line21MinInput = document.query('#line21Min');
    line21MaxInput = document.query('#line21Max');
    line21IdCheckbox = document.query('#line21Id');
    line21NameInput = document.query('#line21Name');
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

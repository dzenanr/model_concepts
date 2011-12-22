class ToolBar {
  
  static final int SELECT = 1;
  static final int BOX = 2;
  static final int LINE = 3;
  
  final Board board;
  
  int _onTool;
  bool _selectToolDblClicked;
  
  ButtonElement selectButton;
  ButtonElement boxButton;
  ButtonElement lineButton;
  
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
      _selectToolDblClicked = true;
    });
    
    boxButton.on.click.add((MouseEvent e) {
      onTool(BOX);
    });
    boxButton.on.dblClick.add((MouseEvent e) {
      onTool(BOX);
      _selectToolDblClicked = false; 
    });
    
    lineButton.on.click.add((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.on.dblClick.add((MouseEvent e) {
      onTool(LINE);
      _selectToolDblClicked = false;
    });
    
    onTool(SELECT);
    _selectToolDblClicked = true;
  }
  
  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton.style.borderColor = "#000000"; // black
      boxButton.style.borderColor = "#808080"; // grey
      lineButton.style.borderColor = "#808080"; // grey
    } else if (_onTool == BOX) {
      selectButton.style.borderColor = "#808080"; // grey
      boxButton.style.borderColor = "#000000"; // black
      lineButton.style.borderColor = "#808080"; // grey
    } else if (_onTool == LINE) {
      selectButton.style.borderColor = "#808080"; // grey
      boxButton.style.borderColor = "#808080"; // grey
      lineButton.style.borderColor = "#000000"; // black
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
  
  void selectToolOn()  {
    if (_selectToolDblClicked) {
      onTool(SELECT);
    }
  }
  
}

class ToolBar {
  
  static final int SELECT = 1;
  static final int BOX = 2;
  
  final Board board;
  
  int _selectedButton = SELECT;
  
  ToolBar(this.board) {
    ButtonElement selectButton = document.query('#select');
    ButtonElement boxButton = document.query('#box');
    
    // Tool bar events.
    selectButton.on.click.add((MouseEvent e) {
      _selectedButton = SELECT;
    });
    boxButton.on.click.add((MouseEvent e) {
      _selectedButton = BOX;
      boxButton.style.maskBoxImage;
    });
  }
  
  bool isSelect() {
    if (_selectedButton == SELECT) {
      return true; 
    }
    return false;
  }
  
  bool isBox() {
    if (_selectedButton == BOX) {
      return true; 
    }
    return false;
  }
  
  selectButton() => _selectedButton = SELECT;
  
}

class ToolBar {
  
  static final int SELECT = 1;
  static final int BOX = 2;
  
  final Board board;
  
  int _selectedButton = BOX;
  
  ToolBar(this.board) {
    // Tool bar events.
    /*
    document.query('#select').on.click.add((MouseEvent e) {
      _selectedButton = SELECT;
    });
    document.query('#box').on.click.add((MouseEvent e) {
      _selectedButton = BOX;
    });
    */
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
  
}

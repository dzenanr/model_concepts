class MenuBar {
  
  final Board board;
  
  ButtonElement selectBoxesButton;
  ButtonElement deleteSelectedBoxesButton;
  ButtonElement hideSelectedBoxesButton;
  ButtonElement showHiddenBoxesButton;
  
  MenuBar(this.board) {
    selectBoxesButton = document.query('#select-boxes');
    deleteSelectedBoxesButton = document.query('#delete-selected-boxes');
    hideSelectedBoxesButton = document.query('#hide-selected-boxes');
    showHiddenBoxesButton = document.query('#show-hidden-boxes');
    
    // Menu bar events.
    selectBoxesButton.on.click.add((MouseEvent e) {
      board.selectBoxes();
    });
    
    deleteSelectedBoxesButton.on.click.add((MouseEvent e) {
      board.deleteSelectedBoxes();
    });
    
    hideSelectedBoxesButton.on.click.add((MouseEvent e) {
      board.hideSelectedBoxes();
    });
    
    showHiddenBoxesButton.on.click.add((MouseEvent e) {
      board.showHiddenBoxes();
    });
  }

}

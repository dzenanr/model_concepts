class MenuBar {
  
  final Board board;
  
  // Edit
  ButtonElement selectAllButton;
  ButtonElement deleteSelectionButton;
  
  // View
  ButtonElement hideSelectionButton;
  ButtonElement showHiddenSelectionButton;
  
  // Utility
  ButtonElement createBoxesInDiagonalButton;
  ButtonElement createBoxesAsTilesButton;
  
  MenuBar(this.board) {
    selectAllButton = document.query('#select-all');
    deleteSelectionButton = document.query('#delete-selection');
    
    hideSelectionButton = document.query('#hide-selection');
    showHiddenSelectionButton = document.query('#show-hidden-selection');
    
    createBoxesInDiagonalButton = document.query('#create-boxes-in-diagonal');
    createBoxesAsTilesButton = document.query('#create-boxes-as-tiles');
    
    // Menu bar events.
    selectAllButton.on.click.add((MouseEvent e) {
      board.select();
    });
    deleteSelectionButton.on.click.add((MouseEvent e) {
      board.deleteSelection();
    });
    
    hideSelectionButton.on.click.add((MouseEvent e) {
      board.hideSelection();
    });
    showHiddenSelectionButton.on.click.add((MouseEvent e) {
      board.showHiddenSelection();
    });
    
    createBoxesInDiagonalButton.on.click.add((MouseEvent e) {
      board.createBoxesInDiagonal();
    });
    createBoxesAsTilesButton.on.click.add((MouseEvent e) {
      board.createBoxesAsTiles();
    });
  }

}

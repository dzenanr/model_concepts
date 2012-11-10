class MenuBar {

  final Board board;

  // Model
  InputElement modelNameInput;
  ButtonElement openModelButton;
  ButtonElement saveModelButton;
  ButtonElement closeModelButton;

  // Edit
  ButtonElement deleteSelectionButton;

  // Select
  ButtonElement selectAllButton;
  ButtonElement selectBoxesButton;
  ButtonElement selectLinesButton;
  ButtonElement selectBoxLinesButton;
  ButtonElement selectLinesBetweenBoxesButton;

  // View
  ButtonElement increaseSelectionHeightButton;
  ButtonElement decreaseSelectionHeightButton;
  ButtonElement increaseSelectionWidthButton;
  ButtonElement decreaseSelectionWidthButton;
  ButtonElement increaseSelectionSizeButton;
  ButtonElement decreaseSelectionSizeButton;
  ButtonElement hideSelectionButton;
  ButtonElement hideNonSelectionButton;
  ButtonElement showHiddenButton;

  // Create
  ButtonElement createBoxesInDiagonalButton;
  ButtonElement createBoxesAsTilesButton;

  MenuBar(this.board) {
    modelNameInput = document.query('#model-name');
    openModelButton = document.query('#open-model');
    saveModelButton = document.query('#save-model');
    closeModelButton = document.query('#close-model');

    deleteSelectionButton = document.query('#delete-selection');

    selectAllButton = document.query('#select-all');
    selectBoxesButton = document.query('#select-boxes');
    selectLinesButton = document.query('#select-lines');
    selectBoxLinesButton = document.query('#select-box-lines');
    selectLinesBetweenBoxesButton = document.query('#select-lines-between-boxes');

    increaseSelectionHeightButton = document.query('#increase-selection-height');
    decreaseSelectionHeightButton = document.query('#decrease-selection-height');
    increaseSelectionWidthButton = document.query('#increase-selection-width');
    decreaseSelectionWidthButton = document.query('#decrease-selection-width');
    increaseSelectionSizeButton = document.query('#increase-selection-size');
    decreaseSelectionSizeButton = document.query('#decrease-selection-size');
    hideSelectionButton = document.query('#hide-selection');
    hideNonSelectionButton = document.query('#hide-non-selection');
    showHiddenButton = document.query('#show-hidden');

    createBoxesInDiagonalButton = document.query('#create-boxes-in-diagonal');
    createBoxesAsTilesButton = document.query('#create-boxes-as-tiles');

    // Menu bar events.
    openModelButton.on.click.add((MouseEvent e) {
      String modelName = modelNameInput.value.trim();
      board.openModel(modelName);
    });
    saveModelButton.on.click.add((MouseEvent e) {
      String modelName = modelNameInput.value.trim();
      board.saveModel(modelName);
    });
    closeModelButton.on.click.add((MouseEvent e) {
      //modelNameInput.value = '';
      board.closeModel();
    });

    deleteSelectionButton.on.click.add((MouseEvent e) {
      board.deleteSelection();
    });

    selectAllButton.on.click.add((MouseEvent e) {
      board.select();
    });
    selectBoxesButton.on.click.add((MouseEvent e) {
      board.selectBoxes();
    });
    selectLinesButton.on.click.add((MouseEvent e) {
      board.selectLines();
    });
    selectBoxLinesButton.on.click.add((MouseEvent e) {
      board.selectBoxLines();
    });
    selectLinesBetweenBoxesButton.on.click.add((MouseEvent e) {
      board.selectLinesBetweenBoxes();
    });

    increaseSelectionHeightButton.on.click.add((MouseEvent e) {
      board.increaseHeightOfSelectedBoxes();
    });
    decreaseSelectionHeightButton.on.click.add((MouseEvent e) {
      board.decreaseHeightOfSelectedBoxes();
    });
    increaseSelectionWidthButton.on.click.add((MouseEvent e) {
      board.increaseWidthOfSelectedBoxes();
    });
    decreaseSelectionWidthButton.on.click.add((MouseEvent e) {
      board.decreaseWidthOfSelectedBoxes();
    });
    increaseSelectionSizeButton.on.click.add((MouseEvent e) {
      board.increaseSizeOfSelectedBoxes();
    });
    decreaseSelectionSizeButton.on.click.add((MouseEvent e) {
      board.decreaseSizeOfSelectedBoxes();
    });
    hideSelectionButton.on.click.add((MouseEvent e) {
      board.hideSelection();
    });
    hideNonSelectionButton.on.click.add((MouseEvent e) {
      board.hideNonSelection();
    });
    showHiddenButton.on.click.add((MouseEvent e) {
      board.showHidden();
    });

    createBoxesInDiagonalButton.on.click.add((MouseEvent e) {
      board.createBoxesInDiagonal();
    });
    createBoxesAsTilesButton.on.click.add((MouseEvent e) {
      board.createBoxesAsTiles();
    });
  }

}

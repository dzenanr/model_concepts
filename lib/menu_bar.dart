part of model_concepts;

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
    openModelButton.onClick.listen((MouseEvent e) {
      String modelName = modelNameInput.value.trim();
      board.openModel(modelName);
    });
    saveModelButton.onClick.listen((MouseEvent e) {
      String modelName = modelNameInput.value.trim();
      board.saveModel(modelName);
    });
    closeModelButton.onClick.listen((MouseEvent e) {
      //modelNameInput.value = '';
      board.closeModel();
    });

    deleteSelectionButton.onClick.listen((MouseEvent e) {
      board.deleteSelection();
    });

    selectAllButton.onClick.listen((MouseEvent e) {
      board.select();
    });
    selectBoxesButton.onClick.listen((MouseEvent e) {
      board.selectBoxes();
    });
    selectLinesButton.onClick.listen((MouseEvent e) {
      board.selectLines();
    });
    selectBoxLinesButton.onClick.listen((MouseEvent e) {
      board.selectBoxLines();
    });
    selectLinesBetweenBoxesButton.onClick.listen((MouseEvent e) {
      board.selectLinesBetweenBoxes();
    });

    increaseSelectionHeightButton.onClick.listen((MouseEvent e) {
      board.increaseHeightOfSelectedBoxes();
    });
    decreaseSelectionHeightButton.onClick.listen((MouseEvent e) {
      board.decreaseHeightOfSelectedBoxes();
    });
    increaseSelectionWidthButton.onClick.listen((MouseEvent e) {
      board.increaseWidthOfSelectedBoxes();
    });
    decreaseSelectionWidthButton.onClick.listen((MouseEvent e) {
      board.decreaseWidthOfSelectedBoxes();
    });
    increaseSelectionSizeButton.onClick.listen((MouseEvent e) {
      board.increaseSizeOfSelectedBoxes();
    });
    decreaseSelectionSizeButton.onClick.listen((MouseEvent e) {
      board.decreaseSizeOfSelectedBoxes();
    });
    hideSelectionButton.onClick.listen((MouseEvent e) {
      board.hideSelection();
    });
    hideNonSelectionButton.onClick.listen((MouseEvent e) {
      board.hideNonSelection();
    });
    showHiddenButton.onClick.listen((MouseEvent e) {
      board.showHidden();
    });

    createBoxesInDiagonalButton.onClick.listen((MouseEvent e) {
      board.createBoxesInDiagonal();
    });
    createBoxesAsTilesButton.onClick.listen((MouseEvent e) {
      board.createBoxesAsTiles();
    });
  }

}

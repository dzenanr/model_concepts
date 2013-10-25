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
    modelNameInput = document.querySelector('#model-name');
    openModelButton = document.querySelector('#open-model');
    saveModelButton = document.querySelector('#save-model');
    closeModelButton = document.querySelector('#close-model');

    deleteSelectionButton = document.querySelector('#delete-selection');

    selectAllButton = document.querySelector('#select-all');
    selectBoxesButton = document.querySelector('#select-boxes');
    selectLinesButton = document.querySelector('#select-lines');
    selectBoxLinesButton = document.querySelector('#select-box-lines');
    selectLinesBetweenBoxesButton = document.querySelector('#select-lines-between-boxes');

    increaseSelectionHeightButton = document.querySelector('#increase-selection-height');
    decreaseSelectionHeightButton = document.querySelector('#decrease-selection-height');
    increaseSelectionWidthButton = document.querySelector('#increase-selection-width');
    decreaseSelectionWidthButton = document.querySelector('#decrease-selection-width');
    increaseSelectionSizeButton = document.querySelector('#increase-selection-size');
    decreaseSelectionSizeButton = document.querySelector('#decrease-selection-size');
    hideSelectionButton = document.querySelector('#hide-selection');
    hideNonSelectionButton = document.querySelector('#hide-non-selection');
    showHiddenButton = document.querySelector('#show-hidden');

    createBoxesInDiagonalButton = document.querySelector('#create-boxes-in-diagonal');
    createBoxesAsTilesButton = document.querySelector('#create-boxes-as-tiles');

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

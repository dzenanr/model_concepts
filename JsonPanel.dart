class JsonPanel {
  
  final Board board;
  
  TextAreaElement modelJsonTextArea;
  ButtonElement fromModelToJsonButton;
  ButtonElement fromJsonToModelButton;
  ButtonElement clearButton;
  
  JsonPanel(this.board) {
    modelJsonTextArea = document.query('#modelJson');
    fromModelToJsonButton = document.query('#fromModelToJson');
    fromModelToJsonButton.on.click.add((MouseEvent e) {
      modelJsonTextArea.value =  board.toJson();
      modelJsonTextArea.select();
    });
    fromJsonToModelButton = document.query('#fromJsonToModel');
    fromJsonToModelButton.on.click.add((MouseEvent e) {
      board.fromJson(modelJsonTextArea.value);
    });
    clearButton = document.query('#clearJson');
    clearButton.on.click.add((MouseEvent e) {
      clear();
    });
  }
  
  void clear() {
    modelJsonTextArea.value = '';
  }

}

class JsonPanel {
  
  final Board board;
  
  TextAreaElement modelJsonTextArea;
  ButtonElement fromModelToJsonButton;
  ButtonElement fromJsonToModelButton;
  
  JsonPanel(this.board) {
    modelJsonTextArea = document.query('#modelJson');
    fromModelToJsonButton = document.query('#fromModelToJson');
    fromModelToJsonButton.on.click.add((MouseEvent e) {
      modelJsonTextArea.value = board.toJson();
    });
    fromJsonToModelButton = document.query('#fromJsonToModel');
    fromJsonToModelButton.on.click.add((MouseEvent e) {
      board.fromJson(modelJsonTextArea.value);
    });
  }

}

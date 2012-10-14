class JsonPanel {

  final Board board;

  TextAreaElement modelJsonTextArea;
  ButtonElement fromModelToJsonButton;
  ButtonElement fromJsonToModelButton;
  ButtonElement clearJsonButton;

  ParagraphElement prettyParagraph;
  ButtonElement prettyJsonButton;
  ButtonElement clearPrettyButton;

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
    clearJsonButton = document.query('#clearJson');
    clearJsonButton.on.click.add((MouseEvent e) {
      clearJson();
    });

    prettyParagraph = document.query('#fromJsonToPretty');
    prettyParagraph.contentEditable = "true";

    prettyJsonButton = document.query('#prettyJson');
    prettyJsonButton.on.click.add((MouseEvent e) {
      prettyParagraph.innerHTML = prettyJson(modelJsonTextArea.value);
    });
    clearPrettyButton = document.query('#clearPretty');
    clearPrettyButton.on.click.add((MouseEvent e) {
      clearPrettyJson();
    });
  }
  
  void clearJson() {
    modelJsonTextArea.value = '';
  }
  
  void clearPrettyJson() {
    prettyParagraph.innerHTML = '';
  }

  // based on http://ketanjetty.com/coldfusion/javascript/format-json/
  String prettyJson(String json) {
    var pretty = '';
    var position = 0;
    var indent = '&nbsp;&nbsp;&nbsp;&nbsp;';
    var newLine = '<br />';
    var char = '';
    for (var i = 0; i < json.length; i++) {
      char = json.substring(i, i+1);
      if (char == '}' || char == ']') {
        pretty = '${pretty}${newLine}';
        position = position - 1;
        for (var j = 0; j < position; j++) {
          pretty = '${pretty}${indent}';
        }
      }
      pretty = '${pretty}${char}';
      if (char == '{' || char == '[' || char == ',') {
        pretty = '${pretty}${newLine}';
        if (char == '{' || char == '[') {
          position = position + 1;
        }
        for (var k = 0; k < position; k++) {
          pretty = '${pretty}${indent}';
        }
      }
    }
    return pretty;
  }

}

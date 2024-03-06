part of model_concepts;

class JsonPanel {
  final Board board;

  TextAreaElement? modelJsonTextArea;
  ButtonElement? fromModelToJsonButton;
  ButtonElement? fromJsonToModelButton;
  ButtonElement? clearJsonButton;

  ParagraphElement? prettyParagraph;
  ButtonElement? prettyJsonButton;
  ButtonElement? clearPrettyButton;

  JsonPanel(this.board) {
    modelJsonTextArea = document.querySelector('#modelJson') as TextAreaElement;

    fromModelToJsonButton =
        document.querySelector('#fromModelToJson') as ButtonElement;
    fromModelToJsonButton?.onClick.listen((MouseEvent e) {
      modelJsonTextArea?.value = board.toJson();
      modelJsonTextArea?.select();
    });
    fromJsonToModelButton =
        document.querySelector('#fromJsonToModel') as ButtonElement;
    fromJsonToModelButton?.onClick.listen((MouseEvent e) {
      board.fromJson(modelJsonTextArea?.value);
    });
    clearJsonButton = document.querySelector('#clearJson') as ButtonElement;
    clearJsonButton?.onClick.listen((MouseEvent e) {
      clearJson();
    });

    prettyParagraph =
        document.querySelector('#fromJsonToPretty') as ParagraphElement;
    prettyParagraph?.contentEditable = "true";

    prettyJsonButton = document.querySelector('#prettyJson') as ButtonElement;
    prettyJsonButton?.onClick.listen((MouseEvent e) {
      prettyParagraph?.innerHtml = prettyJson(modelJsonTextArea?.value);
    });
    clearPrettyButton = document.querySelector('#clearPretty') as ButtonElement;
    clearPrettyButton?.onClick.listen((MouseEvent e) {
      clearPrettyJson();
    });
  }

  void clearJson() {
    modelJsonTextArea?.value = '';
  }

  void clearPrettyJson() {
    prettyParagraph?.innerHtml = '';
  }

  // based on http://ketanjetty.com/coldfusion/javascript/format-json/
  String prettyJson(String? json) {
    if (json == null) {
      return '';
    }

    var pretty = '';
    var position = 0;
    var indent = '&nbsp;&nbsp;&nbsp;&nbsp;';
    var newLine = '<br />';
    var char = '';
    for (var i = 0; i < json.length; i++) {
      char = json.substring(i, i + 1);
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

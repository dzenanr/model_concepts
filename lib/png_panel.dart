part of model_concepts;

class PngPanel {

final Board board;

  ImageElement modelImage;
  ButtonElement fromModelToPngButton;
  ButtonElement clearButton;

  PngPanel(this.board) {
    modelImage = document.querySelector('#modelImage');
    fromModelToPngButton = document.querySelector('#fromModelToPng');
    fromModelToPngButton.onClick.listen((MouseEvent e) {
      modelImage.src = board.canvas.toDataUrl("image/png");
      show();
    });
    clearButton = document.querySelector('#clearImage');
    clearButton.onClick.listen((MouseEvent e) {
      hide();
    });
  }

  void hide() {
    modelImage.hidden = true;
  }

  void show() {
    modelImage.hidden = false;
  }

}

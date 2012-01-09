class PngPanel {
  
final Board board;
  
  ButtonElement fromModelToPngButton;
  
  PngPanel(this.board) {
    fromModelToPngButton = document.query('#fromModelToPng');
    fromModelToPngButton.on.click.add((MouseEvent e) {
      //board.toPng();
      toPng();
    });
  }
  
  void toPng() {
    ImageElement modelImage = document.query('#modelImage');
    modelImage.src = board.canvas.toDataURL("image/png");
  }
  
}



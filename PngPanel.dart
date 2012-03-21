class PngPanel {
  
final Board board;
  
  ImageElement modelImage;
  ButtonElement fromModelToPngButton;
  ButtonElement removeButton;
  
  PngPanel(this.board) {
    modelImage = document.query('#modelImage');
    fromModelToPngButton = document.query('#fromModelToPng');
    fromModelToPngButton.on.click.add((MouseEvent e) {
      modelImage.src = board.canvas.toDataURL("image/png");
      modelImage.hidden = false;
    });
    removeButton = document.query('#remove');
    removeButton.on.click.add((MouseEvent e) {
      modelImage.hidden = true;
    });
  }
  
}



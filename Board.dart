class Board {
  
  int x = 0;
  int y = 0;
  int width;
  int height;
  
  CanvasRenderingContext2D context;
  
  Board(CanvasElement canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    border();
    init();
  }
  
  void init() {
    new Box(this, 20, 20, 40, 60);
    new Box(this, 120, 40, 60, 40);
  }
  
  void border() {
    context.beginPath();
    context.rect(x, y, width, height);
    context.closePath();
    context.stroke();
  }

}

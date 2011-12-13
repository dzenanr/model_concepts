class Board {
  
  final int INTERVAL = 10; // ms
  
  int width;
  int height;
  
  CanvasRenderingContext2D context;
  
  Box box1;
  Box box2;
  Box box3;
  
  Board(CanvasElement canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    border();
    init();
    // Redraw every INTERVAL ms.
    document.window.setInterval(redraw, INTERVAL);
  }
  
  void init() {
    box1 = new Box(this, 20, 20, 80, 40);
    box2 = new Box(this, 120, 220, 40, 80);
    box3 = new Box(this, 60, 80, 80, 40);
  }
  
  void border() {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.closePath();
    context.stroke();
  }
  
  void clear() {
    context.clearRect(0, 0, width, height);
    border();
  } 
  
  void redraw() {
    clear(); 
    box1.draw();
    box2.draw();
    box3.draw();
  }

}

class Item {
  
  final Box box;
  
  String name;
  String category;
  
  Item(this.box, String name, String category) {
    this.name = name;
    this.category = category;
    box.items.add(this);
  }

}

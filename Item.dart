class Item {
  
  final Box box;
  
  int sequence; // sequence number within the box: 10, 20, ...
  String name;
  String category; // attribute, guid, identifier, required
  String init = '';
  
  Item(this.box, this.name, this.category) {
    sequence = box.findLastItemSequence() + 10;
    box.items.add(this);
  }
  
  Map<String, Object> toJson() {
    Map<String, Object> itemMap = new Map<String, Object>();
    itemMap["sequence"] = sequence;
    itemMap["name"] = name;
    itemMap["category"] = category; 
    itemMap["init"] = init;
    return itemMap;
  }

}

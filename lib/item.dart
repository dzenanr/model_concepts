part of model_concepts;

class Item {

  final Box box;

  int sequence; // sequence number within the box: 10, 20, ...
  String _name;
  String category; // attribute, guid, identifier, required
  String type; // String, num, int, double, bool, DateTime, dynamic, Uri, Email, Other
  String init = '';
  bool essential = false; // will it be displayed in a list (table)?
  bool sensitive = false; // will it be hidden in a display?

  Item(this.box, this._name, this.category) {
    this.category = category;
    sequence = box.findLastItemSequence() + 10;
    box.items.add(this);
  }

  String get name => _name;

  set name(String name) {
    if (name != null && name.trim() != '') {
      _name = name;
    }
  }

  display() {
    print('box: ${box.title}; item: ${name}');
  }

  Map<String, Object> toJson() {
    Map<String, Object> itemMap = new Map<String, Object>();
    itemMap["sequence"] = sequence;
    itemMap["name"] = name;
    itemMap["category"] = category;
    itemMap["type"] = type;
    itemMap["init"] = init;
    itemMap["essential"] = essential;
    itemMap["sensitive"] = sensitive;
    return itemMap;
  }

}

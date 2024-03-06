part of model_concepts;

class ToolBar {
  static const int SELECT = 1;
  static const int BOX = 2;
  static const int LINE = 3;

  final Board board;

  late int _onTool;
  late int _fixedTool;

  ButtonElement? selectButton;
  ButtonElement? boxButton;
  ButtonElement? lineButton;
  InputElement? canvasWidthInput;
  InputElement? canvasHeightInput;

  InputElement? boxNameInput;
  InputElement? boxEntryCheckbox;
  InputElement? itemNameInput;
  SelectElement? itemCategorySelect;
  SelectElement? itemTypeSelect;
  InputElement? itemInitInput;
  InputElement? itemEssentialCheckbox;
  InputElement? itemSensitiveCheckbox;
  ButtonElement? getItemButton;
  ButtonElement? getNextItemButton;
  ButtonElement? getPreviousItemButton;
  ButtonElement? moveDownItemButton;
  ButtonElement? moveUpItemButton;
  ButtonElement? removeItemButton;

  Item? currentItem;

  SelectElement? lineSelect;
  InputElement? lineInternalCheckbox;
  ButtonElement? eraseLineNamesButton;
  ButtonElement? genLineNamesButton;

  LabelElement? line12Box1Label;
  LabelElement? line12Box2Label;
  InputElement? line12MinInput;
  InputElement? line12MaxInput;
  InputElement? line12IdCheckbox;
  InputElement? line12NameInput;

  LabelElement? line21Box2Label;
  LabelElement? line21Box1Label;
  InputElement? line21MinInput;
  InputElement? line21MaxInput;
  InputElement? line21IdCheckbox;
  InputElement? line21NameInput;

  ToolBar(this.board) {
    selectButton = document.querySelector('#select') as ButtonElement;
    boxButton = document.querySelector('#box') as ButtonElement;
    lineButton = document.querySelector('#line') as ButtonElement;

    // Tool bar events.
    selectButton?.onClick.listen((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton?.onDoubleClick.listen((Event e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });

    boxButton?.onClick.listen((MouseEvent e) {
      onTool(BOX);
    });
    boxEntryCheckbox = document.querySelector('#boxEntry') as InputElement;
    boxEntryCheckbox?.onChange.listen((Event e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox?.checked ?? false;
      }
    });
    boxButton?.onDoubleClick.listen((Event e) {
      onTool(BOX);
      _fixedTool = BOX;
    });

    lineButton?.onClick.listen((MouseEvent e) {
      onTool(LINE);
    });
    lineButton?.onDoubleClick.listen((Event e) {
      onTool(LINE);
      _fixedTool = LINE;
    });

    onTool(SELECT);
    _fixedTool = SELECT;

    canvasWidthInput = document.querySelector('#canvasWidth') as InputElement;
    canvasHeightInput = document.querySelector('#canvasHeight') as InputElement;
    canvasWidthInput?.valueAsNumber = board.width;
    canvasWidthInput?.onChange.listen((Event e) {
      board.width = canvasWidthInput?.valueAsNumber ?? 1000;
    });
    canvasHeightInput?.valueAsNumber = board.height;
    canvasHeightInput?.onChange.listen((Event e) {
      board.height = canvasHeightInput?.valueAsNumber ?? 1000;
    });

    boxNameInput = document.querySelector('#boxName') as InputElement;
    boxNameInput?.onChange.listen((Event e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        String? boxName = boxNameInput?.value?.trim();
        if (boxName != '') {
          Box? otherBox = board.findBox(boxName);
          if (otherBox == null) {
            box.title = boxName ?? 'Default Title';
            itemNameInput?.focus();
          }
        }
      }
    });
    boxNameInput?.onInput.listen((Event e) {
      Box? box = board.lastBoxSelected;
      if (box == null) {
        boxNameInput?.value = '';
      }
    });

    boxEntryCheckbox = document.querySelector('#boxEntry') as InputElement;
    boxEntryCheckbox?.onChange.listen((Event e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox?.checked ?? false;
      }
    });

    setItem() {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        String? itemName = itemNameInput?.value?.trim();
        if (itemName != null && itemName != '') {
          if (currentItem != null) {
            if (currentItem?.box == box) {
              Item? item = box.findItem(itemName);
              if (item == null) {
                currentItem?.name = itemName;
              }
              itemNameInput?.select();
            }
          } else {
            // current item is null
            Item? item = box.findItem(itemName);
            if (item == null) {
              Item newItem = new Item(
                  box, itemName, itemCategorySelect?.value ?? 'attribute');
              newItem.type = itemTypeSelect?.value ?? 'String';
              newItem.init = itemInitInput?.value?.trim() ?? 'default value';
              if (newItem.category == 'identifier') {
                itemEssentialCheckbox?.checked = true;
              }
              newItem.essential = itemEssentialCheckbox?.checked ?? false;
              newItem.sensitive = itemSensitiveCheckbox?.checked ?? false;
              itemNameInput?.value = '';
            } else {
              // item is not null
              itemNameInput?.value = item.name;
              itemCategorySelect?.value = item.category;
              itemTypeSelect?.value = item.type;
              itemInitInput?.value = item.init;
              itemEssentialCheckbox?.checked = item.essential;
              itemSensitiveCheckbox?.checked = item.sensitive;
              currentItem = item;
              itemNameInput?.select();
            }
          }
        }
      }
    }

    itemNameInput = document.querySelector('#itemName') as InputElement;
    itemNameInput?.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        setItem();
      }
    });
    itemNameInput?.onInput.listen((Event e) {
      Box? box = board.lastBoxSelected;
      if (box == null) {
        itemNameInput?.value = '';
      }
    });

    itemCategorySelect =
        document.querySelector('#itemCategory') as SelectElement;
    itemCategorySelect?.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem?.category = itemCategorySelect?.value ?? 'attribute';
        itemNameInput?.select();
      } else {
        itemNameInput?.focus();
      }
      if (itemCategorySelect?.value == 'identifier') {
        itemEssentialCheckbox?.checked = true;
      } else if (itemCategorySelect?.value == 'attribute') {
        itemEssentialCheckbox?.checked = false;
      }
    });

    itemTypeSelect = document.querySelector('#itemType') as SelectElement;
    itemTypeSelect?.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem?.type = itemTypeSelect?.value ?? 'String';
        itemNameInput?.select();
      } else {
        itemNameInput?.focus();
      }
    });

    itemInitInput = document.querySelector('#itemInit') as InputElement;
    itemInitInput?.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem?.init = itemInitInput?.value?.trim() ?? 'default value';
        itemNameInput?.select();
      } else {
        itemNameInput?.focus();
      }
    });

    itemEssentialCheckbox =
        document.querySelector('#itemEssential') as InputElement;
    itemEssentialCheckbox?.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem?.essential = itemEssentialCheckbox?.checked ?? false;
        itemNameInput?.select();
      } else {
        itemNameInput?.focus();
      }
    });

    itemSensitiveCheckbox =
        document.querySelector('#itemSensitive') as InputElement;
    itemSensitiveCheckbox?.onChange.listen((Event e) {
      if (currentItem != null) {
        currentItem?.sensitive = itemSensitiveCheckbox?.checked ?? false;
        itemNameInput?.select();
      } else {
        itemNameInput?.focus();
      }
    });

    getNextItemButton = document.querySelector('#getNextItem') as ButtonElement;
    getNextItemButton?.onClick.listen((MouseEvent e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item? nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            currentItem = nextItem;
            itemNameInput?.value = nextItem.name;
            itemCategorySelect?.value = nextItem.category;
            itemTypeSelect?.value = nextItem.type;
            itemInitInput?.value = nextItem.init;
            itemEssentialCheckbox?.checked = nextItem.essential;
            itemSensitiveCheckbox?.checked = nextItem.sensitive;
            itemNameInput?.select();
          } else {
            // next item is null
            currentItem = null;
            itemNameInput?.value = '';
            itemCategorySelect?.value = 'attribute';
            itemTypeSelect?.value = 'String';
            itemInitInput?.value = '';
            itemEssentialCheckbox?.checked = false;
            itemSensitiveCheckbox?.checked = false;
          }
        } else {
          // current item is null
          if (!box.items.isEmpty) {
            Item? firstItem = box.findFirstItem();
            currentItem = firstItem;
            itemNameInput?.value = firstItem?.name;
            itemCategorySelect?.value = firstItem?.category;
            itemTypeSelect?.value = firstItem?.type;
            itemInitInput?.value = firstItem?.init;
            itemEssentialCheckbox?.checked = firstItem?.essential;
            itemSensitiveCheckbox?.checked = firstItem?.sensitive;
            itemNameInput?.select();
          }
        }
      }
    });

    getPreviousItemButton =
        document.querySelector('#getPreviousItem') as ButtonElement;
    getPreviousItemButton?.onClick.listen((MouseEvent e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item? previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            currentItem = previousItem;
            itemNameInput?.value = previousItem.name;
            itemCategorySelect?.value = previousItem.category;
            itemTypeSelect?.value = previousItem.type;
            itemInitInput?.value = previousItem.init;
            itemEssentialCheckbox?.checked = previousItem.essential;
            itemSensitiveCheckbox?.checked = previousItem.sensitive;
            itemNameInput?.select();
          } else {
            currentItem = null;
            itemNameInput?.value = '';
            itemCategorySelect?.value = 'attribute';
            itemTypeSelect?.value = 'String';
            itemInitInput?.value = '';
            itemEssentialCheckbox?.checked = false;
            itemSensitiveCheckbox?.checked = false;
          }
        } else {
          if (!box.items.isEmpty) {
            Item? lastItem = box.findLastItem();
            currentItem = lastItem;
            itemNameInput?.value = lastItem?.name;
            itemCategorySelect?.value = lastItem?.category;
            itemTypeSelect?.value = lastItem?.type;
            itemInitInput?.value = lastItem?.init;
            itemEssentialCheckbox?.checked = lastItem?.essential;
            itemSensitiveCheckbox?.checked = lastItem?.sensitive;
            itemNameInput?.select();
          }
        }
      }
    });

    moveDownItemButton =
        document.querySelector('#moveDownItem') as ButtonElement;
    moveDownItemButton?.onClick.listen((MouseEvent e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item? nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            int nextSequence = nextItem.sequence;
            int currentSequence = currentItem?.sequence ?? 0;
            currentItem?.sequence = nextSequence;
            nextItem.sequence = currentSequence;
            itemNameInput?.select();
          } else {
            currentItem = null;
            itemNameInput?.value = '';
            itemCategorySelect?.value = 'attribute';
            itemTypeSelect?.value = 'String';
            itemInitInput?.value = '';
            itemEssentialCheckbox?.checked = false;
            itemSensitiveCheckbox?.checked = false;
          }
        }
      }
    });

    moveUpItemButton = document.querySelector('#moveUpItem') as ButtonElement;
    moveUpItemButton?.onClick.listen((MouseEvent e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item? previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            int previousSequence = previousItem.sequence;
            int currentSequence = currentItem?.sequence ?? 0;
            currentItem?.sequence = previousSequence;
            previousItem.sequence = currentSequence;
            itemNameInput?.select();
          } else {
            currentItem = null;
            itemNameInput?.value = '';
            itemCategorySelect?.value = 'attribute';
            itemTypeSelect?.value = 'String';
            itemInitInput?.value = '';
            itemEssentialCheckbox?.checked = false;
            itemSensitiveCheckbox?.checked = false;
          }
        }
      }
    });

    removeItemButton = document.querySelector('#removeItem') as ButtonElement;
    removeItemButton?.onClick.listen((MouseEvent e) {
      Box? box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          if (box.removeItem(currentItem)) {
            currentItem = null;
            itemNameInput?.value = '';
            itemCategorySelect?.value = 'attribute';
            itemTypeSelect?.value = 'String';
            itemInitInput?.value = '';
            itemEssentialCheckbox?.checked = false;
            itemSensitiveCheckbox?.checked = false;
          }
        }
      }
    });

    lineSelect = document.querySelector('#lineCategory') as SelectElement;
    lineSelect?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null && line.from.title != '' && line.to.title != '') {
        if (line.category == 'relationship') {
          if (lineSelect?.value == 'inheritance' ||
              lineSelect?.value == 'reflexive') {
            line.category = lineSelect?.value ?? 'relationship';
          } else if (lineSelect?.value == 'twin') {
            if (board.findTwinLine(line) != null) {
              line.category = lineSelect?.value ?? 'relationship';
            } else {
              lineSelect?.value = 'relationship';
            }
          }
        } else if (line.category == 'inheritance') {
          if (lineSelect?.value == 'relationship') {
            line.category = lineSelect?.value ?? 'inheritance';
          } else {
            lineSelect?.value = 'inheritance';
          }
        } else if (line.category == 'reflexive') {
          lineSelect?.value = 'reflexive';
        } else if (line.category == 'twin') {
          if (lineSelect?.value == 'relationship') {
            if (board.findTwinLine(line) == null) {
              line.category = lineSelect?.value ?? 'twin';
            } else {
              lineSelect?.value = 'twin';
            }
          } else {
            lineSelect?.value = 'twin';
          }
        }
      } else {
        lineSelect?.value = 'relationship';
      }
    });

    lineInternalCheckbox =
        document.querySelector('#lineInternal') as InputElement;
    lineInternalCheckbox?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.internal = lineInternalCheckbox?.checked ?? false;
        if (line.external) {
          line.to.entry = true;
        } else {
          var alreadyInternal = false;
          for (Line l in board.lines) {
            if (l.to == line.to) {
              if (l != line && l.internal) {
                alreadyInternal = true;
              }
            }
          }
          if (alreadyInternal) {
            line.internal = false;
            lineInternalCheckbox?.checked = false;
          } else {
            line.to.entry = false;
          }
        }
      }
    });
    eraseLineNamesButton =
        document.querySelector('#eraseLineNames') as ButtonElement;
    eraseLineNamesButton?.onClick.listen((MouseEvent e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.fromToName = '';
        line.toFromName = '';
      }
    });
    genLineNamesButton =
        document.querySelector('#genLineNames') as ButtonElement;
    genLineNamesButton?.onClick.listen((MouseEvent e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        if (line.twin) {
          Line? twinLine = board.findTwinLine(line);
          line.fromToName =
              '${line.putInEnglishPlural(line.to.title.toLowerCase())}1';
          line.toFromName = '${line.from.title.toLowerCase()}2';
          twinLine?.fromToName =
              '${line.putInEnglishPlural(twinLine.to.title.toLowerCase())}2';
          twinLine?.toFromName = '${twinLine.from.title.toLowerCase()}1';
        } else if (line.inheritance) {
          line.fromToName = 'as${line.to.title}';
          line.toFromName = 'is${line.from.title}';
        } else {
          if (line.fromToName == '') {
            if (line.fromToMax != '1') {
              line.fromToName =
                  line.putInEnglishPlural(line.to.title).toLowerCase();
            } else {
              line.fromToName = line.to.title.toLowerCase();
            }
          }
          if (line.toFromName == '') {
            if (line.toFromMax != '1') {
              line.toFromName =
                  line.putInEnglishPlural(line.from.title).toLowerCase();
            } else {
              line.toFromName = line.from.title.toLowerCase();
            }
          }
        }
      }
    });

    line12Box1Label = document.querySelector('#line12Box1') as LabelElement;
    line12Box2Label = document.querySelector('#line12Box2') as LabelElement;

    line12MinInput = document.querySelector('#line12Min') as InputElement;
    line12MinInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.fromToMin = line12MinInput?.value?.trim() ?? '0';
      }
    });

    line12MaxInput = document.querySelector('#line12Max') as InputElement;
    line12MaxInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.fromToMax = line12MaxInput?.value?.trim() ?? '0';
      }
    });

    line12IdCheckbox = document.querySelector('#line12Id') as InputElement;
    line12IdCheckbox?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        if (line.fromToMin == '1' && line.fromToMax == '1') {
          line.fromToId = line12IdCheckbox?.checked ?? false;
        } else {
          line12IdCheckbox?.checked = false;
          line.fromToId = false;
        }
      }
    });

    line12NameInput = document.querySelector('#line12Name') as InputElement;
    line12NameInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.fromToName = line12NameInput?.value?.trim() ?? '';
        line21NameInput?.focus();
      }
    });

    line21Box2Label = document.querySelector('#line21Box2') as LabelElement;
    line21Box1Label = document.querySelector('#line21Box1') as LabelElement;

    line21MinInput = document.querySelector('#line21Min') as InputElement;
    line21MinInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.toFromMin = line21MinInput?.value?.trim() ?? '';
      }
    });

    line21MaxInput = document.querySelector('#line21Max') as InputElement;
    line21MaxInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.toFromMax = line21MaxInput?.value?.trim() ?? '';
      }
    });

    line21IdCheckbox = document.querySelector('#line21Id') as InputElement;
    line21IdCheckbox?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        if (line.toFromMin == '1' && line.toFromMax == '1') {
          line.toFromId = line21IdCheckbox?.checked ?? false;
        } else {
          line21IdCheckbox?.checked = false;
          line.toFromId = false;
        }
      }
    });

    line21NameInput = document.querySelector('#line21Name') as InputElement;
    line21NameInput?.onChange.listen((Event e) {
      Line? line = board.lastLineSelected;
      if (line != null) {
        line.toFromName = line21NameInput?.value?.trim() ?? '';
      }
    });
  }

  void bringSelectedBox() {
    Box? box = board.lastBoxSelected;
    if (box != null) {
      boxNameInput?.value = box.title;
      boxEntryCheckbox?.checked = box.entry;
      currentItem = null;
      itemNameInput?.value = '';
      // the following code does not focus on indicated fields!?
      /*
      if (box.title == '') {
        boxNameInput.focus();
      } else {
        itemNameInput?.focus();
      }
      */
    }
  }

  void bringSelectedLine() {
    Line? line = board.lastLineSelected;
    if (line != null) {
      lineSelect?.value = line.category;
      lineInternalCheckbox?.checked = line.internal;

      line12Box1Label?.text = line.from.title;
      line12Box2Label?.text = line.to.title;
      line12MinInput?.value = line.fromToMin;
      line12MaxInput?.value = line.fromToMax;
      line12IdCheckbox?.checked = line.fromToId;
      line12NameInput?.value = line.fromToName;

      line21Box2Label?.text = line.to.title;
      line21Box1Label?.text = line.from.title;
      line21MinInput?.value = line.toFromMin;
      line21MaxInput?.value = line.toFromMax;
      line21IdCheckbox?.checked = line.toFromId;
      line21NameInput?.value = line.toFromName;
      // the following code does not focus on indicated fields!?
      /*
      if (line.fromToName == '') {
        line12NameInput.focus();
      } else {
        line21NameInput.focus();
      }
      */
    }
  }

  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton?.style.borderColor = Board.DEFAULT_LINE_COLOR;
      boxButton?.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton?.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == BOX) {
      selectButton?.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton?.style.borderColor = Board.DEFAULT_LINE_COLOR;
      lineButton?.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == LINE) {
      selectButton?.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton?.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton?.style.borderColor = Board.DEFAULT_LINE_COLOR;
    }
  }

  bool isSelectToolOn() {
    if (_onTool == SELECT) {
      return true;
    }
    return false;
  }

  bool isBoxToolOn() {
    if (_onTool == BOX) {
      return true;
    }
    return false;
  }

  bool isLineToolOn() {
    if (_onTool == LINE) {
      return true;
    }
    return false;
  }

  void backToFixedTool() {
    onTool(_fixedTool);
  }

  void backToSelectAsFixedTool() {
    onTool(SELECT);
    _fixedTool = SELECT;
  }
}

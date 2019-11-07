package zigzagless;

@:forward(addSlot,removeSlot,removeSlotAt,getSlots,forEach)
abstract Slots<S>(SlotsImpl<S>) {
  public function new<K,S>(
    columns: Int,
    putSlot: PutSlotProc<S>,
    moveSlot: MoveSlotProc<S>
  ) {
    this = new SlotsImpl(
      columns,
      putSlot,
      moveSlot
    );
  }
}

abstract PutSlotProc<S>(S -> Int -> Int -> Void) from (S -> Int -> Int -> Void) {
  inline public function call(slot:S, x: Int, y: Int) {
    this(slot, x, y);
  }
}

abstract MoveSlotProc<S>(S -> Int -> Int -> Int -> Int -> Void) from (S -> Int -> Int -> Int -> Int -> Void) {
  inline public function call(slot:S, x0: Int, y0: Int, x: Int, y: Int) {
    this(slot, x0, y0, x, y);
  }
}

private class SlotsImpl<S> implements SlotsMediator {
  
  var columns: Int;
  var putSlot: PutSlotProc<S>;
  var moveSlot: MoveSlotProc<S>;

  var slots = new Array<S>();

  public function new(
    columns: Int,
    putSlot: PutSlotProc<S>,
    moveSlot: MoveSlotProc<S>
  ) {
    if (0 >= columns) throw 'columns must be above 0';

    this.columns = columns;
    this.putSlot = putSlot;
    this.moveSlot = moveSlot;
  }

  public function addSlot(slot: S): Void {
    var newIndex = slots.length;
    slots.push(slot);

    var x = newIndex % columns;
    var y = Std.int(newIndex / columns);

    putSlot.call(slot, x, y);
  }

  public function removeSlot(slot: S): Bool {
    var index = slots.indexOf(slot);
    if (-1 == index) {
      return false;
    }
    removeSlotAt(index);
    return true;
  }

  public function removeSlotAt(index: Int): Null<S> {
    if (index >= slots.length) return null;

    var slot = slots[index];
    SlotsTool.remove(columns, this, index);

    return slot;
  }

  inline public function getSlots(): Array<S> {
    return slots.copy();
  }

  inline public function forEach(consumer: S -> Int -> Void) {
    for (i in 0...slots.length) {
      consumer(slots[i], i);
    }
  }

  public function getSize(): Int {
    return slots.length;
  }

  public function resize(newSize: Int): Void {
    slots.resize(newSize);
  }
  public function remove(index: Int): Void {
    slots[index] = null;
  }

  public function move(from: Int, to: Int): Void {
    var slot = slots[from];
    slots[to] = slot;
    slots[from] = null;

    var x0 = from % columns;
    var y0 = Std.int(from / columns);
    var x = to % columns;
    var y = Std.int(to / columns);

    moveSlot.call(slot, x0, y0, x, y);
  }
}
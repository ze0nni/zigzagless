package zigzagless;

import utest.Assert;
import utest.Async;

class SlotsTest extends utest.Test {
  
  function passPut<S>(slots: S, x: Int, y: Int) {
    //
  }

  function passMove<S>(slots: S, x0: Int, y0: Int, x: Int, y: Int) {
    //
  }

  function noPassPut<S>(slots: S, x: Int, y: Int) {
    throw "Not pass";
  }

  function noPassMove<S>(slots: S, x0: Int, y0: Int, x: Int, y: Int) {
    throw "Not pass";
  }

  function testColumnsAbove0() {
    Assert.raises(function () {
      new Slots(0, noPassPut, noPassMove);
    });
  }

  function testAddOneSlot() {
    var slots = new Slots(1, passPut, noPassMove);

    slots.addSlot("hello");
    var slotsArray = slots.getSlots();

    Assert.same(1, slotsArray.length);
    Assert.same(["hello"].join(","), slotsArray.join(","));
  }

  function testRemoveFirst() {
    var slots = new Slots(1, passPut, passMove);

    slots.addSlot("hello");
    slots.addSlot("world");
    var removedSlot = slots.removeSlotAt(0);
    var slotsArray = slots.getSlots();

    Assert.same("hello", removedSlot);
    Assert.same(1, slotsArray.length);
    Assert.same(["world"].join(","), slotsArray.join(","));
  }

  function testPutSlot() {
    var actions = new Array<String>();

    var slots = new Slots(
      2,
      function (s, x, y) {
        actions.push('${s} ${x} ${y}');
      },
      noPassMove
    );

    slots.addSlot("hello");
    slots.addSlot("world");
    slots.addSlot("!");

    Assert.same(
      ["hello 0 0", "world 1 0", "! 0 1"].join(","),
      actions.join(",")
    );
  }

  function testMoveSlot() {
    var actions = new Array<String>();

    var slots = new Slots(
      1,
      passPut,
      function (s, x0, y0, x, y) {
        actions.push('${s} ${x0} ${y0} ${x} ${y}');
      }
    );

    slots.addSlot("hello");
    slots.addSlot("world");
    slots.addSlot("!");
    slots.removeSlotAt(0);

    Assert.same(
      ["world 0 1 0 0", "! 0 2 0 1"].join(","),
      actions.join(",")
    );
  }
}
package permutator;

import utest.Assert;
import utest.Async;

import permutator.Slots;

private class LogMediator implements SlotsMediator {
    
    public var size(default, null): Int;
    var actions = new Array<String>();

    public function new(size: Int) {
        this.size = size;
    }

    public function getSize(): Int return size;

    public function resize(newSize: Int): Void {
        this.size = newSize;
        actions.push('resize ${newSize}');
    }

    public function remove(index: Int): Void {
        actions.push('remove ${index}');
    }

    public function move(from: Int, to: Int): Void {
        actions.push('move ${from} ${to}');
    }

    public function getActions(): Array<String> {
        return actions.copy();
    }
}

class SlotesTest extends utest.Test {

    function testRemoveOneElement() {
        var log = new LogMediator(1);

        Slots.remove(
            0,
            log
        );

        Assert.same(
            ["remove 0","resize 0"],
            log.getActions()
        );
    }

}
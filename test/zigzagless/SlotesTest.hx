package zigzagless;

import utest.Assert;
import utest.Async;

import zigzagless.Slots;

private class LogMediator implements SlotsMediator {
    
    public var size(default, null): Int;
    public var columns(default, null): Int;

    var actions = new Array<String>();

    public function new(size: Int, columns: Int) {
        this.size = size;
        this.columns = columns;
    }

    public function getColumns(): Int {
        return columns;
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

    function testForDecrimentSize() {
        var log = new LogMediator(1, 1);

        Slots.remove(
            0,
            log
        );

        Assert.same(
            ["remove 0","resize 0"].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveFirstElement2Times() {
        var log = new LogMediator(2, 1);

        Slots.remove(
            0,
            log
        );

        Slots.remove(
            0,
            log
        );

        Assert.same(
            [
                "remove 0",
                
                "move 1 0",

                "resize 1",

                "remove 0",

                "resize 0"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testForRemoveFirstElementIn2ColumnsList() {
        var log = new LogMediator(4, 2);

        Slots.remove(
            0,
            log
        );

        Assert.same(
            [
                /*
                    0 1
                    2 3
                */

                "remove 0",
                
                /*
                      1
                    2 3
                */

                "move 2 0",

                /*
                    2 1
                      3
                */

                "move 3 2",

                /*
                    2 1
                    3
                */

                "resize 3"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testForRemoveFirstElementIn2ColumnsListWith3Elements() {
        var log = new LogMediator(3, 2);

        Slots.remove(
            0,
            log
        );

        Assert.same(
            [
                /*
                    0 1
                    2
                */

                "remove 0",
                
                /*
                      1
                    2
                */

                "move 2 0",

                /*
                    2 1
                */

                "resize 2"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testForRemoveSecondElementIn2ColumnsList() {
        var log = new LogMediator(4, 2);

        Slots.remove(
            1,
            log
        );

        Assert.same(
            [
                /*
                    0 1
                    2 3
                */

                "remove 1",
                
                /*
                    0 
                    2 3
                */

                "move 3 1",

                /*
                    0 3
                    2
                */

                "resize 3"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveFirstElementFromLastRowIn3ColumnList() {
        var log = new LogMediator(8, 3);

        Slots.remove(
            6,
            log
        );

        Assert.same(
            [
                /*
                    0 1 2
                    3 4 5
                    6 7
                */

                "remove 6",
                
                /*
                    0 1 2
                    3 4 5
                      7
                */

                "move 7 6",

                /*
                    0 1 2
                    3 4 5
                    7
                */
                
                "resize 7"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveSecondElementFrom3RowsList() {
        var log = new LogMediator(7, 3);

        Slots.remove(
            1,
            log
        );

        Assert.same(
            [
                /*
                    0 1 2
                    3 4 5
                    6 
                */

                "remove 1",
                
                /*
                    0   2
                    3 4 5
                    6
                */

                "move 4 1",

                /*
                    0 4 2
                    3   5
                    6
                */
                
                "move 3 4",

                /*
                    0 4 2
                      3 5
                    6
                */

                "move 6 3",

                /*
                    0 4 2
                    6 3 5
                */

                "resize 6"
            ].join(","),
            log.getActions().join(",")
        );
    }
}
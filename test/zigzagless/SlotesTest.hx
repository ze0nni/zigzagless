package zigzagless;

import utest.Assert;
import utest.Async;

import zigzagless.Slots;

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

    function testForDecrimentSize() {
        var log = new LogMediator(1);

        Slots.remove(
            1,
            log,
            0
        );

        Assert.same(
            ["remove 0","resize 0"].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveFirstElement2Times() {
        var log = new LogMediator(2);

        Slots.remove(
            1,
            log,
            0
        );

        Slots.remove(
            1,
            log,
            0
        );

        Assert.same(
            [
                /*
                    - 0
                    - 1
                */

                "remove 0",

                /*
                    -
                    - 1
                */
                
                "move 1 0",

                /*
                    - 1
                    - 
                */

                "resize 1",

                /*
                    - 1
                */

                "remove 0",

                /*
                    - 
                */

                "resize 0"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testForRemoveFirstElementIn2ColumnsList() {
        var log = new LogMediator(4);

        Slots.remove(
            2,
            log,
            0
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
        var log = new LogMediator(3);

        Slots.remove(
            2,
            log,
            0
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
        var log = new LogMediator(4);

        Slots.remove(
            2,
            log,
            1
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
        var log = new LogMediator(8);

        Slots.remove(
            3,
            log,
            6
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
        var log = new LogMediator(7);

        Slots.remove(
            3,
            log,
            1
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

    function testRemoveSecondElementFrom3RowsListWithShiftLastRow() {
        var log = new LogMediator(9);

        Slots.remove(
            3,
            log,
            1
        );

        Assert.same(
            [
                /*
                    0 1 2
                    3 4 5
                    6 7 8
                */

                "remove 1",
                
                /*
                    0   2
                    3 4 5
                    6 7 8
                */

                "move 4 1",

                /*
                    0 4 2
                    3   5
                    6 7 8
                */
                
                "move 7 4",

                /*
                    0 4 2
                    3 7 5
                    6   8
                */

                "move 8 7",

                /*
                    0 4 2
                    3 7 5
                    6 8
                */

                "resize 8"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveSecondElementForm2ColimenListWith3Elements() {
        var log = new LogMediator(3);

        Slots.remove(
            2,
            log,
            1
        );


        Assert.same(
            [
                /*
                    0 1
                    2
                */

                "remove 1",
                
                /*
                    0 
                    2
                */

                "move 0 1",
                
                /*
                      0
                    2
                */

                "move 2 0",
                
                /*
                    2 0 
                */

                "resize 2"
            ].join(","),
            log.getActions().join(",")
        );
    }

    function testRemoveLastElementFrom2x2List() {
        var log = new LogMediator(4);

        Slots.remove(
            2,
            log,
            3
        );


        Assert.same(
            [
                /*
                    0 1
                    2 3
                */

                "remove 3",
                
                /*
                    0 1
                    2
                */

                "resize 3"
            ].join(","),
            log.getActions().join(",")
        );
    }
}
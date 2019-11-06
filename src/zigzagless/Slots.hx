package zigzagless;

interface SlotsMediator {
    function getSize(): Int;
    function getColumns(): Int;
    function resize(newSize: Int): Void;
    function remove(index: Int): Void;
    function move(from: Int, to: Int): Void;
}

class Slots {
    
    static public function remove(
        index: Int,
        mediator: SlotsMediator
    ) {
        var size = mediator.getSize();

        var columnsCount = mediator.getColumns();
        var rowsCount = Math.ceil(size / columnsCount);

        var newSize = size - 1;

        mediator.remove(index);

        var removedColumn = index % columnsCount;
        var removedRow = Std.int(index / columnsCount);

        // pop column
        for (r in removedRow...(rowsCount-1)) {
            var from = removedColumn +  (r + 1) * columnsCount;
            var to = removedColumn +  r * columnsCount;
            mediator.move(from, to);
        }

        // shift row
        var lastRow0 = (rowsCount - 1) * columnsCount;

        for (c in removedColumn...(columnsCount-1)) {
            var from = lastRow0 + c + 1;
            var to = lastRow0 + c;
            if (from < size) {
                mediator.move(from, to);
            }
        }

        mediator.resize(newSize);
    }
}
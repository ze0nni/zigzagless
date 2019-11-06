package zigzagless;

class Slots {
    
    static public function remove(
        columnsCount: Int,
        mediator: SlotsMediator,
        index: Int
    ) {
        var size = mediator.getSize();

        var rowsCount = Math.ceil(size / columnsCount);

        var newSize = size - 1;

        mediator.remove(index);

        var removedColumn = index % columnsCount;
        var removedRow = Std.int(index / columnsCount);

        // pop column
        var lastModifyRow = -1;

        for (r in removedRow...(rowsCount-1)) {
            var from = removedColumn +  (r + 1) * columnsCount;
            var to = removedColumn +  r * columnsCount;
            if (from < size) {
                lastModifyRow = r + 1;
            	mediator.move(from, to);
            }
        }

        // shift last modify row slots right, except last line
        if (-1 != lastModifyRow && lastModifyRow != rowsCount - 1) {
            var c = removedColumn;
            var row0 = lastModifyRow * columnsCount;
            while (c > 0) {
                var from = row0 + c - 1;
                var to = row0 + c;
                mediator.move(from, to);
                c -= 1;
            }
        }
        
        // pop first colum element after shift
        if (0 != removedColumn) {
            for (r in lastModifyRow...rowsCount) {
                var from = (r + 1) * columnsCount;
                var to = r * columnsCount;
                if (from < size) {
                    mediator.move(from, to);
                }
            }
        }

        // shift last row slots left
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
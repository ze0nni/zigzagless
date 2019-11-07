package zigzagless;

class Slots {
    
    static public function remove(
        columnsCount: Int,
        mediator: SlotsMediator,
        index: Int
    ) {
        var size = mediator.getSize();
        var newSize = size - 1;
        
        var rowsCount = Math.ceil(size / columnsCount);

        var holeX = index % columnsCount;
        var holeY = Std.int(index / columnsCount);

        mediator.remove(index);

        // move hole bottom 
        for (y in holeY...(rowsCount-1)) {
            var to = y * columnsCount + holeX;
            var from = to + columnsCount;
            if (from >= size) {
                break;
            }
            mediator.move(from, to);
            holeY = y;
        }

        // move last rows elements fo left
        var lastRow0 = (rowsCount - 1) * columnsCount;
        for (x in holeX...(columnsCount-1)) {
            var to = lastRow0 + x;
            var from = to + 1;
            if (from >= size) {
                break;
            }
            mediator.move(from, to);
        }

        mediator.resize(newSize);
    }
}
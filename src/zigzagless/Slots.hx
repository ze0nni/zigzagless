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
        var lastRow = rowsCount - 1;
        var lastRowSize = size % columnsCount;

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
            holeY = y + 1;
        }
        
        if (holeY != lastRow) {
            // move row element to right
            var row0 = holeY * columnsCount;
            while (holeX > 0) {
                holeX -= 1;
                
                var from = row0 + holeX;
                var to = from + 1;

                mediator.move(from, to);
            }

            // now hole at start of next line
            //not need holeY += 1;

            // Pop element form bottom row
            var nextRow0 = row0 + columnsCount;
            if (nextRow0 < size) {
                mediator.move(nextRow0, row0);
            }
        }

        // if last row reached just move elements to left
        var lastRow0 = lastRow * columnsCount;
        for (x in holeX...columnsCount) {
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
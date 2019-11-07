package zigzagless;

class Slots {
    
    static public function remove(
        columnsCount: Int,
        mediator: SlotsMediator,
        index: Int
    ) {
        var size = mediator.getSize();
        var newSize = size - 1;
        
        mediator.remove(index);

        mediator.resize(newSize);
    }
}
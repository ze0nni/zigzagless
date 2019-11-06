package permutator;

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
        var newSize = size - 1;

        mediator.remove(index);
        
        for (i in index...newSize) {
            mediator.move(i + 1, i);
        }

        mediator.resize(newSize);
    }
}
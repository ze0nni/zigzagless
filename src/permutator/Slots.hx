package permutator;

interface SlotsMediator {
    function getSize(): Int;
    function resize(newSize: Int): Void;
    function remove(index: Int): Void;
    function move(from: Int, to: Int): Void;
}

class Slots {
    
    static public function remove(
        index: Int,
        mediator: SlotsMediator
    ) {
        mediator.remove(index);
        mediator.resize(mediator.getSize() - 1);
    }
}
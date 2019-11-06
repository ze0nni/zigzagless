package zigzagless;

interface SlotsMediator {
    function getSize(): Int;
    function resize(newSize: Int): Void;
    function remove(index: Int): Void;
    function move(from: Int, to: Int): Void;
}

library ArraysPlus {
    function removeByValue(address[] storage array, address _target) public {
        for (uint i= 0; i<array.length; i++) {
            if (_target==array[i]) {
                array[i] = array[array.length-1];
                array.pop();
            }
        }
    }
}
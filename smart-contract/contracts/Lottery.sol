pragma solidity >=0.4.22 <0.9.0;

contract Lottery {

    // public이면 자동으로 getter를 만들어 줌
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 5;
    }
}
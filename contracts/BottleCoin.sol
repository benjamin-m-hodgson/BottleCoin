pragma solidity ^0.4.8;

// Utility contract for ownership functionality.
contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract BottleCoin is owned{

  // Authorized roles
  mapping(address => bool) public manufacturer;
  mapping(address => bool) public retailer;
  mapping(address => bool) public transporter;
  mapping(address => bool) public recyclingFacility;
  mapping(address => bool) public vendor;

  enum BottleType {
    waterBottle,
    sodaBottle,
    other
  }

  struct Bottle {
    BottleType bottleType;
    address id;
    uint rewardDeposit;
  }

  struct Actor {
    address id;
  }

  constructor() public {

  }

}

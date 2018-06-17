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

contract BottleCoin is owned {
  using SafeMath for uint;

  // Mapping to store active bottles
  mapping(bytes32 => uint) public activeBottleIndex;
  Bottle[] activeBottles;

  // Authorized roles
  mapping(address => uint) public manufacturer;
  mapping(address => uint) public retailer;
  mapping(address => uint) public transporter;
  mapping(address => uint) public recyclingFacility;
  mapping(address => uint) public vendor;
  Actor[] public authorizedActors;

  enum BottleType {
    waterBottle,
    sodaBottle,
    other
  }

  enum BottleStatus {
    created,
    withManufacturer,
    withRetailer,
    withConsumer,
    withVendor,
    withRecyclingFacility
  }

  enum Role {
    manufacturer,
    retailer,
    consumer,
    recycler,
    transporter,
    recyclingFacility,
    vendor
  }

  struct Bottle {
    bytes32 id;
    BottleType bottleType;
    uint manufacturerPrice;
    BottleStatus bottleStatus;
    uint rewardDeposit;
    address currentOwner;
    Actor[] rewardedActors;
  }

  struct ActorRole {
    Role contribution;
    uint rewardAmount;
  }

  struct Actor {
    address id;
    string name;
    ActorRole role;
  }

  // Modifier that allows only manufacturers to transact
  modifier onlyManufacturers {
      require(manufacturer[msg.sender] != 0 || msg.sender == owner);
      _;
  }

  // Modifier that allows only retailers to transact
  modifier onlyRetailers {
      require(retailer[msg.sender] != 0 || msg.sender == owner);
      _;
  }

  // Modifier that allows only transporters to transact
  modifier onlyTransporters {
      require(transporter[msg.sender] != 0 || msg.sender == owner);
      _;
  }

  // Modifier that allows only recycling facilities to transact
  modifier onlyRecyclingFacilities {
      require(recyclingFacility[msg.sender] != 0 || msg.sender == owner);
      _;
  }

  // Modifier that allows only vendors to transact
  modifier onlyVendors {
      require(vendor[msg.sender] != 0 || msg.sender == owner);
      _;
  }

  constructor() public {

  }

  function createBottle(BottleType _type, uint _price) onlyOwner public {
    bytes32 bottleHash = calculateBottleHash();
    // Check existence of bottle
    uint index = activeBottleIndex[bottleHash];
    if (index == 0) {
        // Add active bottle to ID list.
        activeBottleIndex[bottleHash] = activeBottles.length;
        index = activeBottles.length++;

        // Create and update storage
        Bottle storage b = activeBottles[index];
        b.id = bottleHash;
        b.bottleType = _type;
        b.manufacturerPrice = _price;
        b.bottleStatus = BottleStatus.created;
        b.rewardDeposit = 0;
        b.currentOwner = address(this);
    }
  }

 /**
  * Returns the unique identifying bottle hash scanned from a bottle
  */
  function scanBottle() pure public returns(bytes32) {
    // TODO implement logic to return bottle hash
  }

  // calculates the unique bottle hash for a new bottle
  function calculateBottleHash() view private returns(bytes32) {
    return keccak256(abi.encodePacked(now, activeBottles.length));
  }

  // fallback payable function
  function() payable public {

  }

  // getter that returns the contract ether balance
  function getEtherBalance() onlyOwner view public returns (uint) {
      return address(this).balance;
  }

  // delete the contract from the blockchain
  function kill() onlyOwner public{
      selfdestruct(owner);
  }

}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

}

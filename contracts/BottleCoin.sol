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

    function transferOwnership(address _newOwner) onlyOwner public {
        owner = _newOwner;
    }
}

contract BottleCoin is owned {
  using SafeMath for uint;

  // Constants to define reward sharing and contract functionality
  uint private manufacturerShare = 0;
  uint private retailerShare = 0;
  uint private consumerShare = uint(2).div(uint(14));
  uint private recyclerShare = uint(5).div(uint(14));
  uint private transporterShare = uint(1).div(uint(14));
  uint private recyclingFacilityShare = uint(3).div(uint(14));
  uint private vendorShare = uint(2).div(uint(14));

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
    uint rewardShare;
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

  /**
   * Allows only the contract owner to create a new active bottle
   *
   * @param _type the type of bottle created as specified by the enum BottleType
   * @param _price the minimum price manufacturers can pay for the bottle
   */
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
   * Returns the minimum sale price for this bottle for manufacturers
   *
   * @notice only can be called by authorized manufacturers
   *
   * @param _bottleHash the hash that uniquely identifies this botle
   */
  function getManufacturersPrice(
    bytes32 _bottleHash
  ) onlyManufacturers view public returns(uint) {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    return thisBottle.manufacturerPrice;
  }

  /**
   * Allows a bottle to be sold to authorized manufacturers. Requires the transaction
   * price is greater than the minimum price the bottle can be sold to manufacturers.
   *
   * @notice only can be called by authorized manufacturers
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   * @param _manufacturerName the name of the manufacturer purchasing the bottle
   */
  function sellBottleToManufacturer(
    bytes32 _bottleHash,
    string _manufacturerName
  ) onlyManufacturers payable public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle hasn't been sold before
    if (thisBottle.bottleStatus != BottleStatus.created) {
      revert("This bottle has already been sold to a manufacturer!");
    }
    // require the price is sufficient
    require(msg.value >= thisBottle.manufacturerPrice, "Insufficient funds");
    // update bottle data
    thisBottle.bottleStatus = BottleStatus.withManufacturer;
    ActorRole memory manufacturerRole = ActorRole({
      contribution: Role.manufacturer,
      rewardShare: manufacturerShare
    });
    addRewardedActor(_bottleHash, msg.sender, _manufacturerName, manufacturerRole);
  }

 /**
  * Returns the unique identifying bottle hash scanned from a bottle
  */
  function scanBottle() pure public returns(bytes32) {
    // TODO implement logic to return bottle hash
  }

  /**
   * Adds an actor with the specified parameters to the array of actors to be rewarded
   * for the recycling of a bottle identified by the bottle hash
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   * @param _actorId the address identifying the actor to be rewarded
   * @param _actorName the string name that helps identify the actor further
   * @param _role the role the actor played in the bottle's life cycle
   */
  function addRewardedActor(
    bytes32 _bottleHash,
    address _actorId,
    string _actorName,
    ActorRole _role
  ) private {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    thisBottle.rewardedActors.push(Actor({
      id: _actorId,
      name: _actorName,
      role: _role
    }));
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

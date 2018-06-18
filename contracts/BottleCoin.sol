pragma solidity ^0.4.8;

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

// Utility contract for ownership functionality.
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) onlyOwner public {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BottleToken is ERC20Interface, Owned {
  using SafeMath for uint;

  string public name;
  uint8 public decimals;
  uint private _totalSupply;

  mapping(address => uint) private balances;
  mapping(address => mapping(address => uint)) private allowed;

  constructor() public {
    name = "BottleCoin";
    decimals = 18;
    // TODO set _totalSupply value here
    balances[owner] = _totalSupply;
    emit Transfer(address(0), owner, _totalSupply);
  }

  // ------------------------------------------------------------------------
  // Total supply
  // ------------------------------------------------------------------------
  function totalSupply() public view returns (uint) {
      return _totalSupply.sub(balances[address(0)]);
  }

  // ------------------------------------------------------------------------
  // Get the token balance for account `tokenOwner`
  // ------------------------------------------------------------------------
  function balanceOf(address tokenOwner) public view returns (uint balance) {
      return balances[tokenOwner];
  }

  // ------------------------------------------------------------------------
  // Transfer the balance from token owner's account to `to` account
  // - Owner's account must have sufficient balance to transfer
  // - 0 value transfers are allowed
  // ------------------------------------------------------------------------
  function transfer(address to, uint tokens) public returns (bool success) {
      balances[msg.sender] = balances[msg.sender].sub(tokens);
      balances[to] = balances[to].add(tokens);
      emit Transfer(msg.sender, to, tokens);
      return true;
  }

  // ------------------------------------------------------------------------
  // Token owner can approve for `spender` to transferFrom(...) `tokens`
  // from the token owner's account
  //
  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
  // recommends that there are no checks for the approval double-spend attack
  // as this should be implemented in user interfaces
  // ------------------------------------------------------------------------
  function approve(address spender, uint tokens) public returns (bool success) {
      allowed[msg.sender][spender] = tokens;
      emit Approval(msg.sender, spender, tokens);
      return true;
  }

  // ------------------------------------------------------------------------
  // Transfer `tokens` from the `from` account to the `to` account
  //
  // The calling account must already have sufficient tokens approve(...)-d
  // for spending from the `from` account and
  // - From account must have sufficient balance to transfer
  // - Spender must have sufficient allowance to transfer
  // - 0 value transfers are allowed
  // ------------------------------------------------------------------------
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
      balances[from] = balances[from].sub(tokens);
      allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
      balances[to] = balances[to].add(tokens);
      emit Transfer(from, to, tokens);
      return true;
  }

}

contract BottleCoin is BottleToken {
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
  mapping(bytes32 => uint) private activeBottleIndex;
  Bottle[] private activeBottles;

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
    ActorRole role;
  }

  // Modifier that allows only manufacturers to transact
  modifier onlyManufacturers {
      require(manufacturer[msg.sender] || msg.sender == owner);
      _;
  }

  // Modifier that allows only retailers to transact
  modifier onlyRetailers {
      require(retailer[msg.sender] || msg.sender == owner);
      _;
  }

  // Modifier that allows only transporters to transact
  modifier onlyTransporters {
      require(transporter[msg.sender] || msg.sender == owner);
      _;
  }

  // Modifier that allows only recycling facilities to transact
  modifier onlyRecyclingFacilities {
      require(recyclingFacility[msg.sender] || msg.sender == owner);
      _;
  }

  // Modifier that allows only vendors to transact
  modifier onlyVendors {
      require(vendor[msg.sender] || msg.sender == owner);
      _;
  }

  constructor() public {
  }

  /**
   * Designates an address as an authorized actor for a specific role
   *
   * @param _actor the address whose authorized status is changing
   * @param _role the role the authorized status pertains to
   */
  function addAuthorizedActor(address _actor, Role _role) onlyOwner public {
    toggleAuthorizedActor(_actor, _role, true);
  }

  /**
   * Designates an address as an unauthorized actor for a specific role
   *
   * @param _actor the address whose authorized status is changing
   * @param _role the role the authorized status pertains to
   */
  function removeAuthorizedActor(address _actor, Role _role) onlyOwner public {
    toggleAuthorizedActor(_actor, _role, false);
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
   */
  function sellBottleToManufacturer(
    bytes32 _bottleHash,
    address _buyer
  ) onlyOwner payable public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle hasn't been sold before
    if (thisBottle.bottleStatus != BottleStatus.created) {
      revert("This bottle has already been sold to a manufacturer!");
    }
    // require the bottle is being sold to an authorized manufacturer
    require(manufacturer[_buyer]);
    // require the price is sufficient
    // TODO implement tokens
    require(msg.value >= thisBottle.manufacturerPrice, "Insufficient funds");
    // update bottle data
    thisBottle.bottleStatus = BottleStatus.withManufacturer;
    // TODO implement tokens
    thisBottle.rewardDeposit = msg.value;
    ActorRole memory manufacturerRole = ActorRole({
      contribution: Role.manufacturer,
      rewardShare: manufacturerShare
    });
    addRewardedActor(_bottleHash, msg.sender, manufacturerRole);
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
   * @param _role the role the actor played in the bottle's life cycle
   */
  function addRewardedActor(
    bytes32 _bottleHash,
    address _actorId,
    ActorRole _role
  ) private {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    thisBottle.rewardedActors.push(Actor({
      id: _actorId,
      role: _role
    }));
  }

  /**
   * Designates an address as an authorized or unauthorized actor for a specific role
   *
   * @param _actor the address whose authorized status is changing
   * @param _role the role the authorized status pertains to
   * @param _value the value of the authorized status, true is authoried
   */
  function toggleAuthorizedActor(
    address _actor,
    Role _role,
    bool _value
  ) private {
    if (_role == Role.manufacturer) {
      manufacturer[_actor] = _value;
    }
    else if (_role == Role.retailer) {
      retailer[_actor] = _value;
    }
    else if (_role == Role.transporter) {
      transporter[_actor] = _value;
    }
    else if (_role == Role.recyclingFacility) {
      recyclingFacility[_actor] = _value;
    }
    else if (_role == Role.vendor) {
      vendor[_actor] = _value;
    }
    else {
      revert("Invalid authorized role provided");
    }
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

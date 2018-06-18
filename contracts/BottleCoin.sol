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

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {

  address public owner;

  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {

    function totalSupply() public view returns (uint256);
    function balanceOf(address _owner) public view returns (uint256);
    function allowance(address _owner, address _spender) public view returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
    function approve(address _spender, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    event Transfer(address indexed owner, address indexed spender, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20Interface {
  using SafeMath for uint;

  uint256 totalSupply_;

  mapping(address => uint256) balances;
  mapping (address => mapping (address => uint256)) internal allowed;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {

  bool public mintingFinished = false;

  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    hasMintPermission
    canMint
    public
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

contract BottleToken is MintableToken {
  using SafeMath for uint;

  string public name;
  string public symbol;
  uint8 public decimals;

  constructor() public {
    name = "BottleCoin";
    symbol = "BCT";
    decimals = 18;
    totalSupply_ = 1000;
    balances[owner] = totalSupply_;
    emit Transfer(address(0), owner, totalSupply_);
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

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
    require(_value <= balances[msg.sender], "Insufficient owner balance");

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Transfer token for a specified address from an internal contract call
  * @param _to The address to transfer to.
  * @param _from The address which you want to send tokens from
  * @param _value The amount to be transferred.
  */
  function internalTransfer(
    address _from,
    address _to,
    uint256 _value
  ) internal returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from], "Insufficient _from balance");

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
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
    onlyOwner
    canMint
    public
    returns (bool)
  {
    return internalMint(_to, _amount);
  }

  /**
   * @dev Function to mint tokens
   *
   * @notice modified to be used for minting calls within derived contracts
   *
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function internalMint(
    address _to,
    uint256 _amount
  )
    canMint
    internal
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

  // Constants to define reward sharing
  uint manufacturerShare = 0;
  uint retailerShare = 0;
  uint consumerShare = 2;
  uint recyclerShare = 5;
  uint transporterShare = 1;
  uint recyclingFacilityShare = 3;
  uint vendorShare = 2;
  uint totalRewardShare = 14;

  // Share taken from consumer purchase
  uint saleShare = 27;

  // Token exchange rate
  uint public weiPerToken;

  // Mapping to store active bottles
  mapping(bytes32 => uint) activeBottleIndex;
  Bottle[] activeBottles;

  // Authorized roles
  mapping(address => bool) manufacturer;
  mapping(address => bool) retailer;
  mapping(address => bool) recyclingFacility;
  mapping(address => bool) transporter;
  mapping(address => bool) vendor;

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
    uint minManufacturerWeiPrice;
    uint minConsumerWeiPrice;
    BottleStatus bottleStatus;
    uint rewardDeposit;
    uint saleTime;
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

  constructor(uint _price) public {
    weiPerToken = _price;
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
   * @param _manPrice the minimum price manufacturers can pay for the bottle
   * @param _conPrice the minimum price consumers can pay for the bottle
   */
  function createBottle(BottleType _type, uint _manPrice, uint _conPrice) onlyOwner public {
    bytes32 bottleHash = calculateBottleHash();
    // Check existence of bottle
    uint index = activeBottleIndex[bottleHash];
    require(index == 0, "Bottle already created with generated hash");

    // Add active bottle to ID list.
    activeBottleIndex[bottleHash] = activeBottles.length;
    index = activeBottles.length++;

    // Create and update storage
    Bottle storage b = activeBottles[index];
    b.id = bottleHash;
    b.bottleType = _type;
    b.minManufacturerWeiPrice = _manPrice;
    b.minConsumerWeiPrice = _conPrice;
    b.bottleStatus = BottleStatus.created;
    b.rewardDeposit = 0;
    b.saleTime = 0;
    b.currentOwner = address(this);
  }

  /**
   * Allows only the contract owner to return the bottle hash for a bottle at
   * the specified index in the active bottles array
   *
   * @param _index the index of the bottle whose hash should be returned
   */
  function getBottleHash(uint _index) onlyOwner view public returns (bytes32) {
    return activeBottles[_index].id;
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
    return thisBottle.minManufacturerWeiPrice;
  }

  /**
   * Allows a bottle to be sold to authorized manufacturers. Requires the transaction
   * price is greater than the minimum price the bottle can be sold to manufacturers.
   *
   * @notice only can be called by authorized manufacturers
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   */
  function purchaseBottle(
    bytes32 _bottleHash
  ) onlyManufacturers payable public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle hasn't been sold before
    if (thisBottle.bottleStatus != BottleStatus.created) {
      revert("This bottle has already been sold to a manufacturer!");
    }
    // require the price is sufficient
    require(msg.value >= thisBottle.minManufacturerWeiPrice, "Insufficient funds");

    // update bottle data and mint tokens
    thisBottle.bottleStatus = BottleStatus.withManufacturer;
    thisBottle.currentOwner = msg.sender;

    // TODO refund excess ether sent, msg.value - thisBottle.minManufacturerWeiPrice

    // mint tokens
    uint tokens = weiToTokenConverter(msg.value);
    thisBottle.rewardDeposit = thisBottle.rewardDeposit.add(tokens);
    internalMint(address(this), tokens);
    ActorRole memory manufacturerRole = ActorRole({
      contribution: Role.manufacturer,
      rewardShare: manufacturerShare
    });
    addRewardedActor(_bottleHash, msg.sender, manufacturerRole);
  }

  /**
   * Allows a bottle to be stocked by a retailer. Bottle status must be
   * with manufacturers.
   *
   * @notice only can be called by authorized retailers
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   */
  function stockBottle(bytes32 _bottleHash) onlyRetailers public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle has been sold to a manufacturer
    if (thisBottle.bottleStatus != BottleStatus.withManufacturer) {
      revert("This bottle can't be stocked!");
    }

    // update bottle data
    thisBottle.bottleStatus = BottleStatus.withRetailer;
    thisBottle.currentOwner = msg.sender;
    ActorRole memory retailerRole = ActorRole({
      contribution: Role.retailer,
      rewardShare: retailerShare
    });
    addRewardedActor(_bottleHash, msg.sender, retailerRole);
  }

  /**
   * Allows a bottle to be sold by a retailer. Bottle status must be
   * with retailers and the transaction value must be greater than
   * the minimum consumer price set at bottle creation.
   *
   * @notice only can be called by authorized retailers
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   * @param _buyer the address of the person buying the bottle
   */
  function sellBottle(
    bytes32 _bottleHash,
    address _buyer
  ) onlyRetailers payable public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle has been stocked by a retailer
    if (thisBottle.bottleStatus != BottleStatus.withRetailer) {
      revert("This bottle can't be stocked!");
    }
    // require mandatory sale minimum is reached
    require(msg.value >= thisBottle.minConsumerWeiPrice, "Insufficient funds");

    // update bottle data
    thisBottle.bottleStatus = BottleStatus.withConsumer;
    thisBottle.currentOwner = _buyer;
    thisBottle.saleTime = now;
    uint tokens = weiToTokenConverter(msg.value.mul(saleShare).div(100));
    thisBottle.rewardDeposit = thisBottle.rewardDeposit.add(tokens);
    internalMint(address(this), tokens);
    ActorRole memory consumerRole = ActorRole({
      contribution: Role.consumer,
      rewardShare: consumerShare
    });
    addRewardedActor(_bottleHash, _buyer, consumerRole);
  }

  /**
   * Allows a bottle to be claimed by any actor. Transfers current ownership of
   * the bottle to the msg.sender
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   */
  function claimBottle(bytes32 _bottleHash) public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle has been purchased
    if (thisBottle.bottleStatus != BottleStatus.withConsumer) {
      revert("This bottle can't be claimed! It must be sold first");
    }

    // update ownership
    thisBottle.currentOwner = msg.sender;
  }

  /**
   * Allows a bottle to be vended by an authorized vending location. Adds the
   * vending location to the rewarded actors list within the bottle
   *
   * @notice only can be called by authorized vendors
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   */
  function vend(bytes32 _bottleHash) onlyVendors public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle has been purchased
    if (thisBottle.bottleStatus != BottleStatus.withConsumer) {
      revert("This bottle must be purchased before it can be recycled");
    }

    // update bottle data, don't update owner to reward the depositer later
    thisBottle.bottleStatus = BottleStatus.withVendor;
    ActorRole memory vendorRole = ActorRole({
      contribution: Role.vendor,
      rewardShare: vendorShare
    });
    addRewardedActor(_bottleHash, msg.sender, vendorRole);
  }

  /**
   * Allows only authorized recycling facilities to mark a bottle as recycled.
   * Once recycled rewards are issued to involved actors. An authorized
   * transporter that transported the material must be given.
   *
   * @notice only can be called by authorized recycling facilities
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   * @param _transporter the address of the authorized transporter
   */
  function recycleBottle(
    bytes32 _bottleHash,
    address _transporter
  ) onlyRecyclingFacilities public {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    // require the bottle has been purchased
    if (thisBottle.bottleStatus != BottleStatus.withConsumer
            && thisBottle.bottleStatus != BottleStatus.withVendor) {
      revert("This bottle can't be claimed! It must be sold first");
    }
    // require the supplied _transporter is an authorized transporter
    require(transporter[_transporter], "Unauthorized transporter");

    // update bottle data
    thisBottle.bottleStatus = BottleStatus.withRecyclingFacility;
    ActorRole memory transporterRole = ActorRole({
      contribution: Role.transporter,
      rewardShare: transporterShare
    });
    ActorRole memory recyclerRole = ActorRole({
      contribution: Role.recycler,
      rewardShare: recyclerShare
    });
    ActorRole memory recyclingFacilityRole = ActorRole({
      contribution: Role.recyclingFacility,
      rewardShare: recyclingFacilityShare
    });
    addRewardedActor(_bottleHash, _transporter, transporterRole);
    addRewardedActor(_bottleHash, thisBottle.currentOwner, recyclerRole);
    addRewardedActor(_bottleHash, msg.sender, recyclingFacilityRole);
    transferDeposit(thisBottle.id);
  }

 /**
  * Returns the unique identifying bottle hash scanned from a bottle
  */
  function scanBottle() pure public returns(bytes32) {
    // TODO implement logic to return bottle hash
  }

  /**
   * Issues reward deposits for actors invovled in the process of recycling
   * the bottle identified by the bottle hash.
   *
   * @param _bottleHash the unique identifying bottle hash scanned from a bottle
   */
  function transferDeposit(bytes32 _bottleHash) private {
    Bottle storage thisBottle = activeBottles[activeBottleIndex[_bottleHash]];
    if (thisBottle.bottleStatus != BottleStatus.withRecyclingFacility) {
      revert("This bottle's deposits can't be distributed!");
    }
    for (uint i = 0; i < thisBottle.rewardedActors.length; i++) {
      Actor storage thisActor = thisBottle.rewardedActors[i];
      uint reward = thisBottle.rewardDeposit.mul(thisActor.role.rewardShare)
                          .div(totalRewardShare);
      if (reward > 0) {
        internalTransfer(address(this), thisActor.id, reward);
      }
    }
    thisBottle.rewardDeposit = 0;
    // TODO remove bottle from active bottle list
  }

  /**
   * Calculates the conversion for wei to tokens. Returns the amount of tokens
   * equivalent to the given wei
   */
  function weiToTokenConverter(uint _wei) view private returns (uint) {
    return _wei.div(weiPerToken);
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

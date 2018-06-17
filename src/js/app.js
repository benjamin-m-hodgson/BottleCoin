App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    }
    else {
      // Specify default if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("BottleCoin.json", function(bottlecoin) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.BottleCoin = TruffleContract(bottlecoin);
      // Connect provider to interact with contract
      App.contracts.BottleCoin.setProvider(App.web3Provider);

      return App.render();
    });
  },

  render: function() {
    var bottleCoinInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // TODO Load contract data
    App.contracts.BottleCoin.deployed().then(function(instance) {
      bottleCoinInstance = instance;
    });
  }

  loader.hide();
  content.show();
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});

# BottleCoin
###### Ben Hodgson, Jerry Wang, Surabhi Gupta, Peter Thao

A proof-of-concept application to demonstrate a tokenized model on the Ethereum network that rewards participants in the life cycle of a plastic bottle for recycling.

## Market Analysis 
The world population and level of consumption continues to grow. This growth far outpaces the degradation rate of most plastics and other recyclable packaging materials and poses a significant threat to the planet. Blockchain technology provides a great platform for incentivizing both consumers and producers to recycle through a tokenized packaging material distribution and collection system. Many recycling facilities already implement monetary incentives, but the reward is often not significant enough to motivate individuals to transport and deposit their own materials. 

Our model seeks to capture the market for environmentally conscious individuals that do not have enough incentive to recycle religiously and reward individuals that already participate in a recycling service. The current reward-driven recycling market is also largely dominated by companies that try to incentivize institutions rather than individuals. For example, the former company Green Fiber partnered with businesses and processed paper waste. A business signed a contract with the company guaranteeing to recycle a certain amount of paper in pounds to receive a recycle bin on site. The business is then paid based upon how much paper waste they recycle. This recycling model is great from the perspective of participating institutions, but what if the incentivization process could be extended to individuals? Individual reward mechanisms are excellent motivators and, with the right technologies, can work well to increase recycling rates. The recycling market in its current state does an ineffective job incentivizing individuals to recycle their own recyclable waste, and that's why BottleCoin is a concept worthy of investigation.

## Our Model
Us → Businesses → Consumers → Recyclers → Recycling Facilities → Rewards/Incentives

Our solution incentivizes both companies and consumers to recycle common packaging materials through the reward of tokens. As is widely known, recycling has become a very common practice of reducing the amount of waste that ends up in landfills and the environment. By strongly incentivizing recycling on multiple stages of the material economy, rather than simply promoting it as is often the case now, we hope to see a significant rise in this practice.

Our company manufactures and sells packaging materials for companies to use with their products. Specifically, we propose initially selling plastic bottles to beverage manufacturers. Along with a predetermined set price of purchase is a deposit amount. Each package will include a printed QR code that can be scanned using our decentralized application and allows it to be traced back to both our company, the producers who use it, and the individuals that purchase and recycle the bottle. When this product is returned to a recycling location and scanned again, the individuals are automatically rewarded with tokens from the bottle's token deposits. 

We plan to start on a smaller scale, primarily focusing on companies such as water and soda bottlers, because these products are uniform enough and common enough to be returned in smaller locations, such as recycling “vending machines” located at participating locations. The idea is that an individual can place the bottle in the machine, where it is then scanned and stored until one of our recycling partners recycles it. Vending machines, or, more acurately, reverse vending machines, remove the need for the individual consumer to participate in a recycling service. In an ideal world, these machines would slowly become as ubiquitous as trash cans along the streets and offer an equally accessible alternative to traditional trash disposal. This model will require marketing to convince producers to agree, however by stressing the moral appeal of recycling and the ease of our model, we expect companies and customers will be largely convinced.

## Technical Design
Globally, 80 billion plastic bottles are produced annually, 80% of which end up in oceans and landfills, taking approximately 800 years to biodegrade.  There is a dire need to recycle these plastic bottles and encourage responsible consumer behavior.  Hence, we propose a reward system that allows consumers of our products, individuals that recycle, and recycling facilities to earn tokens for their roles in the recycling process.

Our decentralized application is backed by an Ethereum powered smart contract that traces the provenance of each water bottle and rewards actors in the recycling process with BottleTokens.  Blockchain allows maintenance of a secure, transparent ledger of transactions and facilitates distribution of tokens at different stages of the product life cycle.

#### Actors
We've identified 6 essential actors and 1 optional actor in our model.
  1. **Producer:** they buy our packaging and use it to make their bottles. Examples of these actors in the current market space include Dasani, FIJI, Aquafina, etc.
  2. **Seller:** they establish the association of each product with the buyer and use software to map each product to the customer.  For instance, we foresee applying this through use of a QR code scanner than can sign the sale with an authorized seller’s public key and a consumer’s public key. Examples of sellers in the current space include Walmart, Target, 7-11, etc.
  3. **Consumer:** associated account on the blockchain, rewarded for any purchased product that ends up in recycling. The incentive is not guaranteed for the buyer at time of purchase, which motivates them to have their products recycled to receive a reward. 
  4. **Recycler:** the address that is in possession of the bottle when it is processed at a recycling facility is referred to as the recycler. The assumption is that this person recycled this bottle.
  5. **Transporter:** the government run or privately owned waste management companies that run recycling routes periodically. They transport the recycled waste to the recycling facility.
  6. **Recycling Facility:** the facility that sorts and processes recycled plastic waste.
  7. _(Optional)_ **Vending Location:** the location that maintains a recycling "vending machine" where individuals can deposit their plastic bottles.
  
#### BottleCoin Deposits
Deposits are used to reward individuals with tokens. A small portion of the sale transaction is taken to fund the bottle's deposit. The deposit can be thought of as a pool of money used to maintain the tokenized model and incentivize actors. It is collected in only two types of transactions:
  1. BottleCoin receives payment for a water bottle from a manufacturer
  2. BottleCoin receives a **26.315789%** tax per consumer bottle purchase transaction

In both of the above cases the amount paid is converted to tokens and stored with the bottle information. Once it's recycled the tokens are dispersed to the rewarded actors.

## Incentive Design
#### Bottle Lifecycle
The transfer of tokens, first into the bottle deposit and then rewarded to the involved actors, can be traced through the bottle's lifecycle. 

![Bottle Lifecycle](https://lh3.googleusercontent.com/sDNTBMgEQ9IGBHjqmLs8gtvHWCPiMfcCiVm6aE3XdJfGTSLTFC-7VCXcuPUPEsUqne2mTqojD59O)

The figures in the above graph were generated using the following prices:
  * [To produce one bottle:](https://www.economist.com/economic-and-financial-indicators/2014/11/15/the-price-of-making-a-plastic-bottle) $0.02-$0.04
  * Price for one bottle: $0.08
  * Price for 24 count package of water: ~ $9.00
  * [To collect 1 ton of waste:](http://siteresources.worldbank.org/INTURBANDEVELOPMENT/Resources/336387-1334852610766/AnnexE.pdf) $85 - $250
  * [Price of 1 ton (~40,000 bottles) of recycled water bottles:](https://www.letsrecycle.com/prices/plastics/plastic-bottles/plastic-bottles-2016/) ~$134.00
  * [Cost to recycle 1 ton (~40,000 bottles) of water bottles:](http://www.english.umd.edu/interpolations/2601) ~$147.00
  
For the purposes of calculating rewared percentages we assumed the upper bounds on all of the price ranges.

#### Non-Tokenized Cash Flows

Using the above referenced prices and the assumption that 1 ton of plastic equates to 40,000 plastic water bottles, the below table shows an estimation of water bottle life cycle related revenue streams for each of the actors in our model in the _current marketplace_:

|        Actor       	|             Cost            	|           Revenue          	|    Profit   	|
|:------------------:	|:---------------------------:	|:--------------------------:	|:-----------:	|
|      Producer      	| -$1,600.00 = ($0.04*40,000) 	| $3,200.00 = ($0.08*40,000) 	|  $1,600.00  	|
|       Seller       	|          -$3,200.00         	|   $15,000.00 = 9.00*1,667  	|  $11,800.00 	|
|      Consumer      	|         -$15,000.00         	|          _Unknown_         	| -$15,000.00 	|
|     Transporter    	|           -$250.00          	|          _Unknown_         	|   -$250.00  	|
| Recycling Facility 	|           -$147.00          	|           $134.00          	|   -$13.00   	|

#### Tokenized Cash Flows

Using the above referenced prices and the assumption that 1 ton of plastic equates to 40,000 plastic water bottles, the below table shows an estimation of water bottle life cycle related revenue streams for each of the actors in our model in a tokenized, _reward driven market that exists on the blockchain_:

|        Actor       	|             Cost            	|           Revenue          	| Reward    	|    Profit   	|
|:------------------:	|:---------------------------:	|:--------------------------:	|-----------	|:-----------:	|
|      Producer      	| -$1,600.00 = ($0.04*40,000) 	| $3,200.00 = ($0.08*40,000) 	|     -     	|  $1,600.00  	|
|       Seller       	|          -$3,200.00         	|  $10,950.00 = 15,000*0.73  	|     -     	|  $7,750.00  	|
|      Consumer      	|         -$15,000.00         	|          _Unknown_         	|  $807.14  	| -$14,192.86 	|
|      Recycler      	|          _Unknown_           	|          _Unknown_         	| $2,017.86 	|  $2,017.86  	|
|  Vending Location  	|          _Unknown_          	|              -             	|  $807.14  	|   $807.14   	|
|     Transporter    	|           -$250.00          	|          _Unknown_         	|  $403.57  	|   $153.57   	|
| Recycling Facility 	|           -$147.00          	|           $134.00          	| $1,210.72 	|  $1,063.72  	|

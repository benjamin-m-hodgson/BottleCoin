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

![Bottle Lifecycle](https://github.com/bmh43/BottleCoin/blob/master/Bottle%20Lifecycle%20Diagram.png?raw=true)

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

#### BottleCoin Contract Balance History

To demonstrate the minimum profit BottleCoin retains from the deposits, below is a table showing the contract balance history. The deposits are first added before the withdrawals occur once the bottle is recycled. 

|    Action       |Dollar Value |
|:-------------:	|:----------:	|
|    Deposit    	|  $1,600.00 	|
|    Deposit    	|  $4,050.00 	|
|    Withdraw   	|  -$807.14  	|
|    Withdraw   	|  -$807.14  	|
|    Withdraw   	|  -$2017.86 	|
|    Withdraw   	|  -$403.57  	|
|    Withdraw   	| -$1,210.72 	|
| Final Balance 	|   $403.57  	|

## Incentive Model Cost Benefit Analysis

|          Actor          	|                                                                                                                                                                         Cost                                                                                                                                                                        	| Benefit                                                                                                                                                                                                                                                                                                            	| Incentive Reward                                     	| Explanation                                                                                                                                                                                                                                                                                                                                                           	|
|:-----------------------:	|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:	|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|------------------------------------------------------	|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Producer (Dasani, FIJI) 	| The cost to the producer, who labels and fills the bottle, from our model is negligible as our intention is to sell our plastic bottle production services (imprinting a public key for the bottle around the bottleneck)  for an approximate  **0.04 USD** per bottle,  which is within  the average price range of a plastic water bottle as of 2014  	| If a producer adopted our services it would provide excellent marketing material that could capture a loyal new market comprised of environmentally conscious individuals and those passionate about the new blockchain technology.                                                                                	|                    **0%** of  deposit                    	| The marketing potentials and the moral pull our product offers far outweighs the unchanged costs imposed on producers by our tokenized system. If we can design a comparable bottle and successfully attach it to the blockchain at a relatively similar price it seemed no extra incentivization would be required.                                                  	|
|  Seller (Target, 7-11)  	| The costs to producers is the most significant from a profit perspective as any actor in this tokenized system. Traditionally, water bottle sellers price bottles at $9.00 for 24 bottles, or  **0.38** USD per bottle. Under our model, we would withdraw **0.10 USD** from this transaction. This is a direct profit loss to the seller.                  	| Successful marketing could motivate individuals to go to stores more often to purchase water which could lead to revenue generated from other spontaneous sales. This seems like a stretch, so to counteract this we also plan to give a larger reward to stores that opt to house our recycling vending machines. 	| **0%** no vending machine   **14.2857%** vending machine     	| Despite the lost cost, our intention is not to please the seller financially as much as it is to socially incentivize consumers to recycle. We believe that with a dedicated consumer base even resistant sellers will bend to demand. Our tokenization model motivates them to participate more actively in the process by maintaining a recycling vending machine.  	|
|     Consumer (Alice)    	| Our model introduces no cost to the consumer as long as our bottles are similar in look and durability to the plastic water bottles of today’s market.                                                                                                                                                                                              	| The benefit from a consumer standpoint is significant. We designed our model to accomodate for a  **0.02 USD**  per bottle reward to consumers who purchase our water bottles.                                                                                                                                         	|               **14.2857%** of deposits                   	| Though this reward isn’t large, it’s mere existence should provide enough motivation for most people to choose our products over competitors. It also promotes individual recycling because consumers will want to redeem a larger deposit from recycling.                                                                                                            	|
|      Recycler (Bob)     	| Our model introduces no cost to the individual that recycled the bottle.                                                                                                                                                                                                                                                                            	| Over time small deposits can add up and an individual that recycles regularly has the potential to earn significant savings. In the calculation used to determine our model, this equates to a  **0.05 USD**  reward per bottle recycled.                                                                              	|               **35.7143%** of deposits                   	| This is the largest incentive offered in our tokenized model and we believe it is significant enough to influence people to use our system.                                                                                                                                                                                                                           	|
|    Transporter (City)   	| Our model introduces no cost to the transporter services currently in place.                                                                                                                                                                                                                                                                        	| The opportunity for the transporter to make additional profit for picking up recycled materials                                                                                                                                                                                                                    	|                 **7.1429%** of deposits                  	| Offering transporters a reward helps promote the growth of the entire system because it could lead to an increase in recycling access for our customers.                                                                                                                                                                                                              	|
|    Recycling Facility   	| A significant disadvantage with our model is the need to scan each bottle individually to update the blockchain and initiate the reward distribution once it has been recycled. This increases sorting and other processing time needed to recycle the bottles.                                                                                     	| To compensate for the added time needed our model implements a reward for the facilities.                                                                                                                                                                                                                          	|                 **21.4286%** of deposits                 	| Over time the implementation of vending machines at  authorized  seller locations would eliminate the need to scan at facilities and help combat the costs associated with our model.                                                                                                                                                                                 	|

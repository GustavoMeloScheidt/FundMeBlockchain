# FundMe Blockchain

This is a small Solidity project I built to practice blockchain basics like funding contracts, enforcing a minimum USD amount using price feeds, and handling withdrawals with access control.

## What this project shows

- How to let users fund a contract in ETH with a minimum USD value enforced on-chain.
- How to use a Chainlink price feed to convert ETH to USD with a library (`PriceConverter`). 
- How to track each funder and how much they sent using mappings and arrays. 
- How to restrict withdrawals so only the contract owner can withdraw all funds safely.
- How `fallback` and `receive` functions can redirect plain ETH transfers into the main funding logic. 

## Contracts

- `FundMe.sol`:
  - Uses `PriceConverter` so `msg.value` can be converted to USD. 
  - Keeps a `mapping(address => uint256)` of how much each address funded and an array of all funders.
  - Requires a minimum of 5 USD worth of ETH (`MINIMUM_USD`) to accept a funding transaction. 
  - Has an `onlyOwner` modifier and a `withdraw` function that resets funders and sends the full balance to the owner. 
  - Implements `fallback` and `receive` to call `fund()` whenever ETH is sent directly.

- `PriceConverter-2.sol`:
  - Library that reads the ETH/USD price from a Chainlink `AggregatorV3Interface` on Sepolia. 
  - Provides `getPrice` and `getConversionRate` to turn an ETH amount into its USD value with 18 decimals. 

## How to run

1. Open the project in a Solidity environment (I used Remix). 
2. Make sure the Chainlink price feed address matches the network (this code uses Sepolia). 
3. Compile the contracts with Solidity `^0.8.18`. 
4. Deploy `FundMe` and call `fund()` with some ETH meeting the minimum USD value. 
5. As the owner (deployer), call `withdraw()` to collect all funds from the contract. 

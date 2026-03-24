# Simple Storage Solidity Project

This is a very small project I built while studying blockchains and Solidity to better understand the basic foundations of smart contracts.

## What this project shows

- How to store and retrieve a number on-chain using a simple contract (`SimpleStorage.sol`). [file:22]
- How to work with structs, dynamic arrays, and mappings to store people and their favorite numbers. [file:22]
- How one contract can deploy and interact with multiple instances of another contract using a factory pattern (`StorageFactory-2.sol`). [file:21]
- How to use inheritance and function overriding to change behavior in a child contract (`AddFiveStorage-3.sol` adds 5 before storing). [file:23]

## Contracts

- `SimpleStorage.sol`: Basic storage contract with `store`, `retrieve`, and `addPerson` functions. [file:22]
- `StorageFactory-2.sol`: Deploys multiple `SimpleStorage` contracts and lets you store and read values from them. [file:21]
- `AddFiveStorage-3.sol`: Inherits from `SimpleStorage` and overrides `store` so it saves the given number plus 5. [file:23]

## How to run

1. Open the project in a Solidity environment (e.g. Remix or Hardhat).
2. Compile the contracts with Solidity `0.8.19`. [file:22][file:23]
3. Deploy `SimpleStorage`, `StorageFactory`, or `AddFiveStorage` and call the functions to see how storage and interactions work. [file:21][file:22][file:23]

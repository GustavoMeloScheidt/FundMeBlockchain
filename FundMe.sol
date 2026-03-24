// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// The AggregatorV3Interface location might change 
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    // Attach PriceConverter to all uint256s, so they can all call the library, like with the msg.value example
    using PriceConverter for uint256;

    // To know how much each funder has sent 
    // mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    mapping(address => uint256) public addressToAmountFunded;

    // To keep track of the funders 
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // 5e18

    // "constructor" means that this will be immediately called when this contract is deployed 
    constructor() {
        i_owner = msg.sender;
    }

    // Allows the uders to send $ 
    // Have a minimum $ sent 
    // "payable" is to make the function accept transactions
    function fund() public payable {
        // require(msg.value > 1e18, "send more eth");
        require(msg.value.getConversionRate() >= MINIMUM_USD, "A minimum of 5$ worth of ETH is required");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    // To scale this "ownership of the contract" idea, so when we paste it in the function declaration, it will run this "if" (or "require")
    modifier onlyOwner() {
        // require(msg.sender == owner, "Sender is not the owner!");
        if (msg.sender != i_owner) revert NotOwner();
        _; // Execute whatever else is in the function (we can place this in different places, depending on the logic)
    }

    // "onlyOwner" is the modifier, to make sure that only the owner of the contract can use this function
    function withdraw() public onlyOwner {
        //require(msg.sender == i_owner, "Must be owner!");
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // Reset the array
        funders = new address[](0);

        // Now, to actually withdraw the funds to whomever calls this functions 
        // transfer
        // msg.sender = address
        // as where payable(msg.sender) = payable address

        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); // "send" will only revert the transaction if we add the require, as it returns a bool in case the transaction fails 
        // require(sendSuccess, "Send failed");

        // call
        // the "call" function actually returns two variables, the boolean and the bytes dataReturned, thats why we used (bool callSuccess, )
        (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}

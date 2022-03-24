/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "erc721a/contracts/ERC721A.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Audeamus is ERC721A, Ownable {
    
    uint256 MAX_MINTS = 200;
    uint256 MAX_SUPPLY = 12000;
    uint256 public constant DURATION = 7 days;
    uint256 public startPrice = 0.5 ether ;
    uint public immutable startAt;
    uint public immutable endAt;
    uint public immutable discount;
    constructor(uint _startPrice, uint _discount) ERC721A('Audeamus', 'AUD') {
    startAt = block.timestamp;
    discount = _discount;
    endAt = block.timestamp + DURATION;
    startPrice = _startPrice;
  
    }
    string public baseURI = 'http://api.mynft.com/tokens/';
    function getPrice() public view returns(uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint currentPrice = startPrice;
        if(timeElapsed >= 30 && timeElapsed % 30 == 0){
             currentPrice = startPrice - discount;
        }
        return currentPrice;
    }
    function buy(uint256 quantity) external payable{
        require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, 'Sorry you have reached the max mint');
        require(quantity + totalSupply() <= MAX_SUPPLY, 'Not enough tokens');
        require(msg.value >= (getPrice() * quantity), 'Insufficient ether');
        uint refund = msg.value - getPrice() * quantity;
        _safeMint(msg.sender, quantity);
        if(refund > 0){
            payable(msg.sender).transfer(refund);
        }
    }
    function _baseURI() internal view override returns(string memory){
        return baseURI; //override is used here to override the_baseURI method in the docs that returned an empty string
    }
    function withdraw() public onlyOwner{
        require(address(this).balance > 0);
        payable(owner()).transfer(address(this).balance);
    }

   

    
    }
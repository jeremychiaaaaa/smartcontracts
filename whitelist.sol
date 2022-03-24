// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "erc721a/contracts/ERC721A.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Audeamus is ERC721A, Ownable {
    uint public maxMint = 2;
    uint public maxSupply = 6000;
    uint public startPrice = 0.5 ether;
    constructor (uint _startingPrice) ERC721A('Audeamus', 'ADM'){
        startPrice = _startingPrice;
    }
     string public baseURI = 'http://api.mynft.com/tokens/';
    bytes32 public merkleRoot = 0x4d871defed228a51607c31f9c8419b314f51fa8fbd81b62f958251d9a4e888cd;

    mapping(address => bool) public whiteListClaimed;

    function checkValidity(bytes32[] calldata _merkleproof) public {
        require(!whiteListClaimed[msg.sender], 'taken');

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        require(MerkleProof.verify(_merkleproof, merkleRoot, leaf), 'Invalid Proof');

       whiteListClaimed[msg.sender] = true;
    }

    function mint(uint quantity) external payable {
        require(whiteListClaimed[msg.sender] == true, 'Sorry you are not verified');
        require(msg.value >= startPrice, 'Insufficient ether');
        require(quantity <= maxMint, 'Sorry each user only can mint up to 2');
        
        _safeMint(msg.sender, quantity);
    }
    function _baseURI() internal view override returns(string memory){
        return baseURI;
    }
    function withdraw() public onlyOwner{
        require(address(this).balance > 0);
        payable(owner()).transfer(address(this).balance);
    }

}
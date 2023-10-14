// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";

contract BladeWarrios is ERC1155, Ownable, ERC1155Pausable {

    uint256[] private suplies = [50, 100, 200];
    uint256[] private minted = [0, 0, 0];
    uint256[] private rates = [0.5 ether, 1 ether, 2 ether];

    constructor(address initialOwner)
        ERC1155("ipfs/BladeWarrios.person/")
        Ownable(initialOwner)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount) public payable {
        require(id <= suplies.length, "Token doesn't exist");
        require(id > 0, "Token doesn't exist");
        uint256 index = id - 1;

        require(minted[index] + amount <= suplies[index], "Not enough Supply");
        require(msg.value >= amount * rates[index], "Not enough value");

        _mint(account, id, amount, "");
        minted[index] += amount;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance is 0");
        payable (owner()).transfer(address(this).balance);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }


    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable)
    {
        super._update(from, to, ids, values);
    }
}
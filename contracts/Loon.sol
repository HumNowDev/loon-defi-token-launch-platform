// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Loon is ERC20, Ownable, Pausable {
    uint256 public immutable MAX_SUPPLY;

    constructor(
        uint256 initialSupply,
        uint256 maxSupply
    ) ERC20("Loon", "LOON") {
        require(initialSupply <= maxSupply, "Initial supply exceeds max cap");
        MAX_SUPPLY = maxSupply * 10 ** decimals();
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function airdrop(address[] calldata recipients, uint256 amount) external onlyOwner {
        require(totalSupply() + (amount * recipients.length) <= MAX_SUPPLY, "Exceeds max supply");
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amount);
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
        whenNotPaused
    {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        super._beforeTokenTransfer(from, to, amount);
    }
}

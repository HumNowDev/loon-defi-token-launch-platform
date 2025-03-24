// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Loon is ERC20, ERC20Burnable, Pausable, Ownable {
    uint256 public immutable maxSupply;

    mapping(address => bool) public whitelist;
    mapping(address => uint256) public airdropAllocations;
    mapping(address => bool) public hasClaimed;

    constructor(uint256 initialSupply, uint256 _maxSupply)
        ERC20("Loon", "LOON")
    {
        require(initialSupply <= _maxSupply, "Initial supply exceeds max");
        _mint(msg.sender, initialSupply);
        maxSupply = _maxSupply;
    }

    // 🔐 Mint more tokens (onlyOwner)
    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");
        _mint(to, amount);
    }

    // ⛔ Burn your own tokens
    function burn(uint256 amount) public override {
        super.burn(amount);
    }

    // ⏸ Pause transfers
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // ⛔ Hook: Block transfers if paused
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // ✅ Whitelist management
    function addToWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = false;
        }
    }

    // 🎯 Set airdrop allocations (address => amount)
    function setAirdropAllocations(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Mismatched input lengths");
        for (uint256 i = 0; i < recipients.length; i++) {
            airdropAllocations[recipients[i]] = amounts[i];
        }
    }

    // 🎁 Claim airdrop (once only)
    function claimAirdrop() external {
        require(!hasClaimed[msg.sender], "Airdrop already claimed");
        uint256 amount = airdropAllocations[msg.sender];
        require(amount > 0, "No airdrop allocated");

        hasClaimed[msg.sender] = true;
        _mint(msg.sender, amount);
    }
}

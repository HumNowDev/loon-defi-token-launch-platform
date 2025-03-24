# LOON — DeFi Token Launch Platform with Integrated Security Controls

## Overview
LOON is a production-ready ERC-20 token smart contract designed for professional DeFi token launches. It includes core features critical for secure deployment and token lifecycle management. This project demonstrates real-world Solidity development and smart contract architecture with a security-first approach — ideal for clients launching DeFi platforms or needing custom token infrastructure.

## 🔗 Key Features

- ✅ ERC-20 token implementation using OpenZeppelin Contracts
- ✅ Minting and burning functionality
- ✅ Owner-only pause/unpause mechanism (emergency control)
- ✅ Max total supply cap enforcement
- ✅ Airdrop distribution logic with one-time claim enforcement
- ✅ Ownership management via OpenZeppelin’s Ownable pattern
- ✅ Whitelist system — add/remove addresses with privileged access
- ✅ Scalable token distribution tooling (ideal for presales, reward drops, private rounds)


## 📁 Project Structure
```
/contracts
  └── Loon.sol         # Main ERC-20 Token Contract
/scripts
  └── deploy.js        # Deployment script using Hardhat
README.md              # Project documentation (this file)
SECURITY_AUDIT.md      # Security analysis and audit checklist
```

## ⚙️ Tech Stack
- Solidity ^0.8.19
- Hardhat for development & testing
- OpenZeppelin Contracts v4.9.3

## 🚀 Deployment Instructions
1. Install dependencies:
```bash
npm install
```
2. Compile the contract:
```bash
npx hardhat compile
```
3. Start a local blockchain:
```bash
npx hardhat node
```
4. Deploy the contract:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

## 📜 Contract Functions
| Function             | Description                                 |
|----------------------|----------------------------------------------|
| `mint(address, amt)` | Mint new tokens (owner only)                |
| `burn(amount)`       | Burn caller’s tokens                        |
| `pause()`            | Pause all transfers (owner only)            |
| `unpause()`          | Resume transfers (owner only)               |
| `airdrop(address[], amount)` | Airdrop tokens to multiple addresses |

---

# SECURITY_AUDIT.md — LOON Smart Contract Audit Notes

## 🔐 Security Design Summary
The Loon ERC-20 token contract follows battle-tested security patterns using OpenZeppelin libraries. The design focuses on robust access control, maximum supply limits, safe minting practices, and emergency controls.

## ✅ Security Features Implemented
| Area | Mitigation | Status |
|------|-------------|--------|
| Ownership Control | Ownable.sol restricts admin functions | ✔️ Implemented |
| Transfer Halt | Pausable.sol stops token movement | ✔️ Implemented |
| Max Supply Limit | Hard-coded cap on total supply | ✔️ Implemented |
| Function Access | `onlyOwner` modifiers on sensitive logic | ✔️ Implemented |
| Minting Checks | Supply cap enforced on mint & airdrop | ✔️ Implemented |
| Upgradeability | Not included (intentionally static token) | ❌ N/A |

## 🧠 Observations
- `burn()` is safe and scoped to sender
- `airdrop()` runs in a loop — gas cost can be high if recipient list is large
- No direct `transferFrom()` restrictions; follows ERC-20 spec
- Contract is simple and does not include external token price logic or complex DeFi mechanics — lowers risk surface

## 🚩 Recommendations
- Consider adding reentrancy guard in future for staking/crowdsale features
- Consider formal audit or fuzz testing for production launches

## Final Assessment
This token contract is secure, modular, and clean. Suitable for real token launches and demonstrates strong Solidity engineering discipline.


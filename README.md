# sPOAP: soulbound POAP
sPOAP is a soulbound implementation of Proof of Attendence Protocol (POAP), created by [SoulBound Protocol](https://soulbound.life). 

# Features

- **ERC1155**: sPOAP follows ERC1155 multi-token standard (See [EIP-1155](https://eips.ethereum.org/EIPS/eip-1155)). sPOAP event ID corresponds to ERC1155 token ID.
- **Non-transferable**: SoulBound
- **Community Recovery**: at extreme condition (losing private key), community multisig (contract owner) can transfer the token to the new wallet under the approvement of the token holder.

# How it works?

1. Project/DAO creates new event at SoulBound Protocol website, free and permissionless. (Shall we bring this step on-chain?)
2. SoulBound Protocol server links the project/DAO address and event to a sPOAP eventId.
3. Project/DAO submit the address list of event pariticipants.
4. SoulBound Protocol server signs on the address list, allowing them to mint sPOAP.
5. Participants mint sPOAP at the SoulBound Protocol website.

# Related Projects

1. [ERC721S](https://github.com/SoulBoundProtocol/ERC721S): ERC721S (SoulBound) is a standard for SoulBound Token (non-transferable NFT) coined by Vitalik Buterin in a blog post.


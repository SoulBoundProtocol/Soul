// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./sPOAP.sol";

contract sPOAPMinter is Ownable{
    /* ============ Events ============ */
    event sPOAPMinted(address indexed account, uint256 indexed id);
    event SignerChanged(address indexed oldSigner, address indexed newSigner);

    /* ============ State Variables ============ */
    address public signer;
    sPOAP public poap;
    mapping(uint256 => mapping(address => bool)) public mintedAddress;   // 记录已经mint的地址

    /* ============ Constructor ============ */
    /*
     * @dev initialize sPOAP addresss and signer address
     */
    constructor(address sPOAPaddr_, address signer_){
        poap = sPOAP(sPOAPaddr_);
        signer = signer_;
    }

    /* ============ Public Functions ============ */
    /*
     * @dev concatenate mint account and id to msgHash
     * @param account: mint address
     * @param id: ERC1155 token id
     */
    function getMessageHash(address account, uint256 id) public pure returns(bytes32){
        return keccak256(abi.encodePacked(account, id));
    }

    /**
     * @dev Verify signature using ECDSA, return true if the signature is valid.
     */
    function verify(bytes32 ethSignedMessageHash, bytes memory signature) public view returns (bool) {
        return ECDSA.recover(ethSignedMessageHash, signature) == signer;
    }

    /* ============ External Functions ============ */
    
    /**
     * @dev mint token `id` to `account` if `signature` is valid. 
     * `msgHash` is concatenated by `id` and `account`.
     * @param account: mint account
     * @param id: ERC1155 token id
     */
    function mint(address account, uint256 id, bytes memory signature)
    external
    {
        bytes32 msgHash = getMessageHash(account, id); // 将account和id打包消息
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(msgHash); // 计算以太坊签名消息
        require(verify(ethSignedMessageHash, signature), "Invalid signature"); // ECDSA检验通过
        require(!mintedAddress[id][account], "Already minted!"); // 地址没有mint过
        poap.mint(account, id); // mint
        mintedAddress[id][account] = true; // 记录mint过的地址
        emit sPOAPMinted(account, id);
    }

    /**
     * @dev change signer address. Only owner can call.
     * @param newSigner: address of new signer
     */
     function setSigner(address newSigner) external{
         emit SignerChanged(signer, newSigner);
         signer = newSigner;
     }
}

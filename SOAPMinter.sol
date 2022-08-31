// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./SOAP.sol";

contract SOAPMinter is Ownable{
    /* ============ Events ============ */
    event SOAPMinted(address indexed account, uint256 indexed eventId);
    event SignerChanged(address indexed oldSigner, address indexed newSigner);

    /* ============ State Variables ============ */
    address public signer;
    SOAP public soap;
    mapping(uint256 => mapping(address => bool)) public mintedAddress;   // 记录已经mint的地址

    /* ============ Constructor ============ */
    /*
     * @dev initialize SOAP addresss and signer address
     */
    constructor(address soapAddr_, address signer_){
        soap = SOAP(soapAddr_);
        signer = signer_;
    }

    /* ============ Public Functions ============ */
    /*
     * @dev concatenate mint account and eventId to msgHash
     * @param account: mint address
     * @param eventId: ERC1155 token id
     */
    function getMessageHash(address account, uint256 eventId) public pure returns(bytes32){
        return keccak256(abi.encodePacked(account, eventId));
    }

    /**
     * @dev Verify signature using ECDSA, return true if the signature is valid.
     */
    function verify(bytes32 ethSignedMessageHash, bytes memory signature) public view returns (bool) {
        return ECDSA.recover(ethSignedMessageHash, signature) == signer;
    }

    /* ============ External Functions ============ */
    
    /**
     * @dev mint token `eventId` to `account` if `signature` is valid. 
     * `msgHash` is concatenated by `eventId` and `account`.
     * @param account: mint account
     * @param eventId: ERC1155 token id
     */
    function mint(address account, uint256 eventId, bytes memory signature)
    external
    {
        bytes32 msgHash = getMessageHash(account, eventId); // 将account和eventId打包消息
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(msgHash); // 计算以太坊签名消息
        require(verify(ethSignedMessageHash, signature), "Invalid signature"); // ECDSA检验通过
        require(!mintedAddress[eventId][account], "Already minted!"); // 地址没有mint过
        soap.mint(account, eventId); // mint
        mintedAddress[eventId][account] = true; // 记录mint过的地址
        emit SOAPMinted(account, eventId);
    }

    /**
     * @dev change signer address. Only owner can call.
     * @param newSigner: address of new signer
     */
     function setSigner(address newSigner) external onlyOwner{
         emit SignerChanged(signer, newSigner);
         signer = newSigner;
     }
}

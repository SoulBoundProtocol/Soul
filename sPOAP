// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract sPOAP is ERC1155Supply, Ownable{
    using Strings for uint256;

    /* ============ Events ============ */
    event EventMinterAdded(address indexed newMinter);
    event EventMinterRemoved(address indexed oldMinter);

    /* ============ Modifiers ============ */
    /**
     * Only minter.
     */
    modifier onlyMinter() {
        require(minters[_msgSender()], "must be minter");
        _;
    }

    /* ============ State Variables ============ */
    string private _name; // collection name
    string private _symbol; // collection symbol
    string private _baseURI; // collection base URI
    mapping(address => bool) public minters; // Minters
    mapping(uint256 => uint256) private _totalSupply; // total supply for each id

    /* ============ Constructor ============ */
    constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC1155(""){
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
        minters[msg.sender] = true;
    }

    /* ============ Public Functions ============ */
    /**
     * @dev Returns the token collection name.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the metadata uri for specified token id. The id need to exist.
     */
    function uri(uint256 id) public view virtual override returns (string memory) {
        require(exists(id));
        return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, id.toString())) : "";
    }

    /* ============ External Functions ============ */
    /**
     * @dev Mint sPOAP. This function can only be called by minter.
     */
    function mint(address to, uint256 id)
        external
        onlyMinter
    {
        _mint(to, id, 1, "");
    }

    function setbaseURI(string memory baseURI_) external onlyOwner {
        _baseURI = baseURI_;
    }

    /**
     * @dev Add a new minter.
     */
    function addMinter(address minter) external onlyOwner {
        require(minter != address(0), "Minter must not be 0 address");
        require(!minters[minter], "Minter already exist");
        minters[minter] = true;
        emit EventMinterAdded(minter);
    }

    /**
     * @dev Remove a existing minter.
     */
    function removeMinter(address minter) external onlyOwner {
        require(minters[minter], "Minter does not exist");
        minters[minter] = false;
        emit EventMinterRemoved(minter);
    }

    /**
     * @dev Soulbound version of {IERC1155-safeTransferFrom}. Tokens can only be transfered by contract owner under the approval of the token nowner.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override onlyOwner{
        super.safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev Soulbound version of {IERC1155-safeBatchTransferFrom}. Tokens can only be transfered by contract owner under the approval of the token nowner.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override onlyOwner{
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }
}

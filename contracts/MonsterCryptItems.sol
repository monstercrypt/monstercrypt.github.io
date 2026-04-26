// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MonsterCryptItems is ERC1155, ERC1155Supply, Ownable {
    using Strings for uint256;

    string public name = "Monster Crypt Items";
    string public symbol = "MCI";

    mapping(address => bool) public minters;

    uint256 public constant PLASMA_BLADE = 1;
    uint256 public constant MAGA_SUPREMA = 101;
    uint256 public constant VOID_REAPER = 102;

    constructor() ERC1155("https://monstercrypt.github.io/api/metadata/{id}.json") Ownable(msg.sender) {
        minters[msg.sender] = true;
    }

    modifier onlyMinter() {
        require(minters[msg.sender] || owner() == msg.sender, "Not authorized");
        _;
    }

    function setMinter(address account, bool status) public onlyOwner {
        minters[account] = status;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyMinter {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyMinter {
        _mintBatch(to, ids, amounts, data);
    }

    // This is the function that was causing the error. 
    // In OpenZeppelin 5.0, we override both base contracts that implement _update.
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        virtual
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}

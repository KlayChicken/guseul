pragma solidity ^0.5.0;

import "./token/KIP7/KIP7Mintable.sol";
import "./token/KIP7/KIP7Burnable.sol";
import "./token/KIP7/KIP7Pausable.sol";
import "./token/KIP7/KIP7Metadata.sol";
import "./lifecycle/SelfDestructible.sol";
import "./ownership/Ownable.sol";

contract Guseul is
    KIP7Mintable,
    KIP7Burnable,
    KIP7Pausable,
    KIP7Metadata,
    Ownable,
    SelfDestructible
{
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initialSupply
    ) public KIP7Metadata(name, symbol, decimals) {
        _mint(msg.sender, initialSupply);
    }

    function pauseAll() public onlyPauser {
        pause();
    }
}

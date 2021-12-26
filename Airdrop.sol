pragma solidity ^0.5.6;

import "./ownership/Ownable.sol";
import "./math/SafeMath.sol";
import "./Guseul.sol";

contract Airdrop is Ownable {
    using SafeMath for uint256;

    Guseul public gsl;

    constructor(Guseul _gsl) public {
        gsl = _gsl;
    }

    function airdrop(address[] calldata to, uint256 amount)
        external
        payable
        onlyOwner
    {
        uint256 len = to.length;
        for (uint256 i = 0; i < len; i = i.add(1)) {
            gsl.transfer(to[i], amount);
        }
    }
}

pragma solidity ^0.5.6;

import "./ownership/Ownable.sol";
import "./math/SafeMath.sol";
import "./Guseul.sol";

contract Game is Ownable {
    using SafeMath for uint256;

    Guseul public gsl;
    uint256 public round = 1;

    mapping(uint256 => mapping(address => uint256)) private _betGsl;
    mapping(uint256 => mapping(address => bool)) private _betBool;
    mapping(uint256 => mapping(address => uint256)) private _lastGet;

    mapping(uint256 => address[]) private _betListOdd;
    mapping(uint256 => address[]) private _betListEven;

    constructor(Guseul _gsl) public {
        gsl = _gsl;
    }

    // 이번 라운드 벳 했는지 안했는지 호출
    function betOrNot(address adr) public returns (bool) {
        bool didbet = _betBool[round][adr];
        return didbet;
    }

    // 이번 라운드 벳 액수
    function betHowMuch(address adr) public returns (uint256) {
        uint256 howmuch = _betGsl[round][adr];
        return howmuch;
    }

    // 저번 라운드 벳 액수
    function earnHowMuchLast(address adr) public returns (uint256) {
        uint256 earnhowmuch = _lastGet[round.sub(1)][adr];
        return earnhowmuch;
    }

    // 홀수 벳
    function betOdd(uint256 amount) external payable {
        require(_betBool[round][msg.sender] != true);
        gsl.transferFrom(msg.sender, address(this), amount);
        _betGsl[round][msg.sender] = amount;
        _betBool[round][msg.sender] = true;
        _betListOdd[round].push(msg.sender);
    }

    //짝수 벳
    function betEven(uint256 amount) external payable {
        require(_betBool[round][msg.sender] != true);
        gsl.transferFrom(msg.sender, address(this), amount);
        _betGsl[round][msg.sender] = amount;
        _betBool[round][msg.sender] = true;
        _betListEven[round].push(msg.sender);
    }

    function raffle(uint256 oddeven) external onlyOwner {
        //1이 홀수, 2가 짝수
        uint256 _round = round;
        if (oddeven == 1) {
            uint256 len = _betListOdd[round].length;
            for (uint256 i = 0; i < len; i = i.add(1)) {
                gsl.transfer(
                    _betListOdd[round][i],
                    _betGsl[round][_betListOdd[round][i]].mul(2)
                );
                _lastGet[round][_betListOdd[round][i]] = _betGsl[round][
                    _betListOdd[round][i]
                ].mul(2);
            }
        } else {
            uint256 len = _betListEven[round].length;
            for (uint256 i = 0; i < len; i = i.add(1)) {
                gsl.transfer(
                    _betListEven[round][i],
                    _betGsl[round][_betListEven[round][i]].mul(2)
                );
                _lastGet[round][_betListEven[round][i]] = _betGsl[round][
                    _betListEven[round][i]
                ].mul(2);
            }
        }
        round = _round.add(1);
    }
}

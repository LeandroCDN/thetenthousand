// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

//import "./thenthousand.sol"
/*/TODO:
* add ownable library
* Function play add payable sistem
*/

interface IRadom{
    function rand(address _user) external view returns(uint256);
    function randrange(uint a, uint b,address _user) external view returns(uint);
    function randWhitSignature(uint min, uint max, address _user, uint _randSigner) external view returns(uint);
}

contract factoryTenThoushand {
    mapping (address => address)public MiContratoPersonal;

    function Factory() public {
        address newContract = address(new tenthousand(msg.sender));
        MiContratoPersonal[msg.sender] = newContract;
    }
}

contract tenthousand {
    IRadom randomContract;
    uint public maxNumber = 10000;
    uint public lastResult;
    address public owner;

    uint playPrice;
    uint basePrice;

    constructor(address _owner) {
        owner= _owner;
    }

    function play(uint _number) public returns(bool){
        lastResult = randomContract.randrange(0, maxNumber, msg.sender);
        if(lastResult  == _number){
            maxNumber = 10000;
            return true;
        }else{
            maxNumber -=1;
            return false;
        }
    }

    function setRandomContract(address _randomContract) public {
        require(msg.sender == owner, "No eres el owner");
        randomContract = IRadom(_randomContract);
    } 

    function calculatePricePerPlay()public view returns(uint){
        uint balance = address(msg.sender).balance;
        if (balance > maxNumber){
            return (balance / maxNumber)+basePrice;
        }
        return basePrice; 
    }

    
    function setBasePrice(uint _newBasePrice) public /*onlyOwner*/{
       basePrice =_newBasePrice;
    }
}
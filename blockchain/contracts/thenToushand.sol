// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./utils/WithSigner.sol";
import "./libraries/SignatureVerifier.sol";


interface IRadom{
    function rand(address _user) external view returns(uint256);
    function randrange(uint a, uint b,address _user) external view returns(uint);
    function randWhitSignature(uint min, uint max, address _user, uint _randSigner) external view returns(uint);
}

contract tenthousand is WithSigner{
    using SignatureVerifier for bytes32;
    mapping(uint => bool) public usedKeys;
    IRadom randomContract;
    uint public maxNumber = 10;
    uint public lastResult;
    //address public owner;

    uint playPrice;
    uint basePrice;

    constructor(address _owner, address _signer) WithSigner(_signer) {
        //owner= _owner;
    }

    function play(uint _number, uint _numRand, bytes memory _signature,  uint _idempotencyKey) public view returns(bool){
        bool isPermitValid = validateData(_numRand,_signature,_idempotencyKey);
        return isPermitValid;/*
        require(isPermitValid, "FACTORY: Permit invalid");
        usedKeys[_idempotencyKey] = true;
        //uint randResul = randomContract.randWhitSignature(1,maxNumber,msg.sender,_numRand,_randSigner);
        if(randResul = _number){
            return true;
        }else{
            maxNumber--;
            //transfer founds in.
            return false;
        }    
        revert;*/
    }
    
    function setRandomContract(address _randomContract) public {
        //require(msg.sender == owner, "No eres el owner");
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

    //the mensage hased have [RandomNumber, signature, nonce/key]
    /*TODO:
    * pasar toda las intruciones de validateData a otro contrato
    */ 
    function validateData(uint _numRand, bytes memory _signature, uint _idempotencyKey)public view returns(bool){
        require(!usedKeys[_idempotencyKey], "FACTORY: Permit already used");
        bytes32 hash =getHash(_numRand,  _idempotencyKey, address(this));
        bytes32 messageHash = getEthSignedHash(hash);
        bool isPermitValid= verify(signer(),  messageHash, _signature);
        return isPermitValid;
    }

    function getHash(uint  num, uint _idempotencyKey, address contractID) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(num,_idempotencyKey,contractID));
    }

     function getEthSignedHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }
    function verify(
        address signer,
        bytes32 messageHash,
        bytes memory _signature
    ) public pure returns (bool) {
        
        return messageHash.getSigner(_signature) == signer;
    }
}
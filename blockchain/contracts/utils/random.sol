// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract Random {
    address owner;
    uint seed;
    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }

    constructor(){ 
        //balances :D       
        owner = msg.sender;
    }

    function NewSeed(string memory _randomString)
        public                
        returns(uint256)
    {
    
        seed = (uint256(keccak256(abi.encodePacked(_randomString))))/(block.timestamp*100);
        return seed;
    }
   
    function rand(address _user)
        public
          
        returns(uint256)
    {
        uint balance = address(_user).balance;
        uint balanceSender = address(msg.sender).balance;
        uint256 randNum = uint256(keccak256(abi.encodePacked(block.timestamp + block.difficulty + block.number + 
            ((uint256(keccak256(abi.encodePacked(_user,balance,balanceSender,seed))))
             ))));
        seed = randNum+balanceSender;
        return randNum;
    }
    function rand(address _user, uint _randSigner)
        public
          
        returns(uint256)
    {
        uint balance = address(_user).balance;
        uint balanceSender = address(msg.sender).balance;
        uint256 randNum = uint256(keccak256(abi.encodePacked(block.timestamp + block.difficulty + block.number + 
            ((uint256(keccak256(abi.encodePacked(_user,balance,balanceSender,seed,_randSigner))))
             ))));
        seed = randNum+balanceSender;
        return randNum;
    }

    
    /**
     * @dev Generate random uint in range [a, b]
     * @return uint
     */
    function randrange(uint a, uint b,address _user) external returns(uint) {
        return a + (rand(_user) % b);
    }

    function randWhitSignature(uint min, uint max, address _user, uint _randSigner) external returns(uint) {
        return min + (rand(_user, _randSigner) % max);
    }
    
    function blockTime()public view returns(uint){
        return block.timestamp;
    }
    function blockNum()public view returns(uint){
        return block.number;
    }
    
}
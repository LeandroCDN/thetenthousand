// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SignatureVerifier {

    
  function getEthSignedMessageHash(bytes32 messageHash) internal pure returns (bytes32) {
    return keccak256(abi.encode("\x19Ethereum Signed Message:\n32", messageHash));
  }

  function getSigner(bytes32 _messageHash, bytes memory _signature) internal pure returns (address) {
    (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
    return ecrecover(_messageHash, v, r, s);
  }

  function splitSignature(bytes memory sig)
    internal
    pure
    returns (
      bytes32 r,
      bytes32 s,
      uint8 v
    )
  {
    require(sig.length == 65, "invalid signature length");
    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := byte(0, mload(add(sig, 96)))
    }
  }
  
  function getHash(uint  num, uint _idempotencyKey) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(num,_idempotencyKey));
  }
}
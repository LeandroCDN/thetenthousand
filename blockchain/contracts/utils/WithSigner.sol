// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract WithSigner is Context, Ownable {
  address private _signer;

  event SignerTransferred(address indexed previousSigner, address indexed newSigner);

  /**
   * @dev Initializes the contract setting the deployer as the initial signer.
   */
  constructor(address _newSigner) {
    _transferSigner(_newSigner);
  }

  /**
   * @dev Returns the address of the current signer.
   */
  function signer() public view virtual returns (address) {
    return _signer;
  }

  /**
   * @dev Transfers signer of the contract to a new account (`_newSigner`).
   * Can only be called by the current owner.
   */
  function transferSigner(address _newSigner) public virtual onlyOwner {
    require(_newSigner != address(0), "WithSigner: new signer is the zero address");
    _transferSigner(_newSigner);
  }

  /**
   * @dev Transfers signer of the contract to a new account (`_newSigner`).
   * Internal function without access restriction.
   */
  function _transferSigner(address _newSigner) internal virtual {
    address oldSigner = _signer;
    _signer = _newSigner;
    emit SignerTransferred(oldSigner, _newSigner);
  }
}

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./AuroraBookingNFT.sol";

contract AuroraBooking is Ownable {

  address nftContractAddress;
  uint256 nftCounter;

  event Booked(address indexed buyer, uint8 placeId, uint8 tableId, uint256 nftId);

  constructor(address _nftContractAddress) {
    nftContractAddress = _nftContractAddress;
  }

  function book(uint8 placeId, uint8 tableId) external {
    AuroraBookingNFT(nftContractAddress).mint(msg.sender, nftCounter);

    emit Booked(msg.sender, placeId, tableId, nftCounter);

    nftCounter++;
  }

}

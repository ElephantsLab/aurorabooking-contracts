// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./AuroraBookingNFT.sol";

struct Lot {
  address seller;
  uint256 tokenId;
  uint256 price;
  uint256 time;
  bool isSoldOut;
}

contract AuroraBooking is Ownable {

  address nftContractAddress;
  uint256 nftCounter;

  Lot[] public lots;

  event Booked(address indexed buyer, uint8 placeId, uint8 tableId, uint256 tokenId);
  event LotCreated(address indexed seller, uint256 tokenId, uint256 price);

  constructor(address _nftContractAddress) {
    nftContractAddress = _nftContractAddress;
  }

  function book(uint8 placeId, uint8 tableId) external {
    AuroraBookingNFT(nftContractAddress).mint(msg.sender, nftCounter);

    emit Booked(msg.sender, placeId, tableId, nftCounter);

    nftCounter++;
  }

  function sell(uint256 tokenId, uint256 price) external {
    require(AuroraBookingNFT(nftContractAddress).ownerOf(tokenId) == msg.sender, "You aren't the owner of this NFT");
    require(AuroraBookingNFT(nftContractAddress).getApproved(tokenId) == address(this), "NFT token spend is not allowed");

    //TODO: transfer NFT token to the contract balance

    // create new lot
    lots.push(Lot({
      seller: msg.sender,
      tokenId: tokenId,
      price: price,
      time: block.timestamp,
      isSoldOut: false
    }));

    emit LotCreated(msg.sender, tokenId, price);
  }

  function buy(uint256 lotId) external payable {
    require(lots[lotId].seller == AuroraBookingNFT(nftContractAddress).ownerOf(lots[lotId].tokenId), "Seller isn't an owner of this NFT");
    require(msg.value == lots[lotId].price, "Invalid ETH amount");

    AuroraBookingNFT(nftContractAddress).safeTransferFrom(
      lots[lotId].seller,
      msg.sender,
      lots[lotId].tokenId
    );

    payable(lots[lotId].seller).transfer(msg.value);
  }

}

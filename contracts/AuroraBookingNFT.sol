// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AuroraBookingNFT is ERC721("Aurora Booking Collection", "ABC"), Ownable {

  mapping(address => uint256[]) public owns;

  function _baseURI() internal pure override returns (string memory) {
    return "http://aurorabooking.net:3000/metadata/";
  }

  function _transfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override {
    super._transfer(from, to, tokenId);

    uint8 idx = 0;
    while (idx < owns[from].length) {
      if (owns[from][idx] == tokenId) {
        break;
      }

      idx++;
    }

    if (idx < owns[from].length) {
      owns[from][idx] = owns[from][owns[from].length - 1];
      owns[from].pop();
    }

    owns[to].push(tokenId);
  }

  function mint(address _address, uint256 _id) external onlyOwner {
    _mint(_address, _id);
  }

  //TODO: burning

}

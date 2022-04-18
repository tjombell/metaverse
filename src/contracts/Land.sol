// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Land is ERC721 {
    uint256 public cost = 1 ether;
    uint256 public maxSupply = 13;
    uint256 public totalSupply = 0;

    struct Building {
        string name;
        address owner;
        int256 posX;
        int256 posY;
        int256 posZ;
        uint256 sizeX;
        uint256 sizeY;
        uint256 sizeZ;
    }

    Building[] public buildings;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cost
    ) ERC721(_name, _symbol) {
        cost = _cost;

        buildings.push(Building("Lot 001 VIP", address(0x0), 0, 0, 0, 10, 10, 10));

        buildings.push(Building("Lot 002 premium", address(0x0), 0, 10, 0, 10, 5, 3));
        buildings.push(Building("Lot 003 premium", address(0x0), 0, -10, 0, 10, 5, 3));
        buildings.push(Building("Lot 004 premium", address(0x0), 10, 0, 0, 5, 25, 5));
        buildings.push(Building("Lot 005 premium", address(0x0), -10, 0, 0, 5, 25, 5));

        buildings.push(Building("Lot 006", address(0x0), 0, 18, 0, 10, 5, 3));
        buildings.push(Building("Lot 007", address(0x0), 0, -18, 0, 10, 5, 3));
        buildings.push(Building("Lot 008", address(0x0), 18, 0, 0, 5, 25, 5));
        buildings.push(Building("Lot 009", address(0x0), -18, 0, 0, 5, 25, 5));

        buildings.push(Building("Lot 010", address(0x0), 14, 18, 0, 13, 5, 3));
        buildings.push(Building("Lot 011", address(0x0), -14, -18, 0, 13, 5, 3));
        buildings.push(Building("Lot 012", address(0x0), 14, -18, 0, 13, 5, 3));
        buildings.push(Building("Lot 013", address(0x0), -14, 18, 0, 13, 5, 3));
    }

    function mint(uint256 _id) public payable {
        uint256 supply = totalSupply;
        require(supply <= maxSupply);
        require(buildings[_id - 1].owner == address(0x0));
        require(msg.value >= cost);

        // NOTE: tokenID always starts from 1, but our array starts from 0
        buildings[_id - 1].owner = msg.sender;
        totalSupply = totalSupply + 1;

        _safeMint(msg.sender, _id);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        // Update Building ownership
        buildings[tokenId - 1].owner = to;

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        // Update Building ownership
        buildings[tokenId - 1].owner = to;

        _safeTransfer(from, to, tokenId, _data);
    }

    // Public View Functions
    function getBuildings() public view returns (Building[] memory) {
        return buildings;
    }

    function getBuilding(uint256 _id) public view returns (Building memory) {
        return buildings[_id - 1];
    }
}

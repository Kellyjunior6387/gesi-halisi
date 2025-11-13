// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title CylinderNFT
 * @dev NFT contract for tracking gas cylinders on the blockchain
 * Each cylinder is minted as a unique NFT with metadata stored on-chain
 */
contract CylinderNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Struct to store cylinder metadata on-chain
    struct CylinderMetadata {
        string cylinderId;
        string manufacturer;
        string cylinderType;
        uint256 weight;
        uint256 capacity;
        string batchNumber;
        uint256 mintedAt;
        bool isActive;
    }

    // Mapping from token ID to cylinder metadata
    mapping(uint256 => CylinderMetadata) public cylinders;
    
    // Mapping from cylinderId to token ID (for lookup)
    mapping(string => uint256) public cylinderIdToTokenId;
    
    // Mapping from manufacturer to list of token IDs
    mapping(string => uint256[]) public manufacturerCylinders;

    // Events
    event CylinderMinted(
        uint256 indexed tokenId,
        string cylinderId,
        string manufacturer,
        string cylinderType,
        uint256 weight,
        uint256 capacity,
        string batchNumber
    );

    event CylinderDeactivated(uint256 indexed tokenId);
    event CylinderReactivated(uint256 indexed tokenId);

    constructor() ERC721("Gesi Halisi Cylinder", "GHCYL") Ownable(msg.sender) {
        // Start token IDs from 1
        _tokenIdCounter.increment();
    }

    /**
     * @dev Mint a new cylinder NFT
     * @param to Address to mint the NFT to
     * @param cylinderId Unique cylinder identifier
     * @param manufacturer Manufacturer name/ID
     * @param cylinderType Type of cylinder (LPG, Oxygen, etc.)
     * @param weight Weight of the cylinder in grams
     * @param capacity Capacity in grams
     * @param batchNumber Batch number
     * @param uri Token URI for metadata (can be empty if using on-chain metadata)
     * @return tokenId The ID of the newly minted token
     */
    function mintCylinder(
        address to,
        string memory cylinderId,
        string memory manufacturer,
        string memory cylinderType,
        uint256 weight,
        uint256 capacity,
        string memory batchNumber,
        string memory uri
    ) public onlyOwner returns (uint256) {
        require(bytes(cylinderId).length > 0, "Cylinder ID cannot be empty");
        require(cylinderIdToTokenId[cylinderId] == 0, "Cylinder already minted");
        require(to != address(0), "Cannot mint to zero address");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        // Mint the NFT
        _safeMint(to, tokenId);
        
        // Set token URI if provided
        if (bytes(uri).length > 0) {
            _setTokenURI(tokenId, uri);
        }

        // Store cylinder metadata
        cylinders[tokenId] = CylinderMetadata({
            cylinderId: cylinderId,
            manufacturer: manufacturer,
            cylinderType: cylinderType,
            weight: weight,
            capacity: capacity,
            batchNumber: batchNumber,
            mintedAt: block.timestamp,
            isActive: true
        });

        // Create lookup mappings
        cylinderIdToTokenId[cylinderId] = tokenId;
        manufacturerCylinders[manufacturer].push(tokenId);

        emit CylinderMinted(
            tokenId,
            cylinderId,
            manufacturer,
            cylinderType,
            weight,
            capacity,
            batchNumber
        );

        return tokenId;
    }

    /**
     * @dev Get cylinder metadata by token ID
     * @param tokenId Token ID to query
     * @return Cylinder metadata struct
     */
    function getCylinderMetadata(uint256 tokenId) 
        public 
        view 
        returns (CylinderMetadata memory) 
    {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return cylinders[tokenId];
    }

    /**
     * @dev Get token ID by cylinder ID
     * @param cylinderId Cylinder ID to query
     * @return Token ID
     */
    function getTokenIdByCylinderId(string memory cylinderId) 
        public 
        view 
        returns (uint256) 
    {
        uint256 tokenId = cylinderIdToTokenId[cylinderId];
        require(tokenId != 0, "Cylinder not found");
        return tokenId;
    }

    /**
     * @dev Get all cylinders minted by a manufacturer
     * @param manufacturer Manufacturer name/ID
     * @return Array of token IDs
     */
    function getCylindersByManufacturer(string memory manufacturer) 
        public 
        view 
        returns (uint256[] memory) 
    {
        return manufacturerCylinders[manufacturer];
    }

    /**
     * @dev Deactivate a cylinder (mark as retired/destroyed)
     * @param tokenId Token ID to deactivate
     */
    function deactivateCylinder(uint256 tokenId) public onlyOwner {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        require(cylinders[tokenId].isActive, "Cylinder already deactivated");
        
        cylinders[tokenId].isActive = false;
        emit CylinderDeactivated(tokenId);
    }

    /**
     * @dev Reactivate a cylinder
     * @param tokenId Token ID to reactivate
     */
    function reactivateCylinder(uint256 tokenId) public onlyOwner {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        require(!cylinders[tokenId].isActive, "Cylinder already active");
        
        cylinders[tokenId].isActive = true;
        emit CylinderReactivated(tokenId);
    }

    /**
     * @dev Get the total number of cylinders minted
     * @return Total count
     */
    function totalCylinders() public view returns (uint256) {
        return _tokenIdCounter.current() - 1;
    }

    /**
     * @dev Check if a cylinder is active
     * @param tokenId Token ID to check
     * @return Boolean indicating if cylinder is active
     */
    function isCylinderActive(uint256 tokenId) public view returns (bool) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return cylinders[tokenId].isActive;
    }

    // Override required functions
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract AddressToTokenMap {
    address owner;

    // token address => Symbol for Symbol retrieval
    mapping(address => string) private addresses;

    // token address => token/USD Chainlink price feed address
    mapping(address => address) private priceFeedMap;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not Owner, cannot add mapping");
        _;
    }

    /**
     * @dev Retrieves the symbol for a token address
     * @param _key Token address
     * @return symbol string
     */
    function getSymbol(address _key) public view returns (string memory) {
        return addresses[_key];
    }

    /**
     * @dev Maps token address to symbol
     * @param _key Token address
     * @param _value Symbol string
     */
    function _setAddress(address _key, string memory _value) public onlyOwner {
        // Avoid updating if the value is unchanged
        bytes memory valueBytes = bytes(_value);
        bytes memory keyBytes = bytes(addresses[_key]);

        if (valueBytes.length != keyBytes.length) {
            addresses[_key] = _value;
        } else {
            for (uint256 i = 0; i < valueBytes.length; i++) {
                if (valueBytes[i] != keyBytes[i]) {
                    addresses[_key] = _value;
                    break;
                }
            }
        }
    }

    /**
     * @dev Returns the Chainlink price feed address for a token
     * @param _tokenAddress Token address
     * @return price feed address
     */
    function getPriceFeedMap(address _tokenAddress)
        public
        view
        returns (address)
    {
        return priceFeedMap[_tokenAddress];
    }

    /**
     * @dev Maps token address to Chainlink price feed address
     * @param _tokenAddress Token address
     * @param _pairAddress Price feed address
     */
    function _setPriceFeedMap(
        address _tokenAddress,
        address _pairAddress
    ) public onlyOwner {
        if (priceFeedMap[_tokenAddress] != _pairAddress) {
            priceFeedMap[_tokenAddress] = _pairAddress;
        }
    }

    /**
     * @dev Returns true if the token symbol is ETH
     * @param _token Token address
     * @return boolean
     */
    function isETH(address _token) public view returns (bool) {
        return
            keccak256(abi.encodePacked(getSymbol(_token))) ==
            keccak256(abi.encodePacked("ETH"));
    }
}

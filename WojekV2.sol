// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library WojekHelper
{
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }

    function parseInt(string memory _a) internal pure returns (uint8 _parsedInt) {
        bytes memory bresult = bytes(_a);
        uint8 minty = 0;
        for (uint8 i = 0; i < bresult.length; i++) {
            if (
                (uint8(uint8(bresult[i])) >= 48) &&
                (uint8(uint8(bresult[i])) <= 57)
            ) {
                minty *= 10;
                minty += uint8(bresult[i]) - 48;
            }
        }
        return minty;
    }

    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function stringLength(string memory str) internal pure returns(uint256) {
        return bytes(str).length;
    }
}

enum AttributeTrait
{
    Background,
    Character,
    Skin,  
    Beard,      
    Forehead,   
    Mouth,     
    Eyes,       
    Nose,      
    Headware,   
    Accessory   
}

contract Wojek
{
    struct Attribute 
    {
        string value;
        string trait;
        string svg;
    }

    Attribute[][] private _attributes;
    mapping(uint256 => string) private _tokens;

    /* Hashing standard
        Background  0
        Character   1
        Skin        2   
        Beard       3
        Forehead    4
        Mouth       5   
        Eyes        6
        Nose        7
        Headware    8
        Accessory   9

        Phunked     10
        Series      11
    */

    constructor()
    {
        for(uint256 i = 0; i < 10; i++)
        {
            _attributes.push();
            _attributes[i].push(Attribute("Value_Test", "Trait_Test", "001515012020001515012020001515012020001515012020"));
        }
    }

    //000000000000000000000000000000

    function generateSvg(string memory hash, uint8 traitCount) public view returns(string memory) 
    {
        require(traitCount <= 10);

        string memory svg = "<svg id='wojek' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50'><style>#wojek{shape-rendering: crispedges;}rect{width:1px;height:1px;}.w00{fill:#000000}.w01{fill:#ffffff}</style></svg>";

        for(uint256 i = 0; i < traitCount; i++) 
        {
            //uint256 attributeIndex = WojekHelper.parseInt(WojekHelper.substring(hash, i * 3, i * 3 + 3));
            uint256 attributeIndex = 0;

            for(uint256 r = 0; r < 8; r++)
            {
                string memory data = WojekHelper.substring(_attributes[i][attributeIndex].svg, r * 6, r * 6 + 6);

                svg = string(abi.encodePacked
                (
                    svg, 
                    "<rect class='w", WojekHelper.substring(data, 0, 2), 
                    "' x='", WojekHelper.substring(data, 2, 4), 
                    "' y='", WojekHelper.substring(data, 4, 6), 
                    "'/>"
                ));
            }
        }
        
        return svg;
    }
}
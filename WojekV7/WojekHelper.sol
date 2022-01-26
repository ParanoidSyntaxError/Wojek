// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library WojekHelper
{
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function attributeIndexToString(uint256 index) internal pure returns (string memory result)
    {
        if(index == 0)
        {
            result = "Background";
        }
        else if(index == 1)
        {
            result = "Character";
        }
        else if(index == 2)
        {
            result = "Beard";
        }
        else if(index == 3)
        {
            result = "Forehead";
        }
        else if(index == 4)
        {
            result = "Mouth";
        }
        else if(index == 5)
        {
            result = "Eyes";
        }
        else if(index == 6)
        {
            result = "Nose";
        }
        else if(index == 7)
        {
            result = "Hat";
        }
        else if(index == 8)
        {
            result = "Accessory";
        }

        return result;
    }

    function dirtyRandom(uint256 seed, address sender) internal view returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, sender, seed)));
    }

    function subString(string memory str, uint startIndex, uint endIndex) internal pure returns (bytes memory) 
    {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return result;
    }

    function splitHash(uint256 hash, uint256 hashLength, uint256 attributeIndex) internal pure returns (uint256)
    {
        return ((hash - 10 ** hashLength) / (10 ** (hashLength - (attributeIndex * 3) - 3))) % 1000;
    }

    function stringLength(string memory str) internal pure returns(uint256) {
        return bytes(str).length;
    }

    function toString(uint256 value) internal pure returns (string memory) 
    {
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

    function encode(bytes memory data) internal pure returns (string memory) 
    {
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
}
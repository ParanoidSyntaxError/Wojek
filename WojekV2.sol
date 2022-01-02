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

    uint256 private constant _traitCount = 10;

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
        for(uint256 i = 0; i < _traitCount; i++)
        {
            _attributes.push();
        }

        _attributes[0].push(Attribute("White", "Background", "<rect class='w01'x='00'y='00'width='50'height='50'/>")); 
        _attributes[1].push(Attribute("Wojak", "Character", "<rect class='w01'x='15'y='05'width='19'height='45'/><rect class='w01'x='17'y='03'width='18'height='02'/><rect class='w01'x='34'y='05'width='04'height='37'/><rect class='w01'x='38'y='07'width='02'height='33'/><rect class='w01'x='40'y='09'width='02'height='29'/><rect class='w01'x='42'y='14'width='02'height='20'/><rect class='w01'x='44'y='25'width='01'height='05'/><rect class='w01'x='13'y='07'width='02'height='24'/><rect class='w01'x='11'y='11'width='02'height='15'/><rect class='w01'x='34'y='46'width='12'height='04'/><rect class='w01'x='46'y='49'width='03'height='01'/><rect class='w01'x='34'y='45'width='01'height='01'/><rect class='w01'x='46'y='48'width='01'height='01'/><rect class='w01'x='00'y='47'width='15'height='03'/><rect class='w01'x='05'y='45'width='10'height='02'/><rect class='w01'x='11'y='43'width='04'height='02'/><rect class='w01'x='13'y='39'width='02'height='04'/><rect class='w00'x='00'y='47'width='01'height='01'/><rect class='w00'x='01'y='46'width='04'height='01'/><rect class='w00'x='05'y='45'width='03'height='01'/><rect class='w00'x='08'y='44'width='03'height='01'/><rect class='w00'x='11'y='43'width='01'height='01'/><rect class='w00'x='12'y='42'width='01'height='01'/><rect class='w00'x='13'y='39'width='01'height='03'/><rect class='w00'x='14'y='37'width='01'height='02'/><rect class='w00'x='15'y='32'width='01'height='05'/><rect class='w00'x='14'y='31'width='01'height='01'/><rect class='w00'x='13'y='29'width='01'height='02'/><rect class='w00'x='12'y='26'width='01'height='03'/><rect class='w00'x='11'y='24'width='01'height='02'/><rect class='w00'x='10'y='14'width='01'height='10'/><rect class='w00'x='11'y='11'width='01'height='03'/><rect class='w00'x='12'y='08'width='01'height='03'/><rect class='w00'x='13'y='07'width='01'height='01'/><rect class='w00'x='14'y='06'width='01'height='01'/><rect class='w00'x='15'y='05'width='01'height='01'/><rect class='w00'x='16'y='04'width='01'height='01'/><rect class='w00'x='17'y='03'width='03'height='01'/><rect class='w00'x='20'y='02'width='11'height='01'/><rect class='w00'x='31'y='03'width='04'height='01'/><rect class='w00'x='35'y='04'width='02'height='01'/><rect class='w00'x='37'y='05'width='01'height='01'/><rect class='w00'x='38'y='06'width='01'height='01'/><rect class='w00'x='39'y='07'width='01'height='01'/><rect class='w00'x='40'y='08'width='01'height='01'/><rect class='w00'x='41'y='09'width='01'height='02'/><rect class='w00'x='42'y='11'width='01'height='03'/><rect class='w00'x='43'y='14'width='01'height='03'/><rect class='w00'x='44'y='17'width='01'height='08'/><rect class='w00'x='45'y='25'width='01'height='05'/><rect class='w00'x='44'y='30'width='01'height='02'/><rect class='w00'x='43'y='32'width='01'height='02'/><rect class='w00'x='42'y='34'width='01'height='01'/><rect class='w00'x='41'y='35'width='01'height='03'/><rect class='w00'x='40'y='38'width='01'height='01'/><rect class='w00'x='39'y='39'width='01'height='01'/><rect class='w00'x='38'y='40'width='01'height='01'/><rect class='w00'x='36'y='41'width='02'height='01'/><rect class='w00'x='30'y='42'width='06'height='01'/><rect class='w00'x='28'y='41'width='02'height='01'/><rect class='w00'x='27'y='40'width='01'height='01'/><rect class='w00'x='25'y='39'width='02'height='01'/><rect class='w00'x='24'y='38'width='01'height='01'/><rect class='w00'x='23'y='37'width='01'height='01'/><rect class='w00'x='22'y='36'width='01'height='01'/><rect class='w00'x='21'y='35'width='01'height='01'/><rect class='w00'x='20'y='34'width='01'height='01'/><rect class='w00'x='19'y='31'width='01'height='03'/><rect class='w00'x='18'y='28'width='01'height='03'/><rect class='w00'x='33'y='43'width='01'height='01'/><rect class='w00'x='34'y='44'width='01'height='01'/><rect class='w00'x='35'y='45'width='08'height='01'/><rect class='w00'x='43'y='46'width='03'height='01'/><rect class='w00'x='46'y='47'width='01'height='01'/><rect class='w00'x='47'y='48'width='02'height='01'/><rect class='w00'x='49'y='49'width='01'height='01'/><rect class='w00'x='18'y='36'width='01'height='01'/><rect class='w00'x='19'y='37'width='01'height='02'/><rect class='w00'x='14'y='45'width='02'height='01'/><rect class='w00'x='16'y='44'width='01'height='01'/><rect class='w00'x='17'y='43'width='02'height='01'/><rect class='w00'x='23'y='47'width='02'height='01'/><rect class='w00'x='25'y='48'width='04'height='01'/><rect class='w00'x='29'y='47'width='02'height='01'/>"));
        _attributes[2].push(Attribute("None", "Skin", ""));
        _attributes[3].push(Attribute("None", "Beard", ""));
        _attributes[4].push(Attribute("Wojak forehead", "Forehead", "<rect class='w00'x='23'y='11'width='04'height='01'/><rect class='w00'x='27'y='10'width='09'height='01'/><rect class='w00'x='36'y='11'width='03'height='01'/><rect class='w00'x='21'y='15'width='02'height='01'/><rect class='w00'x='23'y='14'width='06'height='01'/><rect class='w00'x='29'y='13'width='07'height='01'/><rect class='w00'x='36'y='14'width='02'height='01'/><rect class='w00'x='23'y='19'width='02'height='01'/><rect class='w00'x='25'y='18'width='04'height='01'/><rect class='w00'x='36'y='18'width='04'height='01'/><rect class='w00'x='40'y='19'width='02'height='01'/>"));
        _attributes[5].push(Attribute("Wojak mouth", "Mouth", "<rect class='w00'x='28'y='35'width='05'height='01'/><rect class='w00'x='33'y='36'width='05'height='01'/>"));
        _attributes[6].push(Attribute("Wojak eyes", "Eyes", "<rect class='w00'x='24'y='21'width='05'height='02'/><rect class='w00'x='29'y='22'width='01'height='02'/><rect class='w00'x='25'y='23'width='04'height='01'/><rect class='w01'x='25'y='22'width='01'height='01'/><rect class='w00'x='36'y='21'width='05'height='02'/><rect class='w00'x='37'y='23'width='03'height='01'/><rect class='w01'x='37'y='22'width='01'height='01'/>"));
        _attributes[7].push(Attribute("Wojak nose", "Nose", "<rect class='w00'x='30'y='30'width='01'height='01'/><rect class='w00'x='31'y='31'width='01'height='01'/><rect class='w00'x='35'y='31'width='01'height='01'/><rect class='w00'x='36'y='29'width='01'height='02'/><rect class='w00'x='35'y='28'width='01'height='01'/><rect class='w00'x='34'y='25'width='01'height='03'/>"));
        _attributes[8].push(Attribute("None", "Headware", ""));
        _attributes[9].push(Attribute("None", "Accessory", ""));
    }

    function generateSvg() public view returns(string memory) 
    {
        string memory hash = "000000000000000000000000000000";

        string memory svg = "<svg id='wojek' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50'><style>#wojek{shape-rendering: crispedges;}.w00{fill:#000000}.w01{fill:#ffffff}</style>";

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.parseInt(WojekHelper.substring(hash, i * 3, i * 3 + 3));

            svg = string(abi.encodePacked(svg, _attributes[i][attributeIndex].svg));

            /*
            string memory data = _attributes[i][attributeIndex].svg;

            //uint256 attributeLength = WojekHelper.stringLength(data) / 35;

            for(uint256 r = 0; r < 150; r++)
            {
                uint256 dataIndex = r * 35;

                if(dataIndex >= WojekHelper.stringLength(data))
                {
                    break;
                }
                else
                {
                    svg = string(abi.encodePacked
                    (
                        svg,
                        "<rect class='w",
                        WojekHelper.substring(data, dataIndex, dataIndex + 35),
                        "'/>"
                    ));
                }

                svg = string(abi.encodePacked
                (
                    svg,
                    "<rect class='w",
                    WojekHelper.substring(data, dataIndex + 9, dataIndex + 11),
                    "' x='", 
                    WojekHelper.substring(data, dataIndex, dataIndex + 2), 
                    "' y='", 
                    WojekHelper.substring(data, dataIndex + 2, dataIndex + 4), 
                    "' width='",
                    WojekHelper.substring(data, dataIndex + 4, dataIndex + 6),
                    "' height='",
                    WojekHelper.substring(data, dataIndex + 6, dataIndex + 8),
                    "'/>"
                ));
            }
            */
        }

        return string(abi.encodePacked(svg, "</svg>"));
    }
}
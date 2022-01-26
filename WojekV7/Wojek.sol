// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./Ownable.sol";
import "./WojekHelper.sol";

contract Wojek is ERC721, Ownable
{
    struct Attribute 
    {
        string value;
        string svg;
    }

    string private constant _svgHeader = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50' transform='scale(";
    string private constant _svgStyles = "<style>#wojek-svg{shape-rendering: crispedges;}.w10{fill:#000000}.w11{fill:#ffffff}.w12{fill:#00aaff}.w13{fill:#ff0000}.w14{fill:#ff7777}.w15{fill:#ff89b9}.w16{fill:#fff9e5}.w17{fill:#fff9d5}.w18{fill:#93c63b}.w19{fill:#ff6a00}.w20{fill:#808080}.w21{fill:#a94d00}.w22{fill:#00ffff}.w23{fill:#00ff00}.w24{fill:#B2B2B2}.w25{fill:#267F00}.w26{fill:#5B7F00}.w27{fill:#7F3300}.w28{fill:#A3A3A3}.w29{fill:#B78049}.w30{fill:#B5872B}.w31{fill:#565756}.w32{fill:#282828}.w33{fill:#8F7941}.w34{fill:#E3E5E4}.w35{fill:#6BBDD3}.w36{fill:#FFFF00}.w37{fill:#6A6257}";
        
    string private _background = "<rect class='w00' x='00' y='00' width='50' height='50'/>";
    string private _wojakFill = "<rect class='w01' x='15' y='05' width='19' height='45'/><rect class='w01' x='17' y='03' width='18' height='02'/><rect class='w01' x='34' y='05' width='04' height='37'/><rect class='w01' x='38' y='07' width='02' height='33'/><rect class='w01' x='40' y='09' width='02' height='29'/><rect class='w01' x='42' y='14' width='02' height='20'/><rect class='w01' x='44' y='25' width='01' height='05'/><rect class='w01' x='13' y='07' width='02' height='24'/><rect class='w01' x='11' y='11' width='02' height='15'/><rect class='w01' x='34' y='46' width='12' height='04'/><rect class='w01' x='46' y='49' width='03' height='01'/><rect class='w01' x='34' y='45' width='01' height='01'/><rect class='w01' x='46' y='48' width='01' height='01'/><rect class='w01' x='00' y='47' width='15' height='03'/><rect class='w01' x='05' y='45' width='10' height='02'/><rect class='w01' x='11' y='43' width='04' height='02'/><rect class='w01' x='13' y='39' width='02' height='04'/>";
    string private _wojakOutline = "<rect class='w10' x='00' y='47' width='01' height='01'/><rect class='w10' x='01' y='46' width='04' height='01'/><rect class='w10' x='05' y='45' width='03' height='01'/><rect class='w10' x='08' y='44' width='03' height='01'/><rect class='w10' x='11' y='43' width='01' height='01'/><rect class='w10' x='12' y='42' width='01' height='01'/><rect class='w10' x='13' y='39' width='01' height='03'/><rect class='w10' x='14' y='37' width='01' height='02'/><rect class='w10' x='15' y='32' width='01' height='05'/><rect class='w10' x='14' y='31' width='01' height='01'/><rect class='w10' x='13' y='29' width='01' height='02'/><rect class='w10' x='12' y='26' width='01' height='03'/><rect class='w10' x='11' y='24' width='01' height='02'/><rect class='w10' x='10' y='14' width='01' height='10'/><rect class='w10' x='11' y='11' width='01' height='03'/><rect class='w10' x='12' y='08' width='01' height='03'/><rect class='w10' x='13' y='07' width='01' height='01'/><rect class='w10' x='14' y='06' width='01' height='01'/><rect class='w10' x='15' y='05' width='01' height='01'/><rect class='w10' x='16' y='04' width='01' height='01'/><rect class='w10' x='17' y='03' width='03' height='01'/><rect class='w10' x='20' y='02' width='11' height='01'/><rect class='w10' x='31' y='03' width='04' height='01'/><rect class='w10' x='35' y='04' width='02' height='01'/><rect class='w10' x='37' y='05' width='01' height='01'/><rect class='w10' x='38' y='06' width='01' height='01'/><rect class='w10' x='39' y='07' width='01' height='01'/><rect class='w10' x='40' y='08' width='01' height='01'/><rect class='w10' x='41' y='09' width='01' height='02'/><rect class='w10' x='42' y='11' width='01' height='03'/><rect class='w10' x='43' y='14' width='01' height='03'/><rect class='w10' x='44' y='17' width='01' height='08'/><rect class='w10' x='45' y='25' width='01' height='05'/><rect class='w10' x='44' y='30' width='01' height='02'/><rect class='w10' x='43' y='32' width='01' height='02'/><rect class='w10' x='42' y='34' width='01' height='01'/><rect class='w10' x='41' y='35' width='01' height='03'/><rect class='w10' x='40' y='38' width='01' height='01'/><rect class='w10' x='39' y='39' width='01' height='01'/><rect class='w10' x='38' y='40' width='01' height='01'/><rect class='w10' x='36' y='41' width='02' height='01'/><rect class='w10' x='30' y='42' width='06' height='01'/><rect class='w10' x='28' y='41' width='02' height='01'/><rect class='w10' x='27' y='40' width='01' height='01'/><rect class='w10' x='25' y='39' width='02' height='01'/><rect class='w10' x='24' y='38' width='01' height='01'/><rect class='w10' x='23' y='37' width='01' height='01'/><rect class='w10' x='22' y='36' width='01' height='01'/><rect class='w10' x='21' y='35' width='01' height='01'/><rect class='w10' x='20' y='34' width='01' height='01'/><rect class='w10' x='19' y='31' width='01' height='03'/><rect class='w10' x='18' y='28' width='01' height='03'/><rect class='w10' x='33' y='43' width='01' height='01'/><rect class='w10' x='34' y='44' width='01' height='01'/><rect class='w10' x='35' y='45' width='08' height='01'/><rect class='w10' x='43' y='46' width='03' height='01'/><rect class='w10' x='46' y='47' width='01' height='01'/><rect class='w10' x='47' y='48' width='02' height='01'/><rect class='w10' x='49' y='49' width='01' height='01'/><rect class='w10' x='18' y='36' width='01' height='01'/><rect class='w10' x='19' y='37' width='01' height='02'/><rect class='w10' x='14' y='45' width='02' height='01'/><rect class='w10' x='16' y='44' width='01' height='01'/><rect class='w10' x='17' y='43' width='02' height='01'/><rect class='w10' x='23' y='47' width='02' height='01'/><rect class='w10' x='25' y='48' width='04' height='01'/><rect class='w10' x='29' y='47' width='02' height='01'/>";

    uint256 private constant _traitCount = 9;

    uint256 private constant _hashLength = 30;

    Attribute[][] private _attributes;
    mapping(uint256 => bool) private _mintedTokens; //Hash => Is minted
    mapping(uint256 => uint256) private _tokenHashes; //Id => Hash

    uint256 private _totalSupply;
    uint256 private constant _maxSupply = 10000;

    uint256 private _mintCost;
    uint256 private _mintsLeft;

    uint256[] _seriesRanges;

    constructor() ERC721("Wojek", "WOJEK")
    {
        //Initialize the _attributes array
        for(uint256 i = 0; i < _traitCount; i++)
        {
            _attributes.push();
        }
    }

    receive() external payable
    {
        mint();
    }

    function withdraw() public onlyOwner
    {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function totalSupply() public view returns (uint256)
    {
        return _totalSupply;
    }

    function maxSupply() public pure returns (uint256)
    {
        return _maxSupply;
    }

    function mintsLeft() public view returns (uint256)
    {
        return _mintsLeft;
    }

    function mintCost() public view returns (uint256)
    {
        return _mintCost;
    }

    function finishSeries() public onlyOwner returns (bool)
    {
        _seriesRanges.push(_totalSupply);

        return true;
    }

    function startMint(uint256 amount, uint256 cost) public onlyOwner returns (bool)
    {
        require(_totalSupply + amount <= _maxSupply);

        _mintCost = cost;
        _mintsLeft = amount;

        return true;
    }

    function endMint() public onlyOwner returns (bool)
    {
        _mintsLeft = 0;
        _mintCost = 0;

        return true;
    }

    function mint() public payable returns (bool)
    {
        uint256 value = msg.value;
        require(value >= _mintCost);

        uint256 mintAmount = value / _mintCost;
        require(_totalSupply + mintAmount <= _maxSupply);
        require(_mintsLeft - mintAmount >= 0);

        address sender = _msgSender();

        for(uint256 i = 0; i < mintAmount; i++)
        {
            uint256 id = _totalSupply + i;

            uint256 randomNumber = WojekHelper.dirtyRandom(id, sender);

            uint256 hash = 10 ** _hashLength;

            for(uint256 a = 0; a < _traitCount; a++)
            {
                hash += (10 ** (_hashLength - (a * 3) - 3)) * (randomNumber % _attributes[a].length);

                randomNumber >>= 8;
            }

            if(randomNumber % 100 < 5)
            {
                hash += 1; 
            }

            require(_mintedTokens[hash] == false);

            _mintedTokens[hash] = true;
            _tokenHashes[id] = hash;

            _safeMint(sender, id);
        }

        _mintsLeft -= mintAmount;
        _totalSupply += mintAmount;

        return true;
    }

    function addAttributes(uint256 attributeType, Attribute[] memory newAttributes) public onlyOwner returns(bool)
    {
        for(uint256 i = 0; i < newAttributes.length; i++)
        {
            _attributes[attributeType].push(Attribute
            (
                newAttributes[i].value,
                newAttributes[i].svg
            ));
        }

        return true;
    }

    function tokenURI(uint256 id) public view override returns (string memory)
    {
        require(_exists(id));

        uint256 hash = _tokenHashes[id];

        require(_mintedTokens[hash] == true);

        return string(abi.encodePacked(
            "data:application/json;base64,",
            WojekHelper.encode(bytes(string(
                abi.encodePacked(
                    '{"name": "Wojek #',
                    WojekHelper.toString(id),
                    '", "description": "',
                    "Wojeks are a completely onchain collection of images that display a wide variety of emotions, even the feelsbad ones.", 
                    '", "image": "data:image/svg+xml;base64,',
                    WojekHelper.encode(bytes(_generateSvg(hash))),
                    '", "attributes":',
                    _hashMetadata(hash, id),
                    "}"
                )
            )))
        ));
    }

    function _generateSvg(uint256 hash) private view returns(string memory result) 
    {
        string memory xScale = "1";

        if(WojekHelper.splitHash(hash, _hashLength, 9) > 0)
        {
            //Phunked
            xScale = "-1";
        }

        result = string(abi.encodePacked(
            _svgHeader, xScale, ",1)'>", _svgStyles, 
            _attributes[0][WojekHelper.splitHash(hash, _hashLength, 0)].svg, 
            _attributes[1][WojekHelper.splitHash(hash, _hashLength, 1)].svg, 
            "</style>",
            _background,
            _wojakFill,
            _wojakOutline
        ));

        for(uint256 i = 2; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.splitHash(hash, _hashLength, i);

            uint256 svgLength = WojekHelper.stringLength(_attributes[i][attributeIndex].svg) / 10;

            for(uint256 a = 0; a < svgLength; a++)
            {
                uint256 svgIndex = a * 10;

                result = string(abi.encodePacked(
                    result, 
                    "<rect class='w", WojekHelper.subString(_attributes[i][attributeIndex].svg, svgIndex, svgIndex + 2), 
                    "' x='", WojekHelper.subString(_attributes[i][attributeIndex].svg, svgIndex + 2, svgIndex + 4), 
                    "' y='", WojekHelper.subString(_attributes[i][attributeIndex].svg, svgIndex + 4, svgIndex + 6), 
                    "' width='", WojekHelper.subString(_attributes[i][attributeIndex].svg, svgIndex + 6, svgIndex + 8), 
                    "' height='", WojekHelper.subString(_attributes[i][attributeIndex].svg, svgIndex + 8, svgIndex + 10), 
                    "'/>"
                ));
            }
        }

        return string(abi.encodePacked(result, "</svg>"));
    }

    function _hashMetadata(uint256 hash, uint256 id) private view returns(string memory)
    {
        string memory metadata;

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.splitHash(hash, _hashLength, i);

            if(WojekHelper.stringLength(_attributes[i][attributeIndex].svg) > 0)
            {
                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":"',
                    WojekHelper.attributeIndexToString(i),
                    '","value":"',
                    _attributes[i][attributeIndex].value,
                    '"},'
                ));
            }
        }

        if(WojekHelper.splitHash(hash, _hashLength, 9) > 0)
        {
            //Phunked
            metadata = string(abi.encodePacked
            (
                metadata,
                '{"trait_type":"',
                "Phunk",
                '","value":"',
                "Phunked",
                '"},'
            ));
        }

        for(uint256 i = 0; i < _seriesRanges.length + 1; i++) 
        {
            if(i == _seriesRanges.length || id < _seriesRanges[i])
            {
                //Series
                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":"',
                    "Series",
                    '","value":"',
                    WojekHelper.toString(i),
                    '"}'
                ));
            }
        }

        return string(abi.encodePacked("[", metadata, "]"));
    }
}
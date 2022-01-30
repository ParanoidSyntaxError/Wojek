// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

library Base64 {
    string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';
        
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
            for {} lt(dataPtr, endPtr) {}
            {
               dataPtr := add(dataPtr, 3)
               
               // read 3 bytes
               let input := mload(dataPtr)
               
               // write 4 characters
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
               resultPtr := add(resultPtr, 1)
            }
            
            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }
        
        return result;
    }

    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
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

    function toString(uint256 value) internal pure returns (string memory) {
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

enum AttributeType
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

contract Attribute
{
    string private _name;
    string private _layer;
    string private _data;
    string private _color;

    constructor(string memory layer, string memory name, string memory color, string memory data)
    {
        _layer = layer;
        _name = name;
        _color = color;
        _data = data;
    }

    function getName() public view returns (string memory)
    {
        return _name;
    }

    function getType() public view returns (string memory)
    {
        return _layer;    
    }

    function getColor() public view returns (string memory)
    {
        return _color;
    }

    function getData() public view returns (string memory)
    {
        return _data;
    }
}

contract OnChainNFT is ERC721Enumerable, Ownable 
{
    string private _svgHeader = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50' transform='scale(1,1)'>";
    string private _svgStyles = string(abi.encodePacked
    (
        "<style>#wojek-svg{shape-rendering: crispedges;}",
        ".p00{fill:#000000}", //Black
        ".p01{fill:#ffffff}", //White
        ".p02{fill:#00aaff}", //Blue
        ".p03{fill:#ff0000}", //Red  
        ".p04{fill:#ff7777}", //Orange pink
        ".p05{fill:#ff89b9}", //Pink
        ".p06{fill:#fff9e5}", //Light bandage
        ".p07{fill:#fff9d5}", //Bandage
        ".p08{fill:#93c63b}", //Sniff green
        ".p09{fill:#ff6a00}", //Cig orange
        ".p10{fill:#808080}", //Smoke gray
        ".p11{fill:#a94d00}", //Rope brown
        ".p12{fill:#00ffff}", //Cyan
        ".p13{fill:#00ff00}", //Green
        "</style>"
    ));

    string private constant _name = "Wojek";
    string private constant _symbol = "WOJEK";

    Attribute[][] private _attributes;

    mapping(uint256 => string) private _tokens;

    constructor() ERC721(_name, _symbol) 
    {
        _attributes.push();

        for(uint i = 0; i < 10; i++)
        {
            _attributes[0].push();
        }

        // Wojek series #01

        //rXXYYXXYY = Rectangle
        //iXXYY = Pixel

        //pXX = Set color value
        //aXX = Attributes color value
        //cXX = Character color value

        //Backgrounds
        _attributes[uint(AttributeType.Background)].push(new Attribute("Background", "White", "", "r00004949p01"));
        _attributes[uint(AttributeType.Background)].push(new Attribute("Background", "Cyan", "", "r00004949p12"));
        _attributes[uint(AttributeType.Background)].push(new Attribute("Background", "Pink", "", "r00004949p05"));
        _attributes[uint(AttributeType.Background)].push(new Attribute("Background", "Green", "", "r00004949p13"));

        //Characters
        _attributes[uint(AttributeType.Character)].push(new Attribute("Character", "Wojak", "p01", "r15053349aXXr17033404aXXr34053741aXXr38073939aXXr40094137aXXr42144333aXXr44254429aXXr13071430aXXr11111225aXXr34464549aXXr46494849aXXi3445aXXi4648aXXr00471449aXXr05451446aXXr11431444aXXr13391442aXXi0047p00r01460446p00r05450745p00r08441044p00i1143p00i1242p00r13391341p00r14371438p00r15321536p00i1431p00r13291330p00r12261228p00r11241125p00r10141023p00r11111113p00r12081210p00i1307p00i1406p00i1505p00i1604p00r17031903p00r20023002p00r31033403p00r35043604p00i3705p00i3806p00i3907p00i4008p00r41094110p00r42114213p00r43144316p00r44174424p00r45254529p00r44304431p00r43324333p00i4234p00r41354137p00i4038p00i3939p00i3840p00r36413741p00r30423542p00r28412941p00i2740p00r25392639p00i2438p00i2337p00i2236p00i2135p00i2034p00r19311933p00r18281830p00i3343p00i3444p00r35454245p00r43464546p00i4647p00r47484848p00i4949p00i1836p00r19371938p00r14451545p00i1644p00r17431843p00r23472447p00r25482848p00r29473047p00"));
        _attributes[uint(AttributeType.Character)].push(new Attribute("Character", "NPC", "p10", "r15053349aXXr17033404aXXr34053741aXXr38073939aXXr40094137aXXr42144333aXXr44254429aXXr13071430aXXr11111225aXXr34464549aXXr46494849aXXi3445aXXi4648aXXr00471449aXXr05451446aXXr11431444aXXr13391442aXXi0047p00r01460446p00r05450745p00r08441044p00i1143p00i1242p00r13391341p00r14371438p00r15321536p00i1431p00r13291330p00r12261228p00r11241125p00r10141023p00r11111113p00r12081210p00i1307p00i1406p00i1505p00i1604p00r17031903p00r20023002p00r31033403p00r35043604p00i3705p00i3806p00i3907p00i4008p00r41094110p00r42114213p00r43144316p00r44174424p00r45254529p00r44304431p00r43324333p00i4234p00r41354137p00i4038p00i3939p00i3840p00r36413741p00r30423542p00r28412941p00i2740p00r25392639p00i2438p00i2337p00i2236p00i2135p00i2034p00r19311933p00r18281830p00i3343p00i3444p00r35454245p00r43464546p00i4647p00r47484848p00i4949p00i1836p00r19371938p00r14451545p00i1644p00r17431843p00r23472447p00r25482848p00r29473047p00"));
        _attributes[uint(AttributeType.Character)].push(new Attribute("Character", "Pink wojak", "p05", "r15053349aXXr17033404aXXr34053741aXXr38073939aXXr40094137aXXr42144333aXXr44254429aXXr13071430aXXr11111225aXXr34464549aXXr46494849aXXi3445aXXi4648aXXr00471449aXXr05451446aXXr11431444aXXr13391442aXXi0047p00r01460446p00r05450745p00r08441044p00i1143p00i1242p00r13391341p00r14371438p00r15321536p00i1431p00r13291330p00r12261228p00r11241125p00r10141023p00r11111113p00r12081210p00i1307p00i1406p00i1505p00i1604p00r17031903p00r20023002p00r31033403p00r35043604p00i3705p00i3806p00i3907p00i4008p00r41094110p00r42114213p00r43144316p00r44174424p00r45254529p00r44304431p00r43324333p00i4234p00r41354137p00i4038p00i3939p00i3840p00r36413741p00r30423542p00r28412941p00i2740p00r25392639p00i2438p00i2337p00i2236p00i2135p00i2034p00r19311933p00r18281830p00i3343p00i3444p00r35454245p00r43464546p00i4647p00r47484848p00i4949p00i1836p00r19371938p00r14451545p00i1644p00r17431843p00r23472447p00r25482848p00r29473047p00"));
        _attributes[uint(AttributeType.Character)].push(new Attribute("Character", "Green wojak", "p13", "r15053349aXXr17033404aXXr34053741aXXr38073939aXXr40094137aXXr42144333aXXr44254429aXXr13071430aXXr11111225aXXr34464549aXXr46494849aXXi3445aXXi4648aXXr00471449aXXr05451446aXXr11431444aXXr13391442aXXi0047p00r01460446p00r05450745p00r08441044p00i1143p00i1242p00r13391341p00r14371438p00r15321536p00i1431p00r13291330p00r12261228p00r11241125p00r10141023p00r11111113p00r12081210p00i1307p00i1406p00i1505p00i1604p00r17031903p00r20023002p00r31033403p00r35043604p00i3705p00i3806p00i3907p00i4008p00r41094110p00r42114213p00r43144316p00r44174424p00r45254529p00r44304431p00r43324333p00i4234p00r41354137p00i4038p00i3939p00i3840p00r36413741p00r30423542p00r28412941p00i2740p00r25392639p00i2438p00i2337p00i2236p00i2135p00i2034p00r19311933p00r18281830p00i3343p00i3444p00r35454245p00r43464546p00i4647p00r47484848p00i4949p00i1836p00r19371938p00r14451545p00i1644p00r17431843p00r23472447p00r25482848p00r29473047p00"));

        //Skins
        _attributes[uint(AttributeType.Skin)].push(new Attribute("Skin", "None", "", ""));

        /*
            TODO:
            Cursed skin
        */

        //Beards
        _attributes[uint(AttributeType.Beard)].push(new Attribute("Beard", "None", "", ""));

        /*
            TODO:
            Soyjak beard
            12 o clock shadow
        */

        //Foreheads
        _attributes[uint(AttributeType.Forehead)].push(new Attribute("Forehead", "Wojak forehead", "", "r23112611p00r27103510p00r36113811p00r21152215p00r23142814p00r29133513p00r36143714p00r23192419p00r25182818p00r36183918p00r40194119p00"));
        _attributes[uint(AttributeType.Forehead)].push(new Attribute("Forehead", "NPC forehead", "", ""));
        _attributes[uint(AttributeType.Forehead)].push(new Attribute("Forehead", "Smug forehead", "", "r21102210p00r23092509p00r26083508p00r36093709p00i3810p00r26112711p00r28103110p00r32113511p00r23182518p00r26172717p00r28162916p00i3015p00i3517p00r36184118p00i4219p00"));
        _attributes[uint(AttributeType.Forehead)].push(new Attribute("Forehead", "Soyjak forehead", "", "r21052405p00r25063306p00r23092809p00r29103310p00r34093609p00i2016p00i2115p00r22142314p00r24132713p00r28142914p00i3015p00r31163117p00r34163417p00i3515p00r36143714p00r38134013p00r41144214p00"));
        _attributes[uint(AttributeType.Forehead)].push(new Attribute("Forehead", "Pink wojak forehead", "", "r29092910p00r30113013p00r29142915p00r23142414p00r25152615p00i2716p00i2119p00r22182718p00r28192919p00i3020p00i3610p00r35113512p00r34133415p00i3516p00r37153815p00i3914p00i4013p00i3420p00r35193619p00r37184118p00"));

        //Mouths
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Wojak mouth", "", "r28353235p00r33363736p00"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "NPC mouth", "", "r29353635p00"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Dumb wojak mouth", "", "r28343834p00r29353735p00r28352838p02r30363037p02"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Pink wojak mouth", "", "r29333638p00r28342837p00r37343737p00i2934p01r31343234p01r34343534p01i2937p01r31373237p01r34373537p01"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Smug mouth", "", "i2733p00r26342734p00r28353135p00r32363736p00"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Bloomer mouth", "", "r28343637p00r26333233p00r27322735p00r37353736p00r29383538p00r31393439p00r31343234p01r33353435p01r31383338p01i3037p01"));
        _attributes[uint(AttributeType.Mouth)].push(new Attribute("Mouth", "Soyjak mouth", "", "r29333638p00r28342836p00r37343736p00r30393539p00i2732p00r26332635p00i3832p00r39333934p00i3034p01i3234p01i3434p01"));

        //Eyes
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Wojak eyes", "", "r24212822p00r29222923p00r25232823p00i2522p01r36214022p00r37233923p00i3722p01"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "NPC eyes", "", "r26212823p00r37213923p00"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Smug eyes", "", "r24212822p00r29222923p00r25232823p00i2822p01r36214022p00r37233923p00i3922p01"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Closed eyes", "", "i2422p00r25232823p00i2922p00i3622p00r37233923p00i4022p00"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Crying eyes", "", "r24212822p00r29222923p00r25232823p00i2522p04r36214022p00r37233923p00i3722p04r24232430p02r24352437p02i2540p02r26242626p02r29242925p02i2826p02r27272728p02r26292630p02r25312534p02r26352636p02r27372738p02r28392840p02r29422943p02r38243830p02r39313934p02r38353839p02i4023p02r41244130p02r42314233p02"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Pink wojak eyes", "", "r23212824p04i2321p00r24202720p00i2821p00r22222223p00r29222923p00i2324p00i2824p00r24252725p00r25222623p00r36214124p04i3621p00r37204020p00i4121p00r35223523p00r42224223p00i3624p00i4124p00r37254025p00r38223923p00r24262430p03r24352437p03i2540p03i2626p03r29242925p03i2826p03r27272728p03r26292630p03r25312534p03r26352636p03r27372738p03r28392840p03r29422943p03r38263830p03r39313934p03r38353839p03r41254130p03r42314233p03"));
        _attributes[uint(AttributeType.Eyes)].push(new Attribute("Eyes", "Cursed eyes", "", "r24212422p00r25202823p00r29212923p00r26242824p00r25272727p00r28262926p00i3025p00r36213622p00r37204023p00r41214123p00r38244024p00i3625p00r37263826p00r39274027p00"));

        //Noses
        _attributes[uint(AttributeType.Nose)].push(new Attribute("Nose", "Wojak nose", "", "i3030p00i3131p00i3531p00r36293630p00i3528p00r34253427p00"));
        _attributes[uint(AttributeType.Nose)].push(new Attribute("Nose", "NPC nose", "", "r33233324p00r34253426p00r35273528p00i3629p00r30303630p00"));
        _attributes[uint(AttributeType.Nose)].push(new Attribute("Nose", "Dumb wojak nose", "", "r30263028p00r29292930p00i3031p00r35253527p00i3628p00r37293730p00i3631p00"));
        _attributes[uint(AttributeType.Nose)].push(new Attribute("Nose", "Bladerunner nose", "", "r29263027p06r28272928p06r31253527p07r36263828p06r31243424p00r29253025p00i2826p00r27272728p00r28292929p00i3030p00i3131p00r30283528p00r31263127p00r36273630p00i3531p00r37293829p00i3928p00r38263827p00r35253725p00i3526p00"));
        _attributes[uint(AttributeType.Nose)].push(new Attribute("Nose", "Sniff nose", "", "r34253427p00i3528p00i3629p00r34303630p00i3531p00r30303230p00i3131p00i3231p08i3431p08r32323532p08r33333335p08r34353436p08r35363538p08r36383639p08r37393939p08r39404440p08r44394539p08r45384638p08r46374737p08r47364936p08r35334033p08r37343834p08r38354335p08r43344634p08r46334833p08r48324932p08r40324232p08r42314431p08r44304630p08r46294829p08r48284928p08i4927p08"));

        //Headware
        _attributes[uint(AttributeType.Headware)].push(new Attribute("Headware", "None", "", ""));
        _attributes[uint(AttributeType.Headware)].push(new Attribute("Headware", "Doomer beanie", "", "r41104214p00r38074013p00r37043712p00r35033612p00r32023412p00r26013112p00r20012513p00r18021914p00r16031715p00r15041517p00r14051418p00r13061320p00r12071222p00r10111123p00r09140921p00r11091110p00i1616p00i1901p00i4109p00i3906p00r38053806p00r11191121p10i1219p10r13151317p10i1217p10r15141515p10r16131614p10r18121813p10r19111912p10r21112212p10r24112412p10r25102511p10r27102811p10r30103111p10r33103411p10r36103711p10r39114012p10r41124113p10"));
        _attributes[uint(AttributeType.Headware)].push(new Attribute("Headware", "Big brain", "", "r07041327cXXr01110221cXXr03070624cXXi0625cXXr05050606cXXr11011303cXXr09021003cXXr14011517cXXr16011812cXXr19013104cXXr32033504cXXi1327p00r09281228p00r07270827p00i0626p00r04250525p00i0324p00r02220223p00r01200121p00r00140019p00r01110113p00r02090210p00r03070308p00i0406p00i0505p00r06040704p00i0803p00r09021002p00r11011201p00r13002800p00r29013101p00r32023402p00r34033503p00i3604p00i1026p00i1127p00i0524p00i0623p00r03200321p00r09200921p00i1022p00i1121p00i0215p00i0116p00i0418p00i0517p00i0616p00i0717p00r14181518p00r04110412p00i0513p00i0813p00i0914p00r12151315p00i1414p00r06100710p00i0811p00i1109p00r12101310p00r16121712p00i0705p00i0806p00i0707p00i1206p00i1307p00i1507p00i1708p00i1809p00i1202p00i1303p00i1704p00i1805p00i1401p00i2002p00i2103p00r23022402p00i2503p00i2701p00i2802p00i3003p00i3104p00"));
        
        /*
            TODO:
            Feels helment
        */

        //Accessories
        _attributes[uint(AttributeType.Accessory)].push(new Attribute("Accessory", "None", "", ""));
        _attributes[uint(AttributeType.Accessory)].push(new Attribute("Accessory", "Cigarette", "", "i2835p00r27362936p00r26372837p00r25382738p00r24392639p00r23402540p00i2441p00i2836p01i2737p01i2638p01i2539p01r22272228p10r23292331p10r22322235p10r23362339p10i2439p09"));
        _attributes[uint(AttributeType.Accessory)].push(new Attribute("Accessory", "Noose", "", "r02000415p11r04160626p11r06270833p11r08341037p11i1137p11r10381440p11r15401842p11r19423344p11r01000105p00r02060215p00r03160319p00r04200426p00r05270529p00r06290633p00r07340735p00r08360837p00r09380939p00r10391040p00i1140p00r12411441p00r15421642p00r17431843p00r19442344p00r24453345p00r34433444p00r04000405p00r05060515p00r06160619p00r07200726p00r08270830p00r09300933p00r10341035p00i1136p00i1237p00r11381438p00r15391739p00r18401940p00r19412441p00r25423342p00i0200p00i0301p00i0203p00i0304p00i0307p00i0408p00i0310p00i0411p00i0313p00i0414p00i0417p00i0518p00i0521p00i0622p00i0525p00i0626p00i0731p00i0834p00i0936p00r14401540p00i1842p00i2243p00i2342p00i2644p00i2743p00i3044p00i3143p00i3344p00"));
        _attributes[uint(AttributeType.Accessory)].push(new Attribute("Accessory", "Glasses", "", "i1424p00r13221323p00r14212121p00r22202224p00r23193019p00r31203124p00r23253025p00i3221p00i3320p00i3421p00r36194319p00r35203524p00r44204424p00r36254325p00"));
    }

    function mint(string memory hash) public payable 
    {
        uint256 supply = totalSupply();

        _tokens[supply + 1] = hash;

        _safeMint(msg.sender, supply + 1);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        
        return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(abi.encodePacked
        (
            '{"name":"Wojek #',
            Base64.toString(tokenId), '"',

            '"description":', '"',
            "Wojek's display a wide variety of emotions, even the feelsbad ones.", 
            
            '"image":"data:image/svg+xml;base64,',
            Base64.encode(bytes(tokenSVG(tokenId))), '"',
            
            '"attributes":',
            tokenMetadata(tokenId), '}'
        )))));
    }

    //Original Wojak
    //000000000000000000000000000000000001

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

    function tokenMetadata(uint256 tokenId) public view returns (string memory)
    {
        string memory tokenHash = _tokens[tokenId];

        string memory metadata;

        for(uint256 i; i < 12; i++)
        {
            if(i < 10)
            {
                uint256 attributeIndex = Base64.parseInt(Base64.substring(tokenHash, i * 3, (i * 3) + 3));

                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":',
                    _attributes[i][attributeIndex].getType(),
                    '","value":"',
                    _attributes[i][attributeIndex].getName(),
                    '"}'
                ));
            }
            else if(i == 10)
            {
                if(keccak256(abi.encodePacked(Base64.substring(tokenHash, (i * 3) + 2, (i * 3) + 3))) == keccak256(abi.encodePacked("1")))
                {
                    //Phunked
                    metadata = string(abi.encodePacked
                    (
                        metadata,
                        '{"trait_type":',
                        "Phunk",
                        '","value":"',
                        "Phunked",
                        '"}'
                    ));
                }
            }
            else if(i == 11)
            {
                uint256 seriesValue = Base64.parseInt(Base64.substring(tokenHash, i * 3, (i * 3) + 3));

                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":',
                    "Series",
                    '","value":"',
                    seriesValue,
                    '"}'
                ));
            }

            if(i < 11)
            {
                metadata = string(abi.encodePacked(metadata, ","));
            }
        }

        return string(abi.encodePacked("[", metadata, "]"));
    }

    function tokenSVG(uint256 tokenId) public view returns (string memory)
    {
        string memory tokenHash = _tokens[tokenId];
        
        //Get skin color
        uint256 characterIndex = Base64.parseInt(Base64.substring(tokenHash, 1 * 3, (1 * 3) + 3));

        string memory characterColor = _attributes[uint(AttributeType.Character)][characterIndex].getColor();

        //Check if token is Phunked
        string memory xScale = "1";
        
        if(keccak256(abi.encodePacked(Base64.substring(tokenHash, (10 * 3) + 2, (10 * 3) + 3))) == keccak256(abi.encodePacked("1")))
        {
            //Phunked
            xScale = "-1";
        }

        string memory content;

        for(uint i = 0; i < 10; i++)
        {
            uint256 attributeIndex = Base64.parseInt(Base64.substring(tokenHash, i * 3, (i * 3) + 3));

            content = string(abi.encodePacked(content, attributeSVG(AttributeType(i), attributeIndex, characterColor)));
        }

        return string(abi.encodePacked(_svgHeader, _svgStyles, content, "</svg>"));
    }

    function attributeSVG(AttributeType attributeType, uint256 index, string memory characterColor) public view returns (string memory)
    {
        string memory attributeData = _attributes[uint(attributeType)][index].getData();

        string memory svgRects;

        uint256 dataIndex = 0;

        while(dataIndex < Base64.stringLength(attributeData))
        {
            string memory x;
            string memory y;
            string memory width;
            string memory height;
            string memory style;

            if(keccak256(abi.encodePacked(Base64.substring(attributeData, dataIndex, dataIndex + 1))) == keccak256(abi.encodePacked("i"))) //Single pixel
            {
                x = Base64.substring(attributeData, dataIndex + 1, dataIndex + 3);
                y = Base64.substring(attributeData, dataIndex + 3, dataIndex + 5);
                width = "1";
                height = "1";
                style = Base64.substring(attributeData, dataIndex + 5, dataIndex + 8);
                
                dataIndex += 8;
            }
            else if(keccak256(abi.encodePacked(Base64.substring(attributeData, dataIndex, dataIndex + 1))) == keccak256(abi.encodePacked("r"))) //Rectangle
            {
                uint x1 = Base64.parseInt(Base64.substring(attributeData, dataIndex + 1, dataIndex + 3));
                uint x2 = Base64.parseInt(Base64.substring(attributeData, dataIndex + 5, dataIndex + 7));

                if(x1 < x2)
                {
                    width = Base64.toString((x2 + 1) - x1);

                    x = Base64.substring(attributeData, dataIndex + 1, dataIndex + 3);
                }
                else
                {
                    width = Base64.toString((x1 + 1) - x2);

                    x = Base64.substring(attributeData, dataIndex + 5, dataIndex + 7);
                }

                uint y1 = Base64.parseInt(Base64.substring(attributeData, dataIndex + 3, dataIndex + 5));
                uint y2 = Base64.parseInt(Base64.substring(attributeData, dataIndex + 7, dataIndex + 9));

                if(y1 < y2)
                {
                    height = Base64.toString((y2 + 1) - y1);

                    y = Base64.substring(attributeData, dataIndex + 3, dataIndex + 5);
                }
                else
                {
                    height = Base64.toString((y1 + 1) - y2);

                    y = Base64.substring(attributeData, dataIndex + 7, dataIndex + 9);                
                }

                style = Base64.substring(attributeData, dataIndex + 9, dataIndex + 12);

                dataIndex += 12;
            }
            else
            {
                //Bad attribute data
                break;
            }

            if(keccak256(abi.encodePacked(style)) == keccak256(abi.encodePacked("a"))) //Attribute style
            {
                style = _attributes[uint(attributeType)][index].getColor();
            }
            else if(keccak256(abi.encodePacked(style)) == keccak256(abi.encodePacked("c"))) //Character style
            {
                style = characterColor;
            }

            svgRects = string(abi.encodePacked(svgRects, "<rect class='", style, "' x='", x, "' y='", y, "' width='", width, "' height='", height, "'/>"));
        }

        return svgRects;
    }
}
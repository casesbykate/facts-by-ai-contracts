pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/IKIP17.sol";
import "./interfaces/IMix.sol";
import "./klaytn-contracts/token/KIP17/KIP17Full.sol";
import "./klaytn-contracts/token/KIP17/KIP17Pausable.sol";
import "./klaytn-contracts/ownership/Ownable.sol";

contract FactsByAINFT is Ownable, KIP17Full("Facts By AI", "AIFACTS"), KIP17Pausable {

    IKIP17 public cbk;
    IMix public mix;
    mapping(uint256 => string) public facts;

    constructor(IKIP17 _cbk, IMix _mix) public {
        cbk = _cbk;
        mix = _mix;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "KIP17Metadata: URI query for nonexistent token");
        
        if (tokenId == 0) {
            return "https://api.casesbykate.xyz/aifacts/0";
        }

        string memory baseURI = "https://api.casesbykate.xyz/aifacts/";
        string memory idstr;
        
        uint256 temp = tokenId;
        uint256 digits;
        while (temp != 0) {
            digits += 1;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (tokenId != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(tokenId % 10)));
            tokenId /= 10;
        }
        idstr = string(buffer);

        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, idstr)) : "";
    }

    function exists(uint256 id) public view returns (bool) {
        return _exists(id);
    }

    function mint(uint256 id, string calldata fact) external {
        require(cbk.ownerOf(id) == msg.sender);
        mix.burnFrom(msg.sender, 1 ether);
        facts[id] = fact;
        _mint(msg.sender, id);
    }
}

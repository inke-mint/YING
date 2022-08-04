// SPDX-License-Identifier: MIT
/*
+ + + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - + + +
+                                                                                                                 +
+                                                                                                                 +
.                        .^!!~:                                                 .^!!^.                            .
.                            :7Y5Y7^.                                       .^!J5Y7^.                             .
.                              :!5B#GY7^.                             .^!JP##P7:                                  .
.   7777??!         ~????7.        :5@@@@&GY7^.                    .^!JG#@@@@G^        7????????????^ ~????77     .
.   @@@@@G          P@@@@@:       J#@@@@@@@@@@&G57~.          .^7YG#@@@@@@@@@@&5:      #@@@@@@@@@@@@@? P@@@@@@    .
.   @@@@@G          5@@@@@:     :B@@@@@BJG@@@@@@@@@&B5?~:^7YG#@@@@@@@@BJP@@@ @@&!!     #@@@@@@@@@@@@@? P@@@@@@    .
.   @@@@@G          5@@@@@:    .B@@@@#!!J@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@P   ^G@@@@@~.   ^~~~~~^J@ @@@@??:~~~~~    .
.   @@@@@B^^^^^^^^. 5@@@@@:   J@@@@&^   G@7?@@@@@@&@@@@@@@@@@@&@J7&@@@@@#.   .B@@@@P           !@@@@@?            .
.   @@@@@@@@@@@@@@! 5@@@@@:   5@@@@B   ^B&&@@@@@#!#@@@@@@@@@@7G&&@@@@@#!     Y@@@@#.           !@@@@@?            .
.   @@@@@@@@@@@@@@! P@@@@@:   ?@@@@&^    !YPGPY!  !@@@@@Y&@@@@Y  ~YPGP57.    .B@@@@P           !@@@@@?            .
.   @@@@@B~~~~~~~!!.?GPPGP:   .B@@@@&7           ?&@@@@P ?@@@@@5.          ~B@@@@&^            !@@@@@?            .
.   @@@@@G          ^~~~~~.    :G@@@@@BY7~^^~75#@@@@@5.    J@@@@@&P?~^^^!JG@@@@@#~             !@@@@@?            .
.   @@@@@G          5@@@@@:      ?B@@@@@@@@@@@@@@@@B!!      ^P@@@@@@@@@@@@@@@@&Y               !@@@@@?            .
.   @@@@@G.         P@@@@@:        !YB&@@@@@@@@&BY~           ^JG#@@@@@@@@&#P7.                !@@@@@?            .
.   YYYYY7          !YJJJJ.            :~!7??7!^:                 .^!7??7!~:                   ^YJJJY~            .
.                                                                                                                 .
.                                                                                                                 .
.                                                                                                                 .
.                                  ………………               …………………………………………                  …………………………………………        .
.   PBGGB??                      7&######&5            :B##############&5               .G#################^      .
.   &@@@@5                      ?@@@@@@@@@@           :@@@@@@@@@@@@@@@@@G               &@@@@@@@@@@@@ @@@@@^      .
.   PBBBBJ                 !!!!!JPPPPPPPPPY !!!!!     :&@@@@P?JJJJJJJJJJJJJJ?      :JJJJJJJJJJJJJJJJJJJJJJ.       .
.   ~~~~~:                .#@@@@Y          ~@@@@@~    :&@@@@7           ~@@@&.      ^@@@@.                        .
.   #@@@@Y                .#@@@@G?JJJJJJJJ?5@@@@@~    :&@@@@7   !JJJJJJJJJJJJ?     :JJJJJJJJJJJJJJJJJ!!           .
.   #@@@@Y                .#@@@@@@@@@@@@@@@@@@@@@@~   :&@@@@7   G@@@@@@@@G &@@             @@@@@@@@@@P            .
.   #@@@@Y                .#@@@@&##########&@@@@@~    :&@@@@7   7YYYYYYYYJ???7             JYYYYYYYYYYYYJ???7     .
.   #@@@@Y                .#@@@@5 ........ !@@@@@~    :&@@@@7            ~@@@&.                         !@@@#     .
.   #@@@@#5PPPPPPPPPJJ    .#@@@@Y          !@@@@@~    :&@@@@P7??????????JYY5J      .?????????? ???????JYY5J       .
.   &@@@@@@@@@@@@@@@@@    .#@@@@Y          !@@@@@~    :&@@@@@@@@@@@@@@@@@G         ^@@@@@@@@@@@@@@@@@P            .
.   PBBBBBBBBBBBBBBBBY    .#@@@@Y          !@@@@@~    :&@@@@@@@@@@@@@@@@@G         ^@@@@@@@@@@@@@@@ @@5           .
+                                                                                                                 +
+                                                                                                                 +
+ + + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - + + +
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./extensions/HootBaseERC721Owners.sol";
import "../common/HootBase.sol";

/**
 * @title Hootbirds
 * @author HootLabs
 */
abstract contract HootERC721 is
    HootBase,
    HootBaseERC721Owners,
    ERC721,
    IERC721Enumerable
{
    using Strings for uint256;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    uint256 private _totalMinted;
    uint256 private _totalBurned;


    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /***********************************|
    |               Config              |
    |__________________________________*/
    function _startTokenId() internal view virtual returns (uint256) {
        return 1;
    }

    /***********************************|
    |               Core                |
    |__________________________________*/
    function _mint(address to, uint256 tokenId) internal virtual override {
        super._mint(to, tokenId);
        unchecked {
            ++_totalMinted;
        }
    }

    /**
     * @notice issuer have permission to burn token.
     * @param tokenIds_ list of tokenId
     */
    function burn(uint256[] calldata tokenIds_)
        external
        onlyOwner
        nonReentrant
    {
        for (uint256 i = 0; i < tokenIds_.length; i++) {
            uint256 tokenId = tokenIds_[i];
            require(ownerOf(tokenId) == _msgSender(), "caller is not owner");
            _burn(tokenId);
        }
        _totalBurned += tokenIds_.length;
    }

    function totalBurned() public view returns (uint256) {
        return _totalBurned;
    }
    function totalMinted() public view returns (uint256) {
        return _totalMinted;
    }

    /***********************************|
    |        IERC721Enumerable          |
    |__________________________________*/
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalMinted - _totalBurned;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        override
        returns (uint256)
    {
        uint256 stopTokenId = _startTokenId() + _totalMinted;
        uint256 scanIndex = 0;
        for (
            uint256 tokenId = _startTokenId();
            tokenId < stopTokenId;
            tokenId++
        ) {
            if (!_exists(tokenId) || ownerOf(tokenId) != owner) {
                continue;
            }
            if (scanIndex == index) {
                return tokenId;
            }
            ++scanIndex;
        }
        return 0;
    }

    function tokensOfOwner(address owner_)
        external
        view
        returns (uint256[] memory)
    {
        uint256 balance = balanceOf(owner_);
        if (balance == 0) {
            return new uint256[](0);
        }
        uint256[] memory tokens = new uint256[](balance);
        uint256 i = 0;
        unchecked {
            uint256 stopTokenId = _startTokenId() + _totalMinted;
            for (
                uint256 tokenId = _startTokenId();
                tokenId < stopTokenId && i != balance;
                tokenId++
            ) {
                if (!_exists(tokenId) || ownerOf(tokenId) != owner_) {
                    continue;
                }
                tokens[i++] = tokenId;
            }
        }
        return tokens;
    }

    /***********************************|
    |        HootBaseERC721Owners       |
    |__________________________________*/
    function _unsafeOwnerOf(uint256 tokenID_) internal view virtual override returns (address){
        if (_exists(tokenID_)) {
            return this.ownerOf(tokenID_);
        }
        return address(0);
    }
    function exists(uint256 tokenId_) public view virtual override returns (bool){
        return _exists(tokenId_);
    }

    /***********************************|
    |               ERC721              |
    |__________________________________*/
    /**
     * @notice hook function, used to intercept the transfer of token.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(!paused(), "token transfer paused");
        super._beforeTokenTransfer(from, to, tokenId);
    }
}

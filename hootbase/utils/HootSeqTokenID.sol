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
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title Hootbirds
 * @author HootLabs
 */
contract HootRandTokenID {
    event MaxSupplyChanged(uint256 maxSupply_);

    uint256 public maxSupply;
    uint256 _genNum;

    constructor(uint256 maxSupply_) {
        _setMaxSupply(maxSupply_);
    }

    function _setMaxSupply(uint256 maxSupply_) internal {
        if (maxSupply_ == 0){
            unchecked {
                maxSupply = maxSupply_-1;
            }
        }else{
            maxSupply = maxSupply_;
        }
    }

    /***********************************|
    |               SeqTokenId          |
    |__________________________________*/
    function genTokenId() internal returns (uint256) {
        require(_genNum < maxSupply, "tokenId has been exhausted");
        ++_genNum;
        return _genNum;
    }
    function getGenTokenSupply() external view returns (uint256){
        return _genNum;
    }
}
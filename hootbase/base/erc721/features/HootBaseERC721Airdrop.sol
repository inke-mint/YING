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

import "../../common/HootBase.sol";

/**
 * @title HootBaseERC721Airdrop
 * @author HootLabs
 */
abstract contract HootBaseERC721Airdrop is HootBase {
    uint16 private constant AIRDROP_DROP_SET_LIST = 1;
    uint16 private constant AIRDROP_DROP_COMMITED = 2;
    uint16 private constant AIRDROP_DROP_DOING = 3;
    uint16 private constant AIRDROP_DROP_DONE = 4;

    uint256 public airdropSupply;
    address[] public receivers;
    uint16[] public amounts;
    uint256 remainReceiversNum = 1;
    uint16 public airdropStep = AIRDROP_DROP_SET_LIST;

    constructor(){}

    /***********************************|
    |               abstract            |
    |__________________________________*/
    function _airdropToReceiver(address receiverAddr_, uint16 amount_) internal virtual;
    function _airdropMaxSupply() internal virtual returns (uint256);

    /***********************************|
    |               Config              |
    |__________________________________*/
    function addAirdropList(address[] calldata receivers_, uint16[] calldata amounts_)
        external
        atLeastManager
        nonReentrant
    {
        require(
            receivers_.length == amounts_.length,
            "the length of Listing Receiver is different from that of Listing Amounts"
        );
        require(
            airdropStep == AIRDROP_DROP_SET_LIST,
            "airdrop is already committed, please reset airdrop list"
        );
        for (uint16 i = 0; i < receivers_.length; i++) {
            receivers.push(receivers_[i]);
            amounts.push(amounts_[i]);
        }
    }

    function resetAirdropList() external atLeastManager nonReentrant {
        delete receivers;
        delete amounts;
        airdropStep = AIRDROP_DROP_SET_LIST;
    }

    function commitAirdropList() external atLeastManager nonReentrant {
        require(
            airdropStep == AIRDROP_DROP_SET_LIST,
            "airdrop is already committed"
        );
        require(
            receivers.length == amounts.length,
            "the length of Listing Receiver is different from that of Listing Amounts"
        );
        require(_airdropMaxSupply() > 0, "not set max supply");
        uint256 total = 0;
        for (uint16 i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }
        require(total == _airdropMaxSupply(), "different from maxSupply");
        airdropStep = AIRDROP_DROP_COMMITED;
        remainReceiversNum = receivers.length;
    }

    /***********************************|
    |               Core                |
    |__________________________________*/
    /**
     * airdrop Hootbirds NFT to receivers who has INKEPASS.
     */
    function airdrop(uint16 amount_) external atLeastManager nonReentrant {
        require(
            isInAirdropStep(),
            "maybe airdrop list is not committed, maybe airdrop is already completed"
        );
        require(amount_ > 0, "airdrop amount is zero");
        require(
            amount_ <= _airdropMaxSupply() - airdropSupply,
            "minted number is out of maxSupply"
        );
        require(
            remainReceiversNum > 0,
            "not found items to airdrop, maybe airdrop is already completed"
        );
        if(airdropStep == AIRDROP_DROP_COMMITED){
            airdropStep = AIRDROP_DROP_DOING;
        }
        unchecked {
            uint256 num = remainReceiversNum;
            uint256 i = num - 1;
            uint16 remainAmount = amount_;
            uint16 singleAmount;
            do {
                singleAmount = amounts[i];
                if (singleAmount > remainAmount) {
                    singleAmount = remainAmount;
                }else{
                    --num;
                }
                if(singleAmount > 0){
                    _airdropToReceiver(receivers[i], singleAmount);
                    remainAmount -= singleAmount;
                }
                amounts[i] -= singleAmount;
                if(remainAmount > 0 && i > 0){
                    --i;
                }else{
                    break;
                }
            }while(true);
            remainReceiversNum = num;
            airdropSupply += amount_ - remainAmount;
        }
    }

    function isInAirdropStep() internal view returns (bool) {
        return (airdropStep == AIRDROP_DROP_COMMITED ||
            airdropStep == AIRDROP_DROP_DOING);
    }
    
    function commitAirdrop() external atLeastManager nonReentrant {
        require(airdropStep == AIRDROP_DROP_DOING, "no airdrop, maybe");
        require(airdropSupply == _airdropMaxSupply(), "the number of airdrops did not reach the maxSupply");
        airdropStep = AIRDROP_DROP_DONE;
        delete receivers;
        delete amounts;
    }
}

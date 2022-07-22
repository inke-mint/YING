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

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../common/HootBase.sol";

abstract contract Evolvement {
    struct Token {
        uint256 tokenId;
        uint256 amount;
    }
    function nourishing(address holder_, uint256 sourceAmount_, uint256 guaranteeTokenId_) public virtual returns (address, Token[] memory);
    function evolve(uint256 amount) public virtual returns (Token[] memory);
}
/**
 * @title Raising
 * @author HootLabs
 */
abstract contract HootBaseERC721Evolvement is HootBase, Evolvement, IERC721 {
    event NourishingConfigChanged(address sourceContractAddr_, uint256 sourceAmount_, SingleEvoConfig singleEvoCfg_);

    struct SingleEvoConfig {
        address targetContractAddress;
        uint256 targetAmount;
    }
    struct SourceContract {
        address sourceContract;
        uint256 amount;
    }
    mapping(address=>mapping(uint256=>SingleEvoConfig)) _nourishingConfig;
    SourceContract[] public sourceContracts;

    mapping(address=>bool) _evoWhitelist;
    address[] _evoContracts;

    /***********************************|
    |           nourishing              |
    |__________________________________*/
    function setNourishingConfig(address sourceContractAddr_, uint256 sourceAmount_, SingleEvoConfig calldata singleEvoCfg_) external atLeastManager {
        SingleEvoConfig memory oldEvoCfg = _nourishingConfig[sourceContractAddr_][sourceAmount_];
        if(oldEvoCfg.targetContractAddress == address(0)){
            sourceContracts.push(SourceContract(sourceContractAddr_, sourceAmount_));
        }
        _nourishingConfig[sourceContractAddr_][sourceAmount_] = singleEvoCfg_;
        emit NourishingConfigChanged(sourceContractAddr_, sourceAmount_, singleEvoCfg_);
    }
    function clearNourishingConfig() external atLeastManager{
        for(uint256 i=0;i<sourceContracts.length; i++){
            delete _nourishingConfig[sourceContracts[i].sourceContract][sourceContracts[i].amount];
        }
        delete sourceContracts;
    }
    function getNourishingConfig(address sourceContractAddr_, uint256 sourceAmount_) public view returns (SingleEvoConfig memory){
        SingleEvoConfig memory evoCfg = _nourishingConfig[sourceContractAddr_][sourceAmount_];
        require(evoCfg.targetContractAddress != address(0), "unknown source contract address and amount");
        return evoCfg;
    }
    function nourishing(address holder_, uint256 sourceAmount_, uint256 guaranteeTokenId_) public virtual override returns (address, Token[] memory) {
        require(holder_ != address(0), "holder address can not be address(0)");
        require(sourceAmount_ > 0, "source amount can not be 0");
        require(this.ownerOf(guaranteeTokenId_) == holder_, "caller is not owner");

        SingleEvoConfig memory evoCfg = getNourishingConfig(_msgSender(), sourceAmount_);
        Evolvement evo = Evolvement(evoCfg.targetContractAddress);
        Token[] memory tokens = evo.evolve(evoCfg.targetAmount);
        return (evoCfg.targetContractAddress, tokens);
    }

    /***********************************|
    |           nourishing              |
    |__________________________________*/
    function addEvoSourceContract(address guaranteeContractAddress_) external atLeastManager{
        require(_evoWhitelist[guaranteeContractAddress_]==false, "contract address already in evo whitelist");
        _evoWhitelist[guaranteeContractAddress_] = true;
        _evoContracts.push(guaranteeContractAddress_);
    }
    function clearEvoSourceContracts() external atLeastManager {
        for(uint256 i=0;i<_evoContracts.length; i++){
            delete _evoWhitelist[_evoContracts[i]];
        }
        delete _evoContracts;
    }
    function isInEvoContractsWhitelist(address addr_) public view returns (bool) {
        return _evoWhitelist[addr_];
    }

    function _beforeEvolve(uint256 /*amount_*/) internal virtual {
        require(isInEvoContractsWhitelist(_msgSender()), "the contract does not have authority for Evolve");
    }
    function evolve(uint256 amount_) public virtual override returns (Token[] memory) {
        _beforeEvolve(amount_);
        return _evolve(amount_);
    }
    function _evolve(uint256 /*amount_*/) internal virtual returns (Token[] memory) {
        require(false, "contract not supported evolve feature");
        return new Token[](0);
    }
}
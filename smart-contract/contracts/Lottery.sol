pragma solidity >=0.4.22 <0.9.0;

contract Lottery {

    struct BetInfo {
        uint256 anwerBlockNumber;
        address payable bettor;     // 특정 주소에 돈을 보내려면 payable 사용해줘야함
        byte challenges;            // 0xab같은 정답 넣는 칸
    }

    uint256 private _tail;
    uint256 private _head;
    mapping (uint256 => BetInfo) private _bets;
    address public owner;       // public이면 자동으로 getter를 만들어 줌

    uint256 constant internal BLOCK_LIMIT = 256;
    uint256 constant internal BET_BLOCK_INTERVAL = 3;
    uint256 constant internal BET_AMOUNT = 5 * 10 ** 15;
    uint256 private _pot;   

    event BET(uint256 index, address bettor, uint256 amount, byte challenges, uint256 answerBlockNumber);

    constructor() public {
        owner = msg.sender;
    }

    // smart contract에 있는 변수 조회하려면 view  사용해야함
    function getPot() public view returns (uint256 pot) {
        return _pot;
    }

    
    // 베팅(Bet)
    /**
     * @dev 배팅을 한다. 유저는 0.005 ETH를 보내야하고, 배팅용 1 byte 글자를 보낸다.
     * 큐에 저장된 베팅 정보는 이후 distribute 함수에서 해결된다.
     * @param challenges 유저가 베팅하는 글자
     * @return 함수가 잘 수행되는지 확인하는 bool 값
     */
     function bet(byte challenges) public payable returns (bool result) {
         // Check the proper ETH is sent
         require(msg.value == BET_AMOUNT, "Not enough ETH");

         // Push bet to the queue
         require(pushBet(challenges), "Fail to add a Bet Info");

         // emit event
         emit BET(_tail - 1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERVAL);

         return true;
     }

    /**
    검증
    - 정답체크
     */
    

    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, byte challenges) {
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.anwerBlockNumber;
        bettor = b.bettor;
        challenges = b.challenges;
    }

    function pushBet(byte challenges) internal returns (bool) {
        BetInfo memory b;
        b.bettor = msg.sender;
        b.anwerBlockNumber = block.number + BET_BLOCK_INTERVAL;
        b.challenges = challenges;

        _bets[_tail] = b;
        _tail++;

        return true;
    }

    function popBet(uint256 index) internal returns (bool) {
        delete _bets[index];
        return true;
    }
}
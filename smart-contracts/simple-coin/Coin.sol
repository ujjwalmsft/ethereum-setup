pragma solidity 0.4.8;

contract Coin {
    /*
    * @title A simple subcurrency example
    * @author Joe
    * @notice This is the first Smart Contract created
    * @dev This is only for demo purposes
    */
    address public minter;
    uint public totalCoins;

    event LogCoinsMinted(address deliveredTo, uint amount);
    event LogCoinsSent(address sentTo, uint amount);

    mapping (address => uint) balances;

    /**
    * @dev Constructor
    * @param initialCoins The initial amount of coins
    */
    function Coin(uint initialCoins) {
        minter = msg.sender;
        totalCoins = initialCoins;
        balances[minter] = initialCoins;
    }

    /**
    * @dev Mint coins
    * @param owner Address of the Smart Contract creator / owner
    * @param amount Amount of Coins to be minted
    */
    function mint(address owner, uint amount){
        if(msg.sender != owner){
            return;
        }
        totalCoins += amount;
        balances[owner] += amount;

        LogCoinsMinted(owner, amount);
    }

    /**
    * @dev Send coins from sender to receiver
    * @param receiver Address of the receiver
    * @param amount Amount of Coins to be send
    */
    function send(address receiver, uint amount){
        if(balances[msg.sender] < amount){
            return;
        }
        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        LogCoinsSent(receiver, amount);
    }

    /**
    * @dev Query balance of an address
    * @param addr Address to be queried
    * @return balance Current balance of the address
    */
    function queryBalance(address addr) constant returns (uint balance){
        return balances[addr];
    }

    /**
    * @dev Destroy the contract
    * @return status Status after deletion
    */
    function killCoin() returns (bool status){
        if (msg.sender != minter){
            throw;
        }
        selfdestruct(minter);
    }
}
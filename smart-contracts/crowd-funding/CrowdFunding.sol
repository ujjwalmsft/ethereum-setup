pragma solidity 0.4.9;

contract CrowdFunder {
    /*
    * @title CrowdFunder
    * @author Joe
    * @notice Can be used to collect funds from different addresses
    * This includes contribution, withdrawal, payout to fundRecipient
    */
    
    /*******************************************/
    // Data Structures
    /*******************************************/
    // State of the campaign
    enum State {
        Fundraising,
        ExpiredRefund,
        Successful,
        Closed
    }

    // Track Contributors
    struct Contribution {
        uint amount;
        address contributor;
    }

    /*******************************************/
    // State variables
    /*******************************************/
    address public creator; // creator of the contract
    address public fundRecipient; // receiver of the collected funds
    uint public minimumToRaise; // minimum to raise, else refund
    string campaignURL;
    byte constant version = 1;
    State public state = State.Fundraising;
    uint public totalRaised;
    uint public currentBalance;
    uint public raisedBy;
    uint public completeAt;
    Contribution[] contributions;

    /*******************************************/
    // State variables
    /*******************************************/
    event LogFundingReceived(address addr, uint amount, uint currentTotal);
    event LogWinnerPaid(address winnerAddress);
    event LogFunderInitialized (
        address creator,
        address fundRecipient,
        string url,
        uint _minimumToRaise,
        uint256 raisedBy // target date
    )

    /*******************************************/
    // Modifiers
    /*******************************************/
    // control in which state which function can be executed
    modifier inState (State _state) {
        if (state != _state) {
            throw;
        }
        _;
    }

    modifier isCreator () {
        if (msg.sender != creator) {
            throw;
        }
        _;
    }

    // Wait 1 hour after final contract state before allowing contract destruction
    // For functions executed after the life cycle of the funding campaign
    modifier atEndOfLifecycle () {
        if (!((state == State.ExpiredRefund || state == State.Successful) && completeAt + 1 < now)) {
            throw;
        }
        _;
    }

    /*******************************************/
    // Constructor
    /*******************************************/
    function CrowdFunder (
        uint timeInHoursForFundraising,
        string _campaignURL,
        address _fundRecipient,
        uint _minimumToRaise
    ) 
    {
        creator = msg.sender;
        fundRecipient = _fundRecipient;
        campaignURL = _campaignURL;
        minimumToRaise = _minimumToRaise * 1000000000000000000: // convert to Wei
        raiseBy = now + (timeInHoursForFundraising * 1 hours);
        currentBalance = 0;

        LogFunderInitialized (
            creator,
            fundRecipient,
            campaignURL,
            minimumToRaise,
            raiseBy);
        )
    }

    /*******************************************/
    // Functions
    /*******************************************/
    /**@dev Receive the funds
     * @return ID for the contribution that equals the contributions length - 1
     */
     function contribute () public inState(State.Fundraising) payable returns (uint256) {
         contributions.push (
             Contribution ({
                 amount: msg.value,
                 contributor: msg.sender
             })
         );
         totalRaised += msg.value;
         currentBalance = totalRaised;
         
         LogFundingReceived (
             msg.sender,
             msg.value,
             totalRaised
         );

         checkIfFundingCompleteOrExpired();

         return contributions.length - 1; // return id
     }

     /**@dev Check if the funding is complete or expired
      */
     function checkIfFundingCompleteOrExpired () {
         if (totalRaised > minimumToRaise) {
             state = State.Successful;
             payout();
         }
         else if (now > raiseBy) {
             state = State.ExpiredRefund; // Backers can then collect funds -> getRefund(id)
         }
         completeAt = now;
     }

     /**@dev Pay out the funds if the campaign was successful
      */
     function payOut () public inState(State.Successful) {
         if (!fundRecipient.send(this.balance)){
             throw;
         }
         state = State.Closed;
         currentBalance = 0;
         LogWinnerPaid(fundRecipient);
     }

     /**@dev Get the refund
      * @param id   Contribution id
      * @return success result of the operation as boolean
      */
     function getRefund (uint256 id) public inState(State.ExpiredRefund) returns (bool) {
        if (contributions.length <= id || id < 0 || contribution[id].amount == 0) {
            throw;
        }

        uint amountToRefund = contributions[id].amount;
        contributions[id].amount = 0;

        if(!contributions[id].contributor.send(amountToRefund)) {
            contributions[id].amount = amountToRefund;
            return false;
        }
        else {
            totalRaised -= amountToRefund;
            currentBalance -= totalRaised;
        }
        return true;
     }

     /**@dev Destroy the contract
      */
      function removeContract() public isCreator() atEndOfLifecycle() {
          selfdestruct(msg.sender);
      }

      /**@dev Default function
      */
      function () {
          throw;
      }
}
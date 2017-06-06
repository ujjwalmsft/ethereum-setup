pragma solidity ^0.4.4;

/** @title Loc.*/
contract LoC {
    /* define global variables */
    address issuer;
    uint credit;
    address buyer;
    address buyerBank;
    address seller;
    address sellerBank;
    uint startTime;
    uint validTime;
    bool[] requiredChannels;


    /**
    * @dev  Setup the initial parameters for the contract
    * and the start time
    * @param   cred    The credit given by the buyer's bank
    * @param   b       The buyer address
    * @param   bob     The buyer bank
    * @param   s       The seller address
    * @param   bos     The seller bank
    * @param   val     The time validity of the contract from the start time
    */
    function LoC (uint cred, address b, address bob, address s, address bos, uint val) {
        issuer = msg.sender;
        credit = cred;
        buyer = b;
        buyerBank = bob;
        seller = s;
        sellerBank = bos;
        startTime = now;
        validTime = val;
    }

    /* S add carrier C as a channel of transport of the good */
    struct Channel {
        string channelName;
        address channelAddress;
        string channelChecks;
        bool initialized;
        bool active;
        bool checked;
        bool finished;
        bool error;
        string failedChecks;
        bool issuerAccepted;
    }

    /* Initialize an array for Channel structs */
    Channel[] public channelSequence;

    /**
    * @dev Add a channel of transport for the contract
    * There can be more than one channel, therefore the array
    * @param  cName       The name of the channel
    * @param  cAddress    The address of the channel
    * @param  cRole       The role played by the address
    * @param  cChecks      The checks made by the channel
    */
    function addChannel (string cName, address cAddress, string cRole, string cChecks) {
        /* Check if the caller of the function is the seller */
        if (msg.sender != seller){
            throw;
        }
        /* Check if the time when calling the function is less sum of the starting time
        of the contract and the valid time in which the function has to be called after
        the contract has been created */
        if (now < startTime + validTime) {
            throw;
        }

        /* Assign values to the variables within the initialized struct 'channelSequence' */
        channelSequence.push(Channel({
            channelName: cName,
            channelAddress: cAddress,
            channelRole: cRole,
            channelChecks: cChecks,
            initialized: false,
            active: false,
            checked: false,
            finished: false,
            error: false,
            failedChecks: "",
            issuerAccepted: false
        }));
    }

    /**
    * @dev A method for the LC issuer (BoB) to set the required channelSequence
    * whose confirmation and finish is required for releasing the credit
    * @param required    The set of required channels from current channels
    */
    function setRequiredChannels (bool[] required) {
        if (issuer != msg.sender){
            throw;
        }
        requiredChannels = required;
    }

    /**
    * @dev A method for a channel to indicate that it is now
    * active in the transportation
    * @param cIndex    Index to select the appropriate channel
    */
    function channelActivate (uint cIndex) {
        address cAddress = channelSequence[cIndex].channelAddress;
        /* check if the address is not null */
        if (cAddress == address(0)){
            throw;
        }
        if (cAddress != msg.sender){
            throw;
        }
        channelSequence[cIndex].initialized = true;
        channelSequence[cIndex].active = true;
    }

    /**
    * @dev A method for a channel to indicate that it is now
    * inactive in hte transportation
    * @param cIndex Index to select the appropriate channel
    */
    function channelDeactivate (uint cIndex) {
        address cAddress = channelSequence[cIndex].channelAddress;
        if (cAddress == address(0)){
                throw;
            }
            if (cAddress != msg.sender){
                throw;
            }
            if (now < startTime + validTime) {
                throw;
            }
            channelSequence[cIndex].active = false;
    }

    /**
    * @dev A method for a channel to indicate that it has now
    * successfully finished it's part of transportation
    * @param cIndex Index to select the appropriate channel
    */
    function channelFinish (uint cIndex) {
        address cAddress = channelSequence[cIndex].channelAddress;
        if (cAddress == address(0)){
            throw;
        }
        if (cAddress != msg.sender){
            throw;
        }
        if (now < startTime + validTime) {
            throw;
        }
        channelSequence[cIndex].finished = true;
    }

    /**
    * @dev A method for the channel to indicate that it has
    * failed in it's transportation or it's checks
    * @param cIndex   Index to select the appropriate channel
    * @param failed   String to indicate why it failed
    */
    function channelError (uint cIndex, string failed) {
        address cAddress = channelSequence[cIndex].channelAddress;
        if (cAddress == address(0)){
            throw;
        }
        if (cAddress != msg.sender){
            throw;
        }
        if (now < startTime + validTime) {
            throw;
        }
        channelSequence[cIndex].error = true;
        channelSequence[cIndex].failedChecks = failed;
    }
    
    /**
    * @dev A method for the seller to request transfer of credit
    * which will be successful if all the required channels have
    * confirmed and finished
    */
    function getPayment () {
        if (seller != msg.sender) {
            throw;
        }
        for (uint i = 0; i < channelSequence.length; i++) {
            if (requiredChannels[i] == true) {
                if (channelSequence[i].finished = false || 
                channelSequence[i].error == true) {
                    throw;
                }
            }
        }
        //transferCredit(credit, sellerBank, buyerBank);
    }    
}
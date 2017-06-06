pragma solidity ^0.4.4;

contract LetterOfCreditContract {
  /*######################################################################*/
  // Structs
  /*######################################################################*/

  struct LetterOfCredit {
    address buyer;
    address seller;
    string currency;
    uint amount;
    string descriptionOfGoods;
    string portOfLading;
    string portOfDespatch;
    string termsOfPayment;
  }

  struct DocumentReference {
    string reference;
    string hashOfDocument;
  }

  struct Drawing {
    string currency;
    uint amount;
    string billOfLadingNumber;
    string billOfLadingDate;
  }

  struct StatusProcessFlow {
    bool contractInitialized;
    bool locApproved;
    bool drawingAmountLeft;
    bool drawingCompleted;
    bool drawingApproved;
    bool contractCompleted;
  }

  /*######################################################################*/
  // Global contract variables
  /*######################################################################*/

  address _buyer;
  address _buyerBank;
  address _seller;
  address _sellerBank;
  string _currency;
  uint _amount;
  string _descriptionOfGoods;
  string _portOfLading;
  string _portOfDespatch;
  string _termsOfPayment;
  LetterOfCredit _letterOfCredit;
  DocumentReference _invoice;
  DocumentReference _billOfLading;
  DocumentReference _inspectionCertificate;
  Drawing[] _drawings;
  StatusProcessFlow statusProcess;


  /*######################################################################*/
  // Events
  /*######################################################################*/

  event OnCreateEvent(address buyer,
                      address buyerBank,
                      address seller,
                      address sellerBank,
                      string currency,
                      uint amount,
                      string descriptionOfGoods,
                      string portOfLading,
                      string portOfDespatch,
                      string termsOfPayment);

  event LetterOfCreditApprovedEvent();

  event TasksOfSellerFinishedGoodsAreShippingEvent (string referenceInvoice,
                                                    string hashInvoice,
                                                    string referenceBillOfLading,
                                                    string hashBillOfLading,
                                                    string referenceInspectionCertificate,
                                                    string hashOfInspectionCertificate);

  event LetterOfCreditDrawnEvent(address drawer,
                                 string currency,
                                 uint amount,
                                 string billOfLadingNumber,
                                 string billOfLadingDate);

  event ContractCompletedEvent();

  event returnValueEvent(string identifier,
                         string value);


  /*######################################################################*/
  // Main Functions
  /*######################################################################*/

  /**@dev  The constructor. The Smart Contract can only be created from buyerBank address.
   * @param buyer The buyers address
   * @param buyerBank The buyers bank address
   * @param seller The sellers address
   * @param sellerBank The sellers bank address
   * @param currency Currency specified
   * @param amount Credit amount
   * @param descriptionOfGoods Description of the goods
   * @param portOfLading Port of Lading
   * @param portOfDespatch Port of Despatch
   * @param termsOfPayment Terms of Payment
   */
  function LetterOfCreditContract (address buyer,
                                   address buyerBank,
                                   address seller,
                                   address sellerBank,
                                   string currency,
                                   uint amount,
                                   string descriptionOfGoods,
                                   string portOfLading,
                                   string portOfDespatch,
                                   string termsOfPayment) {
    
    if (msg.sender != buyerBank) {
      throw;
    }
                  
    _buyer = buyer;
    _buyerBank = buyerBank;
    _seller = seller;
    _sellerBank = sellerBank;
    _currency = currency;
    _amount = amount;
    _descriptionOfGoods = descriptionOfGoods;
    _portOfLading = portOfLading;
    _portOfDespatch = portOfDespatch;
    _termsOfPayment = termsOfPayment;

    statusProcess = StatusProcessFlow({
      contractInitialized: true,
      locApproved: false,
      drawingAmountLeft: false,
      drawingCompleted: false,
      drawingApproved: false,
      contractCompleted: false
    });
    

    OnCreateEvent(_buyer,
                  _buyerBank,
                  _seller,
                  _sellerBank,
                  _currency,
                  _amount,
                  _descriptionOfGoods,
                  _portOfLading,
                  _portOfDespatch,
                  _termsOfPayment);
  }

  /**@dev A method to approve the creation of the letter of credit by the sellerBank
   */
  function approveLetterOfCreditCreation() {
    if (statusProcess.contractCompleted == true) {
      returnValueEvent("getCurrentLetterOfCredit",
                        "The contract has been completed!");
      return;
    }
    if (statusProcess.contractInitialized != true) {
      returnValueEvent("approveLetterOfCreditCreation",
                      "Wrong status!");
      return;
    }
    if (statusProcess.locApproved == true) {
      returnValueEvent("approveLetterOfCreditCreation",
                        "LoC already approved!");
      return;
    }
    if (msg.sender != _sellerBank) {
      returnValueEvent("approveLetterOfCreditCreation",
                        "Wrong address - only sellerBank is allowed to approve!");
      return;
    }

    _letterOfCredit = LetterOfCredit({
      buyer: _buyer,
      seller: _seller,
      currency: _currency,
      amount: _amount,
      descriptionOfGoods: _descriptionOfGoods,
      portOfLading: _portOfLading,
      portOfDespatch: _portOfDespatch,
      termsOfPayment: _termsOfPayment
    });

    statusProcess = StatusProcessFlow({
      contractInitialized: true,
      locApproved: true,
      drawingAmountLeft: false,
      drawingCompleted: false,
      drawingApproved: false,
      contractCompleted: false
    });
    //statusProcess.locApproved = true;

    LetterOfCreditApprovedEvent();

    returnValueEvent("approveLetterOfCreditCreation",
                      "Letter of Credit approved!");
  }

  /**@dev A method that is called by the seller to confirm the finishing of its steps and that the goods are on its way
   * @param referenceInvoice  Identifier (e.g. URL) to the invoice
   * @param hashInvoice Hash of the invoice document
   * @param referenceBillOfLading Identifier (e.g. URL) to the Bill of Lading
   * @param hashBillOfLading  Hash of the Bill of Lading document
   * @param referenceInspectionCertificate  Identifier (e.g. URL) to the Inspection Certificate
   * @param hashOfInspectionCertificate Hash of the Inspection Certificate document
   */
  /*function tasksOfSellerFinishedGoodsAreShipping(string referenceInvoice,
                                                 string hashInvoice,
                                                 string referenceBillOfLading,
                                                 string hashBillOfLading,
                                                 string referenceInspectionCertificate,
                                                 string hashOfInspectionCertificate){
    if (statusProcess.locApproved != true) {
      returnValueEvent("tasksOfSellerFinishedGoodsAreShipping",
                       "Wrong status!");
      return;
    }
    if (msg.sender != _seller) {
      returnValueEvent("tasksOfSellerFinishedGoodsAreShipping",
                       "Wrong address - only seller is allowed to call the function!");
      return;
    }
    if (bytes(referenceInvoice).length == 0 || bytes(hashInvoice).length == 0 || 
        bytes(referenceBillOfLading).length == 0 || bytes(hashBillOfLading).length == 0 || 
        bytes(referenceInspectionCertificate).length == 0 || bytes(hashOfInspectionCertificate).length == 0) {
      returnValueEvent("tasksOfSellerFinishedGoodsAreShipping",
                       "Missing parameter values!");
      return;
    }

    _invoice = DocumentReference({
      reference: referenceInvoice,
      hashOfDocument: hashInvoice
    });

    _billOfLading = DocumentReference({
      reference: referenceBillOfLading,
      hashOfDocument: hashBillOfLading
    });

    _inspectionCertificate = DocumentReference({
      reference: referenceInspectionCertificate,
      hashOfDocument: hashInvoice
    });

    //statusProcess.?? = true;

    TasksOfSellerFinishedGoodsAreShippingEvent(referenceInvoice,
                                               hashInvoice,
                                               referenceBillOfLading,
                                               hashBillOfLading,
                                               referenceInspectionCertificate,
                                               hashOfInspectionCertificate);
  }*/


  // the arrival at port of despatch and the check through the customs office are not included so far

  /**@dev Draw against a letter of credit
   * @param currency  The currency of the drawing (Must match LetterOfCredit)
   * @param amount  The amount to draw
   * @param billOfLadingNumber  Identifier of BoL
   * @param billOfLadingDate  Date of BoL
   */
  function drawAgainstLetterOfCredit(string currency,
                                     uint amount,
                                     string billOfLadingNumber,
                                     string billOfLadingDate) {
    if (statusProcess.contractCompleted == true) {
      returnValueEvent("getCurrentLetterOfCredit",
                        "The contract has been completed!");
      return;
    }
    if (statusProcess.contractInitialized != true || statusProcess.locApproved != true) {
      returnValueEvent("drawAgainstLetterOfCredit",
                       "Wrong status - at least one previous step not completed!");
      return;
    }
    if (statusProcess.drawingCompleted == true) {
      returnValueEvent("drawAgainstLetterOfCredit",
                       "Drawing already completed!");
      return;
    }
    if(msg.sender != _sellerBank) {
      returnValueEvent("drawAgainstLetterOfCredit",
                       "Wrong address - only sellerBank is allowed to call the function!");
      return;
    }
    if(amount > _letterOfCredit.amount) {
      returnValueEvent("drawAgainstLetterOfCredit",
                       "The amount to be drawn is bigger than the amount allowed to be drawn!");
      return;
    }
    if(amount < 0) {
      returnValueEvent("drawAgainstLetterOfCredit",
                       "The amount to be drawn is less than zero!");
      return;
    }

    var drawing = Drawing({
      currency: currency,
      amount: amount,
      billOfLadingDate: billOfLadingDate,
      billOfLadingNumber: billOfLadingNumber
    });

    _drawings.push(drawing);
    _letterOfCredit.amount -= drawing.amount;

    if (_letterOfCredit.amount == 0) {
      statusProcess = StatusProcessFlow({
        contractInitialized: true,
        locApproved: true,
        drawingAmountLeft: false,
        drawingCompleted: true,
        drawingApproved: false,
        contractCompleted: false
      });
      //statusProcess.drawingAmountLeft == false;
      //statusProcess.drawingCompleted == true;
      returnValueEvent("drawAgainstLetterOfCredit",
                       "All credit has been drawn!");
    }
    else {
      statusProcess = StatusProcessFlow({
        contractInitialized: true,
        locApproved: true,
        drawingAmountLeft: true,
        drawingCompleted: false,
        drawingApproved: false,
        contractCompleted: false
      });
      //statusProcess.drawingAmountLeft == true;
      
      LetterOfCreditDrawnEvent(msg.sender,
                             currency,
                             amount,
                             billOfLadingDate,
                             billOfLadingNumber);
      returnValueEvent("drawAgainstLetterOfCredit",
                       "Credit has been drawn partially. Still credit left!");
    }
  }

  /**@dev A method to approve the completion of the drawing by buyerBank
   */
  function approveDrawing () {
    if (statusProcess.contractCompleted == true) {
      returnValueEvent("getCurrentLetterOfCredit",
                        "The contract has been completed!");
      return;
    }
    if (statusProcess.drawingCompleted != true) {
      returnValueEvent("approveDrawing",
                      "Wrong status - Drawing has not been completed!");
     return;
    }
    if (statusProcess.drawingApproved == true) {
     returnValueEvent("approveDrawing",
                      "Drawing has already been approved!");
     return;
    }
    if (msg.sender != _buyerBank) {
      returnValueEvent("approveDrawing",
                       "Wrong address - only buyerBank is allowed to approve!");
      return;
    }

    statusProcess = StatusProcessFlow({
      contractInitialized: true,
      locApproved: true,
      drawingAmountLeft: false,
      drawingCompleted: true,
      drawingApproved: true,
      contractCompleted: true
    });
    //statusProcess.drawingApproved == true;
    //statusProcess.contractCompleted == true;
    returnValueEvent("approveDrawing",
                     "Drawing has been approved!");
    ContractCompletedEvent();
  }

  
  /*######################################################################*/
  // Helper functions
  /*######################################################################*/

  /**@dev Set the current status of the process flow
   * @param contractInit  contractInitialized status
   * @param locAppr locApproved status
   * @param drawingAmLe drawingAmountLeft status
   * @param drawingComp drawingCompleted status
   * @param drawingAppr drawingApproved status
   * @param contractCompl contractCompleted status
   */
  function setStatusProcessFlow (bool contractInit, 
                                 bool locAppr, 
                                 bool drawingAmLe, 
                                 bool drawingComp,
                                 bool drawingAppr,
                                 bool contractCompl) {
    statusProcess = StatusProcessFlow({
      contractInitialized: contractInit,
      locApproved: locAppr,
      drawingAmountLeft: drawingAmLe,
      drawingCompleted: drawingComp,
      drawingApproved: drawingAppr,
      contractCompleted: contractCompl
    });
  }

  /**@dev Get the current status of the process flow
   * @return contractInit  contractInitialized status
   * @return locAppr locApproved status
   * @return drawingAmLe drawingAmountLeft status
   * @return drawingComp drawingCompleted status
   * @return drawingAppr drawingApproved status
   * @return contractCompl contractCompleted status
   */
  function getStatusProcessFlow () public constant 
    returns (bool contractInit,
              bool locAppr,
              bool drawingAmLe,
              bool drawingComp,
              bool drawingAppr,
              bool contractCompl)  {
    return (statusProcess.contractInitialized,
            statusProcess.locApproved,
            statusProcess.drawingAmountLeft,
            statusProcess.drawingCompleted,
            statusProcess.drawingApproved,
            statusProcess.contractCompleted);
  }

  /**@dev Returns the current letter of credit
   * @return buy  Buyers address
   * @return sell Sellers address
   * @return curr Currency defined
   * @return amou Amount of the credit
   * @return descOfGoods  Description of the goods
   * @return portOfLad  Port of Lading
   * @return portOfDes  Port of Despatch
   * @return termsOfPay  Terms of Payment
   */
  function getCurrentLetterOfCredit() public constant
    returns (address buy,
            address sell,
            string curr,
            uint amou,
            string descOfGoods,
            string portOfLad,
            string portOfDes,
            string termsOfPay) {
    return (_letterOfCredit.buyer,
            _letterOfCredit.seller,
            _letterOfCredit.currency,
            _letterOfCredit.amount,
            _letterOfCredit.descriptionOfGoods,
            _letterOfCredit.portOfLading,
            _letterOfCredit.portOfDespatch,
            _letterOfCredit.termsOfPayment);
  }
}


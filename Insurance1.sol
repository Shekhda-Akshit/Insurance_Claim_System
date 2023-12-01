// SPDX-License-Identifier: GPL-3.0
//10000000000000000000

pragma solidity >=0.4.24 <0.9.0;

import '../Insurance Management/FarmerActor.sol';
import '../Insurance Management/InsuranceActor.sol';
import '../Insurance Management/BankActor.sol';
import '../Insurance Management/SurveyorActor.sol';

contract Insurance1 is FarmerActor,InsuranceActor,BankActor,SurveyorActor
{
    address owner;//contract deployer address
    uint claimid;
    bool result;
    
    

    mapping (uint => Claim) claims;

	mapping (uint => Txblocks) claimsHistory;

    enum State
		{
		ClaimRaisedByFarmer,	// 0
		ClaimReceivedByInsurance,	// 1
		ClaimTransferredToSurveyor,	// 2
		SurveyorVisitsFarmer,	// 3
		SurveyorSubmitsReports,	// 4
		InsuranceInstructsBank,	// 5
		BankTransfersAmount	// 6
		}

         State constant defaultState = State.ClaimRaisedByFarmer;

        struct Claim
		{
		address originalFarmerAddress;
    	uint    claimID;
        uint claimvalue;
		State   processState;
        uint amount;
		address bankactorID;
		address surveyoractorID;
		address insuranceactorID;
		uint claimid;
		
		}

        struct Txblocks 
		{
		uint blockFarmerToInsurance;
		uint blockInsuranceToSurveyor;
		uint blockSurveyorToFarmer;
		uint blockSurveyorToInsurance;
        uint blockInsuranceToBank;
        uint blockBankToFarmer;
		}

    event ClaimRaisedByFarmer(uint claimid);		// 0
	event ClaimReceivedByInsurance(uint claimid);		// 1
	event ClaimTransferredToSurveyor(uint claimid);	// 2
	event SurveyorVisitsFarmer(uint claimid);		// 3
	event SurveyorSubmitsReports(uint claimid);	// 4
	event InsuranceInstructsBank(uint claimid);	// 5
	event BankTransfersAmount(uint claimid);

    modifier onlyOwner() 
	{
	require(msg.sender == owner);
	_;
	}

    modifier  claimRaisedByFarmer(uint _claimid)
{
    require(claims[_claimid].processState==State.ClaimRaisedByFarmer);
    _;
}

modifier  claimReceivedByInsurance(uint _claimid)
{
    require(claims[_claimid].processState==State.ClaimReceivedByInsurance);
	_;
}

modifier   claimTransferredToSurveyor(uint _claimid)
{
    require(claims[_claimid].processState==State.ClaimTransferredToSurveyor);
	_;
}

modifier  surveyorVisitsFarmer(uint _claimid)
{
    require(claims[_claimid].processState==State.SurveyorVisitsFarmer);
	_;
}

modifier  surveyorSubmitsReports(uint _claimid)
{
    require(claims[_claimid].processState==State.SurveyorSubmitsReports);
	_;
}

modifier  insuranceInstructsBank(uint _claimid)
{
    require(claims[_claimid].processState==State.InsuranceInstructsBank);
	_;
}

modifier  bankTransfersAmount(uint _claimid)
{
    require(claims[_claimid].processState==State.BankTransfersAmount);
	_;
}


    constructor()
    {
        owner=msg.sender;
        claimid=1;
    }
    
    function _make_payable(address x) internal pure returns (address payable) {return payable(address(uint160(x)));}


    function claimProductByFarmer(uint _claimid ) public payable  onlyFarmer()
    {
       // Claim memory newProduce;
      // newProduce.claimid = _claimid; 
      claims[_claimid].originalFarmerAddress =msg.sender;
      

      claims[_claimid].processState = State.ClaimRaisedByFarmer;
	  Txblocks memory txBlock;
	  uint placeholder;
	  txBlock.blockFarmerToInsurance = placeholder;
      txBlock.blockInsuranceToSurveyor=placeholder;
      txBlock.blockSurveyorToFarmer = placeholder;
      txBlock.blockSurveyorToInsurance = placeholder;
      txBlock.blockInsuranceToBank = placeholder;
      txBlock.blockBankToFarmer = placeholder;
	  claimsHistory[_claimid] = txBlock;
      emit ClaimRaisedByFarmer(_claimid);
    }

    function claimsReceivedByInsurance(uint _claimid) public payable onlyInsurance()
	 claimRaisedByFarmer(_claimid)
     {
         claims[_claimid].processState = State.ClaimReceivedByInsurance;
         claimsHistory[_claimid].blockFarmerToInsurance = block.number;
      emit ClaimReceivedByInsurance(_claimid);
     }

     function claimsTransferedToSurveyor(uint _claimid) public payable onlyInsurance()
     claimReceivedByInsurance(_claimid)
     {
         claims[_claimid].processState=State.ClaimTransferredToSurveyor;
        claimsHistory[_claimid].blockInsuranceToSurveyor=block.number;
        emit ClaimTransferredToSurveyor(_claimid);
     }

     function claimsSurveyorVisitsFarmer(uint _claimid) public payable onlySurveyor()
     claimTransferredToSurveyor(_claimid)
     {
         claims[_claimid].processState=State.SurveyorVisitsFarmer;
         claimsHistory[_claimid].blockSurveyorToFarmer=block.number;
         emit SurveyorVisitsFarmer(_claimid);
     }

     function claimsSurveyorSubmitsReport(uint _claimid,bool _result) public payable onlySurveyor()
     surveyorVisitsFarmer(_claimid)
     {  
         result=_result;
         claims[_claimid].processState=State.SurveyorSubmitsReports;
         claimsHistory[_claimid].blockSurveyorToInsurance=block.number;
         emit SurveyorSubmitsReports(claimid);
     }

     function claimInsuranceInstructsBank(uint _claimid,uint _amount) public payable onlyInsurance()
     surveyorSubmitsReports(_claimid)
     {
         require(result==true);
         claims[_claimid].amount=_amount;
         claims[_claimid].processState=State.InsuranceInstructsBank;
         claimsHistory[_claimid].blockInsuranceToBank=block.number;
         emit InsuranceInstructsBank(claimid);
     }

     function claimBankTransfersAmount(uint _claimid) public payable onlyBank()
     insuranceInstructsBank(_claimid)
     {
         address payable ownerAddressPayable = payable(claims[_claimid].originalFarmerAddress); 
       ownerAddressPayable.transfer(claims[_claimid].amount);
        
         claims[_claimid].processState=State.BankTransfersAmount;
         claimsHistory[_claimid].blockBankToFarmer=block.number;
         emit BankTransfersAmount(_claimid);
     }




}
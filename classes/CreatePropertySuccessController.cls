/**********************************************************************************************
===============================================================================================
Purpose: CreatePropertySuccessController class is to handle the Web to 
lead form requests and make Dont/Eers call
===============================================================================================
History:

AUTHOR     	   DATE         Reference     						Description
Pooja Kumari   28/10/2022   ESCJ-2007 (Web to lead form)        DONT/EERS options are not working when Web to Leads are created/Updated
***********************************************************************************************/
public class CreatePropertySuccessController {
    public  string leadId;
    public CreatePropertySuccessController(){
    	 leadId =apexpages.currentpage().getparameters().get('confirmationNo');
      }
    public  void calldontEersCheck(){
        SyncLeadPEHandler.dontEersCheck('insertion',leadId);
    }

}
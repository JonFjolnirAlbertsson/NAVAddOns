codeunit 53103 SMSSetupInstallCode
{
    // Set the codeunit to be an install codeunit. 
    Subtype = Install;

    // This trigger includes code for company-related operations. 
    trigger OnInstallAppPerCompany();
    var
        SMSSetupL: Record "SMS Setup";
        SMSSetupInitL: Codeunit SMSSetupInit;
    begin
        // If the "Reward" table is empty, insert the default rewards.
        if SMSSetupL.IsEmpty() then
            SMSSetupInitL.InsertDefaultSMSSetup();
    end;

}
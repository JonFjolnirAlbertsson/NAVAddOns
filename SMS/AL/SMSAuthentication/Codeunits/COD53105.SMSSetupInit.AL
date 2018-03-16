codeunit 53105 SMSSetupInit
{
    trigger OnRun();
    begin
    end;

    procedure InsertDefaultSMSSetup();
    begin
        InsertSMSSetup('BOS', 'sidata', 'sid321', 'https://secure.pswin.com/XMLHttpWrapper/process.aspx');
    end;

    // Create and insert a reward level in the "Reward" table.
    procedure InsertSMSSetup(CompanyNameP: Text[250]; UserNameP: Text[250]; PasswordP: Text; BaseUrlP: Text[250]);
    var
        SMSSetupL: Record "SMS Setup";
    begin
        SMSSetupL.Init();
        SMSSetupL."Base URL" := BaseUrlP;
        SMSSetupL."Company Name" := CompanyNameP;
        SMSSetupL."User Name" := UserNameP;
        SMSSetupL.SetPassword(PasswordP);
        SMSSetupL.Insert();
    end;
}
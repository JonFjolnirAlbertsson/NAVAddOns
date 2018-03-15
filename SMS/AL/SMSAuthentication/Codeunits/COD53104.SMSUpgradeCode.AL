codeunit 53104 SMSUpgradeCode
{
    // An upgrade codeunit includes AL methods for synchronizing changes to a table definition 
    // in an application with the business data table in SQL Server and migrating existing 
    // data.
    Subtype = Upgrade;
    trigger OnCheckPreconditionsPerCompany()
    var
        // "ModuleInfo" is the current executing module. 
        ModuleInfoL: ModuleInfo;
    begin
        // Code to make sure company is OK to upgrade.
        if NavApp.GetCurrentModuleInfo(ModuleInfoL) then
            if ModuleInfoL.DataVersion() = Version.Create(1, 0, 0, 0) then
                ERROR('The upgrade is not compatible')
    end;
    // "OnUpgradePerCompany" trigger is used to perform the actual upgrade.
    trigger OnUpgradePerCompany();
    var
        SMSSetupL: Record "SMS Setup";
        SMSSetupInitL: Codeunit SMSSetupInit;
        // "ModuleInfo" is the current executing module. 
        CurrModuleInfoL: ModuleInfo;
    begin
        // Get information about the current module.
        NavApp.GetCurrentModuleInfo(CurrModuleInfoL);
        // If the code needs to be upgraded
        if CurrModuleInfoL.DataVersion().Major() = 1 then
            case CurrModuleInfoL.DataVersion().Revision() of
                2 :
                begin
                    SMSSetupL.Get();
                    SMSSetupL."Company Name" := 'Upgraded ' + format(CurrModuleInfoL.DataVersion().Revision());
                    SMSSetupL.Modify();
                end;
                3 :
                begin
                    SMSSetupL.DeleteAll(true);
                    SMSSetupInitL.InsertDefaultSMSSetup();
                end;
                4 :
                begin
                    SMSSetupL.Get();
                    SMSSetupL."Company Name" := 'Upgraded ' + format(CurrModuleInfoL.DataVersion().Revision());
                    SMSSetupL.Modify();
                end;
                 5 :
                begin
                    SMSSetupL.Get();
                    SMSSetupL."Company Name" := 'Upgraded ' + format(CurrModuleInfoL.DataVersion().Revision());
                    SMSSetupL.Modify();
                end;
                 6 :
                begin
                    SMSSetupL.Get();
                    SMSSetupL."Company Name" := 'Upgraded ' + format(CurrModuleInfoL.DataVersion().Revision());
                    SMSSetupL.Modify();
                end;
            end;
    end;

    trigger OnValidateUpgradePerCompany()
    begin
        // Code to make sure that upgrade was successful for each company
    end;
}
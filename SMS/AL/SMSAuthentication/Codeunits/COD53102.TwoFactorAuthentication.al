codeunit 53102 TwoFactorAuthentication
{
    var
        C_INC_UserNotFoundTxt: Label 'User does not exists.';

    [EventSubscriber(ObjectType::Codeunit, 1, 'OnBeforeCompanyOpen', '', true, true)]
    local procedure TwoFactorAuthentication_OnBeforeCompanyOpen()
    var
        UserSetup: Record "User Setup";
        SMSSetup: Record "SMS Setup";
        EnterSMSCode: Page EnterSMSCode;
        SMSCode: Text;
        MessageText: Text[450];
        TryAgain: Boolean;
        UserResponse: Text;
        CodeIsValid: Boolean;
        Counter: Integer;
    begin
        if not GuiAllowed() then
            exit;
        if not UserSetup.get(UserId) then
            Error(C_INC_UserNotFoundTxt);

        if not UserSetup."Use SMS Authentication" then
            exit;

        if not SMSSetup.Get() then
            exit;

        SMSCode := Format(Random(100000000));
        MessageText := StrSubstNo('Enter %1 to login in to the %2 company.', SMSCode, CompanyName);

        SMSSetup.SendSMS(UserSetup."Phone No.", MessageText);
        TryAgain := true;

        while TryAgain do
        begin
            clear(EnterSMSCode);
            if EnterSMSCode.RunModal() <> "Action"::OK then
                error('You canceled the login procedure');

            UserResponse := EnterSMSCode.GetSMSCode();

            CodeIsValid := UserResponse = SMSCode;
            Counter += 1;
            TryAgain := (not CodeIsValid) and(Counter < 3);
        end;

        if not CodeIsValid then
            error('You entered an invalid code for %1 times', Counter);
    end;
}
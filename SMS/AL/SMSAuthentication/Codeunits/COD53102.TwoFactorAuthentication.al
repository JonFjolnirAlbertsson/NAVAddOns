codeunit 53102 TwoFactorAuthentication
{
    var
        C_INC_UserNotFoundTxt: Label 'User does not exists.';
        C_INC_EnterSMSCode: Label 'Enter %1 to login in to the %2 company.';
        C_INC_LoginCanceled: Label 'You canceled the login procedure';
        C_INC_LoginInvalid: Label 'You entered an invalid code for %1 times';

    [EventSubscriber(ObjectType::Codeunit, 1, 'OnBeforeCompanyOpen', '', true, true)]
    local procedure TwoFactorAuthentication_OnBeforeCompanyOpen()
    var
        User: Record User;
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
        if not User.get(UserId) then
            Error(C_INC_UserNotFoundTxt);

        if not User."Use SMS Authentication" then
            exit;

        if not SMSSetup.Get() then
            exit;

        SMSCode := Format(Random(100000000));
        MessageText := StrSubstNo(C_INC_EnterSMSCode, SMSCode, CompanyName);

        SMSSetup.SendSMS(User."Phone No.", MessageText);
        TryAgain := true;

        while TryAgain do
        begin
            clear(EnterSMSCode);
            if EnterSMSCode.RunModal() <> "Action"::OK then
                error(C_INC_LoginCanceled);

            UserResponse := EnterSMSCode.GetSMSCode();

            CodeIsValid := UserResponse = SMSCode;
            Counter += 1;
            TryAgain := (not CodeIsValid) and(Counter < 3);
        end;

        if not CodeIsValid then
            error(C_INC_LoginInvalid, Counter);
    end;
}
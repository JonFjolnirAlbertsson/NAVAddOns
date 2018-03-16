page 53102 EnterSMSCode
{
    Caption = 'Enter SMS Code';
    PageType = StandardDialog;
    
    layout
    {
        area(Content)
        {
            field(SMSCode;SMSCode)            
            {
                Caption = 'Enter the code you received by SMS';
            }
        }
    }

    var
        SMSCode : Text;

    procedure GetSMSCode() : Text
    begin
        exit(SMSCode);
    end;
}
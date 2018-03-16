page 53100 SMSSetup
{
    PageType = Card;
    Caption = 'SMS Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    Editable = true;
    SourceTable = "SMS Setup";
    layout
    {
        area(content)
        {
            group(General)
            {
                field(BaseUrl; "Base Url") { }
                field(UserName; "User Name") { }
                field(PasswordTemp; PasswordTemp)
                {
                    Caption = 'Password';
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        SetPassword(PasswordTemp);
                        Commit();
                        CurrPage.Update();
                    end;
                }
                field("Company Name"; "Company Name") { }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    var
        PasswordTemp: Text;

    trigger OnOpenPage()
    begin
        Reset;
        if not get then begin
            Init;
            Insert;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        if("User Name" <> '') and (Password <> '') then
            PasswordTemp := '***************';
    end;

}
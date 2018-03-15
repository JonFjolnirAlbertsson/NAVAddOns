table 53100 "SMS Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(30; "Base Url"; Text[250])
        {
            Caption = 'Base Url';
        }
        field(40; "User Name"; Text[250])
        {
            Caption = 'User Name';
        }
        field(50; "Password Key"; GUID)
        {
            Caption = 'Password';
        }
        field(60; "Company Name"; Text[250])
        {
            Caption = 'Company Name';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

    procedure SetPassword(PasswordTextP: Text)
    var
        ServicePasswordL: Record "Service Password";
    begin
        IF ISNULLGUID("Password Key") OR NOT ServicePasswordL.GET("Password Key") THEN BEGIN
            ServicePasswordL.SavePassword(PasswordTextP);
            ServicePasswordL.INSERT(TRUE);
            "Password Key" := ServicePasswordL.Key;
        END ELSE BEGIN
            ServicePasswordL.SavePassword(PasswordTextP);
            ServicePasswordL.MODIFY(true);
        END;
    end;

    procedure GetPassword(): Text
    var
        ServicePasswordL: Record "Service Password";
    begin
        IF NOT ISNULLGUID("Password Key") THEN
            IF ServicePasswordL.GET("Password Key") THEN
                EXIT(ServicePasswordL.GetPassword());
    end;

    procedure SendSMS(PhoneNumber: Code[30]; Value: Text[450])
    var
        SMSWebServiceL: Codeunit "SMS Web Service";
    begin
        SMSWebServiceL.SendSMS(PhoneNumber, Value);
    end;
}
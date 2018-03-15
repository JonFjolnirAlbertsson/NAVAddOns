codeunit 53101 "SMS Web Service"
{
    trigger OnRun();
    begin
    end;

    procedure SendSMS(PhoneNo: Code[30]; MessageText: Text[450]) ReturnValue: Boolean
    var
        WSManagementL: Codeunit "WS Management";
    begin
        WSManagementL.CallSOAPWebService(PhoneNo, MessageText, TRUE);
    end;
}
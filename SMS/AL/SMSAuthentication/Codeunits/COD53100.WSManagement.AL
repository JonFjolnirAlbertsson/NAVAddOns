codeunit 53100 "WS Management"
{
    trigger OnRun();
    begin
    end;

    var
        C_INC_001Txt: Label 'The message is empty.';
        C_INC_002Txt: Label 'Mottakers mobilnr. er ikke angitt.';
        C_INC_003Txt: Label 'User ID does not exist';
        C_INC_004Txt: Label 'Salesperson %1 %2 does not have a valid email address and valid name';

    procedure CallSOAPWebService(RecipientPhoneNoP: Code[30]; MessageP: Text[450]; ConfirmationP: Boolean) MessageSentR: Boolean
    var
        SMSSetupL: Record "SMS Setup";
        TypeHelperL: Codeunit "Type Helper";
        HttpClientL: HttpClient;
        RequestHeadersL: HttpHeaders;
        ResponseHeadersL: HttpHeaders;
        HttpRequestContentL: HttpContent;
        HttpResponseContentL: HttpContent;
        HttpRequestMessageL: HttpRequestMessage;
        HttpResponseMessageL: HttpResponseMessage;
        LangTmpL: Integer;
        UsernameL: Text;
        PasswordL: Text;
        UrlL: Text;
        RequestXMLL: Text;
    begin
        SMSSetupL.GET();
        SMSSetupL.TESTFIELD("User Name");
        SMSSetupL.TESTFIELD("Password Key");
        // Use Norwegian Language to correct date and currency formats.
        MessageSentR := FALSE;
        LangTmpL := GLOBALLANGUAGE();
        //IF LangTmpL <> PSWinComSetupG."Language Code" THEN
        //  GLOBALLANGUAGE(PSWinComSetupG."Language Code");

        IF MessageP = '' THEN
            ERROR(C_INC_001Txt);
        IF RecipientPhoneNoP = '' THEN
            ERROR(C_INC_002Txt);

        //INC-NO.01 START
        IF COPYSTR(RecipientPhoneNoP, 1, 1) = '0' THEN
            IF COPYSTR(RecipientPhoneNoP, 2, 1) <> '0' THEN // '00' is ok, '0' Remove prefix '0' on swedish phone numbers
                RecipientPhoneNoP := COPYSTR(RecipientPhoneNoP, 2);
        //INC-NO.01 STOP

        MessageP := CONVERTSTR(MessageP, ' ', ' ');
        //MessageP := SanitizeString(MessageP); //6388 16.02.16 SMA
        UsernameL := SMSSetupL."User Name";
        PasswordL := SMSSetupL.GetPassword();
        UrlL := SMSSetupL."Base URL";

        HttpClientL.SetBaseAddress(UrlL);
        RequestXMLL := '<?xml version="1.0" encoding="UTF-8"?><SESSION>';
        RequestXMLL += '<CLIENT>' + UsernameL + '</CLIENT>';
        RequestXMLL += '<PW>' + PasswordL + '</PW>';
        RequestXMLL += '<MSGLST><MSG>';
        RequestXMLL += '<ID>' + FORMAT('1') + '</ID>';
        RequestXMLL += '<TEXT>' + TypeHelperL.HtmlEncode(MessageP) + '</TEXT>';
        RequestXMLL += '<SND>' + 'BOS' + '</SND>'; //Add field to setup
        RequestXMLL += '<RCV>' + RecipientPhoneNoP + '</RCV>'; //PSWinComSetupG."Default Country Code"+ RecipientPhoneNoP
        RequestXMLL += '</MSG></MSGLST></SESSION>';

        HttpRequestContentL.WriteFrom(RequestXMLL);
        HttpRequestContentL.GetHeaders(RequestHeadersL);
        RequestHeadersL.Remove('Content-Type');
        RequestHeadersL.Add('Content-Type', 'application/xml');
        HttpRequestMessageL.Method('POST');
        HttpRequestMessageL.Content(HttpRequestContentL);
        HttpClientL.Send(HttpRequestMessageL, HttpResponseMessageL);
        // Reset language when we're done.
        GLOBALLANGUAGE(LangTmpL);
        ResponseHeadersL := HttpResponseMessageL.Headers();
        HttpResponseContentL := HttpResponseMessageL.Content();

        EXIT(HttpResponseMessageL.IsSuccessStatusCode());
    end;
}
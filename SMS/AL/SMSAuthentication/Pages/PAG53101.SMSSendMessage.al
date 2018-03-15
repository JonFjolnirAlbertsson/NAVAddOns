page 53101 SMSSendMessage
{
    PageType = Card;
    SourceTable = "SMS Setup";
    UsageCategory = Tasks;  
    ApplicationArea = All;
    Editable = true;
    Caption = 'SMS Send Message';
    layout
    {
        area(content)
        {
            field(PhoneNo;PhoneNo)
            {
                Caption = 'Phone No.';
            }
            field(MessageText;MessageText)
            {
                Caption = 'Message';
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                Caption = 'Setup';
                Image = XMLSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page SMSSetup;
            }
            action(Send)
            {
                Caption = 'Send';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SendSMS(PhoneNo,MessageText);
                end;
            }
        }
    }

    var
        PhoneNo: Text;
        MessageText: Text;
    
    trigger OnOpenPage()
    begin
        Reset();
        if not get() then begin
            Init();
            Insert();
        end;
    end;
}
pageextension 53104 AdministratorRoleCenterExt extends "Administrator Role Center"
{

    actions
    {
        addlast(Sections)
        {
            group("SMS Authentication")
            {
                action("SMS Setup")
                {
                    RunObject = page SMSSetup;
                    ApplicationArea = All;
                    RunPageMode = Edit;
                }
                 action("SMS Send Message")
                {
                    RunObject = page SMSSendMessage;
                    ApplicationArea = All;
                    RunPageMode = Edit;
                }
            }
        }
    }
}
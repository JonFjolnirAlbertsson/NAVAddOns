pageextension 53103 UserSetupExt extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(PhoneNo;"Phone No.") {}
            field(UseTwoFactorAuthentication;"Use SMS Authentication") {}
        }
    }
}
tableextension 53101 UserSetupExt extends "User Setup"
{
    fields
    {
        field(53100; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(53101; "Use SMS Authentication"; Boolean)
        {
            Caption = 'Use SMS Authentication';
        }

    }
    
}
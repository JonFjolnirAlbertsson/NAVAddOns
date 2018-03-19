tableextension 53110 UserExt extends User
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
        field(53102; "Use Service Web"; Boolean)
        {
             Caption = 'Use Service Web';
        }
    }
    
}
tableextension 50019 NoseriesRelationshipExt extends "No. Series Relationship"
{
    fields
    {
        field(50000; "Shortcut Dimension 1 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
    }

    var
        myInt: Integer;
}
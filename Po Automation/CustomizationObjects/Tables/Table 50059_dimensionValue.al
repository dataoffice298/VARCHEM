tableextension 50059 DimensionValueExtension extends "Dimension Value"
{
    fields
    {
        field(50006; "Division Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Division Code';
            CaptionClass = '1,2,1';
            // Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
    }

    var
        myInt: Integer;
}
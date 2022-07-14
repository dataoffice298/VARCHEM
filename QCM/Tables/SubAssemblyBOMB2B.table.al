table 33000276 "Sub Assembly BOM B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Sub Assembly BOM';

    fields
    {
        field(1; "Parent Item No."; Code[20])
        {
            Caption = 'Parent Item No.';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Sub Assembly No."; Code[20])
        {
            Caption = 'Sub Assembly No.';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;
        }
        field(4; "Bill of Material"; Boolean)
        {
            Caption = 'Bill of Material';
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(7; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DataClassification = CustomerContent;
        }
        field(8; Position; Code[10])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
        }
        field(9; "Position 2"; Code[10])
        {
            Caption = 'Position 2';
            DataClassification = CustomerContent;
        }
        field(10; "Position 3"; Code[10])
        {
            Caption = 'Position 3';
            DataClassification = CustomerContent;
        }
        field(11; "Machine No."; Code[10])
        {
            Caption = 'Machine No.';
            DataClassification = CustomerContent;
        }
        field(12; "Production Lead Time"; Integer)
        {
            Caption = 'Production Lead Time';
            DataClassification = CustomerContent;
        }
        field(13; "BOM Description"; Text[30])
        {
            Caption = 'BOM Description';
            DataClassification = CustomerContent;
        }
        field(14; "Installed in Line No."; Integer)
        {
            Caption = 'Installed in Line No.';
            DataClassification = CustomerContent;
        }
        field(15; "Installed in SA No."; Code[10])
        {
            Caption = 'Installed in SA No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Parent Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}


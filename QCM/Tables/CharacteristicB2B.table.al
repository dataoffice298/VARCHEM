table 33000251 "Characteristic B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Characteristic';
    LookupPageID = "Characteristics B2B";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Inspection Group Code"; Code[20])
        {
            Caption = 'Inspection Group Code';
            TableRelation = "Inspection Group B2B".Code;
            DataClassification = CustomerContent;
        }
        field(4; Attachment; BLOB)
        {
            Caption = 'Attachment';
            DataClassification = CustomerContent;
        }
        field(5; "File Extension"; Text[50])
        {
            Caption = 'File Extension';
            DataClassification = CustomerContent;
        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(7; Qualitative; Boolean)
        {
            Caption = 'Qualitative';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var

}


table 33000271 "Acceptance Level B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Acceptance Level';
    LookupPageID = "Acceptance Levels B2B";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Quality Reason Code B2B";
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Rating"; Decimal)
        {
            Caption = 'Vendor Rating';
            DataClassification = CustomerContent;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Accepted,Accepted Under Deviation,Rework,Rejected';
            OptionMembers = Accepted,"Accepted Under Deviation",Rework,Rejected;
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
}


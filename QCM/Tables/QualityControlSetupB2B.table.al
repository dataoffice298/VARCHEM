table 33000257 "Quality Control Setup B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Control Setup';

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Specification Nos."; Code[20])
        {
            Caption = 'Specification Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(3; "Inspection Datasheet Nos."; Code[20])
        {
            Caption = 'Inspection Datasheet Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(4; "Posted Inspect. Datasheet Nos."; Code[20])
        {
            Caption = 'Posted Inspect. Datasheet Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(5; "Inspection Receipt Nos."; Code[20])
        {
            Caption = 'Inspection Receipt Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(6; "Sampling Plan Warning"; Boolean)
        {
            Caption = 'Sampling Plan Warning';
            DataClassification = CustomerContent;
        }
        field(7; "Invoice After Inspection Only"; Boolean)
        {
            Caption = 'Invoice After Inspection Only';
            DataClassification = CustomerContent;
        }
        field(8; "Sampling Rounding"; Option)
        {
            Caption = 'Sampling Rounding';
            OptionMembers = Nearest,Up,Down;
            DataClassification = CustomerContent;
        }
        field(9; "Production Batch No."; Code[20])
        {
            Caption = 'Production Batch No.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(10; "Sub Assembly Nos."; Code[20])
        {
            Caption = 'Sub Assembly Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(11; "Rating Per Accepted Qty."; Decimal)
        {
            Caption = 'Rating Per Accepted Qty.';
            DataClassification = CustomerContent;
        }
        field(12; "Rating Per Accepted UD Qty."; Decimal)
        {
            Caption = 'Rating Per Accepted UD Qty.';
            DataClassification = CustomerContent;
        }
        field(13; "Rating Per Rework Qty."; Decimal)
        {
            Caption = 'Rating Per Rework Qty.';
            DataClassification = CustomerContent;
        }
        field(14; "Rating Per Rejected Qty."; Decimal)
        {
            Caption = 'Rating Per Rejected Qty.';
            DataClassification = CustomerContent;
        }
        field(15; "Quality Before Receipt"; Boolean)
        {
            Caption = 'Quality Before Receipt';
            DataClassification = CustomerContent;
        }
        field(16; "Purchase Consignment No."; Code[20])
        {
            Caption = 'Purchase Consignment No.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(17; "Assay Nos."; Code[20])
        {
            Caption = 'Assay Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(25; "Posted IDS. No. is IDS No."; Boolean)
        {
            Caption = 'Posted IDS. No. is IDS No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}


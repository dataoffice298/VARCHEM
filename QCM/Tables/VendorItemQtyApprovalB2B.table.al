table 33000260 "Vendor Item Qty Approval B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Vendor Item Quality Approval';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE("QC Enabled B2B" = CONST(true));
            DataClassification = CustomerContent;
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    ERROR(Text000Err, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));
            end;
        }
        field(4; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Starting Date");
            end;
        }
        field(5; "Certified Agency"; Text[30])
        {
            Caption = 'Certified Agency';
            DataClassification = CustomerContent;
        }
        field(6; Attachment; BLOB)
        {
            Caption = 'Attachment';
            DataClassification = CustomerContent;
        }
        field(7; "File Extension"; Text[260])
        {
            Caption = 'File Extension';
            DataClassification = CustomerContent;
        }
        field(8; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TESTFIELD("Item No.");
    end;

    var
        Text000Err: Label '%1 cannot be after %2.', Comment = '%1 = Starting Date ; %2 = Ending Date ';
}


table 33000274 "Sub Assembly B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Sub Assembly';
    LookupPageID = "Sub Assembly List B2B";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Search Name" := Description;
            end;
        }
        field(3; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(4; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(5; "QC Enabled"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Sub Ass Unit of Measure B2B".Code WHERE("Sub Assembly No." = FIELD("No."));
            DataClassification = CustomerContent;
        }
        field(7; Inventory; Decimal)
        {
            Caption = 'Inventory';
            DataClassification = CustomerContent;
        }
        field(8; "Qty. on Inspection"; Decimal)
        {
            Caption = 'Qty. on Inspection';
            DataClassification = CustomerContent;
        }
        field(9; "Qty. on Rejection"; Decimal)
        {
            Caption = 'Qty. on Rejection';
            DataClassification = CustomerContent;
        }
        field(10; "Qty. on Rework"; Decimal)
        {
            Caption = 'Qty. on Rework';
            DataClassification = CustomerContent;
        }
        field(11; Block; Boolean)
        {
            Caption = 'Block';
            DataClassification = CustomerContent;
        }
        field(12; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        QualitySetup.GET();
        QualitySetup.TESTFIELD("Sub Assembly Nos.");
        if "No." = '' then
            NoSeriesMgt.InitSeries(QualitySetup."Sub Assembly Nos.", xRec."No. Series", 0D, "No.", "No. Series");
    end;

    var
        QualitySetup: Record "Quality Control Setup B2B";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(): Boolean;
    begin
        QualitySetup.GET();
        QualitySetup.TESTFIELD("Sub Assembly Nos.");
        if NoSeriesMgt.SelectSeries(QualitySetup."Sub Assembly Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;
}


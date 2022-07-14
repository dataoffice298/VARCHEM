table 33000266 "Assay Header B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Assay Header';
    LookupPageID = "Assay List B2B";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    QCSetup.GET();
                    NoSeriesMgt.TestManual(QCSetup."Assay Nos.");
                end;
            end;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Sampling Plan Code"; Code[20])
        {
            Caption = 'Sampling Plan Code';
            TableRelation = "Sampling Plan Header B2B";
            DataClassification = CustomerContent;
        }
        field(4; "Inspection Group Code"; Code[20])
        {
            Caption = 'Inspection Group Code';
            TableRelation = "Inspection Group B2B";
            DataClassification = CustomerContent;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Under Development,Certified';
            OptionMembers = New,"Under Development",Certified;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status = Status::Certified then begin
                    TESTFIELD(Description);
                    TESTFIELD("Sampling Plan Code");
                    TESTFIELD("Inspection Group Code");
                end;
            end;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = Exist("Quality Comment Line B2B" WHERE(Type = CONST(Assay),
                                                              "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
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

    trigger OnDelete();
    begin
        AssayLine.SETRANGE("Assay No.", "No.");
        AssayLine.DELETEALL();
    end;

    trigger OnInsert();
    begin
        QCSetup.GET();
        QCSetup.TESTFIELD("Assay Nos.");
        if "No." = '' then
            NoSeriesMgt.InitSeries(QCSetup."Assay Nos.", xRec."No. Series", 0D, "No.", "No. Series");
    end;

    var
        AssayLine: Record "Assay Line B2B";
        QCSetup: Record "Quality Control Setup B2B";
        AssayHeader: Record "Assay Header B2B";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(oldAssayNo: Record "Assay Header B2B"): Boolean;
    begin
        AssayHeader := Rec;
        QCSetup.GET();
        QCSetup.TESTFIELD("Assay Nos.");
        if NoSeriesMgt.SelectSeries(QCSetup."Assay Nos.", oldAssayNo."No. Series", AssayHeader."No. Series") then begin
            QCSetup.GET();
            QCSetup.TESTFIELD("Assay Nos.");
            NoSeriesMgt.SetSeries(AssayHeader."No.");
            Rec := AssayHeader;
            exit(true);
        end;
    end;
}


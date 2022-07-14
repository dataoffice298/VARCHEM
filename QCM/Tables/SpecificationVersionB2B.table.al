table 33000281 "Specification Version B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Specification Version';
    DataCaptionFields = "Specification No.", "Version Code", Description;
    DrillDownPageID = "Specification Version List B2B";
    LookupPageID = "Specification Version List B2B";

    fields
    {
        field(1; "Specification No."; Code[20])
        {
            Caption = 'Specification No.';
            NotBlank = true;
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(2; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Under Development,Certified';
            OptionMembers = New,"Under Development",Certified;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status = Status::Certified then
                    TestStatus();
            end;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(22; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Specification No.", "Version Code")
        {
        }
        key(Key2; "Specification No.", "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var

    begin
        SpecLine.reset();
        SpecLine.SETRANGE("Spec ID", "Specification No.");
        SpecLine.SETRANGE("Version Code", "Version Code");
        SpecLine.DELETEALL(true);
    end;

    trigger OnInsert();
    begin
        SpecHeader.GET("Specification No.");
        if "Version Code" = '' then
            SpecHeader.TESTFIELD("Version Nos.");
        NoSeriesMgt.InitSeries(SpecHeader."Version Nos.", xRec."No. Series", 0D, "Version Code", "No. Series");
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY();
    end;

    var
        SpecHeader: Record "Specification Header B2B";
        SpecVersion: Record "Specification Version B2B";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text000Err: Label 'No Specification Lines exists.';

    procedure AssistEdit(OldSpecVersion: Record "Specification Version B2B"): Boolean;
    begin
        SpecVersion := Rec;
        SpecHeader.GET(SpecVersion."Specification No.");
        SpecHeader.TESTFIELD("Version Nos.");
        if NoSeriesMgt.SelectSeries(SpecHeader."Version Nos.", OldSpecVersion."No. Series", SpecVersion."No. Series") then begin
            NoSeriesMgt.SetSeries(SpecVersion."Version Code");
            Rec := SpecVersion;
            exit(true);
        end;
    end;

    procedure TestStatus();
    var

        SpecIndent: Codeunit "Spec Line Indent B2B";
        InspectGroupCode: Code[20];
        SamplingPlanCode: Code[20];
        EndCheck: Boolean;
        BeginCheck: Boolean;
    begin
        SpecIndent.ChangeStatus();
        SpecIndent.IndentSpecVersion(Rec);
        SpecLine2.reset();
        SpecLine2.SETRANGE("Spec ID", "Specification No.");
        if SpecLine2.FIND('-') then begin
            SpecLine2.TESTFIELD("Character Type", SpecLine2."Character Type"::"Begin");
            repeat
                if BeginCheck then begin
                    BeginCheck := false;
                    SpecLine2.TESTFIELD("Character Type", SpecLine2."Character Type"::Standard);
                end;

                if EndCheck then begin
                    EndCheck := false;
                    SpecLine2.TESTFIELD("Character Type", SpecLine2."Character Type"::"Begin");
                end;

                if SpecLine2."Character Type" = SpecLine2."Character Type"::"Begin" then begin
                    BeginCheck := true;
                    SpecLine2.TESTFIELD("Sampling Code");
                    SpecLine2.TESTFIELD("Inspection Group Code");
                    SamplingPlanCode := SpecLine2."Sampling Code";
                    InspectGroupCode := SpecLine2."Inspection Group Code"
                end else begin
                    if SpecLine2."Character Type" = SpecLine2."Character Type"::"End" then
                        EndCheck := true;
                    SpecLine2."Sampling Code" := SamplingPlanCode;
                    SpecLine2."Inspection Group Code" := InspectGroupCode;
                    SpecLine2.MODIFY();
                end;
            until SpecLine2.NEXT() = 0
        end else
            ERROR(Text000Err);
    end;

    var
        SpecLine: Record "Specification Line B2B";
        SpecLine2: Record "Specification Line B2B";
}


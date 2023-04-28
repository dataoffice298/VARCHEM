table 33000253 "Specification Header B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Specification Header';
    DataCaptionFields = "Spec ID", Description;
    LookupPageID = "Specification List B2B";

    fields
    {
        field(1; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
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
        field(6; Comment; Boolean)
        {
            CalcFormula = Exist("Quality Comment Line B2B" WHERE(Type = CONST(Specification),
                                                              "No." = FIELD("Spec ID")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Under Development,Certified';
            OptionMembers = New,"Under Development",Certified;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status = Status::Certified then begin
                    Rec.TestField("ISO Format Number");//4.05
                    TestStatus();
                end;
            end;
        }
        field(8; "Sampling Plan"; Code[20])
        {
            Caption = 'Sampling Plan';
            TableRelation = "Sampling Plan Header B2B";
            DataClassification = CustomerContent;
        }
        field(50; "Version Nos."; Code[10])
        {
            Caption = 'Version Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

        //4.05 >>
        field(50000; "ISO Format Number"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Shortcut Dimension 1 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(50002; "Shortcut Dimension 2 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        //4.05 <<
    }

    keys
    {
        key(Key1; "Spec ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        InspectDataHeader.SETRANGE("Spec ID", "Spec ID");
        if InspectDataHeader.FIND('-') then
            ERROR(Text015Err, "Spec ID");
        PurchLine.SETRANGE("Spec ID B2B", "Spec ID");
        if PurchLine.FIND('-') then
            ERROR(Text016Err, "Spec ID");
        Item.SETRANGE("Spec ID B2B", "Spec ID");
        Item.MODIFYALL("Spec ID B2B", '');
        SpecLineGRec.SETRANGE("Spec ID", "Spec ID");
        SpecLineGRec.DELETEALL();
    end;

    trigger OnInsert();
    begin
        QualitySetup.GET();
        QualitySetup.TESTFIELD("Specification Nos.");
        if "Spec ID" = '' then
            NoSeriesMgt.InitSeries(QualitySetup."Specification Nos.", xRec."No. Series", 0D, "Spec ID", "No. Series");
    end;

    var
        QualitySetup: Record "Quality Control Setup B2B";
        Spec: Record "Specification Header B2B";
        SpecLineGRec: Record "Specification Line B2B";
        PurchLine: Record "Purchase Line";
        InspectDataHeader: Record "Ins Datasheet Header B2B";
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;

        Text015Err: Label 'You can not delete Specification %1 as Inspection Data Sheet exist.', Comment = '%1 = Spec ID';
        Text016Err: Label 'You can not delete Specification %1 as Purchase Line exist.', Comment = '%1 = Spec ID';
        Text017Err: Label 'No specification lines exist.';

    procedure AssistEdit(OldSpec: Record "Specification Header B2B"): Boolean;
    begin
        Spec := Rec;
        QualitySetup.GET();
        QualitySetup.TESTFIELD("Specification Nos.");
        if NoSeriesMgt.SelectSeries(QualitySetup."Specification Nos.", OldSpec."No. Series", Spec."No. Series") then begin
            QualitySetup.GET();
            QualitySetup.TESTFIELD("Specification Nos.");
            NoSeriesMgt.SetSeries(Spec."Spec ID");
            Rec := Spec;
            exit(true);
        end;
    end;

    procedure TestStatus();
    var

        SamplinPlan: Record "Sampling Plan Header B2B";
        SpecIndent: Codeunit "Spec Line Indent B2B";
        InspectGroupCode: Code[20];
        SamplingPlanCode: Code[20];
        EndCheck: Boolean;
        BeginCheck: Boolean;
    begin
        SpecIndent.ChangeStatus();
        SpecIndent.RUN(Rec);
        SpecLine2.reset();
        SpecLine2.SETRANGE("Spec ID", "Spec ID");
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
                    if SamplinPlan.GET(SamplingPlanCode) then
                        SamplinPlan.TESTFIELD(SamplinPlan.Status, SamplinPlan.Status::Certified);
                end;
            until SpecLine2.NEXT() = 0
        end else
            ERROR(Text017Err);
    end;

    procedure CopyAssay();
    var
        AssayHeader: Record "Assay Header B2B";


        SpecLineNo: Integer;
    begin
        TESTFIELD("Spec ID");
        specline.reset();
        SpecLine.SETRANGE("Spec ID", "Spec ID");
        if SpecLine.FIND('+') then
            SpecLineNo := SpecLine."Line No." + 10000
        else
            SpecLineNo := 10000;
        if PAGE.RUNMODAL(0, AssayHeader) = ACTION::LookupOK then begin
            AssayHeader.TESTFIELD(Status, AssayHeader.Status::Certified);
            AssayLine.reset();
            AssayLine.SETRANGE("Assay No.", AssayHeader."No.");
            if AssayLine.FIND('-') then begin
                SpecLine.INIT();
                SpecLine."Spec ID" := "Spec ID";
                SpecLine."Line No." := SpecLineNo;
                SpecLine."Character Type" := SpecLine."Character Type"::"Begin";
                SpecLine."Sampling Code" := AssayHeader."Sampling Plan Code";
                SpecLine."Inspection Group Code" := AssayHeader."Inspection Group Code";
                SpecLine.Description := AssayHeader.Description;
                SpecLine.INSERT();
                repeat
                    SpecLine.INIT();
                    SpecLineNo := SpecLineNo + 10000;
                    SpecLine."Spec ID" := "Spec ID";
                    SpecLine."Line No." := SpecLineNo;
                    SpecLine."Character Code" := AssayLine."Character Code";
                    SpecLine."Inspection Group Code" := AssayHeader."Inspection Group Code";
                    SpecLine.Description := AssayLine.Description;
                    SpecLine."Sampling Code" := AssayHeader."Sampling Plan Code";
                    SpecLine."Normal Value (Num)" := AssayLine."Normal Value (Num)";
                    SpecLine."Min. Value (Num)" := AssayLine."Min. Value (Num)";
                    SpecLine."Max. Value (Num)" := AssayLine."Max. Value (Num)";
                    SpecLine."Normal Value (Char)" := AssayLine."Normal Value (Char)";
                    SpecLine."Min. Value (Char)" := AssayLine."Min. Value (Char)";
                    SpecLine."Max. Value (Char)" := AssayLine."Max. Value (Char)";
                    SpecLine."Unit of Measure Code" := AssayLine."Unit of Measure Code";
                    SpecLine.Qualitative := AssayLine.Qualitative;
                    SpecLine."Character Type" := SpecLine."Character Type"::Standard;
                    SpecLine.INSERT();
                until AssayLine.NEXT() = 0;

                SpecLine.INIT();
                SpecLine."Spec ID" := "Spec ID";
                SpecLine."Line No." := SpecLineNo + 10000;
                SpecLine."Character Type" := SpecLine."Character Type"::"End";
                SpecLine.Description := AssayHeader.Description;
                SpecLine.INSERT();
            end;
        end;
    end;

    procedure GetSpecVersion(SpecHeaderNo: Code[20]; Date: Date; OnlyCertified: Boolean): Code[20];
    var

    begin
        SpecVersion.reset();
        SpecVersion.SETCURRENTKEY("Specification No.", "Starting Date");
        SpecVersion.SETRANGE("Specification No.", SpecHeaderNo);
        SpecVersion.SETFILTER("Starting Date", '%1|..%2', 0D, Date);
        if OnlyCertified then
            SpecVersion.SETRANGE(Status, SpecVersion.Status::Certified);
        if not SpecVersion.FIND('+') then
            CLEAR(SpecVersion);

        exit(SpecVersion."Version Code");
    end;

    var
        SpecVersion: Record "Specification Version B2B";
        SpecLine2: Record "Specification Line B2B";

        SpecLine: Record "Specification Line B2B";
        AssayLine: Record "Assay Line B2B";
}


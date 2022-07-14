table 33000254 "Specification Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Specification Line';

    fields
    {
        field(1; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B"."Spec ID";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Character Code"; Code[20])
        {
            Caption = 'Character Code';
            TableRelation = "Characteristic B2B".Code;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Character Type" = "Character Type"::Standard then
                    if Characterstic.GET("Character Code") then begin
                        "Inspection Group Code" := Characterstic."Inspection Group Code";
                        Description := Characterstic.Description;
                        "Unit of Measure Code" := Characterstic."Unit of Measure Code";
                        Qualitative := Characterstic.Qualitative;
                    end;
            end;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(5; "Sampling Code"; Code[20])
        {
            Caption = 'Sampling Code';
            TableRelation = "Sampling Plan Header B2B".Code;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Sampling Code" <> '' then
                    TESTFIELD("Character Type", "Character Type"::"Begin");
            end;
        }
        field(6; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("Character Type", "Character Type"::Standard);
                TESTFIELD(Qualitative, false);
                TESTFIELD("Character Type", "Character Type"::Standard);
                if ("Max. Value (Num)" = 0) and ("Normal Value (Num)" < "Min. Value (Num)") then
                    ERROR(Text002Err, FIELDCAPTION("Normal Value (Num)"), FIELDCAPTION("Min. Value (Num)"));

                if "Max. Value (Num)" <> 0 then
                    if ("Normal Value (Num)" < "Min. Value (Num)") or ("Normal Value (Num)" > "Max. Value (Num)") then
                        ERROR(Text003Err, FIELDCAPTION("Normal Value (Num)"), FIELDCAPTION("Min. Value (Num)"), FIELDCAPTION("Max. Value (Num)"));
            end;
        }
        field(7; "Min. Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Min. Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Max. Value (Num)");
                VALIDATE("Normal Value (Num)");
            end;
        }
        field(8; "Max. Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Max. Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("Max. Value (Num)" < "Min. Value (Num)") and ("Max. Value (Num)" <> 0) then
                    ERROR(Text004Err, FIELDCAPTION("Min. Value (Num)"), FIELDCAPTION("Max. Value (Num)"), "Line No.");
                VALIDATE("Normal Value (Num)");
            end;
        }
        field(9; "Normal Value (Char)"; Code[20])
        {
            Caption = 'Normal Value (Char)';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Normal Value (Char)" <> '' then begin
                    TESTFIELD("Character Type", "Character Type"::Standard);
                    TESTFIELD(Qualitative, true);
                end;
            end;
        }
        field(10; "Min. Value (Char)"; Code[20])
        {
            Caption = 'Min. Value (Char)';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Normal Value (Char)");
            end;
        }
        field(11; "Max. Value (Char)"; Code[20])
        {
            Caption = 'Max. Value (Char)';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Normal Value (Char)");
            end;
        }
        field(12; "Inspection Group Code"; Code[20])
        {
            Caption = 'Inspection Group Code';
            TableRelation = "Inspection Group B2B";
            DataClassification = CustomerContent;


            trigger OnValidate();
            begin
                if "Inspection Group Code" <> '' then
                    VALIDATE("Sampling Code");
            end;
        }
        field(13; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Unit of Measure Code" <> '' then
                    TESTFIELD("Character Type", "Character Type"::Standard);
            end;
        }
        field(14; Qualitative; Boolean)
        {
            Caption = 'Qualitative';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Qualitative = true then
                    TESTFIELD("Character Type", "Character Type"::Standard);
            end;
        }
        field(15; "Character Type"; Option)
        {
            Caption = 'Character Type';
            OptionCaption = 'Standard,Heading,Begin,End';
            OptionMembers = Standard,Heading,"Begin","End";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Character Type" in ["Character Type"::"Begin", "Character Type"::"End"] then begin
                    "Normal Value (Num)" := 0;
                    "Min. Value (Num)" := 0;
                    "Max. Value (Num)" := 0;
                    "Normal Value (Char)" := '';
                    "Min. Value (Char)" := '';
                    "Max. Value (Char)" := '';
                    "Unit of Measure Code" := '';
                    Qualitative := false;
                end;
            end;
        }
        field(16; Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
        }
        field(20; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Spec ID", "Version Code", "Line No.")
        {
        }
        key(Key2; "Inspection Group Code")
        {
        }
        key(Key3; "Spec ID", "Character Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatus();
    end;

    trigger OnInsert();
    begin
        if "Character Type" = "Character Type"::Standard then
            TESTFIELD("Character Code");
        TestStatus();
    end;

    trigger OnModify();
    begin
        if "Character Type" = "Character Type"::Standard then
            TESTFIELD("Character Code");
        TestStatus();
    end;

    var
        Characterstic: Record "Characteristic B2B";
        SpecHeader: Record "Specification Header B2B";
        Text002Err: Label '%1 should not be less than %2.', Comment = '%1 = Normal Value; %2 =Min. Value ';
        Text003Err: Label '%1 should be within %2 and %3.', Comment = '%1 = Normal Value ; %2 = Min. Value ; %3 = Max. Value ';
        Text004Err: Label '%1 should not be greater than %2 specification line %3.', Comment = '%1 = Min. Value ; %2 = Max. Value ; %3 = Line No ';

    procedure TestStatus();
    var
        SpecVersion: Record "Specification Version B2B";
    begin
        if "Version Code" = '' then begin
            SpecHeader.GET("Spec ID");
            if SpecHeader.Status = SpecVersion.Status::Certified then
                SpecHeader.FIELDERROR(Status);
        end else begin
            SpecVersion.GET("Spec ID", "Version Code");
            if SpecVersion.Status = SpecVersion.Status::Certified then
                SpecVersion.FIELDERROR(Status);
        end;
    end;
}


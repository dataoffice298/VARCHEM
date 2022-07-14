table 33000267 "Assay Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Assay Line';

    fields
    {
        field(1; "Assay No."; Code[20])
        {
            Caption = 'Assay No.';
            TableRelation = "Assay Header B2B";
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
                if Characterstic.GET("Character Code") then begin
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
        field(6; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Normal Value (Num)" <> 0 then
                    TESTFIELD(Qualitative, false);
                if ("Max. Value (Num)" = 0) and ("Normal Value (Num)" < "Min. Value (Num)") then
                    ERROR(Text000Err, FIELDCAPTION("Normal Value (Num)"), FIELDCAPTION("Min. Value (Num)"));

                if "Max. Value (Num)" <> 0 then
                    if ("Normal Value (Num)" < "Min. Value (Num)") or ("Normal Value (Num)" > "Max. Value (Num)") then
                        ERROR(Text001Err, FIELDCAPTION("Normal Value (Num)"), FIELDCAPTION("Min. Value (Num)"), FIELDCAPTION("Max. Value (Num)"));
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
                    ERROR(Text003Err, FIELDCAPTION("Min. Value (Num)"), FIELDCAPTION("Max. Value (Num)"), "Line No.");
                VALIDATE("Normal Value (Num)");
            end;
        }
        field(9; "Normal Value (Char)"; Code[20])
        {
            Caption = 'Normal Value (Char)';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Normal Value (Char)" <> '' then
                    TESTFIELD(Qualitative, true);
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
        field(13; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14; Qualitative; Boolean)
        {
            Caption = 'Qualitative';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Assay No.", "Line No.")
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
        TESTFIELD("Character Code");
        TestStatus();
    end;

    trigger OnModify();
    begin
        TESTFIELD("Character Code");
        TestStatus();
    end;

    var
        Characterstic: Record "Characteristic B2B";
        AssayHeader: Record "Assay Header B2B";
        Text000Err: Label '%1 should not be less than %2.', Comment = '%1 = Normal Value ; %2 = Min. Value';
        Text001Err: Label '%1 should be within %2 and %3.', Comment = '%1 = Normal Value; %2 = Min. Value ;%3 = Max. Value';
        Text003Err: Label '%1 should not be greater than %2 Specification Line %3.', Comment = '%1 = Min. Value ; %2 = Max. Value ; %3 = Line No';

    procedure TestStatus();
    begin
        AssayHeader.GET("Assay No.");
        if AssayHeader.Status = AssayHeader.Status::Certified then
            AssayHeader.FIELDERROR(Status);
    end;
}


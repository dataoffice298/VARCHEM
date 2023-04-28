table 33000256 "Inspection Datasheet Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Inspection Datasheet Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            NotBlank = true;
            TableRelation = "Ins Datasheet Header B2B"."No.";
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
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Sampling Plan Code"; Code[20])
        {
            Caption = 'Sampling Plan Code';
            TableRelation = "Sampling Plan Header B2B".Code;
            DataClassification = CustomerContent;
        }
        field(6; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(7; "Min. Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Min. Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(8; "Max. Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Max. Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(9; "Actual Value (Num)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Actual Value (Num)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Actual Value (Num)" <> 0 then begin
                    TESTFIELD("Character Type", "Character Type"::Standard);
                    TESTFIELD(Qualitative, false);
                end;

                if ("Normal Value (Text)" = '') and ("Min. Value (Text)" = '') and ("Max. Value (Text)" = '') then
                    if ("Actual Value (Num)" <= "Max. Value (Num)") and ("Actual Value (Num)" >= "Min. Value (Num)") then begin
                        if ("Normal Value (Num)" <> 0.0) and ("Max. Value (Num)" <> 0.0) then
                            Accept := true
                        else
                            Accept := false;
                    end else
                        Accept := false;

                if "Actual Value (Num)" = 0 then
                    Accept := false;

                //4.06 >>
                if not Accept then
                    "Style Expression" := 'Attention'
                else
                    "Style Expression" := '';
                //4.06 <<
            end;
        }
        field(10; "Normal Value (Text)"; Code[20])
        {
            Caption = 'Normal Value (Text)';
            DataClassification = CustomerContent;
        }
        field(11; "Min. Value (Text)"; Code[20])
        {
            Caption = 'Min. Value (Text)';
            DataClassification = CustomerContent;
        }
        field(12; "Max. Value (Text)"; Code[20])
        {
            Caption = 'Max. Value (Text)';
            DataClassification = CustomerContent;
        }
        field(13; "Actual  Value (Text)"; Code[20])
        {
            Caption = 'Actual  Value (Text)';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Actual  Value (Text)" <> '' then begin
                    TESTFIELD("Character Type", "Character Type"::Standard);
                    TESTFIELD(Qualitative, true);
                end;


                if ("Actual  Value (Text)" = "Min. Value (Text)") or ("Actual  Value (Text)" = "Max. Value (Text)") then
                    Accept := true
                else
                    Accept := false;


            end;
        }
        field(14; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(15; "Character Group No."; Integer)
        {
            Caption = 'Character Group No.';
            DataClassification = CustomerContent;
        }
        field(16; Accept; Boolean)
        {
            Caption = 'Accept';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Accept then
                    TESTFIELD("Character Type", "Character Type"::Standard);
            end;
        }
        field(17; "Lot Size - Min"; Decimal)
        {
            BlankZero = true;
            Caption = 'Lot Size - Min';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(18; "Lot Size - Max"; Decimal)
        {
            BlankZero = true;
            Caption = 'Lot Size - Max';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(19; "Sampling Size"; Decimal)
        {
            BlankZero = true;
            Caption = 'Sampling Size';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(20; "Allowable Defects - Min"; Decimal)
        {
            BlankZero = true;
            Caption = 'Allowable Defects - Min';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(21; "Allowable Defects - Max"; Decimal)
        {
            BlankZero = true;
            Caption = 'Allowable Defects - Max';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(29; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Quality Reason Code B2B";
            DataClassification = CustomerContent;
        }
        field(30; Remarks; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(31; "Inspection Persons"; Text[100])
        {
            Caption = 'Inspection Persons';
            DataClassification = CustomerContent;
        }
        field(35; "Character Type"; Option)
        {
            Caption = 'Character Type';
            OptionCaption = 'Standard,Heading,Begin,End';
            OptionMembers = Standard,Heading,"Begin","End";
            DataClassification = CustomerContent;
        }
        field(36; Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
        }
        field(37; Qualitative; Boolean)
        {
            Caption = 'Qualitative';
            DataClassification = CustomerContent;
        }
        //4.06 >>
        field(50000; "Style Expression"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        //4.06 <<
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Character Code", "Character Group No.")
        {
        }
        key(Key3; "Document No.", "Character Code", "Character Group No.", Accept)
        {
            SumIndexFields = "Min. Value (Num)";
        }
        key(Key4; "Character Group No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        TestStatusOpen();
        InspectDatasheetHeader.MODIFY(true);
    end;

    var
        InspectDatasheetHeader: Record "Ins Datasheet Header B2B";

    procedure TestStatusOpen();
    begin
        InspectDatasheetHeader.SETRANGE("No.", "Document No.");
        InspectDatasheetHeader.FIND('-');
        if InspectDatasheetHeader.Status = InspectDatasheetHeader.Status::Released then
            InspectDatasheetHeader.TESTFIELD(Status, InspectDatasheetHeader.Status::Open);
    end;
}


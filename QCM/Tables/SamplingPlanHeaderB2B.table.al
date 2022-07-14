table 33000252 "Sampling Plan Header B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Sampling Plan Header';
    LookupPageID = "Sampling Plan List B2B";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Standard Reference"; Code[20])
        {
            Caption = 'Standard Reference';
            DataClassification = CustomerContent;
        }
        field(4; "AQL Percentage"; Code[20])
        {
            Caption = 'AQL Percentage';
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
                if Status = Status::Certified then
                    case "Sampling Type" of
                        "Sampling Type"::"Fixed Quantity":
                            TESTFIELD("Fixed Quantity");
                        "Sampling Type"::"Percentage Lot":
                            TESTFIELD("Lot Percentage");
                        "Sampling Type"::"Variable Quantity":
                            begin
                                SamplingPlanLine.SETRANGE("Sampling Code", Code);
                                if not SamplingPlanLine.FIND('-') then
                                    ERROR(Text001Err);
                                SamplingPlanLine.reset();
                                SamplingPlanLine.SETRANGE("Sampling Code", Code);
                                PreviousSampLineSampleSize := 0;
                                if SamplingPlanLine.FIND('-') then
                                    repeat
                                        if PreviousSampLineSampleSize > SamplingPlanLine."Sampling Size" then
                                            ERROR(Text000Err, SamplingPlanLine."Line No.");
                                        PreviousSampLineSampleSize := SamplingPlanLine."Sampling Size";

                                    until SamplingPlanLine.NEXT() = 0;
                            end;



                    end;

            end;
        }
        field(6; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
        field(7; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
        }
        field(8; "Sampling Type"; Option)
        {
            Caption = 'Sampling Type';
            OptionCaption = 'Variable Quantity,Fixed Quantity,Percentage Lot,Complete Lot';
            OptionMembers = "Variable Quantity","Fixed Quantity","Percentage Lot","Complete Lot";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status = Status::Certified then
                    FIELDERROR(Status);
            end;
        }
        field(9; "Fixed Quantity"; Integer)
        {
            Caption = 'Fixed Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Sampling Type");
                TESTFIELD("Sampling Type", "Sampling Type"::"Fixed Quantity");
            end;
        }
        field(10; "Lot Percentage"; Decimal)
        {
            Caption = 'Lot Percentage';
            MaxValue = 100;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Sampling Type");
                TESTFIELD("Sampling Type", "Sampling Type"::"Percentage Lot");
            end;
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

    trigger OnDelete();
    begin
        SamplingPlanLine.SETRANGE("Sampling Code", Code);
        SamplingPlanLine.DELETEALL();
    end;

    trigger OnInsert();
    begin
        "Created Date" := TODAY();
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := TODAY();
    end;

    var
        SamplingPlanLine: Record "Sampling Plan Line B2B";
        PreviousSampLineSampleSize: Integer;
        Text000Err: Label 'Sample line %1 sample size is less than the previous sample line.', Comment = '%1 = Line No';
        Text001Err: Label 'No sampling plan lines exists.';
}


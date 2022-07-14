table 33000280 "Quality Comment Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Comment Line';
    DrillDownPageID = "Quality Comment List B2B";
    LookupPageID = "Quality Comment List B2B";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inspection Data Sheets,Posted Inspection Data Sheets,Inspection Receipt,Specification,Assay';
            OptionMembers = "Inspection Data Sheets","Posted Inspection Data Sheets","Inspection Receipt",Specification,Assay;
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            TableRelation = IF (Type = CONST("Inspection Data Sheets")) "Ins Datasheet Header B2B"."No."
            ELSE
            IF (Type = CONST("Posted Inspection Data Sheets")) "Posted Ins DatasheetHeader B2B"."No."
            ELSE
            IF (Type = CONST("Inspection Receipt")) "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
        QualityCommentLine: Record "Quality Comment Line B2B";
    begin
        QualityCommentLine.SETRANGE(Type, Type);
        QualityCommentLine.SETRANGE("No.", "No.");
        if QualityCommentLine.IsEmpty() then
            Date := WORKDATE();
    end;
}


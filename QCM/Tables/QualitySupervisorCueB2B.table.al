table 33000287 "Quality Supervisor Cue B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Supervisor Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Inspection Receipt"; Integer)
        {
            CalcFormula = Count("Inspection Receipt Header B2B" WHERE(Status = FILTER(false)));
            Caption = 'Inspection Receipt';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Posted Inspection Datasheet"; Integer)
        {
            CalcFormula = Count("Posted Ins DatasheetHeader B2B");
            Caption = 'Posted Inspection Datasheet';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Posted Inspection Receipt"; Integer)
        {
            CalcFormula = Count("Inspection Receipt Header B2B" WHERE(Status = FILTER(true)));
            Caption = 'Posted Inspection Receipt';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Purchase Order - Open"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Order)));
            Caption = 'Purchase Order - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}


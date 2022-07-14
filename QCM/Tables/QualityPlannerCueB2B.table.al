table 33000285 "Quality Planner Cue B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Planner Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Certified Specifications"; Integer)
        {
            CalcFormula = Count("Specification Header B2B" WHERE(Status = FILTER(Certified)));
            Caption = 'Certified Specifications';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Certified Sampling Plan"; Integer)
        {
            CalcFormula = Count("Sampling Plan Header B2B" WHERE(Status = FILTER(Certified)));
            Caption = 'Certified Sampling Plan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Sub Assembly"; Integer)
        {
            CalcFormula = Count("Sub Assembly B2B" WHERE(Block = FILTER(false)));
            Caption = 'Sub Assembly';
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


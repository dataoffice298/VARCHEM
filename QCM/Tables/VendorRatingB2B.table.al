table 33000265 "Vendor Rating B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Vendor Rating';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(5; Inspected; Decimal)
        {
            CalcFormula = Sum("Inspection Receipt Header B2B".Quantity WHERE("Vendor No." = FIELD("Vendor No."),
                                                                          "Item No." = FIELD("Item No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Rework Level" = CONST(0),
                                                                          Status = FILTER(true)));
            Caption = 'Inspected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; Accepted; Decimal)
        {
            CalcFormula = Sum("Inspection Receipt Header B2B"."Qty. Accepted" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                 "Item No." = FIELD("Item No."),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Rework Level" = CONST(0),
                                                                                 Status = FILTER(true)));
            Caption = 'Accepted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Accepted UD"; Decimal)
        {
            CalcFormula = Sum("Inspection Receipt Header B2B"."Qty. Accepted Under Deviation" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                 "Item No." = FIELD("Item No."),
                                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                                 "Rework Level" = CONST(0),
                                                                                                 Status = FILTER(true)));
            Caption = 'Accepted UD';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; Rework; Decimal)
        {
            CalcFormula = Sum("Inspection Receipt Header B2B"."Qty. Rework" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                               "Item No." = FIELD("Item No."),
                                                                               "Posting Date" = FIELD("Date Filter"),
                                                                               "Rework Level" = CONST(0),
                                                                               Status = FILTER(true)));
            Caption = 'Rework';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Reject; Decimal)
        {
            CalcFormula = Sum("Inspection Receipt Header B2B"."Qty. Rejected" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                 "Item No." = FIELD("Item No."),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Rework Level" = CONST(0),
                                                                                 Status = FILTER(true)));
            Caption = 'Reject';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }
}


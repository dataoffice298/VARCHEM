tableextension 33000252 "ItemExt B2B" extends Item
{
    // version NAVW111.00.00.27667,B2BQC1.00.00

    fields
    {
        field(33000250; "Spec ID B2B"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01

                VALIDATE("QC Enabled B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000251; "QC Enabled B2B"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01

                if "QC Enabled B2B" then
                    TESTFIELD("Spec ID B2B");
                if Inventory < 0 then
                    ERROR(Text33000250Err);

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000252; "Lots Accept B2B"; Boolean)
        {
            Caption = 'Lots Accept';
            DataClassification = CustomerContent;
        }
        field(33000253; "Quantity Under Inspection B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Item Ledger Entry B2B"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                                      "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                      "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                      "Location Code" = FIELD("Location Filter"),
                                                                                      "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                                      "Variant Code" = FIELD("Variant Filter"),
                                                                                      "Lot No." = FIELD("Lot No. Filter"),
                                                                                      "Serial No." = FIELD("Serial No. Filter"),
                                                                                      "Inspection Status" = CONST("Under Inspection"),
                                                                                      "Sent for Rework" = CONST(false),
                                                                                      Accept = CONST(true)));
            Caption = 'Quantity Under Inspection';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000254; "Quantity Rejected B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Item Ledger Entry B2B"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                                      "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                      "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                      "Location Code" = FIELD("Location Filter"),
                                                                                      "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                                      "Variant Code" = FIELD("Variant Filter"),
                                                                                      "Lot No." = FIELD("Lot No. Filter"),
                                                                                      "Serial No." = FIELD("Serial No. Filter"),
                                                                                      "Inspection Status" = CONST(Rejected)));
            Caption = 'Quantity Rejected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000255; "WIP Spec ID B2B"; Code[20])
        {
            Caption = 'WIP Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01

                VALIDATE("WIP QC Enabled B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000256; "WIP QC Enabled B2B"; Boolean)
        {
            Caption = 'WIP QC Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01

                if "WIP QC Enabled B2B" then
                    TESTFIELD("WIP Spec ID B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000257; "Quantity Accepted B2B"; Decimal)
        {
            Caption = 'Quantity Accepted';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(33000258; "Quantity Rework B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Item Ledger Entry B2B"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                                      "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                      "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                      "Location Code" = FIELD("Location Filter"),
                                                                                      "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                                      "Variant Code" = FIELD("Variant Filter"),
                                                                                      "Lot No." = FIELD("Lot No. Filter"),
                                                                                      "Serial No." = FIELD("Serial No. Filter"),
                                                                                      "Inspection Status" = CONST("Under Inspection"),
                                                                                      Rework = CONST(true),
                                                                                      "Sent for Rework" = CONST(false)));
            Caption = 'Quantity Rework';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000259; "Quantity Sent for Rework B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Item Ledger Entry B2B"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                                      "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                      "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                      "Location Code" = FIELD("Location Filter"),
                                                                                      "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                                      "Variant Code" = FIELD("Variant Filter"),
                                                                                      "Lot No." = FIELD("Lot No. Filter"),
                                                                                      "Serial No." = FIELD("Serial No. Filter"),
                                                                                      "Inspection Status" = CONST("Under Inspection"),
                                                                                      "Sent for Rework" = CONST(true)));
            Caption = 'Quantity Sent for Rework';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000260; "Rejection Location B2B"; Code[20])
        {
            Caption = 'Rejection Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text33000250Err: Label 'QC enabled is not possible when inventory is negative.';
}


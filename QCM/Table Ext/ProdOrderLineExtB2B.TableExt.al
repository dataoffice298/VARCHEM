tableextension 33000254 "ProdOrderLineExt B2B" extends "Prod. Order Line"
{
    // version NAVW111.00.00.27667,B2BQC1.00.00

    fields
    {

        modify("Item No.")//PKON22M26
        {
            trigger OnAfterValidate()
            var
                Item: record Item;
            begin
                if Item.get("Item No.") then begin
                    "WIP QC Enabled B2B" := Item."WIP QC Enabled B2B";
                    "WIP Spec ID B2B" := Item."WIP Spec ID B2B";
                    IF "WIP Spec ID B2B" <> '' THEN
                        "Spec Version Code B2B" := GetSpecVersion;

                end;
            end;
        }
        modify(Quantity)//PKON22M26
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                If "WIP Spec ID B2B" <> '' then
                    "Qty Sending to Quality B2B" := Quantity

            end;
        }
        field(33000250; "WIP QC Enabled B2B"; Boolean)
        {
            Caption = 'WIP QC Enabled';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33000251; "WIP Spec ID B2B"; Code[20])
        {
            Caption = 'WIP Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(33000252; "Quantity Sent to Quality B2B"; Decimal)
        {
            Caption = 'Quantity Sent to Quality';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(33000253; "Qty Sending to Quality B2B"; Decimal)
        {
            Caption = 'Quantity Sending to Quality';
            MinValue = 0;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(33000254; "Quantity Accepted B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B".Quantity WHERE("Source Type" = FILTER(WIP),
                                                                     "Order No." = FIELD("Prod. Order No."),
                                                                     "Order Line No." = FIELD("Line No."),
                                                                     "Entry Type" = FILTER(Accepted),
                                                                     "Operation No." = FILTER('')));
            Caption = 'Quantity Accepted';
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(33000255; "Quantity Rejected B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B".Quantity WHERE("Source Type" = FILTER(WIP),
                                                                     "Order No." = FIELD("Prod. Order No."),
                                                                     "Order Line No." = FIELD("Line No."),
                                                                     "Entry Type" = FILTER(Reject),
                                                                     "Operation No." = FILTER('')));
            Caption = 'Quantity Rejected';
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(33000256; "Quantity Rework B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B".Quantity WHERE("Source Type" = FILTER(WIP),
                                                                     "Order No." = FIELD("Prod. Order No."),
                                                                     "Order Line No." = FIELD("Line No."),
                                                                     "Entry Type" = FILTER(Rework),
                                                                     "Operation No." = FILTER('')));
            Caption = 'Quantity Rework';
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(33000257; "Spec Version Code B2B"; Code[20])
        {
            Caption = 'Spec Version Code';
            TableRelation = "Specification Version B2B"."Version Code" WHERE("Specification No." = FIELD("WIP Spec ID B2B"));
            DataClassification = CustomerContent;
        }
    }

    PROCEDURE CreateInspectionDataSheets();
    BEGIN
        // Start  B2BQC1.00.00 - 01
        //Create Inspection Datasheets

        InspectDataSheets.CreateProdLineInspectDataSheet(Rec);
        // Stop   B2BQC1.00.00 - 01
    END;

    procedure GetSpecVersion(): Code[20]//PKONNO15
    var
        SpecHeader: record "Specification Header B2B";
    begin
        EXIT(SpecHeader.GetSpecVersion("WIP Spec ID B2B", WORKDATE, TRUE));
    end;

    var
        InspectDataSheets: Codeunit "Inspection Data Sheets B2B";
}


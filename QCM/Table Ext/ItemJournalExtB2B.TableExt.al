tableextension 33000251 "ItemJournalExt B2B" extends "Item Journal Line"
{
    // version NAVW111.00.00.26401,B2BQC1.00.00

    fields
    {
        field(33000251; "Quality Ledger Entry No. B2B"; Integer)
        {
            Caption = 'Quality Ledger Entry No.';
            TableRelation = "Quality Ledger Entry B2B";
            DataClassification = CustomerContent;
        }
        field(33000252; "After Inspection B2B"; Boolean)
        {
            Caption = 'After Inspection';
            DataClassification = CustomerContent;
        }
        field(33000253; "Inspection Receipt No. B2B"; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            TableRelation = "Inspection Receipt Header B2B";
            DataClassification = CustomerContent;
        }
        field(50000; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
    }


    procedure CreateInspectionDataSheets();
    var
        ProdOrderRoutingLine: Record 5409;
        InspectionDataSheets: Codeunit 33000251;
    begin
        // Start  B2BQC1.00.00 - 01
        //Create Inspection Datasheets

        IF ProdOrderRoutingLine.GET(ProdOrderRoutingLine.Status::Released, "Order No.", "Routing Reference No.", "Routing No.",
          "Operation No.") THEN BEGIN

            ProdOrderRoutingLine."Qty. to Produce B2B" := "Output Quantity";
            IF ProdOrderRoutingLine."Qty. to Produce B2B" <> 0 THEN
                InspectionDataSheets.CreateInprocInspectDataSheet(ProdOrderRoutingLine);

        END;

        // Stop   B2BQC1.00.00 - 01
    end;

}


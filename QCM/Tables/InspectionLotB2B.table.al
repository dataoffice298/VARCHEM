table 33000259 "Inspection Lot B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Inspection Lot';
    LookupPageID = "Inspection Lots B2B";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purch. Rcpt. Header";
            DataClassification = CustomerContent;
        }
        field(2; "Purch. Line No."; Integer)
        {
            Caption = 'Purch. Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(5; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(6; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Quantity <> 0 then begin
                    TESTFIELD(Quantity);
                    TESTFIELD("Inspect. Data Sheet Created", false);
                end;
            end;
        }
        field(8; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(9; "Inspect. Data Sheet Created"; Boolean)
        {
            Caption = 'Inspect. Data sheet Created';
            DataClassification = CustomerContent;
        }
        field(12; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(50000; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Purch. Line No.", "Lot No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key2; "Document No.", "Item No.")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TESTFIELD(Quantity);
        PostPurchLine.SETRANGE("Document No.", "Document No.");
        PostPurchLine.SETRANGE("Line No.", "Purch. Line No.");
        PostPurchLine.FIND('-');
        "Item No." := PostPurchLine."No.";
        "Item Description" := PostPurchLine.Description;
        "Spec ID" := PostPurchLine."Spec ID B2B";
    end;

    var
        PostPurchLine: Record "Purch. Rcpt. Line";

    procedure CopyItemTrackingLots();
    var

        ItemLedgEntry: Record "Item Ledger Entry";
        InspectLot: Record "Inspection Lot B2B";

        LineNo: Integer;
    begin
        ItemEntryRelation.reset();
        ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
        ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Purch. Rcpt. Line");
        ItemEntryRelation.SETRANGE("Source Subtype", 0);
        ItemEntryRelation.SETRANGE("Source ID", "Document No.");
        ItemEntryRelation.SETRANGE("Source Batch Name", '');
        ItemEntryRelation.SETRANGE("Source Prod. Order Line", 0);
        ItemEntryRelation.SETRANGE("Source Ref. No.", "Purch. Line No.");
        TempItemLedgEntry.DELETEALL();
        LineNo := 10000;
        if ItemEntryRelation.FIND('-') then
            repeat
                ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                AddTempRecordSet(TempItemLedgEntry);
            until ItemEntryRelation.NEXT() = 0;

        if TempItemLedgEntry.FIND('-') then begin
            InspectLot.SETRANGE("Document No.", "Document No.");
            InspectLot.SETRANGE("Purch. Line No.", "Purch. Line No.");
            if InspectLot.FIND('+') then
                LineNo := InspectLot."Line No.";
            InspectLot.INIT();
            repeat
                InspectLot."Document No." := "Document No.";
                InspectLot."Purch. Line No." := "Purch. Line No.";
                InspectLot."Lot No." := TempItemLedgEntry."Lot No.";
                InspectLot."Vendor Lot No_B2B" := TempItemLedgEntry."Vendor Lot No_B2B";
                InspectLot."Line No." := LineNo;
                InspectLot.Quantity := TempItemLedgEntry.Quantity;
                InspectLot.INSERT(true);
                LineNo := LineNo + 10000;
            until TempItemLedgEntry.NEXT() = 0;
        end;
    end;

    procedure AddTempRecordSet(var TempItemLedgEntry: Record "Item Ledger Entry");
    var
        TempItemLedgEntry2: Record "Item Ledger Entry";
    begin
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.RESET();
        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry2."Lot No.");
        if TempItemLedgEntry.FIND('-') then begin
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry.MODIFY();
        end else
            TempItemLedgEntry.INSERT();
        TempItemLedgEntry.RESET();
    end;

    var
        ItemEntryRelation: Record "Item Entry Relation";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
}


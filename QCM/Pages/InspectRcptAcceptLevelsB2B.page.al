page 33000283 "Inspect.Rcpt.Accept Levels B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    AutoSplitKey = true;
    Caption = 'Inspect. Rcpt. Accept Levels';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "IR Acceptance Levels B2B";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(ReceiptQtyCap; ReceiptQty)
            {
                Caption = 'Receipt Quantity';
                Editable = false;
                ApplicationArea = all;
                tooltip = 'how much quantity receipt';
            }
            field(AssignedQtyCap; AssignedQty)

            {
                Caption = 'Assigned Quantity';
                ToolTip = 'This field defines how much Quantity are Assigned ';
                Editable = false;
                ApplicationArea = all;
            }
            repeater(Control1000000000)
            {
                field("Acceptance Code"; Rec."Acceptance Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Quality can be expressed through Acceptance Codes';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                    tooltip = 'which define the levels of acceptance, rejections/reworks at the time of Inspection Receipts';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                    tooltip = 'setting the setup of rhe number series';
                    trigger OnLookup(var Text: Text): Boolean
                    var

                    begin
                        QualityItemLedgEntry.RESET();
                        InspectionReceipt.RESET();
                        InspectionReceipt.SETRANGE("No.", Rec."Inspection Receipt No.");
                        IF InspectionReceipt.FIND('-') THEN BEGIN
                            ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
                            ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Purch. Rcpt. Line");
                            ItemEntryRelation.SETRANGE("Source Subtype", 0);
                            ItemEntryRelation.SETRANGE("Source ID", InspectionReceipt."Receipt No.");
                            ItemEntryRelation.SETRANGE("Source Batch Name", '');
                            ItemEntryRelation.SETRANGE("Source Prod. Order Line", 0);
                            ItemEntryRelation.SETRANGE("Source Ref. No.", InspectionReceipt."Purch Line No");
                            ItemEntryRelation.SETRANGE("Lot No.", InspectionReceipt."Lot No.");
                            IF ItemEntryRelation.FIND('-') THEN BEGIN
                                IF InspectionReceipt."Rework Level" = 0 THEN
                                    REPEAT
                                        IF QualityItemLedgEntry.GET(ItemEntryRelation."Item Entry No.") THEN
                                            IF QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection" THEN
                                                CASE Rec."Quality Type" OF
                                                    Rec."Quality Type"::Accepted:
                                                        IF QualityItemLedgEntry.Accept THEN
                                                            QualityItemLedgEntry.MARK(TRUE);
                                                    Rec."Quality Type"::Rework:
                                                        IF QualityItemLedgEntry.Rework THEN
                                                            QualityItemLedgEntry.MARK(TRUE);
                                                    Rec."Quality Type"::Rejected:
                                                        IF QualityItemLedgEntry.Reject THEN
                                                            QualityItemLedgEntry.MARK(TRUE);
                                                END;

                                    UNTIL ItemEntryRelation.NEXT() = 0;
                                IF QualityItemLedgEntry.MARKEDONLY(TRUE) THEN
                                    IF PAGE.RUNMODAL(PAGE::"Qty Item Ledger Entries B2B", QualityItemLedgEntry) = ACTION::LookupOK THEN BEGIN

                                        Rec."Serial No." := QualityItemLedgEntry."Serial No.";
                                        Rec."ILE No." := QualityItemLedgEntry."Entry No.";
                                        Rec.Quantity := 1;
                                        CASE Rec."Quality Type" OF
                                            Rec."Quality Type"::Accepted:
                                                QualityItemLedgEntry."Temp Accept" := TRUE;
                                            Rec."Quality Type"::"Accepted Under Deviation":
                                                QualityItemLedgEntry."Accept Under Deviation" := TRUE;
                                            Rec."Quality Type"::Rejected:
                                                QualityItemLedgEntry.Reject := TRUE;
                                            Rec."Quality Type"::Rework:
                                                QualityItemLedgEntry.Rework := TRUE;
                                        end;
                                        QualityItemLedgEntry.MODIFY();
                                    END;

                            END;
                        END;

                        QualityItemLedgEntry.RESET();
                        InspectionReceipt.RESET();
                        InspectionReceipt.SETRANGE("No.", Rec."Inspection Receipt No.");
                        IF InspectionReceipt.FIND('-') THEN BEGIN
                            ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
                            ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Return Receipt Line");
                            ItemEntryRelation.SETRANGE("Source Subtype", 0);
                            ItemEntryRelation.SETRANGE("Source ID", InspectionReceipt."Receipt No.");
                            ItemEntryRelation.SETRANGE("Source Batch Name", '');
                            ItemEntryRelation.SETRANGE("Source Prod. Order Line", 0);
                            ItemEntryRelation.SETRANGE("Source Ref. No.", InspectionReceipt."Purch Line No");
                            ItemEntryRelation.SETRANGE("Lot No.", InspectionReceipt."Lot No.");
                            IF ItemEntryRelation.FIND('-') THEN
                                IF InspectionReceipt."Rework Level" = 0 THEN
                                    REPEAT
                                        IF QualityItemLedgEntry.GET(ItemEntryRelation."Item Entry No.") THEN
                                            IF QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection" THEN
                                                IF (QualityItemLedgEntry."Temp Accept" = FALSE) AND (QualityItemLedgEntry.Rework = FALSE) AND
                                                   (QualityItemLedgEntry.Reject = FALSE) AND (QualityItemLedgEntry."Accept Under Deviation" = FALSE)
                                                THEN
                                                    QualityItemLedgEntry.MARK(TRUE);
                                    UNTIL ItemEntryRelation.NEXT() = 0;
                            //Commit();//B2BESGOn13Jun2022
                            IF QualityItemLedgEntry.MARKEDONLY(TRUE) THEN
                                IF PAGE.RUNMODAL(PAGE::"Qty Item Ledger Entries B2B", QualityItemLedgEntry) = ACTION::LookupOK THEN BEGIN
                                    Rec."Serial No." := QualityItemLedgEntry."Serial No.";
                                    Rec."ILE No." := QualityItemLedgEntry."Entry No.";
                                    Rec.Quantity := 1;
                                    CASE Rec."Quality Type" OF
                                        Rec."Quality Type"::Accepted:
                                            QualityItemLedgEntry."Temp Accept" := TRUE;
                                        Rec."Quality Type"::"Accepted Under Deviation":
                                            QualityItemLedgEntry."Accept Under Deviation" := TRUE;
                                        Rec."Quality Type"::Rejected:
                                            QualityItemLedgEntry.Reject := TRUE;
                                        Rec."Quality Type"::Rework:
                                            QualityItemLedgEntry.Rework := TRUE;
                                    end;
                                    QualityItemLedgEntry.MODIFY();
                                END;
                        END;
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                    trigger OnValidate();
                    begin
                        UpdateQtyBalance();
                        QuantityOnAfterValidate();
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        UpdateQtyBalance();
    end;

    trigger OnOpenPage();
    begin
        Rec.SETRANGE("Inspection Receipt No.", "InspectionReceiptNo.");
        Rec.SETRANGE("Quality Type", IRQuantityType);

        UpdateQtyBalance();
    end;

    var
        ReceiptQty: Decimal;
        AssignedQty: Decimal;
        "InspectionReceiptNo.": Code[20];
        IRQuantity: Decimal;
        IRQuantityType: Option Accepted,"Accepted Under Deviation",Rework,Rejected;

    procedure UpdateQtyBalance();
    var

    begin
        ReceiptQty := IRQuantity;
        InpectRcptAcptLevels.reset();
        InpectRcptAcptLevels.SETRANGE("Inspection Receipt No.", "InspectionReceiptNo.");
        AssignedQty := 0;
        if InpectRcptAcptLevels.FIND('-') then
            repeat
                AssignedQty := AssignedQty + InpectRcptAcptLevels.Quantity;
            until InpectRcptAcptLevels.NEXT() = 0;
    end;

    local procedure QuantityOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;

    procedure GetIRNumber("IRNo.": Code[20]; Qty: Decimal; QtyType: Option Accepted,"Accepted Under Deviation",Rework,Rejected);
    begin
        "InspectionReceiptNo." := "IRNo.";
        IRQuantity := Qty;
        IRQuantityType := QtyType;
    end;

    var
        InpectRcptAcptLevels: Record "IR Acceptance Levels B2B";
        QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B";
        ItemEntryRelation: record "Item Entry Relation";
        InspectionReceipt: Record "Inspection Receipt Header B2B";
}


Codeunit 33000261 "ItemJnlPostLineExt B2B"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', False, False)]
    local procedure AfterInitItemLedgEntr(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."QLE No. B2B" := ItemJournalLine."Quality Ledger Entry No. B2B";
        // Start  B2BQC1.00.00 - 01

        IF ItemJournalLine."After Inspection B2B" AND
        (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) THEN
            UpdateReworkComponents(ItemJournalLine.Quantity, ItemJournalLine);

        // Stop   B2BQC1.00.00 - 01   
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeApplyItemLedgEntry', '', False, False)]
    local procedure BeforeApplyItemLedgEntry(VAR ItemLedgEntry: Record "Item Ledger Entry"; VAR OldItemLedgEntry: Record "Item Ledger Entry"; VAR ValueEntry: Record "Value Entry"; CausedByTransfer: Boolean; VAR Handled: Boolean)
    var

    begin
        // Start  B2BQC1.00.00 - 01
        IF OldItemLedgEntry.GET(ItemLedgEntry."Applies-to Entry") THEN
            IF QualityItemLedgEntry.GET(OldItemLedgEntry."Entry No.") THEN
                IF ItemLedgEntry."QLE No. B2B" = 0 THEN
                    IF (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Purchase) AND (NOT ItemLedgEntry.Positive) THEN BEGIN
                        IF QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection" THEN
                            QualityItemLedgEntry.FIELDERROR(QualityItemLedgEntry."Inspection Status")
                        ELSE BEGIN
                            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" + ItemLedgEntry.Quantity;
                            IF QualityItemLedgEntry."Remaining Quantity" = 0 THEN
                                QualityItemLedgEntry.DELETE()
                            ELSE
                                QualityItemLedgEntry.MODIFY();
                        END;
                    END ELSE
                        IF (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::"Negative Adjmt.") AND (NOT ItemLedgEntry.Positive) THEN BEGIN
                            IF QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::Rejected THEN BEGIN
                                QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" + ItemLedgEntry.Quantity;
                                IF QualityItemLedgEntry."Remaining Quantity" = 0 THEN
                                    QualityItemLedgEntry.DELETE()
                                ELSE
                                    QualityItemLedgEntry.MODIFY();
                            END ELSE
                                QualityItemLedgEntry.FIELDERROR(QualityItemLedgEntry."Inspection Status");
                        END ELSE
                            QualityItemLedgEntry.FIELDERROR(QualityItemLedgEntry."Inspection Status");
        //END;


        // Stop   B2BQC1.00.00 - 01
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterApplyItemLedgEntrySetFilters', '', False, False)]

    procedure ExcludeQualityItems(VAR ItemLedgerEntry2: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        Item: Record 27;
        AcceptedQty: Decimal;
        Text33000251Err: Label 'Outbound Quantity is more than Quantity Accepted.';
        Text33000250Err: Label 'Negative inventory is not allowed if the item is QC Enabled.';
    BEGIN
        // Start  B2BQC1.00.00 - 01
        //Exclude all Quality Items
        //Message('At line no. 69 ----- %1...%2', ItemLedgerEntry2."Entry No.", ItemLedgerEntry2."Remaining Quantity");//PKON22FE25//B2BESGOn22May2022 Commented
        IF ItemLedgerEntry2.FIND('-') THEN
            REPEAT
                IF NOT QualityItemLedgEntry.GET(ItemLedgerEntry2."Entry No.") THEN BEGIN
                    //Message('At line no. 73 ----- IN');//PKON22FE25//B2BESGOn22May2022 Commented
                    ItemLedgerEntry2.MARK(TRUE);
                    AcceptedQty := AcceptedQty + ItemLedgerEntry2."Remaining Quantity";
                END;
            UNTIL ItemLedgerEntry2.NEXT() = 0;
        ItemLedgerEntry2.MARKEDONLY(TRUE);
        IF (NOT ItemLedgerEntry.Positive) AND (Item."QC Enabled B2B") THEN
            IF NOT ItemLedgerEntry2.FIND('-') THEN
                ERROR(Text33000251Err)
            ELSE
                IF AcceptedQty < Abs(ItemLedgerEntry.Quantity) THEN
                    ERROR(Text33000250Err);

        // Stop   B2BQC1.00.00 - 01
    END;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforePostItemJnlLine', '', False, False)]
    local procedure BeforePostItemJnlLine(VAR ItemJournalLine: Record "Item Journal Line")
    begin
        // Start  B2BQC1.00.00 - 01

        IF NOT ItemJournalLine."After Inspection B2B" THEN
            ItemJournalLine.CreateInspectionDataSheets();

        // Stop   B2BQC1.00.00 - 01

    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnPostOutputOnAfterUpdateAmounts', '', False, False)]
    local procedure PostOutputOnAfterUpdateAmounts(VAR ItemJournalLine: Record "Item Journal Line")
    begin
        // Start  B2BQC1.00.00 - 01

        InspectJnlLine.CheckPostProdOrderOutput(ItemJournalLine);

        // Stop   B2BQC1.00.00 - 01

    end;

    PROCEDURE UpdateReworkComponents(QtyBase: Decimal; ItemJnlLine: Record 83);
    VAR

    BEGIN
        // Start  B2BQC1.00.00 - 01
        //Update Rework Components

        IF ProdOrderInspectComponents.GET(ProdOrderInspectComponents.Status::Released, ItemJnlLine."Order No.",
           ItemJnlLine."Order Line No.", ItemJnlLine."Inspection Receipt No. B2B", ItemJnlLine."Prod. Order Comp. Line No.")
        THEN BEGIN
            ProdOrderInspectComponents."Quantity Consumed" := ProdOrderInspectComponents."Quantity Consumed" + QtyBase;
            ProdOrderInspectComponents."Remaining Quantity" := ProdOrderInspectComponents."Expected Quantity" -
            ProdOrderInspectComponents."Quantity Consumed";
            ProdOrderInspectComponents.MODIFY();
        END;

        // Stop   B2BQC1.00.00 - 01
    END;

    var
        QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B";
        ProdOrderInspectComponents: Record 33000279;
        InspectJnlLine: Codeunit "Inspection Jnl. Post Line B2B";


}
codeunit 33000253 "Inspection Jnl. Post Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    Permissions = TableData "Purch. Rcpt. Line" = rimd;
    TableNo = "Inspection Receipt Header B2B";

    trigger OnRun()
    begin


        InspectReceiptCheckLine.RunCheck(Rec);
        QualityLedgerEntry.RESET();
        QualityLedgerEntry.LOCKTABLE();
        if QualityLedgerEntry.FIND('+') then
            QualityLedgerEntryNo := QualityLedgerEntry."Entry No."
        else
            QualityLedgerEntryNo := 0;
        InitQualityLedger(Rec);
        if (Rec."Item Tracking Exists") and (Rec."Source Type" = Rec."Source Type"::"In Bound") and
           (not Rec."Quality Before Receipt")
        then begin
            if Item.GET(Rec."Item No.") then;
            IF ItemTrackingCode.GET(Item."Item Tracking Code") THEN;

            IF (ItemTrackingCode."SN Specific Tracking") OR (ItemTrackingCode."SN Sales Inbound Tracking") OR
                (ItemTrackingCode."SN Sales Outbound Tracking") THEN
                InsertSerialTrackingQLE(Rec)
            ELSE
                IF ((ItemTrackingCode."Lot Specific Tracking") OR (ItemTrackingCode."Lot Sales Inbound Tracking") OR
                        (ItemTrackingCode."Lot Sales Outbound Tracking")) THEN
                    InsertQCItemTrackingLedger(DATABASE::"Purch. Rcpt. Line", 0, Rec."Receipt No.", '', 0, Rec."Purch Line No", Rec);

        end else
            InsertQualityLedgerEntry(Rec);
        if Rec."Source Type" = Rec."Source Type"::"In Bound" then begin
            if not Rec."Quality Before Receipt" then
                UpdatePurchRcptLine(Rec)
            else
                UpdateWhseReceipts(Rec);
            InsertItemVendorRating(Rec);
        end;
        UpdateInspectAcptLevels(Rec);
        Evaluate(Rec."Posted By", USERID());
        Rec."Posted Date" := TODAY();
        Rec."Posted Time" := TIME();
        Rec.Status := true;
        Rec.MODIFY();
    end;

    var

        QualityLedgerEntry: Record "Quality Ledger Entry B2B";
        //  QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B";
        ItemApplnEntry: Record "Item Application Entry";
        DeliveryChalan: Record "Delivery/Receipt Entry B2B";
        ItemJnlLine: Record "Item Journal Line";
        ItemTrackingCode: Record "Item Tracking Code";
        Item: Record Item;
        InspectDataSheets: Codeunit "Inspection Data Sheets B2B";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        InspectReceiptCheckLine: Codeunit "Inspection Jnl. Check Line B2B";
        QualityLedgerEntryNo: Integer;

        Text001Err: Label 'Output Quantity should be less than the Quality Accepted.';
        RemainQty: Decimal;
        QtyToApply: Decimal;
        Text002Qst: Label 'Do you want to send the material back to Vendor/Works?';

        Text003Qst: Label 'Do you want to receive the reworked material back?';
        Text004Msg: Label 'Material is transferred to Vendor successfully.';
        Text005Msg: Label 'Material is received back from Vendor successfully.';
        Text330001Txt: Label 'RECLASS';
        Text330002Txt: Label 'DEFAULT';


    procedure InsertQualityLedgerEntry(InspectReceipt: Record "Inspection Receipt Header B2B");
    begin
        if InspectReceipt."Qty. Accepted" <> 0 then begin
            if InspectReceipt."Rework Level" = 0 then
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No."
            else
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."DC Inbound Ledger Entry.";
            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
            QualityLedgerEntry.Quantity := InspectReceipt."Qty. Accepted";
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Accepted";
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            if (InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound") and
               (not InspectReceipt."Quality Before Receipt")
            then
                UpdateItemLedgerEntry(QualityLedgerEntry, false);
        end;
        if InspectReceipt."Qty. Rejected" <> 0 then begin
            if InspectReceipt."Rework Level" = 0 then
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No."
            else
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."DC Inbound Ledger Entry.";
            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
            QualityLedgerEntry.Quantity := InspectReceipt."Qty. Rejected";
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Rejected";
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            if (InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound") and
               (not InspectReceipt."Quality Before Receipt")
            then
                UpdateItemLedgerEntry(QualityLedgerEntry, false);
        end;
        if InspectReceipt."Qty. Accepted Under Deviation" <> 0 then begin
            if InspectReceipt."Rework Level" = 0 then
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No."
            else
                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."DC Inbound Ledger Entry.";
            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
            QualityLedgerEntry.Quantity := InspectReceipt."Qty. Accepted Under Deviation";
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Accepted Under Deviation";
            QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt."Qty. Accepted UD Reason";
            QualityLedgerEntry."Reason Description" := InspectReceipt."Reason Description";
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            if (InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound") and
               (not InspectReceipt."Quality Before Receipt")
            then
                UpdateItemLedgerEntry(QualityLedgerEntry, false);
        end;
        QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No.";
        QualityLedgerEntry."Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No.";

        UpdateParentInspectionReceipt(InspectReceipt);
        if InspectReceipt."Qty. Rework" <> 0 then begin
            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
            QualityLedgerEntry.Open := true;
            QualityLedgerEntry.Quantity := InspectReceipt."Qty. Rework";
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Rework";
            QualityLedgerEntry."Accepted Under Dev. Reason" := '';
            QualityLedgerEntry."Reason Description" := '';
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
        end;
    end;




    procedure InitQualityLedger(var InspectReceipt: Record "Inspection Receipt Header B2B");
    begin
        OnBeforeInitQualityLedger(QualityLedgerEntry, InspectReceipt);
        QualityLedgerEntry.INIT();
        OnAfterInitQualityLedger(QualityLedgerEntry, InspectReceipt);
        QualityLedgerEntry."Item No." := InspectReceipt."Item No.";
        QualityLedgerEntry."Sub Assembly Code" := InspectReceipt."Sub Assembly Code";
        QualityLedgerEntry."Posting Date" := InspectReceipt."Posting Date";
        QualityLedgerEntry."Source No." := InspectReceipt."Receipt No.";
        QualityLedgerEntry."Source Type" := InspectReceipt."Source Type";
        QualityLedgerEntry."Unit of Measure Code" := InspectReceipt."Unit of Measure Code";
        if InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound" then begin
            QualityLedgerEntry."Order No." := InspectReceipt."Order No.";
            QualityLedgerEntry."Order Line No." := InspectReceipt."Purch Line No"
        end else begin
            QualityLedgerEntry."Order No." := InspectReceipt."Prod. Order No.";
            QualityLedgerEntry."Order Line No." := InspectReceipt."Prod. Order Line";
        end;
        QualityLedgerEntry."Document No." := InspectReceipt."No.";
        QualityLedgerEntry."Location Code" := InspectReceipt."Location Code";
        QualityLedgerEntry."New Location Code" := InspectReceipt."New Location Code";
        QualityLedgerEntry."Lot No." := InspectReceipt."Lot No.";
        QualityLedgerEntry."Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No.";
        QualityLedgerEntry."Vendor No." := InspectReceipt."Vendor No.";
        QualityLedgerEntry."Rework Level" := InspectReceipt."Rework Level";
        QualityLedgerEntry."Rework Reference No." := InspectReceipt."Rework Reference No.";
        QualityLedgerEntry."Unit of Measure Code" := InspectReceipt."Unit of Measure Code";
        QualityLedgerEntry."Qty. per Unit of Measure" := InspectReceipt."Qty. per Unit of Measure";
    end;


    procedure UpdateItemLedgerEntry(QualityLedgEntry2: Record "Quality Ledger Entry B2B"; ItemTrackingExists: Boolean);
    var
        // ItemApplicEntry: Record "Item Application Entry";
        InsRcpt: Record "Inspection Receipt Header B2B";
    begin
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
        if ItemJnlLine.FIND('-') then
            ItemJnlLine.DELETEALL();
        ItemJnlLine.RESET();
        ItemJnlLine.INIT();
        ItemJnlLine."Journal Template Name" := Text330001Txt;
        ItemJnlLine."Journal Batch Name" := Text330002Txt;
        ItemJnlLine."Posting Date" := WORKDATE();
        ItemJnlLine."Document Date" := WORKDATE();
        ItemJnlLine."Document No." := QualityLedgEntry2."Document No.";
        ItemJnlLine."Line No." := ItemReclassLineNo();
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine.VALIDATE("Item No.", QualityLedgEntry2."Item No.");
        if QualityLedgEntry2."Unit of Measure Code" <> '' then
            ItemJnlLine.VALIDATE("Unit of Measure Code", QualityLedgEntry2."Unit of Measure Code");
        if QualityLedgEntry2."Rework Level" = 0 then begin
            IF (QualityLedgEntry2."Entry Type" = QualityLedgEntry2."Entry Type"::Reject) AND ItemTrackingExists THEN
                ItemJnlLine.VALIDATE(Quantity, QualityLedgEntry2.Quantity)
            ELSE
                ItemJnlLine.VALIDATE(Quantity, QualityLedgEntry2."Remaining Quantity");

            if QualityLedgEntry2."Location Code" <> '' then
                ItemJnlLine.VALIDATE("Location Code", QualityLedgEntry2."Location Code");
            if QualityLedgEntry2."Entry Type" = QualityLedgEntry2."Entry Type"::Accepted then
                ItemJnlLine.VALIDATE("New Location Code", QualityLedgEntry2."Location Code")
            else
                if QualityLedgEntry2."New Location Code" <> '' then
                    ItemJnlLine.VALIDATE("New Location Code", QualityLedgEntry2."New Location Code");
            IF NOT ItemTrackingExists THEN
                ItemJnlLine.VALIDATE("Applies-to Entry", QualityLedgerEntry."In bound Item Ledger Entry No.");
            ItemJnlLine."Quality Ledger Entry No. B2B" := QualityLedgEntry2."Entry No.";
            if InsRcpt.GET(QualityLedgEntry2."Document No.") then;
            ItemJnlLine."Dimension Set ID" := InsRcpt."Dimension Set ID";
            ItemJnlLine."New Dimension Set ID" := InsRcpt."Dimension Set ID";
            OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            ItemJnlLine.INSERT();
            OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            IF ItemTrackingExists THEN
                UpdateResEntry(ItemJnlLine, QualityLedgEntry2);

            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            if (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Accepted) or
               (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Reject)
            then begin
                ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityLedgEntry2."In bound Item Ledger Entry No.");
                if ItemApplnEntry.FIND('+') then
                    QualityLedgerEntry."Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
            end;
            UpdateQualityItemLedgEntry(); //testing commented

        end else begin
            QualityItemLedgEntry.SETRANGE("Entry No.", QualityLedgEntry2."In bound Item Ledger Entry No.");
            RemainQty := QualityLedgEntry2.Quantity;
            if QualityItemLedgEntry.FIND('-') then
                repeat
                    if RemainQty < QualityItemLedgEntry."Remaining Quantity" then
                        QtyToApply := RemainQty
                    else
                        QtyToApply := QualityItemLedgEntry."Remaining Quantity";
                    RemainQty := RemainQty - QtyToApply;
                    if QtyToApply <> 0 then begin
                        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
                        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
                        if ItemJnlLine.FIND('-') then
                            ItemJnlLine.DELETEALL();
                        ItemJnlLine.RESET();
                        ItemJnlLine.INIT();
                        ItemJnlLine."Journal Template Name" := Text330001Txt;
                        ItemJnlLine."Journal Batch Name" := Text330002Txt;
                        ItemJnlLine."Posting Date" := WORKDATE();
                        ItemJnlLine."Document Date" := WORKDATE();
                        ItemJnlLine."Document No." := QualityLedgEntry2."Document No.";
                        ItemJnlLine."Line No." := ItemReclassLineNo();
                        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                        ItemJnlLine.VALIDATE("Item No.", QualityLedgEntry2."Item No.");
                        ItemJnlLine."Applies-to Entry" := QualityItemLedgEntry."Entry No.";
                        ItemJnlLine.VALIDATE(Quantity, QtyToApply);
                        ItemJnlLine.VALIDATE("Location Code", QualityLedgEntry2."Location Code");
                        if QualityLedgEntry2."Entry Type" = QualityLedgEntry2."Entry Type"::Reject then
                            ItemJnlLine.VALIDATE("New Location Code", QualityLedgEntry2."New Location Code")
                        else
                            ItemJnlLine.VALIDATE("New Location Code", QualityLedgEntry2."Location Code");
                        ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                        ItemJnlLine."Quality Ledger Entry No. B2B" := QualityLedgEntry2."Entry No.";
                        QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        if InsRcpt.GET(QualityLedgEntry2."Document No.") then;
                        ItemJnlLine."Dimension Set ID" := InsRcpt."Dimension Set ID";
                        ItemJnlLine."New Dimension Set ID" := InsRcpt."Dimension Set ID";
                        OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        ItemJnlLine.INSERT();
                        OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
                        if (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Accepted) or
                           (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Reject)
                        then begin
                            ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityLedgerEntry."In bound Item Ledger Entry No.");
                            if ItemApplnentry.FIND('+') then
                                QualityLedgerEntry."Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
                        end;
                        UpdateQualityItemLedgEntry();
                    end;
                until QualityItemLedgEntry.NEXT() = 0;
        end;
        QualityLedgerEntry.Open := false;
        QualityLedgerEntry."Remaining Quantity" := 0;
        QualityLedgerEntry.MODIFY();
    end;




    procedure UpdateParentInspectionReceipt(InspectReceipt: Record "Inspection Receipt Header B2B");
    var


        ProdOrderInspectComp: Record "Rework Component B2B";
        ProdOrderInspectRtng: Record "Rework Routing Line B2B";
    begin
        if ParentInspectionReceipt.GET(InspectReceipt."Rework Reference No.") then begin
            ParentInspectionReceipt."Rework Completed" := true;
            ParentInspectionReceipt.MODIFY();
            if InspectReceipt."In Process" then begin
                ProdOrderInspectComp.SETRANGE(Status, ProdOrderInspectComp.Status::Released);
                ProdOrderInspectComp.SETRANGE("Prod. Order No.", InspectReceipt."Prod. Order No.");
                ProdOrderInspectComp.SETRANGE("Prod. Order Line No.", InspectReceipt."Prod. Order Line");
                ProdOrderInspectComp.SETRANGE("Inspection Receipt No.", InspectReceipt."Rework Reference No.");
                ProdOrderInspectComp.MODIFYALL("Rework Completed", true);
                ProdOrderInspectRtng.SETRANGE("Routing Status", ProdOrderInspectRtng."Routing Status"::"In Progress");
                ProdOrderInspectRtng.SETRANGE("Prod. Order No.", InspectReceipt."Prod. Order No.");
                ProdOrderInspectRtng.SETRANGE("Routing Reference No.", InspectReceipt."Routing Reference No.");
                ProdOrderInspectRtng.SETRANGE("Routing No.", InspectReceipt."Routing No.");
                ProdOrderInspectRtng.SETRANGE("Inspection Receipt No.", InspectReceipt."Rework Reference No.");
                ProdOrderInspectRtng.MODIFYALL("Routing Status", ProdOrderInspectRtng."Routing Status"::Finished);
            end;
        end;

        if not InspectReceipt."Item Tracking Exists" then begin
            QualityLedgEntryParentIR.SETRANGE("Document No.", InspectReceipt."Rework Reference No.");
            QualityLedgEntryParentIR.SETRANGE("Entry Type", QualityLedgEntryParentIR."Entry Type"::Rework);
            QualityLedgEntryParentIR.SETRANGE(Open, true);
            if QualityLedgEntryParentIR.FIND('-') then begin
                QualityLedgEntryParentIR."Remaining Quantity" := QualityLedgEntryParentIR."Remaining Quantity" - InspectReceipt.Quantity;
                if QualityLedgEntryParentIR."Remaining Quantity" = 0 then
                    QualityLedgEntryParentIR.Open := false;
                if QualityItemLedgEntry.GET(InspectReceipt."DC Inbound Ledger Entry.") then begin
                    QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                    QualityItemLedgEntry.Rework := true;
                    QualityItemLedgEntry.Accept := false;
                    QualityItemLedgEntry.MODIFY();
                end;
                QualityLedgEntryparentIR.MODIFY();
            end;
        end;
    end;

    procedure UpdateParentQualityLedgEntry(RoutingReferenceNo: Code[20]);
    var

    begin
        QualityLedgEntryUpdateParent.SETRANGE("Item Ledger Entry No.", QualityLedgerEntry."Item Ledger Entry No.");
        QualityLedgEntryUpdateParent.SETRANGE("Document No.", RoutingReferenceNo);
        if QualityLedgEntryUpdateParent.FIND('-') then begin
            QualityLedgEntryUpdateParent."Remaining Quantity" := 0;
            QualityLedgEntryUpdateParent.Open := false;
            QualityLedgEntryUpdateParent.MODIFY();
        end;
    end;

    procedure UpdateInspectRoutingComponents();
    begin
    end;

    procedure UpdateQualityItemLedgEntry();
    var
        // QualityItemLedgEntry : Record "Quality Item Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        case QualityLedgerEntry."Entry Type" of
            QualityLedgerEntry."Entry Type"::Reject:
                begin
                    ItemLedgEntry.GET(QualityLedgerEntry."Item Ledger Entry No.");
                    QualityItemLedgEntry.TRANSFERFIELDS(ItemLedgEntry);
                    QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
                    QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                    QualityItemLedgEntry.Reject := true;
                    QualityItemLedgEntry.Accept := false;
                    QualityItemLedgEntry.INSERT();
                end;
            QualityLedgerEntry."Entry Type"::Rework, QualityLedgerEntry."Entry Type"::Reworked:
                exit;
        end;
        QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
        QualityItemLedgEntry.GET(QualityLedgerEntry."In bound Item Ledger Entry No.");
        if QualityLedgerEntry."Rework Reference No." = '' then begin
            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QualityLedgerEntry.Quantity;
            QualityItemLedgEntry.Accept := false;
            QualityItemLedgEntry.Rework := true;
        end else begin
            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QtyToApply;
            QualityItemLedgEntry.Accept := false;
            QualityItemLedgEntry.Rework := true;
        end;
        if QualityItemLedgEntry."Remaining Quantity" = 0 then
            QualityItemLedgEntry.DELETE()
        else
            QualityItemLedgEntry.MODIFY();
    end;

    procedure UpdateWhseReceipts(InspectReceipt2: Record "Inspection Receipt Header B2B");
    var

    begin
        WhseReceiptLine.RESET();
        WhseReceiptLine.SETRANGE("Source Type", 39);
        WhseReceiptLine.SETRANGE("Source Subtype", 1);
        WhseReceiptLine.SETRANGE("Source Document", WhseReceiptLine."Source Document"::"Purchase Order");
        WhseReceiptLine.SETRANGE("Source No.", InspectReceipt2."Order No.");
        WhseReceiptLine.SETRANGE("Source Line No.", InspectReceipt2."Purch Line No");
        if WhseReceiptLine.FIND('-') then begin
            WhseReceiptLine."Quantity Accepted B2B" := WhseReceiptLine."Quantity Accepted B2B" +
            InspectReceipt2."Qty. Accepted" + InspectReceipt2."Qty. Accepted Under Deviation";
            if InspectReceipt2."Rework Level" = 0 then
                WhseReceiptLine."Quantity Rework B2B" := WhseReceiptLine."Quantity Rework B2B" + InspectReceipt2."Qty. Rework"
            else
                WhseReceiptLine."Quantity Rework B2B" := WhseReceiptLine."Quantity Rework B2B" - InspectReceipt2.Quantity +
                                                     InspectReceipt2."Qty. Rework";
            WhseReceiptLine."Quantity Rejected B2B" := WhseReceiptLine."Quantity Rejected B2B" + InspectReceipt2."Qty. Rejected";
            WhseReceiptLine.MODIFY();
        end;
    end;

    procedure UpdatePurchRcptLine(InspectReceipt2: Record "Inspection Receipt Header B2B");
    var

    begin
        PurchRcptLine.RESET();
        PurchRcptLine.SETRANGE("Document No.", InspectReceipt2."Receipt No.");
        PurchRcptLine.SETRANGE("Line No.", InspectReceipt2."Purch Line No");
        PurchRcptLine.FIND('-');
        PurchRcptLine."Quantity Accepted B2B" += InspectReceipt2."Qty. Accepted" + InspectReceipt2."Qty. Accepted Under Deviation";
        PurchRcptLine."Quantity Rework B2B" := InspectReceipt2."Qty. Rework";
        PurchRcptLine."Quantity Rejected B2B" += InspectReceipt2."Qty. Rejected";
        PurchRcptLine.MODIFY();
        UpdatePostedWhseReceipts(InspectReceipt2);
    end;

    procedure UpdatePostedWhseReceipts(InspectReceipt2: Record "Inspection Receipt Header B2B");
    var

    begin
        PostWReceiptLine.RESET();
        PostWReceiptLine.SETRANGE("Source Document", PostWReceiptLine."Source Document"::"Purchase Order");
        PostWReceiptLine.SETRANGE("Posted Source No.", InspectReceipt2."Receipt No.");
        PostWReceiptLine.SETRANGE("Source Line No.", InspectReceipt2."Purch Line No");
        if PostWReceiptLine.FIND('-') then begin
            PostWReceiptLine."Quantity Accepted B2B" += InspectReceipt2."Qty. Accepted" + InspectReceipt2."Qty. Accepted Under Deviation";
            PostWReceiptLine."Quantity Rework B2B" := InspectReceipt2."Qty. Rework";
            PostWReceiptLine."Quantity Rejected B2B" += InspectReceipt2."Qty. Rejected";
            PostWReceiptLine.MODIFY();
            UpdateWhsePutaway(PostWReceiptLine);
        end;
    end;

    procedure UpdateWhsePutaway(PostWReceiptLine2: Record "Posted Whse. Receipt Line");
    var

        TempWhseActivityLine1: Record "Warehouse Activity Line" temporary;
        TempWhseActivityLine2: Record "Warehouse Activity Line" temporary;
    begin
        WhseActivityLIne.RESET();
        WhseActivityLIne.SETRANGE("Whse. Document Type", WhseActivityLIne."Whse. Document Type"::Receipt);
        WhseActivityLIne.SETRANGE(WhseActivityLIne."Whse. Document No.", PostWReceiptLine2."No.");
        WhseActivityLIne.SETRANGE("Whse. Document Line No.", PostWReceiptLine2."Line No.");
        if WhseActivityLIne.FIND('-') then
            if WhseActivityLIne.COUNT() = 1 then begin
                WhseActivityLIne."Quantity Accepted B2B" := WhseActivityLIne."Quantity Accepted B2B" + PostWReceiptLine2."Quantity Accepted B2B";
                WhseActivityLIne."Quantity Rework B2B" := WhseActivityLIne."Quantity Rework B2B" + PostWReceiptLine2."Quantity Rework B2B";
                WhseActivityLIne."Quantity Rejected B2B" := WhseActivityLIne."Quantity Rejected B2B" + PostWReceiptLine2."Quantity Rejected B2B";
                WhseActivityLIne.MODIFY();
                exit;
            end else begin
                repeat
                    if WhseActivityLIne."Cross-Dock Information" = WhseActivityLIne."Cross-Dock Information"::"Cross-Dock Items" then
                        TempWhseActivityLine1 := WhseActivityLIne
                    else
                        TempWhseActivityLine2 := WhseActivityLIne;
                until WhseActivityLIne.NEXT() = 0;

                if TempWhseActivityLine1.Quantity <= PostWReceiptLine2."Quantity Accepted B2B" then begin
                    TempWhseActivityLine1."Quantity Accepted B2B" := TempWhseActivityLine1.Quantity;
                    TempWhseActivityLine2."Quantity Accepted B2B" := PostWReceiptLine2."Quantity Accepted B2B" - TempWhseActivityLine1.Quantity;
                end else
                    TempWhseActivityLine1."Quantity Accepted B2B" := PostWReceiptLine2."Quantity Accepted B2B";

                if TempWhseActivityLine2.Quantity <= PostWReceiptLine2."Quantity Rejected B2B" then begin
                    TempWhseActivityLine2."Quantity Rejected B2B" := TempWhseActivityLine2.Quantity;
                    TempWhseActivityLine1."Quantity Rejected B2B" := PostWReceiptLine2."Quantity Rejected B2B" - TempWhseActivityLine2.Quantity;
                end else
                    TempWhseActivityLine2."Quantity Rejected B2B" := PostWReceiptLine2."Quantity Rejected B2B";

                TempWhseActivityLine1."Quantity Rework B2B" := TempWhseActivityLine1.Quantity - TempWhseActivityLine1."Quantity Accepted B2B" -
                                                           TempWhseActivityLine1."Quantity Rejected B2B";
                TempWhseActivityLine2."Quantity Rework B2B" := TempWhseActivityLine2.Quantity - TempWhseActivityLine2."Quantity Accepted B2B" -
                                                           TempWhseActivityLine2."Quantity Rejected B2B";


                if WhseActivityLIne."Cross-Dock Information" = WhseActivityLIne."Cross-Dock Information"::"Cross-Dock Items" then begin
                    WhseActivityLIne := TempWhseActivityLine1;
                    WhseActivityLIne.MODIFY();
                end else begin
                    WhseActivityLIne := TempWhseActivityLine2;
                    WhseActivityLIne.MODIFY();
                end;
            end;
        //end;
    end;

    procedure CallPostedItemTrackingForm(Type: Integer; Subtype: Integer; ID: Code[20]; BatchName: Code[10]; ProdOrderLine: Integer; RefNo: Integer; var InspectReceipt2: Record "Inspection Receipt Header B2B") OK: Boolean;
    var

        // QualityItemLedgEntry : Record "Quality Item Ledger Entry";
        TempItemLedgEntry1: Record "Quality Item Ledger Entry B2B" temporary;
        SignFactor: Integer;
    begin
        ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
        ItemEntryRelation.SETRANGE("Source Type", Type);
        ItemEntryRelation.SETRANGE("Source Subtype", Subtype);
        ItemEntryRelation.SETRANGE("Source ID", ID);
        ItemEntryRelation.SETRANGE("Source Batch Name", BatchName);
        ItemEntryRelation.SETRANGE("Source Prod. Order Line", ProdOrderLine);
        ItemEntryRelation.SETRANGE("Source Ref. No.", RefNo);
        ItemEntryRelation.SETRANGE("Lot No.", InspectReceipt2."Lot No.");
        TempItemLedgEntry1.DELETEALL();
        if ItemEntryRelation.FIND('-') then begin
            SignFactor := TableSignFactor(Type);
            if not InspectReceipt2.Status then begin
                if InspectReceipt2."Rework Level" = 0 then begin
                    repeat
                        if QualityItemLedgEntry.GET(ItemEntryRelation."Item Entry No.") then
                            if (QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection") then begin
                                TempItemLedgEntry1 := QualityItemLedgEntry;
                                TempItemLedgEntry1.INSERT();
                            end;

                    until ItemEntryRelation.NEXT() = 0;
                    PAGE.RUNMODAL(33000276, TempItemLedgEntry1)
                end else begin
                    if InspectReceipt2."Serial No." = '' then begin
                        QualityItemLedgEntry.SETRANGE("Lot No.", InspectReceipt2."Lot No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            TempItemLedgEntry1 := QualityItemLedgEntry;
                            TempItemLedgEntry1.INSERT();
                        end;
                    end else begin
                        QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Serial No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            TempItemLedgEntry1 := QualityItemLedgEntry;
                            TempItemLedgEntry1.INSERT();
                        end
                    end;
                    PAGE.RUNMODAL(33000276, TempItemLedgEntry1);
                end;
                InspectReceipt2."Qty. Accepted" := 0;
                InspectReceipt2."Qty. Rejected" := 0;
                InspectReceipt2."Qty. Rework" := 0;
                InspectReceipt2."Qty. Accepted Under Deviation" := 0;
                if TempItemLedgEntry1.FIND('-') then
                    repeat
                        if TempItemLedgEntry1.Accept then
                            InspectReceipt2."Qty. Accepted" := InspectReceipt2."Qty. Accepted" + TempItemLedgEntry1.Quantity;
                        if TempItemLedgEntry1.Reject then
                            InspectReceipt2."Qty. Rejected" := InspectReceipt2."Qty. Rejected" + TempItemLedgEntry1.Quantity;
                        if TempItemLedgEntry1.Rework then
                            InspectReceipt2."Qty. Rework" := InspectReceipt2."Qty. Rework" + TempItemLedgEntry1.Quantity;
                        if TempItemLedgEntry1."Accept Under Deviation" then
                            InspectReceipt2."Qty. Accepted Under Deviation" := InspectReceipt2."Qty. Accepted Under Deviation" +
                                                                               TempItemLedgEntry1.Quantity;
                        QualityItemLedgEntry.COPY(TempItemLedgEntry1);
                        QualityItemLedgEntry.MODIFY();
                    until TempItemLedgEntry1.NEXT() = 0;
                InspectReceipt2.MODIFY();
                exit(true);
            end else begin
                if InspectReceipt2."Rework Level" = 0 then begin
                    QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."Receipt No.");
                    if QualityItemLedgEntry.FIND('-') then
                        repeat
                            if QualityItemLedgEntry.Rework then begin
                                TempItemLedgEntry1 := QualityItemLedgEntry;
                                TempItemLedgEntry1.INSERT();
                            end;
                        until QualityItemLedgEntry.NEXT() = 0;
                    PAGE.RUNMODAL(33000276, TempItemLedgEntry1);
                end else begin
                    if InspectReceipt2."Serial No." = '' then begin
                        QualityItemLedgEntry.SETRANGE("Lot No.", InspectReceipt2."Lot No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            TempItemLedgEntry1 := QualityItemLedgEntry;
                            TempItemLedgEntry1.INSERT();
                        end;
                    end else begin
                        QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Serial No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            TempItemLedgEntry1 := QualityItemLedgEntry;
                            TempItemLedgEntry1.INSERT();
                        end;
                    end;
                    Page.RUNMODAL(33000276, TempItemLedgEntry1);
                end;
                InspectReceipt2."Qty. to Vendor(Rework)" := 0;
                if TempItemLedgEntry1.FIND('-') then
                    repeat
                        if TempItemLedgEntry1."Sending to Rework" then
                            InspectReceipt2."Qty. to Vendor(Rework)" := InspectReceipt2."Qty. to Vendor(Rework)" + TempItemLedgEntry1.Quantity;
                        QualityItemLedgEntry.COPY(TempItemLedgEntry1);
                        QualityItemLedgEntry.MODIFY();
                    until TempItemLedgEntry1.NEXT() = 0;
                InspectReceipt2.MODIFY();
            end;
            exit(true);
        end else
            exit(false);
    end;

    procedure UpdateInspectAcptLevels(InspectRcpt: Record "Inspection Receipt Header B2B");
    var

    begin
        InspectRcptLevel.SETRANGE("Inspection Receipt No.", InspectRcpt."No.");
        InspectRcptLevel.MODIFYALL(Status, true);
    end;

    procedure InsertQCItemTrackingLedger(Type: Integer; Subtype: Integer; ID: Code[20]; BatchName: Code[10]; ProdOrderLine: Integer; RefNo: Integer; var InspectReceipt2: Record "Inspection Receipt Header B2B");
    var

    // QualityItemLedgEntry : Record "Quality Item Ledger Entry";
    begin
        ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
        ItemEntryRelation.SETRANGE("Source Type", Type);
        ItemEntryRelation.SETRANGE("Source Subtype", Subtype);
        ItemEntryRelation.SETRANGE("Source ID", ID);
        ItemEntryRelation.SETRANGE("Source Batch Name", BatchName);
        ItemEntryRelation.SETRANGE("Source Prod. Order Line", ProdOrderLine);
        ItemEntryRelation.SETRANGE("Source Ref. No.", RefNo);
        ItemEntryRelation.SETRANGE("Lot No.", InspectReceipt2."Lot No.");
        if InspectReceipt2."Rework Level" = 0 then begin
            if ItemEntryRelation.FIND('-') then
                repeat
                    if QualityItemLedgEntry.GET(ItemEntryRelation."Item Entry No.") and
                       (QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection")
                    then begin
                        if (QualityItemLedgEntry.Accept) or (QualityItemLedgEntry."Accept Under Deviation") then begin
                            QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                            QualityLedgerEntry."Remaining Quantity" := 0;
                            QualityLedgerEntry.Open := false;
                            QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                            QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                            QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                            if QualityItemLedgEntry."Accept Under Deviation" then begin
                                QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt2."Qty. Accepted UD Reason";
                                QualityLedgerEntry."Reason Description" := InspectReceipt2."Reason Description";
                            end;
                            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                            QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                            QualityLedgerEntry.INSERT();
                            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                            QualityItemLedgEntry.DELETE();
                        end;
                        if QualityItemLedgEntry.Reject then begin
                            QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                            QualityLedgerEntry."Remaining Quantity" := 0;
                            QualityLedgerEntry.Open := false;
                            QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                            QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                            QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                            QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
                            QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                            QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                            QualityLedgerEntry."Reason Description" := '';
                            IF InspectReceipt2."Rework Level" = 0 THEN
                                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt2."Item Ledger Entry No."
                            ELSE
                                QualityLedgerEntry."In bound Item Ledger Entry No." := InspectReceipt2."DC Inbound Ledger Entry.";
                            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                            QualityLedgerEntry.INSERT();
                            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                            QualityItemLedgEntry.MODIFY();
                            IF (InspectReceipt2."Source Type" = InspectReceipt2."Source Type"::"In Bound") AND
                                (NOT InspectReceipt2."Quality Before Receipt") THEN
                                UpdateItemLedgerEntry(QualityLedgerEntry, TRUE);
                        end;
                        if QualityItemLedgEntry.Rework then begin
                            QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                            QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                            QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                            QualityLedgerEntry.Open := true;
                            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                            QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                            QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                            QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                            QualityLedgerEntry."Reason Description" := '';
                            OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                            QualityLedgerEntry.INSERT();
                            OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                        end;
                    end;
                until ItemEntryRelation.NEXT() = 0;
            //end;
        end else begin
            if InspectReceipt2."Serial No." = '' then
                QualityItemLedgEntry.SETRANGE("Lot No.", InspectReceipt2."Lot No.")
            else
                QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Serial No.");
            if QualityItemLedgEntry.FIND('-') then begin
                if (QualityItemLedgEntry.Accept) or (QualityItemLedgEntry."Accept Under Deviation") then begin
                    QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                    QualityLedgerEntry."Remaining Quantity" := 0;
                    QualityLedgerEntry.Open := false;
                    QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                    QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                    QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                    if QualityItemLedgEntry."Accept Under Deviation" then begin
                        QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt2."Qty. Accepted UD Reason";
                        QualityLedgerEntry."Reason Description" := InspectReceipt2."Reason Description";
                    end;
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                    QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                    QualityLedgerEntry.INSERT();
                    QualityItemLedgEntry.DELETE();
                end;
                if QualityItemLedgEntry.Reject then begin
                    QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                    QualityLedgerEntry."Remaining Quantity" := 0;
                    QualityLedgerEntry.Open := false;
                    QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                    QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                    QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                    QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
                    QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                    QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                    QualityLedgerEntry."Reason Description" := '';
                    QualityLedgerEntry.INSERT();
                    QualityItemLedgEntry."Document No." := InspectReceipt2."No.";
                    QualityItemLedgEntry.MODIFY();

                end;
                if QualityItemLedgEntry.Rework then begin
                    QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                    QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                    QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                    QualityLedgerEntry.Open := true;
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                    QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                    QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                    QualityLedgerEntry."Reason Description" := '';
                    QualityLedgerEntry.INSERT();
                    QualityItemLedgEntry."Document No." := InspectReceipt2."No.";
                    QualityItemLedgEntry.MODIFY();
                end;
            end;
            if InspectReceipt2."Rework Reference No." <> '0' then
                UpdateParentQualityLedgEntry(InspectReceipt2."Rework Reference No.");
        end;
    end;

    local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SignFactor: Integer);
    var
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
    begin
        if SignFactor <> 1 then begin
            TempItemLedgEntry.Quantity *= SignFactor;
            TempItemLedgEntry."Remaining Quantity" *= SignFactor;
            TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        end;
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.RESET();
        TempItemLedgEntry.SETRANGE("Serial No.", TempItemLedgEntry2."Serial No.");
        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SETRANGE("Warranty Date", TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SETRANGE("Expiration Date", TempItemLedgEntry2."Expiration Date");
        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry2."Lot No.");
        if TempItemLedgEntry.FIND('-') then begin
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
            TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
            TempItemLedgEntry.MODIFY();
        end else
            TempItemLedgEntry.INSERT();

        TempItemLedgEntry.RESET();
    end;

    local procedure TableSignFactor(TableNo: Integer): Integer;
    begin
        if TableNo in [
          DATABASE::"Sales Line",
          DATABASE::"Sales Shipment Line",
          DATABASE::"Sales Invoice Line",
          DATABASE::"Purch. Cr. Memo Line",
          DATABASE::"Prod. Order Component",
          DATABASE::"Transfer Shipment Line",
          DATABASE::"Return Shipment Line",
          DATABASE::"Planning Component"//,
                                        //DATABASE::Table5932
          ]
        then
            exit(-1)
        else
            exit(1);
    end;

    procedure CopyQRItemstoReturnOrder(PurchHeader: Record "Purchase Header"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order");
    var
        PurchLine: Record "Purchase Line";
        //QualityItemLedgEntry : Record "Quality Item Ledger Entry";
        QualityLedgEntry3: Record "Quality Ledger Entry B2B";
        LineNo: Integer;
    begin
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::"Return Order");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        if PurchLine.FIND('+') then
            LineNo := PurchLine."Line No."
        else
            LineNo := 0;
        QualityItemLedgEntry.SETRANGE(Open, true);
        QualityItemLedgEntry.SETRANGE("Inspection Status", QualityItemLedgEntry."Inspection Status"::Rejected);
        if QualityItemLedgEntry.FIND('-') then
            repeat
                LineNo := LineNo + 10000;
                QualityLedgEntry3.GET(QualityItemLedgEntry."Quality Ledger Entry No.");
                if QualityLedgEntry3."Vendor No." = PurchHeader."Buy-from Vendor No." then begin
                    PurchLine.INIT();
                    PurchLine."Document Type" := PurchLine."Document Type"::"Return Order";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := LineNo;
                    PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                    PurchLine.VALIDATE("No.", QualityItemLedgEntry."Item No.");
                    PurchLine.VALIDATE("Location Code", QualityItemLedgEntry."Location Code");
                    PurchLine.VALIDATE(PurchLine.Quantity, QualityItemLedgEntry."Remaining Quantity");
                    PurchLine.VALIDATE("Appl.-to Item Entry", QualityItemLedgEntry."Entry No.");
                    PurchLine.INSERT(true);
                end;
            until QualityItemLedgEntry.NEXT() = 0;
        //end;
    end;

    procedure CopyQRItemstoCreditMemo(PurchHeader: Record "Purchase Header"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order");
    var
        PurchLine: Record "Purchase Line";
        //QualityItemLedgEntry : Record "Quality Item Ledger Entry";
        QualityLedgEntry3: Record "Quality Ledger Entry B2B";
        LineNo: Integer;
    begin
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::"Credit Memo");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        if PurchLine.FIND('+') then
            LineNo := PurchLine."Line No."
        else
            LineNo := 0;
        QualityItemLedgEntry.SETRANGE(Open, true);
        QualityItemLedgEntry.SETRANGE("Inspection Status", QualityItemLedgEntry."Inspection Status"::Rejected);
        if QualityItemLedgEntry.FIND('-') then
            repeat
                LineNo := LineNo + 10000;
                QualityLedgEntry3.GET(QualityItemLedgEntry."Quality Ledger Entry No.");
                if QualityLedgEntry3."Vendor No." = PurchHeader."Buy-from Vendor No." then begin
                    PurchLine.INIT();
                    PurchLine."Document Type" := PurchLine."Document Type"::"Credit Memo";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := LineNo;
                    PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                    PurchLine.VALIDATE("No.", QualityItemLedgEntry."Item No.");
                    PurchLine.VALIDATE("Location Code", QualityItemLedgEntry."Location Code");
                    PurchLine.VALIDATE(PurchLine.Quantity, QualityItemLedgEntry."Remaining Quantity");
                    PurchLine.VALIDATE("Appl.-to Item Entry", QualityItemLedgEntry."Entry No.");
                    PurchLine.INSERT(true);
                end;
            until QualityItemLedgEntry.NEXT() = 0;
        //end;
    end;

    procedure CheckPostProdOrderOutput(ItemJnlLine: Record "Item Journal Line");
    var

        ProdOrderLine2: Record "Prod. Order Line";
        QtyApplied: Decimal;
        PrevQtyApplied: Decimal;
    begin
        if ProdOrderLine2.GET(ProdOrderLine2.Status::Released, ItemJnlLine."Order No.", ItemJnlLine."Order Line No.") then
            if not ProdOrderLine2."WIP QC Enabled B2B" then
                exit;
        QtyApplied := 0;
        PrevQtyApplied := 0;
        QualityLedgEntryOutPut.SETCURRENTKEY("Order No.", "Order Line No.", "Source Type", "Entry Type", Open);
        QualityLedgEntryoutput.SETRANGE("Order No.", ItemJnlLine."Order No.");
        QualityLedgEntryoutput.SETRANGE("Order Line No.", ItemJnlLine."Order Line No.");
        QualityLedgEntryoutput.SETRANGE("Source Type", QualityLedgEntryoutput."Source Type"::WIP);
        QualityLedgEntryoutput.SETFILTER("Entry Type", 'Accepted|Reject');
        QualityLedgEntryoutput.SETRANGE(Open, true);
        QualityLedgEntryoutput.CALCSUMS(QualityLedgEntryoutput."Remaining Quantity");
        ProdOrderLine2.CALCFIELDS("Quantity Accepted B2B", "Quantity Rejected B2B");
        if ItemJnlLine."Output Quantity" > ((ProdOrderLine2."Quantity Accepted B2B" + ProdOrderLine2."Quantity Rejected B2B")
                                           - ProdOrderLine2."Finished Quantity")
        then
            ERROR(Text001Err);
        if QualityLedgEntryoutput.FIND('-') then
            repeat
                QtyApplied := QtyApplied + QualityLedgEntryoutput."Remaining Quantity";
                if QtyApplied <= ItemJnlLine."Output Quantity" then begin
                    QualityLedgEntryoutput."Remaining Quantity" := 0;
                    QualityLedgEntryoutput.Open := false;
                    QualityLedgEntryoutput.MODIFY();
                end else begin
                    QualityLedgEntryoutput."Remaining Quantity" := QualityLedgEntryoutput."Remaining Quantity" -
                                                              (ItemJnlLine."Output Quantity" - PrevQtyApplied);
                    QualityLedgEntryoutput.MODIFY();
                    QtyApplied := ItemJnlLine."Output Quantity";
                end;
                if QtyApplied = ItemJnlLine."Output Quantity" then
                    exit;
                PrevQtyApplied := QtyApplied;
            until QualityLedgEntryoutput.NEXT() = 0;
    end;

    procedure InsertItemVendorRating(InspectReceipt: Record "Inspection Receipt Header B2B");
    var
        ItemVendorRating: Record "Vendor Rating B2B";
    begin
        if InspectReceipt."Vendor No." = '' then
            exit;
        if not ItemVendorRating.GET(InspectReceipt."Item No.", InspectReceipt."Vendor No.") then begin
            ItemVendorRating.INIT();
            ItemVendorRating."Item No." := InspectReceipt."Item No.";
            ItemVendorRating."Vendor No." := InspectReceipt."Vendor No.";
            ItemVendorRating.INSERT();
        end;
    end;

    procedure FillReworkItemJnlLineAndPost(var InspectRcpt: Record "Inspection Receipt Header B2B");
    var

        Vendor: Record Vendor;

        ItemLedgEntry: Record "Item Ledger Entry";



        DelryChalanNo: Integer;
        i: Integer;
    begin
        if not CONFIRM(Text002Qst, true) then
            exit;
        if DeliveryChalan.FIND('+') then
            DelryChalanNo := DeliveryChalan."Entry No."
        else
            DelryChalanNo := 0;
        if InspectRcpt."Source Type" = InspectRcpt."Source Type"::"In Bound" then begin
            Vendor.GET(InspectRcpt."Vendor No.");
            Vendor.TESTFIELD(Vendor."Rework Location B2B");
        end;
        if (InspectRcpt."Source Type" = InspectRcpt."Source Type"::"In Bound") and (not InspectRcpt."Quality Before Receipt") and
           (InspectRcpt."Qty. to Vendor(Rework)" <> 0)
        then //begin
            if InspectRcpt."Rework Level" = 0 then begin
                ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
                ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
                if ItemJnlLine.FIND('-') then
                    ItemJnlLine.DELETEALL();
                ItemJnlLine.RESET();
                ItemJnlLine.INIT();
                ItemJnlLine."Journal Template Name" := Text330001Txt;
                ItemJnlLine."Journal Batch Name" := Text330002Txt;
                ItemJnlLine."Posting Date" := WORKDATE();
                ItemJnlLine."Document Date" := WORKDATE();
                ItemJnlLine."Document No." := InspectRcpt."No.";
                ItemJnlLine."Line No." := ItemReclassLineNo();
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                ItemJnlLine.VALIDATE("Item No.", InspectRcpt."Item No.");
                ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code", InspectRcpt."Unit of Measure Code");
                ItemJnlLine.VALIDATE(Quantity, InspectRcpt."Qty. to Vendor(Rework)");
                if InspectRcpt."Location Code" <> '' then
                    ItemJnlLine.VALIDATE("Location Code", InspectRcpt."Location Code");
                ItemJnlLine.VALIDATE("New Location Code", Vendor."Rework Location B2B");
                ItemJnlLine.VALIDATE("Applies-to Entry", InspectRcpt."Item Ledger Entry No.");
                ItemJnlLine."Quality Ledger Entry No. B2B" := InspectRcpt."Item Ledger Entry No.";
                ItemJnlLine."Dimension Set ID" := InspectRcpt."Dimension Set ID";
                ItemJnlLine."New Dimension Set ID" := InspectRcpt."Dimension Set ID";
                ItemJnlLine.INSERT();
                ItemJnlPostLine.RUN(ItemJnlLine);
                QualityItemLedgEntry.GET(InspectRcpt."Item Ledger Entry No.");
                QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - InspectRcpt."Qty. to Vendor(Rework)";
                if QualityItemLedgEntry."Remaining Quantity" = 0 then
                    QualityItemLedgEntry.DELETE()
                else
                    QualityItemLedgEntry.MODIFY();
                ItemApplnEntry.SETRANGE("Transferred-from Entry No.", InspectRcpt."Item Ledger Entry No.");
                if ItemApplnEntry.FIND('+') then;
                ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                QualityItemLedgEntry.TRANSFERFIELDS(ItemLedgEntry);
                QualityItemLedgEntry."Sent for Rework" := true;
                QualityItemLedgEntry.Accept := false;
                QualityItemLedgEntry.INSERT();
            end else begin
                RemainQty := InspectRcpt."Qty. to Vendor(Rework)";
                QualityItemLedgEntry.SETRANGE("Document No.", InspectRcpt."Rework Reference No.");
                QualityItemLedgEntry.SETRANGE("Inspection Status", QualityItemLedgEntry."Inspection Status"::"Under Inspection");
                QualityItemLedgEntry.SETRANGE("Sent for Rework", false);
                if QualityItemLedgEntry.FIND('-') then
                    repeat
                        if RemainQty <= QualityItemLedgEntry."Remaining Quantity" then
                            QtyToApply := RemainQty
                        else
                            QtyToApply := QualityItemLedgEntry."Remaining Quantity";
                        RemainQty := RemainQty - QtyToApply;
                        if QtyToApply <> 0 then begin
                            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
                            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
                            if ItemJnlLine.FIND('-') then
                                ItemJnlLine.DELETEALL();
                            ItemJnlLine.RESET();
                            ItemJnlLine.INIT();
                            ItemJnlLine."Journal Template Name" := Text330001Txt;
                            ItemJnlLine."Journal Batch Name" := Text330002Txt;
                            ItemJnlLine."Posting Date" := WORKDATE();
                            ItemJnlLine."Document Date" := WORKDATE();
                            ItemJnlLine."Document No." := InspectRcpt."No.";
                            ItemJnlLine."Line No." := ItemReclassLineNo();
                            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                            ItemJnlLine.VALIDATE("Item No.", InspectRcpt."Item No.");
                            ItemJnlLine.VALIDATE(Quantity, QtyToApply);
                            ItemJnlLine.VALIDATE("Location Code", InspectRcpt."Location Code");
                            ItemJnlLine.VALIDATE("New Location Code", Vendor."Rework Location B2B");
                            ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                            ItemJnlLine."Quality Ledger Entry No. B2B" := QualityItemLedgEntry."Entry No.";
                            ItemJnlLine."Dimension Set ID" := InspectRcpt."Dimension Set ID";
                            ItemJnlLine."New Dimension Set ID" := InspectRcpt."Dimension Set ID";
                            ItemJnlLine.INSERT();
                            ItemJnlPostLine.RUN(ItemJnlLine);
                            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QtyToApply;
                            if QualityItemLedgEntry."Remaining Quantity" = 0 then
                                QualityItemLedgEntry.DELETE()
                            else
                                QualityItemLedgEntry.MODIFY();
                            ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                            if ItemApplnEntry.FIND('+') then;
                            ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                            QualityItemLedgEntry.TRANSFERFIELDS(ItemLedgEntry);
                            QualityItemLedgEntry."Sent for Rework" := true;
                            QualityItemLedgEntry.Accept := false;
                            QualityItemLedgEntry.INSERT();
                        end;
                        i := i + 1;
                    until QualityItemLedgEntry.NEXT() = 0;
            end;
        //end;
        if InspectRcpt."Qty. to Vendor(Rework)" <> 0 then begin
            DelryChalanNo := DeliveryChalan."Entry No." + 1;
            QualityLedgEntryFill.SETRANGE("Document No.", InspectRcpt."No.");
            QualityLedgEntryFill.SETFILTER("Entry Type", '=%1', QualityLedgEntryFill."Entry Type"::Rework);
            QualityLedgEntryFill.FIND('-');
            DeliveryChalan.INIT();
            DeliveryChalan.TRANSFERFIELDS(QualityLedgEntryFill);
            DeliveryChalan."Entry No." := DelryChalanNo;
            DeliveryChalan.Quantity := InspectRcpt."Qty. to Vendor(Rework)";
            DeliveryChalan."Remaining Quantity" := InspectRcpt."Qty. to Vendor(Rework)";
            DeliveryChalan."Inbound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
            DeliveryChalan.INSERT();
        end;
        if InspectRcpt."Qty. to Vendor(Rejected)" <> 0 then begin
            DelryChalanNo := DeliveryChalan."Entry No." + 1;
            QualityLedgEntryFill.SETRANGE("Document No.", InspectRcpt."No.");
            QualityLedgEntryFill.SETFILTER("Entry Type", '=%1', QualityLedgEntryFill."Entry Type"::Reject);
            QualityLedgEntryFill.FIND('-');
            DeliveryChalan.INIT();
            DeliveryChalan.TRANSFERFIELDS(QualityLedgEntryFill);
            DeliveryChalan."Entry No." := DelryChalanNo;
            DeliveryChalan.Quantity := InspectRcpt."Qty. to Vendor(Rejected)";
            DeliveryChalan."Remaining Quantity" := 0;
            DeliveryChalan.INSERT();
        end;
        InspectRcpt."Qty. sent to Vendor(Rejected)" := InspectRcpt."Qty. sent to Vendor(Rejected)" + InspectRcpt."Qty. to Vendor(Rejected)";
        InspectRcpt."Qty. to Vendor(Rejected)" := 0;
        InspectRcpt."Qty. sent to Vendor(Rework)" := InspectRcpt."Qty. sent to Vendor(Rework)" + InspectRcpt."Qty. to Vendor(Rework)";
        InspectRcpt."Qty. to Vendor(Rework)" := 0;
    end;

    procedure ReceiveReworkAndPost(var InspectRcpt: Record "Inspection Receipt Header B2B");
    var

        DeliveryChalan2: Record "Delivery/Receipt Entry B2B";

        DelryChalanNo: Integer;

    begin
        if not CONFIRM(Text003QSt, true) then
            exit;

        if DeliveryChalan.FIND('+') then
            DelryChalanNo := DeliveryChalan."Entry No." + 1
        else
            DelryChalanNo := 1;
        InspectRcpt.TESTFIELD("Qty. to Receive(Rework)");
        RemainQty := InspectRcpt."Qty. to Receive(Rework)";
        DeliveryChalan.RESET();
        if DeliveryChalan.GET(InspectRcpt."Rework Reference Document No.") then begin
            DeliveryChalan2.INIT();
            DeliveryChalan2.TRANSFERFIELDS(DeliveryChalan);
            DeliveryChalan2."Entry No." := DelryChalanNo;
            DeliveryChalan2."Applies-to Entry" := InspectRcpt."Rework Reference Document No.";
            DeliveryChalan2."Posting Date" := WORKDATE();
            DeliveryChalan2."Document Type" := DeliveryChalan2."Document Type"::"In Bound";
            DeliveryChalan2.Quantity := RemainQty;
            DeliveryChalan2."Remaining Quantity" := 0;
            DeliveryChalan2.Open := false;
            DeliveryChalan2.Positive := true;
            DeliveryChalan2.INSERT();
            if RemainQty > 0 then begin
                if RemainQty < DeliveryChalan."Remaining Quantity" then begin
                    DeliveryChalan."Remaining Quantity" := DeliveryChalan."Remaining Quantity" - RemainQty;
                    RemainQty := 0
                end else begin
                    RemainQty := RemainQty - DeliveryChalan."Remaining Quantity";
                    DeliveryChalan."Remaining Quantity" := 0;
                    DeliveryChalan.Open := false;
                end;
                DeliveryChalan.MODIFY();
            end;
            if (InspectRcpt."Source Type" = InspectRcpt."Source Type"::"In Bound") and (not InspectRcpt."Quality Before Receipt") then
                ReceiptRework(InspectRcpt);
            if DeliveryChalan.FIND('+') then
                InspectRcpt."DC Inbound Ledger Entry." := DeliveryChalan."Inbound Item Ledger Entry No.";
            InspectRcpt.MODIFY();
            InspectDataSheets.CreateReworkInspectDataSheets(InspectRcpt);
            InspectRcpt."Qty. Received(Rework)" := InspectRcpt."Qty. Received(Rework)" + InspectRcpt."Qty. to Receive(Rework)";
            InspectRcpt."Qty. to Receive(Rework)" := 0;
        end;
    end;

    procedure ReceiptRework(InspectRcpt: Record "Inspection Receipt Header B2B");
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        QualityItemLedgEntry2: Record "Quality Item Ledger Entry B2B";
        DeliveryChalan3: Record "Delivery/Receipt Entry B2B";

    begin
        RemainQty := InspectRcpt."Qty. to Receive(Rework)";
        if DeliveryChalan3.GET(InspectRcpt."Rework Reference Document No.") then
            if QualityItemLedgEntry.GET(DeliveryChalan3."Inbound Item Ledger Entry No.") then begin
                if RemainQty <= QualityItemLedgEntry."Remaining Quantity" then
                    QtyToApply := RemainQty
                else
                    QtyToApply := QualityItemLedgEntry."Remaining Quantity";
                RemainQty := RemainQty - QtyToApply;
                if QtyToApply <> 0 then begin
                    ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
                    ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
                    if ItemJnlLine.FIND('-') then
                        ItemJnlLine.DELETEALL();
                    ItemJnlLine.RESET();
                    ItemJnlLine.INIT();
                    ItemJnlLine."Journal Template Name" := Text330001Txt;
                    ItemJnlLine."Journal Batch Name" := Text330002Txt;
                    ItemJnlLine."Posting Date" := WORKDATE();
                    ItemJnlLine."Document Date" := WORKDATE();
                    ItemJnlLine."Document No." := InspectRcpt."No.";
                    ItemJnlLine."Line No." := 10000;
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                    ItemJnlLine.VALIDATE("Item No.", InspectRcpt."Item No.");
                    ItemJnlLine.VALIDATE(Quantity, QtyToApply);
                    if DeliveryChalan3."New Location Code" <> '' then
                        ItemJnlLine.VALIDATE("Location Code", DeliveryChalan3."New Location Code");
                    if DeliveryChalan3."Location Code" <> '' then
                        ItemJnlLine.VALIDATE("New Location Code", DeliveryChalan3."Location Code");
                    ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                    ItemJnlLine."Quality Ledger Entry No. B2B" := QualityItemLedgEntry."Entry No.";
                    ItemJnlLine."External Document No." := InspectRcpt."External Document No.";
                    ItemJnlLine."Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine."New Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine.INSERT();
                    ItemJnlPostLine.RUN(ItemJnlLine);
                    ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                    if ItemApplnEntry.FIND('+') then;
                    ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                    QualityItemLedgEntry2.TRANSFERFIELDS(ItemLedgEntry);
                    QualityItemLedgEntry2."Sent for Rework" := false;
                    QualityItemLedgEntry2.INSERT();
                    if DeliveryChalan.FIND('+') then begin
                        DeliveryChalan."Inbound Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
                        DeliveryChalan.MODIFY();
                    end;
                    QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QtyToApply;
                    if QualityItemLedgEntry."Remaining Quantity" = 0 then
                        QualityItemLedgEntry.DELETE()
                    else
                        QualityItemLedgEntry.MODIFY();
                end;
            end;
    end;

    procedure ItemReclassLineNo(): Integer;
    var

    begin
        ItemJnlLine2.SETRANGE(ItemJnlLine2."Journal Template Name", Text330001Txt);
        ItemJnlLine2.SETRANGE(ItemJnlLine2."Journal Batch Name", Text330002Txt);
        if ItemJnlLine2.FIND('+') then
            exit(ItemJnlLine2."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure UpdateSentBackToVendor(var InspectRcptHeader: Record "Inspection Receipt Header B2B");
    var

        Vend: Record Vendor;

        DelryChalanNo: Integer;

    begin
        if not CONFIRM(Text002Qst, true) then
            exit;
        QualityItemLedgerEntry.reset();
        if DeliveryChalan.FIND('+') then
            DelryChalanNo := DeliveryChalan."Entry No."
        else
            DelryChalanNo := 0;
        if InspectRcptHeader."Rework Level" = 0 then
            QualityItemLedgerEntry.SETRANGE("Document No.", InspectRcptHeader."Receipt No.")
        else
            QualityItemLedgerEntry.SETRANGE("Document No.", InspectRcptHeader."No.");
        QualityItemLedgerEntry.SETRANGE("Sending to Rework", true);
        if QualityItemLedgerEntry.FIND('-') then
            repeat
                if Vend.GET(InspectRcptHeader."Vendor No.") then begin
                    Vend.TESTFIELD(Vend."Rework Location B2B");
                    QualityItemLedgerEntry."Location Code" := Vend."Rework Location B2B";
                end;
                QualityItemLedgerEntry."Sending to Rework" := false;
                QualityItemLedgerEntry.Rework := false;
                QualityItemLedgerEntry."Sent for Rework" := true;
                QualityItemLedgerEntry.MODIFY();
                if InspectRcptHeader."Qty. to Vendor(Rework)" <> 0 then begin
                    QualityLedgEntry2.reset();
                    QualityLedgEntry2.SETRANGE("Item Ledger Entry No.", QualityItemLedgerEntry."Entry No.");
                    if QualityLedgEntry2.FIND('-') then begin
                        DelryChalanNo := DeliveryChalan."Entry No." + 1;
                        DeliveryChalan.INIT();
                        DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                        DeliveryChalan."Document No." := InspectRcptHeader."No.";
                        DeliveryChalan.Open := true;
                        DeliveryChalan."Entry No." := DelryChalanNo;
                        DelryChalanNo := DelryChalanNo + 1;
                        DeliveryChalan.Quantity := QualityLedgEntry2.Quantity;
                        DeliveryChalan."Remaining Quantity" := QualityLedgEntry2.Quantity;
                        DeliveryChalan."Inbound Item Ledger Entry No." := QualityItemLedgerEntry."Entry No.";
                        DeliveryChalan.INSERT();
                    end;
                end;
                if InspectRcptHeader."Qty. to Vendor(Rejected)" <> 0 then begin
                    DelryChalanNo := DeliveryChalan."Entry No." + 1;
                    QualityLedgEntry2.SETRANGE("Document No.", InspectRcptHeader."No.");
                    QualityLedgEntry2.SETFILTER("Entry Type", '=%1', QualityLedgEntry2."Entry Type"::Reject);
                    QualityLedgEntry2.FIND('-');
                    DeliveryChalan.INIT();
                    DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                    DeliveryChalan."Entry No." := DelryChalanNo;
                    DeliveryChalan.Quantity := InspectRcptHeader."Qty. to Vendor(Rejected)";
                    DeliveryChalan."Remaining Quantity" := 0;
                    DeliveryChalan.INSERT();
                end;
            until QualityItemLedgerEntry.NEXT() = 0;
        InspectRcptHeader."Qty. sent to Vendor(Rework)" := InspectRcptHeader."Qty. sent to Vendor(Rework)" + InspectRcptHeader."Qty. to Vendor(Rework)";
        InspectRcptHeader."Qty. to Vendor(Rework)" := 0;
        MESSAGE(Text004Msg);
    end;

    procedure UpdateReceiveRework(var InspectRcptHeader: Record "Inspection Receipt Header B2B");
    var

        Vend: Record Vendor;

        DeliveryChalan2: Record "Delivery/Receipt Entry B2B";
        DelryChalanNo: Integer;
    begin
        if not CONFIRM(Text003Qst, true) then
            exit;
        InspectRcptHeader.TESTFIELD("Qty. to Receive(Rework)");
        RemainQty := InspectRcptHeader."Qty. to Receive(Rework)";
        if DeliveryChalan.FIND('+') then
            DelryChalanNo := DeliveryChalan."Entry No." + 1
        else
            DelryChalanNo := 1;
        if DeliveryChalan.GET(InspectRcptHeader."Rework Reference Document No.") then begin
            if QualityItemLedgerEntryrework.GET(DeliveryChalan."Item Ledger Entry No.") then begin
                if Vend.GET(InspectRcptHeader."Vendor No.") then
                    QualityItemLedgerEntryrework."Location Code" := InspectRcptHeader."Location Code";
                QualityItemLedgerEntryrework."Sent for Rework" := false;
                QualityItemLedgerEntryrework.Accept := true;
                QualityItemLedgerEntryrework.MODIFY();
            end;
            DeliveryChalan2.INIT();
            DeliveryChalan2.TRANSFERFIELDS(DeliveryChalan);
            DeliveryChalan2."Entry No." := DelryChalanNo;
            DeliveryChalan2."Applies-to Entry" := InspectRcptHeader."Rework Reference Document No.";
            DeliveryChalan2."Posting Date" := WORKDATE();
            DeliveryChalan2."Document Type" := DeliveryChalan2."Document Type"::"In Bound";
            DeliveryChalan2.Quantity := RemainQty;
            DeliveryChalan2."Remaining Quantity" := 0;
            DeliveryChalan2.Open := false;
            DeliveryChalan2.Positive := true;
            DeliveryChalan2.INSERT();
            if RemainQty > 0 then begin
                if RemainQty < DeliveryChalan."Remaining Quantity" then begin
                    DeliveryChalan."Remaining Quantity" := DeliveryChalan."Remaining Quantity" - RemainQty;
                    RemainQty := 0
                end else begin
                    RemainQty := RemainQty - DeliveryChalan."Remaining Quantity";
                    DeliveryChalan."Remaining Quantity" := 0;
                    DeliveryChalan.Open := false;
                end;
                DeliveryChalan.MODIFY();
            end;
            if (InspectRcptHeader."Source Type" = InspectRcptHeader."Source Type"::"In Bound") and (not InspectRcptHeader."Quality Before Receipt") then
                InspectDataSheets.CreateReworkInspectDataSheets(InspectRcptHeader);
            InspectRcptHeader."Qty. Received(Rework)" := InspectRcptHeader."Qty. Received(Rework)" + InspectRcptHeader."Qty. to Receive(Rework)";
            InspectRcptHeader."Qty. to Receive(Rework)" := 0;
        end;
        MESSAGE(Text005Msg);

    end;

    procedure UpdateResEntry(VAR ItemJournalLine: Record "Item Journal Line"; VAR QualityLedgEntry2: Record "Quality Ledger Entry B2B");


    Var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        Entrynum: Integer;

    begin
        IF ReservationEntry2.FINDlast() THEN
            EntryNum := ReservationEntry2."Entry No."
        ELSE
            EntryNum := 0;
        ReservationEntry.INIT();
        ReservationEntry."Entry No." := EntryNum + 1;
        ReservationEntry.VALIDATE(Positive, FALSE);
        ReservationEntry.VALIDATE("Item No.", ItemJournalLine."Item No.");
        ReservationEntry.VALIDATE("Location Code", ItemJournalLine."Location Code");
        ReservationEntry.VALIDATE("Quantity (Base)", -QualityLedgEntry2.Quantity);
        ReservationEntry.VALIDATE(Quantity, -QualityLedgEntry2.Quantity);
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry.VALIDATE("Creation Date", ItemJournalLine."Posting Date");
        ReservationEntry.VALIDATE("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.VALIDATE("Source Subtype", 4);
        ReservationEntry.VALIDATE("Source ID", ItemJnlLine."Journal Template Name");
        ReservationEntry.VALIDATE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        ReservationEntry.VALIDATE("Source Ref. No.", ItemJnlLine."Line No.");
        ReservationEntry.VALIDATE("Shipment Date", ItemJournalLine."Posting Date");
        ReservationEntry.VALIDATE("Serial No.", QualityLedgEntry2."Serial No.");
        ReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
        ReservationEntry.VALIDATE("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.VALIDATE("Expiration Date", QualityLedgEntry2."Expiration Date");
        ReservationEntry.VALIDATE("Lot No.", QualityLedgEntry2."Lot No.");
        ReservationEntry.VALIDATE(ReservationEntry."New Lot No.", QualityLedgEntry2."Lot No.");
        ReservationEntry.VALIDATE(ReservationEntry."New Serial No.", QualityLedgEntry2."Serial No.");
        ReservationEntry.VALIDATE("New Expiration Date", QualityLedgEntry2."Expiration Date");
        ReservationEntry.VALIDATE("Appl.-to Item Entry", QualityLedgEntry2."In bound Item Ledger Entry No.");
        ReservationEntry.VALIDATE(Correction, FALSE);
        ReservationEntry.INSERT();

    end;

    procedure InsertSerialTrackingQLE(InspectReceipt: Record "Inspection Receipt Header b2B");
    var

        ItemLedgEntry: Record "Item Ledger Entry";

    begin
        IF InspectReceipt."Qty. Accepted" <> 0 THEN BEGIN
            InspectRecptAcceptLevel.RESET();
            InspectRecptAcceptLevel.SETRANGE("Quality Type", InspectRecptAcceptLevel."Quality Type"::Accepted);
            InspectRecptAcceptLevel.SETRANGE("Inspection Receipt No.", InspectReceipt."No.");
            IF InspectRecptAcceptLevel.FIND('-') THEN
                REPEAT
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                    QualityLedgerEntry.Quantity := InspectRecptAcceptLevel.Quantity;
                    QualityLedgerEntry."New Location Code" := InspectReceipt."Location Code";
                    ;
                    QualityLedgerEntry."Serial No." := InspectRecptAcceptLevel."Serial No.";
                    QualityLedgerEntry."In bound Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    QualityLedgerEntry."Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    IF ItemLedgEntry.GET(InspectRecptAcceptLevel."ILE No.") THEN
                        QualityLedgerEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                    QualityLedgerEntry.INSERT();
                    QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptAcceptLevel."ILE No.");
                    IF QualityItemLedgEntry.FIND('-') THEN
                        QualityItemLedgEntry.DELETE();
                UNTIL InspectRecptAcceptLevel.NEXT() = 0;
        END;
        IF InspectReceipt."Qty. Accepted Under Deviation" <> 0 THEN BEGIN
            InspectRecptAcceptLevel.RESET();
            InspectRecptAcceptLevel.SETRANGE("Quality Type", InspectRecptAcceptLevel."Quality Type"::"Accepted Under Deviation");
            InspectRecptAcceptLevel.SETRANGE("Inspection Receipt No.", InspectReceipt."No.");
            IF InspectRecptAcceptLevel.FIND('-') THEN
                REPEAT
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                    QualityLedgerEntry."New Location Code" := InspectReceipt."Location Code";
                    QualityLedgerEntry.Quantity := InspectRecptAcceptLevel.Quantity;
                    QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt."Qty. Accepted UD Reason";
                    QualityLedgerEntry."Reason Description" := InspectReceipt."Reason Description";
                    QualityLedgerEntry."Serial No." := InspectRecptAcceptLevel."Serial No.";
                    QualityLedgerEntry."In bound Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    QualityLedgerEntry."Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    IF ItemLedgEntry.GET(InspectRecptAcceptLevel."ILE No.") THEN
                        QualityLedgerEntry."Expiration Date" := ItemLedgEntry."Expiration Date";

                    QualityLedgerEntry.INSERT();
                    QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptAcceptLevel."ILE No.");
                    IF QualityItemLedgEntry.FIND('-') THEN
                        QualityItemLedgEntry.DELETE();
                UNTIL InspectRecptAcceptLevel.NEXT() = 0;
        END;
        IF InspectReceipt."Qty. Rejected" <> 0 THEN BEGIN
            InspectRecptAcceptLevel.RESET();
            InspectRecptAcceptLevel.SETRANGE("Quality Type", InspectRecptAcceptLevel."Quality Type"::Rejected);
            InspectRecptAcceptLevel.SETRANGE("Inspection Receipt No.", InspectReceipt."No.");
            IF InspectRecptAcceptLevel.FIND('-') THEN
                REPEAT
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                    QualityLedgerEntry.Quantity := InspectRecptAcceptLevel.Quantity;
                    QualityLedgerEntry."New Location Code" := InspectReceipt."New Location Code";
                    QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                    QualityLedgerEntry."Reason Description" := '';
                    QualityLedgerEntry."Serial No." := InspectRecptAcceptLevel."Serial No.";
                    QualityLedgerEntry."In bound Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    QualityLedgerEntry."Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    IF ItemLedgEntry.GET(InspectRecptAcceptLevel."ILE No.") THEN
                        QualityLedgerEntry."Expiration Date" := ItemLedgEntry."Expiration Date";

                    QualityLedgerEntry.INSERT();
                    UpdateItemLedgerEntry(QualityLedgerEntry, TRUE);
                    QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptAcceptLevel."ILE No.");
                    IF QualityItemLedgEntry.FIND('-') THEN
                        QualityItemLedgEntry.DELETE();
                UNTIL InspectRecptAcceptLevel.NEXT() = 0;
        END;


    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInitQualityLedger(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; InspectReceipt: Record "Inspection Receipt Header B2B")
    begin
    end;

    procedure OnAfterInitQualityLedger(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; InspectReceipt: Record "Inspection Receipt Header B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertQualityLedgerEntry(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; InspectReceipt: Record "Inspection Receipt Header B2B")
    begin
    end;

    procedure OnAfterInsertQualityLedgerEntry(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; InspectReceipt: Record "Inspection Receipt Header B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertQualityItemLedgEntryRework(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInsertQualityItemLedgEntryRework(var QualityLedgerEntry: Record "Quality Ledger Entry B2B"; QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeItemJnlLineInsert(var ItemJnlLine: Record "Item Journal Line"; QualityLedgEntry2: Record "Quality Ledger Entry B2B")
    begin
    end;

    procedure OnAfterItemJnlLineInsert(var ItemJnlLine: Record "Item Journal Line"; QualityLedgEntry2: Record "Quality Ledger Entry B2B")
    begin
    end;

    var
        WhseActivityLIne: Record "Warehouse Activity Line";
        InspectRcptLevel: Record "IR Acceptance Levels B2B";
        InspectRecptAcceptLevel: Record "IR Acceptance Levels B2B";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PostWReceiptLine: Record "Posted Whse. Receipt Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemEntryRelation: Record "Item Entry Relation";
        ParentInspectionReceipt: Record "Inspection Receipt Header B2B";
        ItemJnlLine2: Record "Item Journal Line";
        QualityItemLedgerEntry: Record "Quality Item Ledger Entry B2B";
        QualityLedgEntry2: Record "Quality Ledger Entry B2B";
        QualityItemLedgerEntryRework: Record "Quality Item Ledger Entry B2B";
        QualityLedgEntryOutPut: Record "Quality Ledger Entry B2B";
        QualityLedgEntryFill: Record "Quality Ledger Entry B2B";
        QualityLedgEntryUpdateParent: Record "Quality Ledger Entry B2B";
        QualityLedgEntryParentIR: Record "Quality Ledger Entry B2B";
        QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B";

}


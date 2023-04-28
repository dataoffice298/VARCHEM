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
            //InsertQualityLedgerEntryTracking(Rec);

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
        OnBeforeModifyStatusInspRcptLine(Rec);
        Evaluate(Rec."Posted By", USERID());
        if Rec."Qty. Hold" <> 0 then begin
            Rec."Qty. sent to Hold" := Rec."Qty. Hold";
            Rec."Qty. Hold" := 0;
        end;
        Rec."Posted Date" := TODAY();
        Rec."Posted Time" := TIME();
        Rec.Status := true;
        Rec.MODIFY();
    end;

    var

        QualityLedgerEntry: Record "Quality Ledger Entry B2B";
        PurchaseRcptHdr: Record "Purch. Rcpt. Header";
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
        Text004Qst: Label 'Do you want to receive the Hold material back?';
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
            /*if (InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound") and
               (not InspectReceipt."Quality Before Receipt")
            then
                UpdateItemLedgerEntry(QualityLedgerEntry, false);*/ //Commented by b2bjk
            if ((InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound"))
              and (not InspectReceipt."Quality Before Receipt")
           then begin
                //B2BMSOn19Apr2022<<
                if (InspectReceipt."Qty. Accepted Under Deviation" = 0) and (InspectReceipt."Qty. Rejected" = 0) and (InspectReceipt."Qty. Rework" = 0) and (InspectReceipt."Qty. Hold" = 0) then begin
                    QualityItemLedgEntry.GET(QualityLedgerEntry."In bound Item Ledger Entry No.");
                    QualityItemLedgEntry.DELETE();
                end else begin
                    QualityItemLedgEntry.GET(QualityLedgerEntry."In bound Item Ledger Entry No.");
                    QualityItemLedgEntry."Remaining Quantity" -= InspectReceipt."Qty. Accepted";
                    QualityItemLedgEntry.Modify();
                end;
            end;
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
        if InspectReceipt."Qty. Hold" <> 0 then begin
            QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
            QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
            QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
            QualityLedgerEntry.Open := true;
            QualityLedgerEntry.Quantity := InspectReceipt."Qty. Hold";
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Hold";
            QualityLedgerEntry."Accepted Under Dev. Reason" := '';
            QualityLedgerEntry."Reason Description" := '';
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            UpdateItemLedgerEntryHold(QualityLedgerEntry, false);
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
        end;
    end;

    procedure InsertQualityLedgerEntryTracking(InspectReceipt: Record "Inspection Receipt Header B2B");
    Var
        ItemLedgerEntryLvar: Record "Item Ledger Entry";
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
            //QualityLedgerEntry.ex
            QualityLedgerEntry."Remaining Quantity" := InspectReceipt."Qty. Accepted";
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            if ItemLedgerEntryLvar.Get(QualityLedgerEntry."In bound Item Ledger Entry No.") then
                QualityLedgerEntry."Expiration Date" := ItemLedgerEntryLvar."Expiration Date";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
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
            //QualityLedgerEntry."Expiration Date" := InspectReceipt.ex
            QualityLedgerEntry."Operation No." := InspectReceipt."Operation No.";
            if ItemLedgerEntryLvar.Get(QualityLedgerEntry."In bound Item Ledger Entry No.") then
                QualityLedgerEntry."Expiration Date" := ItemLedgerEntryLvar."Expiration Date";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);

            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            if (InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound") and
               (not InspectReceipt."Quality Before Receipt")
            then
                UpdateItemLedgerEntry(QualityLedgerEntry, InspectReceipt."Item Tracking Exists");
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
            if ItemLedgerEntryLvar.Get(QualityLedgerEntry."In bound Item Ledger Entry No.") then
                QualityLedgerEntry."Expiration Date" := ItemLedgerEntryLvar."Expiration Date";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);

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
            if ItemLedgerEntryLvar.Get(QualityLedgerEntry."In bound Item Ledger Entry No.") then
                QualityLedgerEntry."Expiration Date" := ItemLedgerEntryLvar."Expiration Date";
            OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            QualityLedgerEntry.INSERT();
            OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt);
            //QC1.1>>
            QualityItemLedgEntry."Remaining Quantity" := InspectReceipt."Qty. Rework";//QC1.2
            QualityItemLedgEntry.Rework := TRUE;
            QualityItemLedgEntry."Sending to Rework" := TRUE;
            QualityItemLedgEntry.MODIFY;

            //QC1.1<<
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
        QualityLedgerEntry."Vendor Lot No_B2B" := InspectReceipt."Vendor Lot No_B2B";
        QualityLedgerEntry."Item Ledger Entry No." := InspectReceipt."Item Ledger Entry No.";
        QualityLedgerEntry."Vendor No." := InspectReceipt."Vendor No.";
        QualityLedgerEntry."Rework Level" := InspectReceipt."Rework Level";
        QualityLedgerEntry."Rework Reference No." := InspectReceipt."Rework Reference No.";
        QualityLedgerEntry."Unit of Measure Code" := InspectReceipt."Unit of Measure Code";
        QualityLedgerEntry."Qty. per Unit of Measure" := InspectReceipt."Qty. per Unit of Measure";
    end;


    procedure UpdateItemLedgerEntry(QualityLedgEntry2: Record "Quality Ledger Entry B2B"; ItemTrackingExists: Boolean);
    var
        // ItemApplicEntry: Record "Item Application Entry"; //Doubt
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
            ItemJnlLine.Validate("Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;
            OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            ItemJnlLine.INSERT();
            OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            IF ItemTrackingExists THEN
                UpdateResEntry(ItemJnlLine, QualityLedgEntry2);

            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            if (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Accepted) or
               (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Reject)
            then begin
                //QC1.2>>MS
                if InsRcpt."From Hold" then
                    ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityLedgEntry2."Item Ledger Entry No.")
                else
                    //QC1.2<<
                    ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityLedgEntry2."In bound Item Ledger Entry No.");
                if ItemApplnEntry.FIND('+') then
                    QualityLedgerEntry."Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
            end;
            UpdateQualityItemLedgEntry(); //testing commented

        end else begin
            //QC1.2>>MS
            if (InsRcpt.GET(QualityLedgEntry2."Document No.")) and (InsRcpt."From Hold")
                and (QualityLedgEntry2."Entry Type" = QualityLedgEntry2."Entry Type"::Reject) then begin
                QualityItemLedgEntry.Reset();
                QualityItemLedgEntry.SETRANGE("Entry No.", QualityLedgEntry2."Item Ledger Entry No.")
            end else
                //QC1.2<<
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
                        IF NOT ItemTrackingExists THEN
                            ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                        ItemJnlLine."Quality Ledger Entry No. B2B" := QualityLedgEntry2."Entry No.";
                        QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        if InsRcpt.GET(QualityLedgEntry2."Document No.") then;
                        ItemJnlLine."Dimension Set ID" := InsRcpt."Dimension Set ID";
                        ItemJnlLine."New Dimension Set ID" := InsRcpt."Dimension Set ID";
                        ItemJnlLine.Validate("Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;
                        OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        ItemJnlLine.INSERT();
                        OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        IF ItemTrackingExists THEN
                            UpdateResEntry(ItemJnlLine, QualityLedgEntry2);
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
                    QualityItemLedgEntry."Sending to Rework" := TRUE;
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
        QualityItemLedgEntry2: Record "Quality Item Ledger Entry B2B";
        ItemLedgEntry: Record "Item Ledger Entry";
        //QC1.2>>MS
        InsRcpt: Record "Inspection Receipt Header B2B";
    //QC1.2<<
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
        //QC1.2>>MS
        if (InsRcpt.Get(QualityLedgerEntry."Document No.") and (InsRcpt."From Hold")) then
            QualityItemLedgEntry.GET(QualityLedgerEntry."Item Ledger Entry No.")
        else
            //QC1.2<<
            QualityItemLedgEntry.GET(QualityLedgerEntry."In bound Item Ledger Entry No.");
        if QualityLedgerEntry."Rework Reference No." = '' then begin
            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QualityLedgerEntry.Quantity;
            QualityItemLedgEntry.Accept := false;
            if QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Rework then begin
                QualityItemLedgEntry.Rework := true;
                QualityItemLedgEntry."Sending to Rework" := TRUE;
            end;
            if QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Hold then begin
                ItemLedgEntry.GET(QualityLedgerEntry."Item Ledger Entry No.");
                QualityItemLedgEntry2.TRANSFERFIELDS(ItemLedgEntry);
                QualityItemLedgEntry2."Inspection Status" := QualityItemLedgEntry."Inspection Status"::"Under Inspection";
                QualityItemLedgEntry2."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                QualityItemLedgEntry2.Reject := false;
                QualityItemLedgEntry2.Accept := false;
                QualityItemLedgEntry2.Hold := true;
                QualityItemLedgEntry2.INSERT();
                QualityItemLedgEntry.Accept := false;
                QualityItemLedgEntry.Rework := false;
                QualityItemLedgEntry."Sending to Rework" := false;
                QualityItemLedgEntry.Hold := true;
            end;
        end else begin
            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QtyToApply;
            QualityItemLedgEntry.Accept := false;
            if QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Rework then begin
                QualityItemLedgEntry.Rework := true;
                QualityItemLedgEntry."Sending to Rework" := TRUE;
            end;
            if QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Hold then begin
                QualityItemLedgEntry.Accept := false;
                QualityItemLedgEntry.Rework := false;
                QualityItemLedgEntry."Sending to Rework" := false;
                QualityItemLedgEntry.Hold := true;
            end;
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
        IRAcceptanceLevelsB2B: Record "IR Acceptance Levels B2B";//B2B22DEC22
        LineNum: Integer;//B2B22DEC22
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

        //B2B22DEC22<<
        if ItemEntryRelation.FIND('-') then begin
            SignFactor := TableSignFactor(Type);
            if not InspectReceipt2.Status then begin
                if (InspectReceipt2."Rework Level" = 0) and not InspectReceipt2."From Hold" then begin
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
                        if InspectReceipt2."From Hold" then begin
                            QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."No.");
                            //QualityItemLedgEntry.SetRange(Hold, false);
                        end else
                            QualityItemLedgEntry.SETRANGE("Lot No.", InspectReceipt2."Lot No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            repeat
                                TempItemLedgEntry1 := QualityItemLedgEntry;
                                TempItemLedgEntry1.INSERT();
                            until QualityItemLedgEntry.Next() = 0;
                        end;
                    end else begin
                        if InspectReceipt2."From Hold" then begin
                            QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."No.");
                            //QualityItemLedgEntry.SetRange(Hold, false);
                        end else
                            QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Serial No.");
                        if QualityItemLedgEntry.FIND('-') then begin
                            repeat
                                TempItemLedgEntry1 := QualityItemLedgEntry;
                                TempItemLedgEntry1.INSERT();
                            until QualityItemLedgEntry.Next() = 0;
                        end else begin
                            QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Rework Reference No.");
                            if QualityItemLedgEntry.FIND('-') then begin
                                repeat
                                    TempItemLedgEntry1 := QualityItemLedgEntry;
                                    TempItemLedgEntry1.INSERT();
                                until QualityItemLedgEntry.Next() = 0;
                            end
                        end;
                    end;
                    PAGE.RUNMODAL(33000276, TempItemLedgEntry1);
                end;

                InspectReceipt2."Qty. Accepted" := 0;
                InspectReceipt2."Qty. Rejected" := 0;
                InspectReceipt2."Qty. Rework" := 0;
                InspectReceipt2."Qty. Accepted Under Deviation" := 0;
                InspectReceipt2."Qty. Hold" := 0;
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
                        if TempItemLedgEntry1.Hold then
                            InspectReceipt2."Qty. Hold" := InspectReceipt2."Qty. Hold" +
                                                                              TempItemLedgEntry1.Quantity;
                        QualityItemLedgEntry.COPY(TempItemLedgEntry1);
                        QualityItemLedgEntry.MODIFY();

                    until TempItemLedgEntry1.NEXT() = 0;
                InspectReceipt2.MODIFY();

                exit(true);
            end else begin
                if InspectReceipt2."Rework Level" = 0 then begin
                    if InspectReceipt2."From Hold" then
                        QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."No.")
                    else
                        QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."Receipt No.");
                    if QualityItemLedgEntry.FIND('-') then
                        repeat
                            if QualityItemLedgEntry.Rework or QualityItemLedgEntry.Hold then begin
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
        if (InspectReceipt2."Rework Level" = 0) and (not InspectReceipt2."From Hold") then begin
            if ItemEntryRelation.FIND('-') then
                repeat
                    if QualityItemLedgEntry.GET(ItemEntryRelation."Item Entry No.") and
                       (QualityItemLedgEntry."Inspection Status" = QualityItemLedgEntry."Inspection Status"::"Under Inspection")
                    then begin
                        if QualityItemLedgEntry."Serial No." = '' then begin
                            if ((InspectReceipt2."Qty. Accepted" <> 0)) or (InspectReceipt2."Qty. Accepted Under Deviation" <> 0) then begin
                                QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Accepted";
                                QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Accepted";
                                QualityLedgerEntry.Open := false;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                if InspectReceipt2."Qty. Accepted Under Deviation" <> 0 then begin
                                    QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt2."Qty. Accepted UD Reason";
                                    QualityLedgerEntry."Reason Description" := InspectReceipt2."Reason Description";
                                    QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Accepted Under Deviation";
                                    QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Accepted Under Deviation";
                                end;
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                                QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                                OnBeforeInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                                QualityLedgerEntry.INSERT();
                                OnAfterInsertQualityLedgerEntry(QualityLedgerEntry, InspectReceipt2);
                                if (InspectReceipt2.Quantity = InspectReceipt2."Qty. Accepted") or (InspectReceipt2.Quantity = InspectReceipt2."Qty. Accepted Under Deviation") then
                                    QualityItemLedgEntry.DELETE();
                            end;
                            if InspectReceipt2."Qty. Rejected" <> 0 then begin
                                QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Rejected";
                                QualityLedgerEntry."Remaining Quantity" := 0;
                                QualityLedgerEntry.Open := false;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                                //QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
                                QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
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
                            if InspectReceipt2."Qty. Rework" <> 0 then begin
                                QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Rework";
                                QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntry.Open := true;
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                                QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                                QualityLedgerEntry."Reason Description" := '';
                                OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                QualityLedgerEntry.INSERT();
                                OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                //QC1.1>>
                                QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                                QualityItemLedgEntry.Rework := TRUE;
                                QualityItemLedgEntry."Sending to Rework" := TRUE;
                                QualityItemLedgEntry.MODIFY;

                                //QC1.1<<
                            end;
                            if InspectReceipt2."Qty. Hold" <> 0 then begin
                                QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Hold";
                                QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Hold";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntry.Open := true;
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
                                QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                                QualityLedgerEntry."Reason Description" := '';
                                QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                                OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                QualityLedgerEntry.INSERT();
                                OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                //QC1.1>>
                                QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                                QualityItemLedgEntry.Hold := TRUE;
                                QualityItemLedgEntry.MODIFY;
                                UpdateItemLedgerEntryHold(QualityLedgerEntry, true);
                                //QC1.1<<
                            end;
                        end else begin
                            if ((QualityItemLedgEntry.Accept)) or (QualityItemLedgEntry."Accept Under Deviation") then begin
                                QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                                QualityLedgerEntry."Remaining Quantity" := 0;
                                QualityLedgerEntry.Open := false;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
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
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                                //QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
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
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                                QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                                QualityLedgerEntry."Reason Description" := '';
                                OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                QualityLedgerEntry.INSERT();
                                OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                //QC1.1>>
                                //QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                                QualityItemLedgEntry.Rework := TRUE;
                                QualityItemLedgEntry."Sending to Rework" := TRUE;
                                QualityItemLedgEntry.MODIFY;

                                //QC1.1<<
                            end;
                            if QualityItemLedgEntry.Hold then begin
                                QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Hold";
                                QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Hold";
                                QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                QualityLedgerEntry.Open := true;
                                QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                                QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                                QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                                QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                                QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                                QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                                QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
                                QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                                QualityLedgerEntry."Reason Description" := '';
                                QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                                OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                QualityLedgerEntry.INSERT();
                                OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                                //QC1.1>>
                                QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                                QualityItemLedgEntry.Hold := TRUE;
                                QualityItemLedgEntry.MODIFY;
                                UpdateItemLedgerEntryHold(QualityLedgerEntry, true);
                                //QC1.1<<
                            end;
                        end;
                    end;
                until ItemEntryRelation.NEXT() = 0;
            //end;
        end else begin
            if InspectReceipt2."From Hold" then begin
                //if InspectReceipt2."Rework Level" <> 0 then
                //QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."Rework Reference No.")
                //else
                if InspectReceipt2."Rework Level" <> 0 then
                    QualityItemLedgEntry.SetRange("Entry No.", InspectReceipt2."Item Ledger Entry No.");
            end else
                if InspectReceipt2."Serial No." = '' then
                    QualityItemLedgEntry.SETRANGE("Lot No.", InspectReceipt2."Lot No.")
                else
                    QualityItemLedgEntry.SETRANGE("Serial No.", InspectReceipt2."Serial No.");
            QualityItemLedgEntry.SETRANGE("Document No.", InspectReceipt2."No.");
            if QualityItemLedgEntry.FIND('-') then begin
                if QualityItemLedgEntry."Serial No." = '' then begin
                    if ((InspectReceipt2."Qty. Accepted" <> 0)) or (InspectReceipt2."Qty. Accepted Under Deviation" <> 0) then begin
                        QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Accepted";
                        QualityLedgerEntry."Remaining Quantity" := 0;
                        QualityLedgerEntry.Open := false;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        if QualityItemLedgEntry."Accept Under Deviation" then begin
                            QualityLedgerEntry."Accepted Under Dev. Reason" := InspectReceipt2."Qty. Accepted UD Reason";
                            QualityLedgerEntry."Reason Description" := InspectReceipt2."Reason Description";
                            QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Accepted Under Deviation";
                            QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Accepted Under Deviation";
                        end;
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Accepted;
                        QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                        QualityLedgerEntry.INSERT();
                        if (InspectReceipt2.Quantity = InspectReceipt2."Qty. Accepted") or (InspectReceipt2.Quantity = InspectReceipt2."Qty. Accepted Under Deviation") then
                            QualityItemLedgEntry.DELETE();
                    end;
                    if (InspectReceipt2."Qty. Rejected" <> 0) then begin
                        QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Rejected";
                        QualityLedgerEntry."Remaining Quantity" := 0;
                        QualityLedgerEntry.Open := false;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Reject;
                        //QualityItemLedgEntry."Inspection Status" := QualityItemLedgEntry."Inspection Status"::Rejected;
                        QualityItemLedgEntry."Quality Ledger Entry No." := QualityLedgerEntry."Entry No.";
                        QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                        QualityLedgerEntry."Reason Description" := '';
                        QualityLedgerEntry.INSERT();
                        QualityItemLedgEntry."Document No." := InspectReceipt2."No.";
                        QualityItemLedgEntry.MODIFY();
                        //QC1.2>>MS
                        IF (InspectReceipt2."Source Type" = InspectReceipt2."Source Type"::"In Bound") AND
                                    (NOT InspectReceipt2."Quality Before Receipt") THEN
                            UpdateItemLedgerEntry(QualityLedgerEntry, TRUE);
                        //QC1.2<<
                    end;
                    if (InspectReceipt2."Qty. Rework" <> 0) then begin
                        if InspectReceipt2."Item Ledger Entry No." <> 0 then
                            QualityItemLedgEntry.Get(InspectReceipt2."Item Ledger Entry No.");
                        QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Rework";
                        QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry.Open := true;
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                        QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                        QualityLedgerEntry."Reason Description" := '';
                        QualityLedgerEntry.INSERT();
                        //QualityItemLedgEntry."Document No." := InspectReceipt2."No.";
                        //QualityItemLedgEntry.MODIFY();
                        //QC1.1>>
                        QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                        QualityItemLedgEntry.Rework := TRUE;
                        QualityItemLedgEntry."Sending to Rework" := TRUE;
                        QualityItemLedgEntry.MODIFY;
                        //QC1.1<<
                    end;
                    if InspectReceipt2."Qty. Hold" <> 0 then begin
                        QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Hold";
                        QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Hold";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry.Open := true;
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
                        QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                        QualityLedgerEntry."Reason Description" := '';
                        QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                        OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                        QualityLedgerEntry.INSERT();
                        OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                        //QC1.1>>
                        QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                        QualityItemLedgEntry.Hold := TRUE;
                        QualityItemLedgEntry.MODIFY;
                        UpdateItemLedgerEntryHold(QualityLedgerEntry, true);
                        //QC1.1<<
                    end;
                end else begin
                    if ((QualityItemLedgEntry.Accept)) or (QualityItemLedgEntry."Accept Under Deviation") then begin
                        QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                        QualityLedgerEntry."Remaining Quantity" := 0;
                        QualityLedgerEntry.Open := false;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
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
                    if (QualityItemLedgEntry.Reject) then begin
                        QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                        QualityLedgerEntry."Remaining Quantity" := 0;
                        QualityLedgerEntry.Open := false;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
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
                    if (QualityItemLedgEntry.Rework) then begin
                        QualityLedgerEntry.Quantity := QualityItemLedgEntry."Remaining Quantity";
                        QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry.Open := true;
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
                        QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                        QualityLedgerEntry."Reason Description" := '';
                        QualityLedgerEntry.INSERT();
                        //QualityItemLedgEntry."Document No." := InspectReceipt2."No.";
                        //QualityItemLedgEntry.MODIFY();
                        //QC1.1>>
                        //QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                        QualityItemLedgEntry.Rework := TRUE;
                        QualityItemLedgEntry."Sending to Rework" := TRUE;
                        QualityItemLedgEntry.MODIFY;

                        //QC1.1<<
                    end;
                    if QualityItemLedgEntry.Hold then begin
                        QualityLedgerEntry.Quantity := InspectReceipt2."Qty. Hold";
                        QualityLedgerEntry."Remaining Quantity" := InspectReceipt2."Qty. Hold";
                        QualityLedgerEntry."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        QualityLedgerEntry.Open := true;
                        QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                        QualityLedgerEntry."Serial No." := QualityItemLedgEntry."Serial No.";
                        QualityLedgerEntry."Lot No." := QualityItemLedgEntry."Lot No.";
                        QualityLedgerEntry."Vendor Lot No_B2B" := QualityItemLedgEntry."Vendor Lot No_B2B";
                        QualityLedgerEntry."Expiration Date" := QualityItemLedgEntry."Expiration Date";
                        QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                        QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
                        QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                        QualityLedgerEntry."Reason Description" := '';
                        QualityLedgerEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity";
                        OnBeforeInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                        QualityLedgerEntry.INSERT();
                        OnAfterInsertQualityItemLedgEntryRework(QualityLedgerEntry, QualityItemLedgEntry);
                        //QC1.1>>
                        QualityItemLedgEntry."Remaining Quantity" := InspectReceipt2."Qty. Rework";//QC1.2
                        QualityItemLedgEntry.Hold := TRUE;
                        QualityItemLedgEntry.MODIFY;
                        UpdateItemLedgerEntryHold(QualityLedgerEntry, true);
                        //QC1.1<<
                    end;
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
        ItemGrec: Record Item;
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
                    PurchLine.INSERT(true);
                    PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                    PurchLine.VALIDATE("No.", QualityItemLedgEntry."Item No.");
                    PurchLine.VALIDATE("Location Code", QualityItemLedgEntry."Location Code");
                    PurchLine.VALIDATE(PurchLine.Quantity, QualityItemLedgEntry."Remaining Quantity");
                    if ItemGrec.Get(QualityItemLedgEntry."Item No.") and (ItemGrec."Item Tracking Code" <> '') then begin
                        UpdateResEntryForReturnShipments(PurchLine, QualityLedgEntry3);
                        QualityItemLedgEntry.Delete();
                    end else
                        PurchLine.VALIDATE("Appl.-to Item Entry", QualityItemLedgEntry."Entry No.");
                    PurchLine.Modify(true);

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
                ItemJnlLine.Validate("Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                ItemJnlLine.Validate("Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
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
                            ItemJnlLine.Validate("Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                            ItemJnlLine.Validate("Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                            ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                            ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;
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
                    if not InspectRcpt."Item Tracking Exists" then
                        ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                    ItemJnlLine."Quality Ledger Entry No. B2B" := QualityItemLedgEntry."Entry No.";
                    ItemJnlLine."External Document No." := InspectRcpt."External Document No.";
                    ItemJnlLine."Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine."New Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine.Validate("Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;
                    ItemJnlLine.INSERT();
                    if InspectRcpt."Item Tracking Exists" then
                        UpdateResEntryQILE(ItemJnlLine, QualityItemLedgEntry);
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


        ReclassWithItemTracking(InspectRcptHeader, TRUE);
        /*QualityItemLedgerEntry.reset();
        if DeliveryChalan.FIND('+') then
            DelryChalanNo := DeliveryChalan."Entry No."
        else
            DelryChalanNo := 0;
        if (InspectRcptHeader."Rework Level" = 0) and not InspectRcptHeader."From Hold" then
            QualityItemLedgerEntry.SETRANGE("Document No.", InspectRcptHeader."Receipt No.")
        else
            QualityItemLedgerEntry.SETRANGE("Document No.", InspectRcptHeader."No.");
        //QualityItemLedgEntry.SetFilter(qt,'<>%1',0);
        QualityItemLedgerEntry.SETRANGE("Sending to Rework", true);  // doubt
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
            until QualityItemLedgerEntry.NEXT() = 0;*/
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
            //B2BV1.0 >>
            IF ((InspectRcptHeader."Source Type" = InspectRcptHeader."Source Type"::"In Bound") OR (InspectRcptHeader."Source Type" = InspectRcptHeader."Source Type"::WIP)) AND (NOT InspectRcptHeader."Quality Before Receipt") THEN
                ReceiptRework(InspectRcptHeader);
            if DeliveryChalan.FIND('+') then
                InspectRcptHeader."DC Inbound Ledger Entry." := DeliveryChalan."Inbound Item Ledger Entry No.";
            InspectRcptHeader.modify;
            //B2BV1.0 <<
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
        //QC1.2>>MS
        InsRcpt: Record "Inspection Receipt Header B2B";
    //QC1.2<<
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
        ReservationEntry."Vendor Lot No_B2B" := QualityLedgEntry2."Vendor Lot No_B2B";
        ReservationEntry.VALIDATE(ReservationEntry."New Lot No.", QualityLedgEntry2."Lot No.");
        ReservationEntry.VALIDATE(ReservationEntry."New Serial No.", QualityLedgEntry2."Serial No.");
        ReservationEntry.VALIDATE("New Expiration Date", QualityLedgEntry2."Expiration Date");
        //QC1.2>>MS
        if (InsRcpt.Get(QualityLedgEntry2."Document No.") and (InsRcpt."From Hold")) then
            ReservationEntry.VALIDATE("Appl.-to Item Entry", QualityLedgEntry2."Item Ledger Entry No.")
        else
            //QC1.2<<
            ReservationEntry.VALIDATE("Appl.-to Item Entry", QualityLedgEntry2."In bound Item Ledger Entry No.");
        ReservationEntry.VALIDATE(Correction, FALSE);
        ReservationEntry.INSERT();

    end;

    procedure UpdateResEntryForReturnShipments(PurchaseLinePar: Record "Purchase Line"; QualityLedgEntry2: Record "Quality Ledger Entry B2B");


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
        ReservationEntry.VALIDATE("Item No.", QualityLedgEntry2."Item No.");
        ReservationEntry.VALIDATE("Location Code", PurchaseLinePar."Location Code");
        ReservationEntry.VALIDATE("Quantity (Base)", -QualityLedgEntry2.Quantity);
        ReservationEntry.VALIDATE(Quantity, -QualityLedgEntry2.Quantity);
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry.VALIDATE("Creation Date", QualityLedgEntry2."Posting Date");
        ReservationEntry.VALIDATE("Source Type", DATABASE::"Purchase Line");
        ReservationEntry.VALIDATE("Source Subtype", PurchaseLinePar."Document Type");//purline doc ty
        ReservationEntry.VALIDATE("Source ID", PurchaseLinePar."Document No.");//doc no
        //ReservationEntry.VALIDATE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        ReservationEntry.VALIDATE("Source Ref. No.", PurchaseLinePar."Line No.");
        ReservationEntry.VALIDATE("Shipment Date", QualityLedgEntry2."Posting Date");
        ReservationEntry.VALIDATE("Serial No.", QualityLedgEntry2."Serial No.");
        ReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
        ReservationEntry.VALIDATE("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.VALIDATE("Expiration Date", QualityLedgEntry2."Expiration Date");
        ReservationEntry.VALIDATE("Lot No.", QualityLedgEntry2."Lot No.");
        ReservationEntry."Vendor Lot No_B2B" := QualityLedgEntry2."Vendor Lot No_B2B";
        ReservationEntry.VALIDATE(ReservationEntry."New Lot No.", QualityLedgEntry2."Lot No.");
        ReservationEntry.VALIDATE(ReservationEntry."New Serial No.", QualityLedgEntry2."Serial No.");
        ReservationEntry.VALIDATE("New Expiration Date", QualityLedgEntry2."Expiration Date");
        //ReservationEntry.VALIDATE("Appl.-to Item Entry", QualityLedgEntry2."In bound Item Ledger Entry No.");
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
        IF InspectReceipt."Qty. Hold" <> 0 THEN BEGIN
            InspectRecptAcceptLevel.RESET();
            InspectRecptAcceptLevel.SETRANGE("Quality Type", InspectRecptAcceptLevel."Quality Type"::Hold);
            InspectRecptAcceptLevel.SETRANGE("Inspection Receipt No.", InspectReceipt."No.");
            IF InspectRecptAcceptLevel.FIND('-') THEN
                REPEAT
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Hold;
                    QualityLedgerEntry.Quantity := InspectRecptAcceptLevel.Quantity;
                    QualityLedgerEntry."New Location Code" := InspectReceipt."New Location Code";
                    QualityLedgerEntry."Accepted Under Dev. Reason" := '';
                    QualityLedgerEntry."Reason Description" := '';
                    QualityLedgerEntry."Serial No." := InspectRecptAcceptLevel."Serial No.";
                    QualityLedgerEntry."In bound Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    QualityLedgerEntry."Item Ledger Entry No." := InspectRecptAcceptLevel."ILE No.";
                    IF ItemLedgEntry.GET(InspectRecptAcceptLevel."ILE No.") THEN
                        QualityLedgerEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                    QualityLedgerEntry."Remaining Quantity" := ItemLedgEntry."Remaining Quantity";
                    QualityLedgerEntry.INSERT();
                    UpdateItemLedgerEntryHold(QualityLedgerEntry, TRUE);
                    QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptAcceptLevel."ILE No.");
                    IF QualityItemLedgEntry.FIND('-') THEN
                        QualityItemLedgEntry.DELETE();
                UNTIL InspectRecptAcceptLevel.NEXT() = 0;
        END;
        IF InspectReceipt."Qty. Rework" <> 0 THEN BEGIN
            InspectRecptAcceptLevel.RESET();
            InspectRecptAcceptLevel.SETRANGE("Quality Type", InspectRecptAcceptLevel."Quality Type"::Rework);
            InspectRecptAcceptLevel.SETRANGE("Inspection Receipt No.", InspectReceipt."No.");
            IF InspectRecptAcceptLevel.FIND('-') THEN
                REPEAT
                    QualityLedgerEntryNo := QualityLedgerEntryNo + 1;
                    QualityLedgerEntry."Entry No." := QualityLedgerEntryNo;
                    QualityLedgerEntry."Entry Type" := QualityLedgerEntry."Entry Type"::Rework;
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
                    QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptAcceptLevel."ILE No.");
                    IF QualityItemLedgEntry.FIND('-') THEN begin
                        QualityItemLedgEntry."Sending to Rework" := true;
                        QualityItemLedgEntry.Modify();
                    end;

                UNTIL InspectRecptAcceptLevel.NEXT() = 0;
        End;
    end;

    procedure ReclassWithItemTracking(InspectRecptHeaderGRec: Record "Inspection Receipt Header B2B"; ItemTrackingExists: Boolean)
    var
        Vendor: REcord vendor;
        DelryChalanNo: integer;
        ItemLedgEntry: Record "Item Ledger Entry";
        QualityItemLedgEntry2: record "Quality Item Ledger Entry B2B";

        ToLocationCode: Code[20];
        QualityControlSetup: Record "Quality Control Setup B2B";

    begin
        clear(ToLocationCode);

        IF InspectRecptHeaderGRec."Source Type" = InspectRecptHeaderGRec."Source Type"::"In Bound" THEN BEGIN
            Vendor.GET(InspectRecptHeaderGRec."Vendor No.");
            Vendor.TESTFIELD(Vendor."Rework Location B2B");
            ToLocationCode := Vendor."Rework Location B2B";
        END else begin
            QualityControlSetup.get;
            //QualityControlSetup.Testfield("Production Location Code");
            //ToLocationCode := QualityControlSetup."Production Location Code";
        end;

        //  QualityItemLedgerEntry."Location Code" := Vend."Rework Location"; //Recheck

        IF DeliveryChalan.FINDLAST THEN;
        QualityItemLedgEntry.RESET;
        IF (InspectRecptHeaderGRec."Rework Level" = 0) and (Not InspectRecptHeaderGRec."From Hold") THEN BEGIN
            if InspectRecptHeaderGRec."Source Type" = InspectRecptHeaderGRec."Source Type"::"In Bound" then //QC1.3
                QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."Receipt No.")
            else
                QualityItemLedgEntry.SETRANGE("Entry No.", InspectRecptHeaderGRec."Item Ledger Entry No.");  //QC1.3
            QualityItemLedgEntry.SETRANGE("Sending to Rework", TRUE);
        END ELSE begin
            if InspectRecptHeaderGRec."From Hold" then
                QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."No.")
            else
                QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."Rework Reference No.");//QC1.1
        end;

        // QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."Rework Reference No.");//QC1.1
        QualityItemLedgEntry.SETRANGE("Lot No.", InspectRecptHeaderGRec."Lot No.");
        QualityItemLedgEntry.SETRANGE(Rework, TRUE);
        IF QualityItemLedgEntry.FindSet() THEN BEGIN

            IF ((InspectRecptHeaderGRec."Source Type" = InspectRecptHeaderGRec."Source Type"::"In Bound") OR (InspectRecptHeaderGRec."Source Type" = InspectRecptHeaderGRec."Source Type"::WIP)) AND (NOT InspectRecptHeaderGRec."Quality Before Receipt")
          AND
              (InspectRecptHeaderGRec."Qty. to Vendor(Rework)" <> 0) THEN BEGIN

                IF InspectRecptHeaderGRec."Rework Level" = 0 THEN BEGIN
                    repeat
                        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", 'RECLASS');
                        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", 'DEFAULT');
                        IF ItemJnlLine.FIND('-') THEN
                            ItemJnlLine.DELETEALL;
                        ItemJnlLine.RESET;
                        ItemJnlLine.INIT;
                        ItemJnlLine."Journal Template Name" := 'RECLASS';
                        ItemJnlLine."Journal Batch Name" := 'DEFAULT';
                        ItemJnlLine."Posting Date" := WORKDATE;
                        ItemJnlLine."Document Date" := WORKDATE;
                        ItemJnlLine."Document No." := InspectRecptHeaderGRec."No.";
                        ItemJnlLine."Line No." := ItemReclassLineNo();//InspectJnlPostLine.ItemReclassLineNo;
                        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                        ItemJnlLine.VALIDATE("Item No.", InspectRecptHeaderGRec."Item No.");
                        ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code", InspectRecptHeaderGRec."Unit Of Measure Code");
                        if QualityItemLedgEntry."Serial No." <> '' then
                            ItemJnlLine.VALIDATE(Quantity, QualityItemLedgEntry."Remaining Quantity")
                        else
                            ItemJnlLine.VALIDATE(Quantity, InspectRecptHeaderGRec."Qty. to Vendor(Rework)");
                        IF InspectRecptHeaderGRec."Location Code" <> '' THEN
                            ItemJnlLine.VALIDATE("Location Code", InspectRecptHeaderGRec."Location Code");
                        ItemJnlLine.VALIDATE("New Location Code", ToLocationCode);//Vendor."Rework Location B2B");//QC1.3
                        IF NOT ItemTrackingExists THEN
                            ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                        ItemJnlLine."Quality Ledger Entry No. B2B" := QualityItemLedgEntry."Entry No.";
                        ItemLedgEntry."QLE No. B2B" := QualityItemLedgEntry."Entry No.";
                        // Dimension Passing>>
                        ItemJnlLine."Shortcut Dimension 1 Code" := InspectRecptHeaderGRec."Shortcut Dimension 1 Code";
                        ItemJnlLine."Shortcut Dimension 2 Code" := InspectRecptHeaderGRec."Shortcut Dimension 2 Code";
                        ItemJnlLine."New Shortcut Dimension 1 Code" := InspectRecptHeaderGRec."Shortcut Dimension 1 Code";
                        ItemJnlLine."New Shortcut Dimension 2 Code" := InspectRecptHeaderGRec."Shortcut Dimension 2 Code";
                        ItemJnlLine."Dimension Set ID" := InspectRecptHeaderGRec."Dimension Set ID";
                        ItemJnlLine."New Dimension Set ID" := InspectRecptHeaderGRec."Dimension Set ID";
                        // Dimension Passing<<
                        ItemJnlLine.INSERT;

                        IF ItemTrackingExists THEN
                            UpdateResEntryQILE(ItemJnlLine, QualityItemLedgEntry);

                        ItemJnlPostLine.RUN(ItemJnlLine);
                        if QualityItemLedgEntry."Serial No." <> '' then
                            ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.")
                        else
                            ItemApplnEntry.SETRANGE("Transferred-from Entry No.", InspectRecptHeaderGRec."Item Ledger Entry No.");
                        IF ItemApplnEntry.FIND('+') THEN;
                        ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                        QualityItemLedgEntry2.TRANSFERFIELDS(ItemLedgEntry);
                        QualityItemLedgEntry2."Sent for Rework" := TRUE;
                        QualityItemLedgEntry2.Accept := FALSE;
                        QualityItemLedgEntry2.INSERT;

                        IF InspectRecptHeaderGRec."Qty. to Vendor(Rework)" <> 0 THEN BEGIN
                            //QualityLedgEntry2.SETRANGE("Item Ledger Entry No.",QualityItemLedgerEntry."Entry No.");
                            DelryChalanNo := DeliveryChalan."Entry No." + 1;
                            QualityLedgEntry2.SETRANGE("Document No.", InspectRecptHeaderGRec."No.");
                            QualityLedgEntry2.SETFILTER("Entry Type", '=%1', QualityLedgEntry2."Entry Type"::Rework);
                            IF QualityLedgEntry2.FIND('-') THEN BEGIN
                                DeliveryChalan.INIT;
                                DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                                DeliveryChalan."Document No." := InspectRecptHeaderGRec."No.";
                                DeliveryChalan.Open := TRUE;
                                DeliveryChalan."Entry No." := DelryChalanNo;
                                DelryChalanNo := DelryChalanNo;
                                if QualityItemLedgEntry."Serial No." <> '' then
                                    DeliveryChalan.Quantity := QualityLedgEntry2.Quantity
                                else
                                    DeliveryChalan.Quantity := InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                                if QualityItemLedgEntry."Serial No." <> '' then
                                    DeliveryChalan."Remaining Quantity" := QualityLedgEntry2.Quantity
                                else
                                    DeliveryChalan."Remaining Quantity" := InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                                //            DeliveryChalan."Location Code" := QualityItemLedgEntry2."Location Code";
                                DeliveryChalan."New Location Code" := ToLocationCode;//Vendor."Rework Location B2B";//QC1.3
                                                                                     //DeliveryChalan."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                                                                                     //B2BV1.0 >>
                                ItemApplnEntry.RESET;
                                ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                                IF ItemApplnEntry.FIND('+') THEN
                                    DeliveryChalan."Inbound Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
                                //B2BV1.0 <<
                                DeliveryChalan.INSERT;
                            END;
                        END;

                        IF InspectRecptHeaderGRec."Qty. To Vendor(Rejected)" <> 0 THEN BEGIN
                            DelryChalanNo := DeliveryChalan."Entry No." + 1;
                            QualityLedgEntry2.SETRANGE("Document No.", InspectRecptHeaderGRec."No.");
                            QualityLedgEntry2.SETFILTER("Entry Type", '=%1', QualityLedgEntry2."Entry Type"::Reject);
                            QualityLedgEntry2.FIND('-');
                            DeliveryChalan.INIT;
                            DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                            DeliveryChalan."Entry No." := DelryChalanNo;
                            DeliveryChalan.Quantity := InspectRecptHeaderGRec."Qty. To Vendor(Rejected)";
                            DeliveryChalan."Remaining Quantity" := 0;
                            DeliveryChalan.INSERT;
                        END;
                        //
                        if QualityItemLedgEntry."Serial No." <> '' then
                            QualityItemLedgEntry."Remaining Quantity" := 0
                        else
                            QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                        IF QualityItemLedgEntry."Remaining Quantity" = 0 THEN
                            QualityItemLedgEntry.DELETE
                        ELSE
                            QualityItemLedgEntry.MODIFY;
                    until QualityItemLedgEntry.Next() = 0;
                END ELSE BEGIN
                    RemainQty := InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                    //QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."Rework Reference No.");//QC1.1
                    //QualityItemLedgEntry.SETRANGE("Document No.", InspectRecptHeaderGRec."No.");//QC1.1
                    // QualityItemLedgEntry.SETRANGE("Inspection Status", QualityItemLedgEntry."Inspection Status"::"Under Inspection");//QC1.2
                    //QualityItemLedgEntry.SETRANGE(Rework, TRUE);//QC1.1
                    //QualityItemLedgEntry.SETRANGE("Sent for Rework", FALSE);
                    IF QualityItemLedgEntry.FIND('-') THEN
                        REPEAT
                            IF RemainQty <= QualityItemLedgEntry."Remaining Quantity" THEN
                                QtyToApply := RemainQty
                            ELSE
                                QtyToApply := QualityItemLedgEntry."Remaining Quantity";
                            RemainQty := RemainQty - QtyToApply;
                            IF QtyToApply <> 0 THEN BEGIN
                                ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", Text330001Txt);
                                ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", Text330002Txt);
                                IF ItemJnlLine.FIND('-') THEN
                                    ItemJnlLine.DELETEALL;
                                ItemJnlLine.RESET;
                                ItemJnlLine.INIT;
                                ItemJnlLine."Journal Template Name" := Text330001Txt;
                                ItemJnlLine."Journal Batch Name" := Text330002Txt;
                                ItemJnlLine."Posting Date" := WORKDATE;
                                ItemJnlLine."Document Date" := WORKDATE;
                                ItemJnlLine."Document No." := InspectRecptHeaderGRec."No.";
                                ItemJnlLine."Line No." := ItemReclassLineNo();//InspectJnlPostLine.ItemReclassLineNo;
                                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                                //            ItemJnlLine."Lot No." := QualityItemLedgEntry."Lot No.";
                                //            ItemJnlLine."Serial No." := QualityItemLedgEntry."Serial No.";
                                ItemJnlLine.VALIDATE("Item No.", InspectRecptHeaderGRec."Item No.");
                                ItemJnlLine.VALIDATE(Quantity, QtyToApply);
                                //B2BV1.0 >>
                                //            ItemJnlLine.VALIDATE("Location Code",InspectRecptHeaderGRec."Location Code");
                                //            ItemJnlLine.VALIDATE("New Location Code",Vendor."Rework Location");
                                IF InspectRecptHeaderGRec."Location Code" <> '' THEN
                                    ItemJnlLine.VALIDATE("Location Code", InspectRecptHeaderGRec."Location Code");
                                ItemJnlLine.VALIDATE("New Location Code", ToLocationCode);//Vendor."Rework Location B2B");//QC1.3
                                //B2BV1.0 <<
                                IF NOT ItemTrackingExists THEN
                                    ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                                ItemJnlLine."Quality Ledger Entry No. b2B" := QualityItemLedgEntry."Entry No.";
                                // Dimension Passing>>
                                ItemJnlLine."Shortcut Dimension 1 Code" := InspectRecptHeaderGRec."Shortcut Dimension 1 Code";
                                ItemJnlLine."Shortcut Dimension 2 Code" := InspectRecptHeaderGRec."Shortcut Dimension 2 Code";
                                ItemJnlLine."New Shortcut Dimension 1 Code" := InspectRecptHeaderGRec."Shortcut Dimension 1 Code";
                                ItemJnlLine."New Shortcut Dimension 2 Code" := InspectRecptHeaderGRec."Shortcut Dimension 2 Code";
                                ItemJnlLine."Dimension Set ID" := InspectRecptHeaderGRec."Dimension Set ID";
                                ItemJnlLine."New Dimension Set ID" := InspectRecptHeaderGRec."Dimension Set ID";
                                // Dimension Passing<<
                                ItemJnlLine.INSERT;

                                IF ItemTrackingExists THEN
                                    UpdateResEntryQILE(ItemJnlLine, QualityItemLedgEntry);

                                ItemJnlPostLine.RUN(ItemJnlLine);

                                ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                                IF ItemApplnEntry.FIND('+') THEN;
                                ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                                QualityItemLedgEntry2.TRANSFERFIELDS(ItemLedgEntry);
                                QualityItemLedgEntry2."Sent for Rework" := TRUE;

                                QualityItemLedgEntry2.Accept := FALSE;
                                QualityItemLedgEntry2.INSERT;
                                QualityItemLedgEntry."Sending to Rework" := FALSE;
                                QualityItemLedgEntry."Sent for Rework" := TRUE;
                                QualityItemLedgEntry.MODIFY;
                            END;
                            //
                            IF InspectRecptHeaderGRec."Qty. To Vendor(Rework)" <> 0 THEN BEGIN
                                //QualityLedgEntry2.SETRANGE("Item Ledger Entry No.",QualityItemLedgerEntry."Entry No.");
                                DelryChalanNo := DeliveryChalan."Entry No." + 1;
                                QualityLedgEntry2.SETRANGE("Document No.", InspectRecptHeaderGRec."No.");
                                QualityLedgEntry2.SETFILTER("Entry Type", '=%1', QualityLedgEntry2."Entry Type"::Rework);
                                IF QualityLedgEntry2.FIND('-') THEN BEGIN
                                    DeliveryChalan.INIT;
                                    DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                                    DeliveryChalan."Document No." := InspectRecptHeaderGRec."No.";
                                    DeliveryChalan.Open := TRUE;
                                    DeliveryChalan."Entry No." := DelryChalanNo;
                                    DelryChalanNo := DelryChalanNo;
                                    if QualityItemLedgEntry."Serial No." <> '' then
                                        DeliveryChalan.Quantity := QualityLedgEntry2."Remaining Quantity"
                                    else
                                        DeliveryChalan.Quantity := InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                                    if QualityItemLedgEntry."Serial No." <> '' then
                                        DeliveryChalan."Remaining Quantity" := QualityLedgEntry2."Remaining Quantity"
                                    else
                                        DeliveryChalan."Remaining Quantity" := InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                                    //DeliveryChalan."Location Code" := QualityItemLedgEntry2."Location Code";
                                    DeliveryChalan."New Location Code" := ToLocationCode;//Vendor."Rework Location B2B";//QC1.3
                                    //DeliveryChalan."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";

                                    ItemApplnEntry.RESET;
                                    ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                                    IF ItemApplnEntry.FIND('+') THEN begin
                                        DeliveryChalan."DC Inbound Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";
                                        DeliveryChalan."Inbound Item Ledger Entry No." := ItemApplnEntry."Inbound Item Entry No.";//Qc1.1
                                    end;

                                    DeliveryChalan.INSERT;
                                END;
                            END;

                            IF InspectRecptHeaderGRec."Qty. To Vendor(Rejected)" <> 0 THEN BEGIN
                                DelryChalanNo := DeliveryChalan."Entry No." + 1;
                                QualityLedgEntry2.SETRANGE("Document No.", InspectRecptHeaderGRec."No.");
                                QualityLedgEntry2.SETFILTER("Entry Type", '=%1', QualityLedgEntry2."Entry Type"::Reject);
                                QualityLedgEntry2.FIND('-');
                                DeliveryChalan.INIT;
                                DeliveryChalan.TRANSFERFIELDS(QualityLedgEntry2);
                                DeliveryChalan."Entry No." := DelryChalanNo;
                                DeliveryChalan.Quantity := InspectRecptHeaderGRec."Qty. To Vendor(Rejected)";
                                DeliveryChalan."Remaining Quantity" := 0;
                                DeliveryChalan.INSERT;
                            END;
                            //
                            // QualityItemLedgEntry.GET(InspectRecptHeaderGRec."Item Ledger Entry No.");
                            if QualityItemLedgEntry."Serial No." <> '' then
                                QualityItemLedgEntry."Remaining Quantity" := 0
                            else
                                QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - InspectRecptHeaderGRec."Qty. To Vendor(Rework)";
                            IF QualityItemLedgEntry."Remaining Quantity" = 0 THEN
                                QualityItemLedgEntry.DELETE
                            ELSE
                                QualityItemLedgEntry.MODIFY;
                        //
                        UNTIL QualityItemLedgEntry.NEXT = 0;
                END;
            END;
        END;

    end;

    procedure UpdateResEntryQILE(VAR ItemJournalLine: Record "Item Journal Line"; VAR QualityItemLedgerEntry: Record "Quality Item Ledger Entry B2B")
    var
        ReservationEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        ItemLRec: Record Item; //b2bms

    begin
        If ItemLRec.Get(ItemJournalLine."Item No.") then
            if ItemLRec."Item Tracking Code" = '' then
                exit;

        //B2BV1.0 >>
        IF TempReservationEntry.FIND('+') THEN
            EntryNo := TempReservationEntry."Entry No."
        ELSE
            EntryNo := 0;
        ReservationEntry.INIT;
        ReservationEntry."Entry No." := EntryNo + 1;
        ReservationEntry.VALIDATE(Positive, FALSE);
        ReservationEntry.VALIDATE("Item No.", ItemJournalLine."Item No.");
        ReservationEntry.VALIDATE("Location Code", ItemJournalLine."Location Code");
        //ReservationEntry.VALIDATE("Quantity (Base)",-QualityItemLedgerEntry.Quantity);
        ReservationEntry.VALIDATE("Quantity (Base)", -ItemJournalLine."Quantity (Base)");
        ReservationEntry.VALIDATE(Quantity, -ItemJournalLine.Quantity);
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Prospect); //B2BMSOn25May2022
        ReservationEntry.VALIDATE("Creation Date", ItemJournalLine."Posting Date");
        ReservationEntry.VALIDATE("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.VALIDATE("Source Subtype", 4);
        ReservationEntry.VALIDATE("Source ID", ItemJournalLine."Journal Template Name");
        ReservationEntry.VALIDATE("Source Batch Name", ItemJournalLine."Journal Batch Name");
        ReservationEntry.VALIDATE("Source Ref. No.", ItemJournalLine."Line No.");
        ReservationEntry.VALIDATE("Shipment Date", ItemJournalLine."Posting Date");
        ReservationEntry.VALIDATE("Serial No.", QualityItemLedgerEntry."Serial No.");
        ReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
        ReservationEntry.VALIDATE("Planning Flexibility", ReservationEntry."Planning Flexibility"::Unlimited);
        ReservationEntry.VALIDATE("Expiration Date", QualityItemLedgerEntry."Expiration Date");
        ReservationEntry.VALIDATE("Lot No.", QualityItemLedgerEntry."Lot No.");
        ReservationEntry.Validate("Vendor Lot No_B2B", QualityItemLedgerEntry."Vendor Lot No_B2B");
        ReservationEntry.VALIDATE(ReservationEntry."New Lot No.", QualityItemLedgerEntry."Lot No.");
        ReservationEntry.VALIDATE(ReservationEntry."New Serial No.", QualityItemLedgerEntry."Serial No.");
        ReservationEntry.VALIDATE("New Expiration Date", QualityItemLedgerEntry."Expiration Date"); //SMY 1.1
        ReservationEntry.VALIDATE("Appl.-to Item Entry", QualityItemLedgerEntry."Entry No.");
        ReservationEntry.VALIDATE(Correction, FALSE);
        ReservationEntry.INSERT;


    end;

    procedure UpdateItemLedgerEntryHold(QualityLedgEntry2: Record "Quality Ledger Entry B2B"; ItemTrackingExists: Boolean);
    var
        // ItemApplicEntry: Record "Item Application Entry"; //Doubt
        InsRcpt: Record "Inspection Receipt Header B2B";
        QCSetup: Record "Quality Control Setup B2B";
    begin
        QCSetup.Get();
        QCSetup.TestField("Hold Location");
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
            ItemJnlLine.VALIDATE("New Location Code", QCSetup."Hold Location");
            IF NOT ItemTrackingExists THEN
                ItemJnlLine.VALIDATE("Applies-to Entry", QualityLedgerEntry."In bound Item Ledger Entry No.");
            ItemJnlLine."Quality Ledger Entry No. B2B" := QualityLedgEntry2."Entry No.";
            if InsRcpt.GET(QualityLedgEntry2."Document No.") then;
            ItemJnlLine."Dimension Set ID" := InsRcpt."Dimension Set ID";
            ItemJnlLine."New Dimension Set ID" := InsRcpt."Dimension Set ID";
            ItemJnlLine.Validate("Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
            ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
            OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            ItemJnlLine.INSERT();
            OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
            IF ItemTrackingExists THEN
                UpdateResEntry(ItemJnlLine, QualityLedgEntry2);

            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            if (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Accepted) or
               (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Reject) or (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Hold)
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
                        ItemJnlLine.VALIDATE("New Location Code", QCSetup."Hold Location");
                        ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                        ItemJnlLine."Quality Ledger Entry No. B2B" := QualityLedgEntry2."Entry No.";
                        QualityLedgerEntry."In bound Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        if InsRcpt.GET(QualityLedgEntry2."Document No.") then;
                        ItemJnlLine."Dimension Set ID" := InsRcpt."Dimension Set ID";
                        ItemJnlLine."New Dimension Set ID" := InsRcpt."Dimension Set ID";
                        ItemJnlLine.Validate("Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InsRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                        ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InsRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;
                        OnBeforeItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        ItemJnlLine.INSERT();
                        OnAfterItemJnlLineInsert(ItemJnlLine, QualityLedgEntry2);
                        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
                        if (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Accepted) or
                           (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Reject) or
                           (QualityLedgerEntry."Entry Type" = QualityLedgerEntry."Entry Type"::Hold)
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

    procedure ReceiveHoldAndPost(var InspectRcpt: Record "Inspection Receipt Header B2B");
    var

        DeliveryChalan2: Record "Delivery/Receipt Entry B2B";

        DelryChalanNo: Integer;

    begin
        if not CONFIRM(Text004QSt, true) then
            exit;


        if (InspectRcpt."Source Type" = InspectRcpt."Source Type"::"In Bound") and (not InspectRcpt."Quality Before Receipt") then
            ReceiptHold(InspectRcpt);

        InspectDataSheets.CreateHoldInspectDataSheets(InspectRcpt);
        InspectRcpt."Qty. Received(Hold)" := InspectRcpt."Qty. Received(Hold)" + InspectRcpt."Qty. to Receive(Hold)";
        InspectRcpt."Qty. to Receive(Hold)" := 0;
        InspectRcpt.MODIFY();
    end;

    procedure ReceiptHold(var InspectRcpt: Record "Inspection Receipt Header B2B");
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        QualityItemLedgEntry2: Record "Quality Item Ledger Entry B2B";
        DeliveryChalan3: Record "Delivery/Receipt Entry B2B";
        QCSetup: Record "Quality Control Setup B2B";
    begin
        RemainQty := InspectRcpt."Qty. to Receive(Hold)";
        QCSetup.Get();
        QCSetup.TestField("Hold Location");
        QualityItemLedgEntry.Reset();
        QualityItemLedgEntry.SetRange("Document No.", InspectRcpt."No.");
        QualityItemLedgEntry.SetRange(Hold, true);
        if QualityItemLedgEntry.FindSet() then begin
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
                    ItemJnlLine."Line No." := 10000;
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                    ItemJnlLine.VALIDATE("Item No.", InspectRcpt."Item No.");
                    ItemJnlLine.VALIDATE(Quantity, QtyToApply);

                    ItemJnlLine.VALIDATE("Location Code", QCSetup."Hold Location");
                    ItemJnlLine.VALIDATE("New Location Code", InspectRcpt."Location Code");
                    if not InspectRcpt."Item Tracking Exists" then
                        ItemJnlLine.VALIDATE("Applies-to Entry", QualityItemLedgEntry."Entry No.");
                    ItemJnlLine."Quality Ledger Entry No. B2B" := QualityItemLedgEntry."Entry No.";
                    ItemJnlLine."External Document No." := InspectRcpt."External Document No.";
                    ItemJnlLine."Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine."New Dimension Set ID" := InspectRcpt."Dimension Set ID";
                    ItemJnlLine.Validate("Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("New Shortcut Dimension 1 Code", InspectRcpt."Shortcut Dimension 1 Code");//B2BJK On 24mar2022
                    ItemJnlLine.Validate("New Shortcut Dimension 2 Code", InspectRcpt."Shortcut Dimension 2 Code");//B2BJK On 24mar2022;

                    ItemJnlLine.INSERT();
                    if InspectRcpt."Item Tracking Exists" then
                        UpdateResEntryQILE(ItemJnlLine, QualityItemLedgEntry);
                    ItemJnlPostLine.RUN(ItemJnlLine);
                    ItemApplnEntry.SETRANGE("Transferred-from Entry No.", QualityItemLedgEntry."Entry No.");
                    if ItemApplnEntry.FIND('+') then;
                    ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                    QualityItemLedgEntry2.TRANSFERFIELDS(ItemLedgEntry);
                    QualityItemLedgEntry2."Sent for Rework" := false;
                    QualityItemLedgEntry2.INSERT();
                    InspectRcpt."DC Inbound Ledger Entry." := QualityItemLedgEntry2."Entry No.";

                    QualityItemLedgEntry."Remaining Quantity" := QualityItemLedgEntry."Remaining Quantity" - QtyToApply;
                    if QualityItemLedgEntry."Remaining Quantity" = 0 then
                        QualityItemLedgEntry.DELETE()
                    else
                        QualityItemLedgEntry.MODIFY();
                end;
            until QualityItemLedgEntry.Next() = 0;
        end;
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

    [IntegrationEvent(false, false)]
    procedure OnBeforeModifyStatusInspRcptLine(var InspectRcptHdr: Record "Inspection Receipt Header B2B")
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
        cu12: Codeunit 22;

}


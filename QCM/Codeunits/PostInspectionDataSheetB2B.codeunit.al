codeunit 33000250 "Post-Inspection Data Sheet B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    TableNo = "Ins Datasheet Header B2B";

    trigger OnRun();
    begin
        QualitySetup.GET();
        QualitySetup.TESTFIELD("Posted Inspect. Datasheet Nos.");
        QualitySetup.TESTFIELD("Inspection Receipt Nos.");

        PostInspectData.TRANSFERFIELDS(Rec);

        if not QualitySetup."Posted IDS. No. is IDS No." then begin
            if Rec."Shortcut Dimension 1 Code" = 'DOM' then
                PostInspectData."No." := NoSeriesMgt.GetNextNo(QualitySetup."Posted Inspect. Datasheet Nos.", TODAY(), true)
            else
                if Rec."Shortcut Dimension 1 Code" = 'EOU' then
                    PostInspectData."No." := NoSeriesMgt.GetNextNo(QualitySetup."Posted InspectDatas Nos.(Eou)", TODAY(), true)
        end;
        InspReportNo := InsertInspectionReportHeader(PostInspectData);
        PostInspectData."Inspection Receipt No." := InspReportNo;

        PostInspectData."Posted Date" := WORKDATE();
        PostInspectData."Posted Time" := TIME();
        Evaluate(PostInspectData."Posted By", USERID());
        PostInspectData.INSERT();

        InspectDataLine.SETRANGE("Document No.", Rec."No.");
        InspectDataLine.SETCURRENTKEY("Character Group No.");
        InspectReport.SETRANGE("Document No.", InspReportNo);
        if InspectReport.FIND('+') then
            LineNo := InspectReport."Line No.";
        CharGroupCode := 0;
        if InspectDataLine.FIND('-') then
            repeat
                PostInspectDataLine.TRANSFERFIELDS(InspectDataLine);
                PostInspectDataLine."Document No." := PostInspectData."No.";
                PostInspectDataLine.INSERT();
                if CharGroupCode <> InspectDataLine."Character Group No." then begin
                    LineNo := LineNo + 1;
                    CharGroupCode := InspectDataLine."Character Group No.";
                    InspectReport.INIT();
                    InspectReport.TRANSFERFIELDS(InspectDataLine);
                    InspectReport."Document No." := InspReportNo;
                    InspectReport."Line No." := LineNo + 10000;
                    InspectReport."Receipt No." := Rec."Receipt No.";
                    InspectReport."Posting Date" := TODAY();
                    InspectReport."Item No." := Rec."Item No.";
                    InspectReport."Vendor No." := Rec."Vendor No.";
                    InspectReport."Purch Line No." := PostInspectData."Purch. Line No";
                    InspectReport."Posted Inspect Doc. No." := PostInspectData."No.";
                    InspectReport.INSERT();
                end;
            until InspectDataLine.NEXT() = 0;
        MESSAGE(Text000Msg);
        Rec.DELETE(true);
    end;

    var
        QualitySetup: Record "Quality Control Setup B2B";
        InspectDataLine: Record "Inspection Datasheet Line B2B";


        InspectReportHeader: Record "Inspection Receipt Header B2B";
        InspectReport: Record "Inspection Receipt Line B2B";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CharGroupCode: Integer;
        LineNo: Integer;
        Text000Msg: Label 'Document Posted successfully.';
        InspReportNo: Code[20];

    procedure InsertInspectionReportHeader(InspectHeader: Record "Posted Ins DatasheetHeader B2B"): Code[20];
    var
        QualityItemLedgEntry: Record "Quality Item Ledger Entry B2B";
        RemainQty: Decimal;
        QtyToApply: Decimal;
        ItemLedgerEntries: Record "Item Ledger Entry";
    begin
        if InspectHeader."Source Type" = InspectHeader."Source Type"::"In Bound" then begin
            if InspectReportHeader."Quality Before Receipt" then
                InspectReportHeader.SETRANGE("Order No.", InspectHeader."Order No.")
            else
                InspectReportHeader.SETRANGE("Receipt No.", InspectHeader."Receipt No.");
            InspectReportHeader.SETRANGE("Purch Line No", InspectHeader."Purch. Line No");
            InspectReportHeader.SETRANGE("Lot No.", InspectHeader."Lot No.");
            InspectReportHeader.SETRANGE("Purchase Consignment", InspectHeader."Purchase Consignment No.");
            InspectReportHeader.SETRANGE("Rework Reference No.", InspectHeader."Rework Reference No.");

        end else begin
            InspectReportHeader.SETRANGE("Prod. Order No.", InspectHeader."Prod. Order No.");
            InspectReportHeader.SETRANGE("Prod. Order Line", InspectHeader."Prod. Order Line");
            InspectReportHeader.SETRANGE("Production Batch No.", InspectHeader."Production Batch No.");
            InspectReportHeader.SETRANGE("Rework Reference No.", InspectHeader."Rework Reference No.");
        end;

        if not InspectReportHeader.FIND('-') then begin
            InspectReportHeader.INIT();
            InspectReportHeader."Receipt No." := InspectHeader."Receipt No.";
            if InspectHeader."Shortcut Dimension 1 Code" = 'DOM' then
                InspectReportHeader."No." := NoSeriesMgt.GetNextNo(QualitySetup."Inspection Receipt Nos.", TODAY(), true)
            else
                if InspectHeader."Shortcut Dimension 1 Code" = 'EOU' then
                    InspectReportHeader."No." := NoSeriesMgt.GetNextNo(QualitySetup."Inspection Receipt Nos.(Eou)", TODAY(), true);
            InspectReportHeader."Order No." := InspectHeader."Order No.";
            if InspectHeader."In Process" then begin
                InspectReportHeader."Posting Date" := WORKDATE();
                InspectReportHeader."Document Date" := WORKDATE();
            end else begin
                InspectReportHeader."Posting Date" := InspectHeader."Posting Date";
                InspectReportHeader."Document Date" := InspectHeader."Document Date";
            end;
            InspectReportHeader."Vendor No." := InspectHeader."Vendor No.";
            InspectReportHeader."Vendor Name" := InspectHeader."Vendor Name";
            InspectReportHeader."Vendor Name 2" := InspectHeader."Vendor Name 2";
            InspectReportHeader.Address := InspectHeader.Address;
            InspectReportHeader."Address 2" := InspectHeader."Address 2";
            InspectReportHeader."Contact Person" := '';
            InspectReportHeader."Item No." := InspectHeader."Item No.";
            InspectReportHeader."Item Description" := InspectHeader."Item Description";
            InspectReportHeader."External Document No." := InspectHeader."External Document No.";
            InspectReportHeader."Unit of Measure Code" := InspectHeader."Unit of Measure Code";
            InspectReportHeader."Created Date" := WORKDATE();
            InspectReportHeader.Quantity := InspectHeader.Quantity;
            InspectReportHeader."Spec ID" := InspectHeader."Spec ID";
            InspectReportHeader."Purch Line No" := InspectHeader."Purch. Line No";
            InspectReportHeader."Location Code" := InspectHeader.Location;
            InspectReportHeader."New Location Code" := InspectHeader."New Location";
            InspectReportHeader."Base Unit of Measure" := InspectHeader."Base Unit Of Measure";
            InspectReportHeader."Quantity(Base)" := InspectHeader."Quantity (Base)";
            InspectReportHeader."Lot No." := InspectHeader."Lot No.";
            InspectReportHeader."Vendor Lot No_B2B" := InspectHeader."Vendor Lot No_B2B";
            if InspectHeader."Rework Level" <> 0 then
                InspectReportHeader."DC Inbound Ledger Entry." := InspectHeader."DC Inbound Ledger Entry";
            InspectReportHeader."Serial No." := InspectHeader."Serial No.";
            InspectReportHeader."Item Tracking Exists" := InspectHeader."Item Tracking Exists";
            InspectReportHeader."Rework Reference No." := InspectHeader."Rework Reference No.";
            InspectReportHeader."Rework Level" := InspectHeader."Rework Level";

            InspectReportHeader."Item Ledger Entry No." := InspectHeader."Item Ledger Entry No.";
            InspectReportHeader."Prod. Order No." := InspectHeader."Prod. Order No.";
            InspectReportHeader."Prod. Order Line" := InspectHeader."Prod. Order Line";
            InspectReportHeader."Routing No." := InspectHeader."Routing No.";
            InspectReportHeader."Routing Reference No." := InspectHeader."Routing Reference No.";
            InspectReportHeader."Operation No." := InspectHeader."Operation No.";
            InspectReportHeader."Operation Description" := InspectHeader."Operation Description";
            InspectReportHeader."Sub Assembly Code" := InspectHeader."Sub Assembly Code";
            InspectReportHeader."Sub Assembly Description" := InspectHeader."Sub Assembly Description";
            InspectReportHeader."In Process" := InspectHeader."In Process";
            InspectReportHeader."Quality Before Receipt" := InspectHeader."Quality Before Receipt";
            InspectReportHeader."Source Type" := InspectHeader."Source Type";
            InspectReportHeader."Production Batch No." := InspectHeader."Production Batch No.";
            InspectReportHeader."Purchase Consignment" := InspectHeader."Purchase Consignment No.";
            InspectReportHeader."Shortcut Dimension 1 Code" := InspectHeader."Shortcut Dimension 1 Code";
            InspectReportHeader."Shortcut Dimension 2 Code" := InspectHeader."Shortcut Dimension 2 Code";
            InspectReportHeader."From Hold" := InspectHeader."From Hold";
            if (not InspectHeader."Item Tracking Exists") and (InspectReportHeader."From Hold") then begin
                ItemLedgerEntries.Reset();
                ItemLedgerEntries.SetRange("Document No.", InspectHeader."Rework Reference No.");
                ItemLedgerEntries.SetRange(open, true);
                if ItemLedgerEntries.FindFirst() then
                    InspectReportHeader."Item Ledger Entry No." := ItemLedgerEntries."Entry No.";
            end;
            OnBeforeInsertInspectionReportHeader(InspectReportHeader, InspectHeader);
            InspectReportHeader.INSERT();
            if InspectReportHeader."From Hold" then begin
                RemainQty := InspectReportHeader.Quantity;
                QualityItemLedgEntry.Reset();
                QualityItemLedgEntry.SETRANGE("Document No.", InspectReportHeader."Rework Reference No.");
                QualityItemLedgEntry.SetRange(Hold, false);
                if QualityItemLedgEntry.FindSet() then
                    repeat
                        if RemainQty <= QualityItemLedgEntry."Remaining Quantity" then
                            QtyToApply := RemainQty
                        else
                            QtyToApply := QualityItemLedgEntry."Remaining Quantity";
                        RemainQty := RemainQty - QtyToApply;
                        if QtyToApply <> 0 then begin
                            QualityItemLedgEntry."Document No." := InspectReportHeader."No.";
                            QualityItemLedgEntry.MODIFY();
                        end;
                        InspectReportHeader."Item Ledger Entry No." := QualityItemLedgEntry."Entry No.";
                        InspectReportHeader.Modify();
                    until QualityItemLedgEntry.Next() = 0;
            end;
            OnAfterInsertInspectionReportHeader(InspectReportHeader, InspectHeader);
        end;
        exit(InspectReportHeader."No.");

    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertInspectionReportHeader(var InspectReportHeader: Record "Inspection Receipt Header B2B"; InspectHeader: Record "Posted Ins DatasheetHeader B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInsertInspectionReportHeader(var InspectReportHeader: Record "Inspection Receipt Header B2B"; InspectHeader: Record "Posted Ins DatasheetHeader B2B")
    begin
    end;

    var
        PostInspectData: Record "Posted Ins DatasheetHeader B2B";
        PostInspectDataLine: Record "Posted Ins Datasheet Line B2B";

}


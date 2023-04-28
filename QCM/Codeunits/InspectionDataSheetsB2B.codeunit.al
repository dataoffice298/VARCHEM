codeunit 33000251 "Inspection Data Sheets B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    TableNo = "Inspection Lot B2B";

    trigger OnRun();
    begin
        Rec.TESTFIELD("Lot No.");
        if Rec."Inspect. Data Sheet Created" then
            if not CONFIRM(Text001QstLbl, false, Rec."Lot No.") then
                exit;
        PurchRcptLine.GET(Rec."Document No.", Rec."Purch. Line No.");
        PurchRcptHeader.SETRANGE("No.", Rec."Document No.");
        PurchRcptHeader.FIND('-');
        InspLot.COPY(Rec);
        InitInspectionHeader(InspectionType::"Purchase Lot");
        InsertInspectionDataHeader(PurchRcptHeader."Shortcut Dimension 1 Code");

        if not CheckVendorQualityApproval(PurchRcptLine, true) then
            exit;
        Rec."Inspect. Data Sheet Created" := true;
        Rec.MODIFY();
        MESSAGE(Text000Msg);
    end;

    var
        QualitySetup: Record "Quality Control Setup B2B";
        SpecLine: Record "Specification Line B2B";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        InspLot: Record "Inspection Lot B2B";
        ProdOrderLine: Record "Prod. Order Line";
        InspectDataHeader: Record "Ins Datasheet Header B2B";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        InspectDataLine: Record "Inspection Datasheet Line B2B";
        InspectionReceipt: Record "Inspection Receipt Header B2B";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry1: Record "Quality Item Ledger Entry B2B";
        Item: Record Item;
        ProdOrderLine1: Record "Prod. Order Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;

        Samplesize: Integer;
        InspectLineNo: Integer;
        Text000Msg: Label 'Inspection Data Sheets created successfully.';

        InspectionType: Option Purchase,"Purchase Lot",Rework,"Production Order","Purchase Before Inspection",Hold;
        QCSetupRead: Boolean;
        Flag: Boolean;
        LotMin: Decimal;
        LotMax: Decimal;
        AllowableDefects: Decimal;
        SamplingSize: Decimal;
        Text003Msg: Label 'There is nothing to create Inspection Data Sheets.';
        Text004Msg: Label 'Inspection Data Sheets are created for %1 Purchase Lines.', comment = '%1 = NoOfInspectDS';
        Text005Err: Label 'Purchase Order No. does not exist.';
        Text006Err: Label 'Sample Plan %1 is out of range for the Lot %2.', Comment = '%1 = sampling Code ; %2 = Lot No.';
        Text007Qst: Label 'Vendor Quality Approval exists.Do you want to create Inspection Lines?';
        Text001QstLbl: Label 'Inspection Data Sheets already exits for the Lot No. %1.\Do you want to create Inpection Data Sheets again?', comment = '%1 = Lot No';



    procedure "CreatePur.LineInspectDataSheet"(PurchRcptHeader2: Record "Purch. Rcpt. Header"; PurchRcptLine2: Record "Purch. Rcpt. Line");
    begin
        PurchRcptHeader.COPY(PurchRcptHeader2);
        PurchRcptLine.COPY(PurchRcptLine2);
        if not CheckVendorQualityApproval(PurchRcptLine, true) then
            exit;
        if PurchRcptLine."Item Rcpt. Entry No." = 0 then
            CreateLotTrackInspectDataSheet(PurchRcptLine2)
        else begin
            InitInspectionHeader(InspectionType::Purchase);
            InsertInspectionDataHeader(PurchRcptHeader."Shortcut Dimension 1 Code");
            ItemLedgEntry.GET(PurchRcptLine."Item Rcpt. Entry No.");
            ItemLedgEntry1.INIT();
            ItemLedgEntry1.TRANSFERFIELDS(ItemLedgEntry);
            ItemLedgEntry1.INSERT();
        end;
        MESSAGE(Text000Msg);
    end;

    procedure CreatePurLineInspectDataSheet(PurchHeader2: Record "Purchase Header"; var PurchLine2: Record "Purchase Line");
    begin
        PurchHeader.COPY(PurchHeader2);
        PurchLine.COPY(PurchLine2);
        InitInspectionHeader(InspectionType::"Purchase Before Inspection");
        InsertInspectionDataHeader(PurchHeader."Shortcut Dimension 1 Code");
        PurchLine2."Qty. Sent to Quality B2B" := PurchLine2."Qty. Sent to Quality B2B" + PurchLine2."Qty. Sending to Quality B2B";
        PurchLine2."Qty. Sending to Quality B2B" := 0;
        PurchLine2.MODIFY();
        MESSAGE(Text000Msg);
    end;

    procedure CreateLotTrackInspectDataSheet(PurchRcptLine2: Record "Purch. Rcpt. Line");
    var

    begin
        if PurchRcptLine."Quality Before Receipt B2B" then
            exit;
        PurchRcptLine.COPY(PurchRcptLine2);
        PurchRcptHeader.GET(PurchRcptLine2."Document No.");
        CopyItemTrackingLots(PurchRcptLine2);
        InspectLot.reset();
        InspectLot.SETRANGE("Document No.", PurchRcptLine2."Document No.");
        InspectLot.SETRANGE("Purch. Line No.", PurchRcptLine2."Line No.");
        if InspectLot.FIND('-') then
            repeat
                InspLot.COPY(InspectLot);
                InitInspectionHeader(InspectionType::"Purchase Lot");
                InsertInspectionDataHeader(PurchRcptHeader."Shortcut Dimension 1 Code");
                InspectLot."Inspect. Data Sheet Created" := true;
                InspectLot.MODIFY();

            until InspectLot.NEXT() = 0;
    end;

    procedure CreateReworkInspectDataSheets(var InspectReceipt: Record "Inspection Receipt Header B2B");
    begin
        InspectReceipt.TESTFIELD("Qty. to Receive(Rework)");
        InspectReceipt."Last Rework Level" := InspectReceipt."Rework Level" - 1;
        if InspectReceipt."Last Rework Level" < 0 then
            InspectReceipt."Last Rework Level" := 0;
        InspectReceipt."Rework Inspect DS Created" := true;
        InspectReceipt.MODIFY();
        if InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound" then begin
            if InspectReceipt."Quality Before Receipt" then begin
                if not PurchLine.GET(PurchLine."Document Type"::Order, InspectReceipt."Order No.", InspectReceipt."Purch Line No") then
                    ERROR(Text005Err);
                PurchHeader.GET(PurchHeader."Document Type"::Order, InspectReceipt."Order No.");
            end else begin
                PurchRcptLine.GET(InspectReceipt."Receipt No.", InspectReceipt."Purch Line No");
                PurchRcptHeader.SETRANGE("No.", InspectReceipt."Receipt No.");
                PurchRcptHeader.FIND('-')
            end;
        end else
            if InspectReceipt."In Process" then
                ProdOrderRoutingLine.GET(ProdOrderRoutingLine.Status::Released, InspectReceipt."Prod. Order No.", InspectReceipt."Routing Reference No.", InspectReceipt."Routing No.", InspectReceipt."Operation No.")
            else
                ProdOrderLine.GET(ProdOrderLine.Status::Released, InspectReceipt."Prod. Order No.", InspectReceipt."Prod. Order Line");

        InspectionReceipt := InspectReceipt;
        InitInspectionHeader(InspectionType::Rework);
        InspectDataHeader."Rework Level" := InspectReceipt."Rework Level" + 1;
        InsertInspectionDataHeader(InspectionReceipt."Shortcut Dimension 1 Code");
        MESSAGE(Text000Msg);
    end;

    procedure CreateHoldInspectDataSheets(var InspectReceipt: Record "Inspection Receipt Header B2B");
    begin
        InspectReceipt.TESTFIELD("Qty. to Receive(Hold)");
        InspectReceipt."Rework Inspect DS Created" := true;
        InspectReceipt.MODIFY();
        if InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound" then begin
            if InspectReceipt."Quality Before Receipt" then begin
                if not PurchLine.GET(PurchLine."Document Type"::Order, InspectReceipt."Order No.", InspectReceipt."Purch Line No") then
                    ERROR(Text005Err);
                PurchHeader.GET(PurchHeader."Document Type"::Order, InspectReceipt."Order No.");
            end else begin
                PurchRcptLine.GET(InspectReceipt."Receipt No.", InspectReceipt."Purch Line No");
                PurchRcptHeader.SETRANGE("No.", InspectReceipt."Receipt No.");
                PurchRcptHeader.FIND('-')
            end;
        end else
            if InspectReceipt."In Process" then
                ProdOrderRoutingLine.GET(ProdOrderRoutingLine.Status::Released, InspectReceipt."Prod. Order No.", InspectReceipt."Routing Reference No.", InspectReceipt."Routing No.", InspectReceipt."Operation No.")
            else
                ProdOrderLine.GET(ProdOrderLine.Status::Released, InspectReceipt."Prod. Order No.", InspectReceipt."Prod. Order Line");

        InspectionReceipt := InspectReceipt;
        InitInspectionHeader(InspectionType::Hold);
        InsertInspectionDataHeader(InspectionReceipt."Shortcut Dimension 1 Code");
        MESSAGE(Text000Msg);
    end;

    procedure CreateProdLineInspectDataSheet(var ProdOrderLine2: Record "Prod. Order Line");
    begin
        ProdOrderLine2.TESTFIELD("WIP QC Enabled B2B", true);
        ProdOrderLine2.TESTFIELD("Qty Sending to Quality B2B");
        ProdOrderLine := ProdOrderLine2;
        InitInspectionHeader(InspectionType::"Production Order");
        InsertInspectionDataHeader(ProdOrderLine."Shortcut Dimension 1 Code");
        ProdOrderLine2."Quantity Sent to Quality B2B" := ProdOrderLine2."Quantity Sent to Quality B2B" +
                                                       ProdOrderLine2."Qty Sending to Quality B2B";
        ProdOrderLine2."Qty Sending to Quality B2B" := 0;
        ProdOrderLine2.MODIFY();
        MESSAGE(Text000Msg);
    end;

    procedure CreateInprocInspectDataSheet(var ProdOrderRoutingLine2: Record "Prod. Order Routing Line");
    begin
        if not ProdOrderRoutingLine2."QC Enabled B2B" then
            exit;
        ProdOrderRoutingLine2.TESTFIELD("Sub Assembly B2B");
        ProdOrderRoutingLine2.TESTFIELD("Spec ID B2B");
        ProdOrderRoutingLine2.TESTFIELD("Qty. to Produce B2B");
        ProdOrderRoutingLine := ProdOrderRoutingLine2;
        InitInspectionHeader(InspectionType::"Production Order");
        InsertInspectionDataHeader(ProdOrderLine."Shortcut Dimension 1 Code");
        ProdOrderRoutingLine2."Quantity Produced B2B" := ProdOrderRoutingLine2."Quantity Produced B2B" + ProdOrderRoutingLine2."Qty. to Produce B2B";
        ProdOrderRoutingLine2."Quantity Sent to Quality B2B" := ProdOrderRoutingLine2."Quantity Produced B2B";
        if ProdOrderRoutingLine2."Quantity B2B" - ProdOrderRoutingLine2."Quantity Produced B2B" > 0 then
            ProdOrderRoutingLine2."Qty. to Produce B2B" := ProdOrderRoutingLine2."Quantity B2B" - ProdOrderRoutingLine2."Quantity Produced B2B"
        else
            ProdOrderRoutingLine2."Qty. to Produce B2B" := 0;
        ProdOrderRoutingLine2.MODIFY();
        MESSAGE(Text000Msg);
    end;

    procedure InitInspectionHeader(InspectionType: Option Purchase,"Purchase Lot",Rework,"Production Order","Purchase Before Inspection",Hold);
    var
        DeliveryReceipt: Record "Delivery/Receipt Entry B2B";
    begin
        QCSetup();
        QualitySetup.TESTFIELD("Inspection Datasheet Nos.");

        InspectDataHeader.INIT();
        Evaluate(InspectDataHeader."Created By", USERID());
        InspectDataHeader."Created Date" := WORKDATE();
        InspectDataHeader."Created Time" := TIME();

        case InspectionType of
            InspectionType::Purchase:
                begin
                    InspectDataHeader.Description := PurchRcptHeader."Buy-from Vendor No.";
                    InspectDataHeader."Receipt No." := PurchRcptHeader."No.";
                    InspectDataHeader."Order No." := PurchRcptHeader."Order No.";
                    InspectDataHeader."Posting Date" := PurchRcptHeader."Posting Date";
                    InspectDataHeader."Document Date" := PurchRcptHeader."Document Date";
                    InspectDataHeader."Vendor No." := PurchRcptHeader."Buy-from Vendor No.";
                    InspectDataHeader."Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                    InspectDataHeader."Vendor Name 2" := PurchRcptHeader."Buy-from Vendor Name 2";
                    InspectDataHeader.Address := PurchRcptHeader."Buy-from Address";
                    InspectDataHeader."Address 2" := PurchRcptHeader."Buy-from Address 2";
                    InspectDataHeader."Contact Person" := PurchRcptHeader."Buy-from Contact";
                    InspectDataHeader.Location := PurchRcptLine."Location Code";
                    InspectDataHeader."Item Ledger Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    InspectDataHeader."Source Type" := InspectDataHeader."Source Type"::"In Bound";
                    if Item.GET(PurchRcptLine."No.") then;
                    InspectDataHeader."External Document No." := PurchRcptHeader."Vendor Shipment No.";
                    InspectDataHeader."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
                    InspectDataHeader."Spec Version" := PurchRcptLine."Spec Version B2B";
                    InspectDataHeader."Qty. per Unit of Measure" := PurchRcptLine."Qty. per Unit of Measure";
                    InspectDataHeader."Base Unit of Measure" := Item."Base Unit of Measure";
                    InspectDataHeader."Quantity (Base)" := PurchRcptLine."Quantity (Base)";
                    if InspectDataHeader."Item Ledger Entry No." = 0 then
                        InspectDataHeader."Item Tracking Exists" := true;
                    InspectDataHeader."Item No." := PurchRcptLine."No.";
                    InspectDataHeader."Item Description" := PurchRcptLine.Description;
                    InspectDataHeader.Quantity := PurchRcptLine.Quantity;
                    CheckSpecCertified(PurchRcptLine."Spec ID B2B");
                    InspectDataHeader."Spec ID" := PurchRcptLine."Spec ID B2B";
                    InspectDataHeader."Purch. Line No" := PurchRcptLine."Line No.";
                    InspectDataHeader."Shortcut Dimension 1 Code" := PurchRcptHeader."Shortcut Dimension 1 Code";
                    InspectDataHeader."Shortcut Dimension 2 Code" := PurchRcptHeader."Shortcut Dimension 2 Code";
                    OnAfterInitInspectionHeaderInsTypePurchase(InspectDataHeader, PurchRcptHeader, PurchRcptLine);
                end;
            InspectionType::"Purchase Before Inspection":
                begin
                    InspectDataHeader.Description := PurchHeader."Buy-from Vendor No.";
                    InspectDataHeader."Receipt No." := '';
                    InspectDataHeader."Order No." := PurchHeader."No.";
                    InspectDataHeader."Posting Date" := PurchHeader."Posting Date";
                    InspectDataHeader."Document Date" := PurchHeader."Document Date";
                    InspectDataHeader."Vendor No." := PurchHeader."Buy-from Vendor No.";
                    InspectDataHeader."Vendor Name" := PurchHeader."Buy-from Vendor Name";
                    InspectDataHeader."Vendor Name 2" := PurchHeader."Buy-from Vendor Name 2";
                    InspectDataHeader.Address := PurchHeader."Buy-from Address";
                    InspectDataHeader."Address 2" := PurchHeader."Buy-from Address 2";
                    InspectDataHeader."Contact Person" := PurchHeader."Buy-from Contact";
                    InspectDataHeader.Location := PurchLine."Location Code";
                    InspectDataHeader."Source Type" := InspectDataHeader."Source Type"::"In Bound";
                    InspectDataHeader."Item No." := PurchLine."No.";
                    InspectDataHeader."Item Description" := PurchLine.Description;
                    InspectDataHeader."External Document No." := PurchHeader."Vendor Shipment No.";
                    InspectDataHeader."Unit of Measure Code" := PurchLine."Unit of Measure Code";
                    InspectDataHeader."Spec Version" := PurchLine."Spec Version B2B";
                    InspectDataHeader.Quantity := PurchLine."Qty. Sending to Quality B2B";
                    CheckSpecCertified(PurchLine."Spec ID B2B");
                    InspectDataHeader."Spec ID" := PurchLine."Spec ID B2B";
                    InspectDataHeader."Purch. Line No" := PurchLine."Line No.";
                    InspectDataHeader."Quality Before Receipt" := true;
                    InspectDataHeader."Qty. per Unit of Measure" := PurchRcptLine."Qty. per Unit of Measure";
                    InspectDataHeader."Base Unit of Measure" := Item."Base Unit of Measure";
                    InspectDataHeader."Quantity (Base)" := PurchLine."Quantity (Base)";
                    InspectDataHeader."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                    InspectDataHeader."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                    QualitySetup.TESTFIELD("Purchase Consignment No.");
                    InspectDataHeader."Purchase Consignment No." := NoSeriesMgt.GetNextNo(QualitySetup."Purchase Consignment No.", 0D, true);
                    OnAfterInitInspectioHeaderInsTypePurchaseBeforeInspection(InspectDataHeader, PurchHeader, PurchLine);
                end;

            InspectionType::"Production Order":
                begin
                    InspectDataHeader."Source Type" := InspectDataHeader."Source Type"::WIP;
                    InspectDataHeader."Posting Date" := WORKDATE();
                    InspectDataHeader."Document Date" := WORKDATE();
                    if ProdOrderLine."Item No." <> '' then begin
                        InspectDataHeader."Item No." := ProdOrderLine."Item No.";
                        InspectDataHeader."Item Description" := ProdOrderLine.Description;
                        InspectDataHeader."Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
                        InspectDataHeader."Spec Version" := ProdOrderLine."Spec Version Code B2B";
                        InspectDataHeader.Quantity := ProdOrderLine."Qty Sending to Quality B2B";
                        CheckSpecCertified(ProdOrderLine."WIP Spec ID B2B");
                        InspectDataHeader."Spec ID" := ProdOrderLine."WIP Spec ID B2B";
                        InspectDataHeader."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                        InspectDataHeader."Prod. Order Line" := ProdOrderLine."Line No.";
                        InspectDataHeader."Routing No." := ProdOrderLine."Routing No.";
                        InspectDataHeader."Routing Reference No." := ProdOrderLine."Routing Reference No.";
                        InspectDataHeader.Location := ProdOrderLine."Location Code";
                        InspectDataHeader."Qty. per Unit of Measure" := PurchRcptLine."Qty. per Unit of Measure";
                        InspectDataHeader."Base Unit of Measure" := Item."Base Unit of Measure";
                        InspectDataHeader."Quantity (Base)" := PurchRcptLine."Quantity (Base)";
                        InspectDataHeader."Shortcut Dimension 1 Code" := ProdOrderLine."Shortcut Dimension 1 Code";
                        InspectDataHeader."Shortcut Dimension 2 Code" := ProdOrderLine."Shortcut Dimension 2 Code";
                    end else begin

                        InspectDataHeader."Sub Assembly Code" := ProdOrderRoutingLine."Sub Assembly B2B";
                        InspectDataHeader."Sub Assembly Description" := ProdOrderRoutingLine."Sub Assembly Description B2B";
                        InspectDataHeader."Unit of Measure Code" := ProdOrderRoutingLine."Sub Assembly UOM Code B2B";
                        InspectDataHeader.Quantity := ProdOrderRoutingLine."Qty. to Produce B2B";
                        InspectDataHeader."Prod. Order Line" := ProdOrderRoutingLine."Routing Reference No.";
                        CheckSpecCertified(ProdOrderRoutingLine."Spec ID B2B");
                        InspectDataHeader."Spec ID" := ProdOrderRoutingLine."Spec ID B2B";
                        InspectDataHeader."Prod. Order No." := ProdOrderRoutingLine."Prod. Order No.";
                        ProdOrderLine1.INIT();
                        ProdOrderLine1.SETRANGE("Prod. Order No.", InspectDataHeader."Prod. Order No.");
                        ProdOrderLine1.SETRANGE("Line No.", ProdOrderRoutingLine."Routing Reference No.");
                        if ProdOrderLine1.FIND('-') then begin
                            InspectDataHeader."Item No." := ProdOrderLine1."Item No.";
                            InspectDataHeader."Item Description" := ProdOrderLine1.Description;
                            InspectDataHeader.Location := ProdOrderLine1."Location Code";
                        end;
                        InspectDataHeader."Routing No." := ProdOrderRoutingLine."Routing No.";
                        InspectDataHeader."Routing Reference No." := ProdOrderRoutingLine."Routing Reference No.";
                        InspectDataHeader."Operation No." := ProdOrderRoutingLine."Operation No.";
                        InspectDataHeader."Operation Description" := ProdOrderRoutingLine.Description;
                        InspectDataHeader."In Process" := true;
                    end;

                    QualitySetup.TESTFIELD("Production Batch No.");
                    InspectDataHeader."Production Batch No." := NoSeriesMgt.GetNextNo(QualitySetup."Production Batch No.", 0D, true);
                    OnAfterInitInspectionHeaderInsTypeProductionOrder(InspectDataHeader, ProdOrderLine, PurchRcptLine, ProdOrderRoutingLine, ProdOrderLine1);
                end;
            InspectionType::"Purchase Lot":
                begin
                    InspectDataHeader.Description := PurchRcptHeader."Buy-from Vendor No.";
                    InspectDataHeader."Receipt No." := PurchRcptHeader."No.";
                    InspectDataHeader."Order No." := PurchRcptHeader."Order No.";
                    InspectDataHeader."Posting Date" := PurchRcptHeader."Posting Date";
                    InspectDataHeader."Document Date" := PurchRcptHeader."Document Date";
                    InspectDataHeader."Vendor No." := PurchRcptHeader."Buy-from Vendor No.";
                    InspectDataHeader."Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                    InspectDataHeader."Vendor Name 2" := PurchRcptHeader."Buy-from Vendor Name 2";
                    InspectDataHeader.Address := PurchRcptHeader."Buy-from Address";
                    InspectDataHeader."Address 2" := PurchRcptHeader."Buy-from Address 2";
                    InspectDataHeader."Contact Person" := PurchRcptHeader."Buy-from Contact";
                    InspectDataHeader.Location := PurchRcptLine."Location Code";
                    InspectDataHeader."Item Ledger Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    InspectDataHeader."Source Type" := InspectDataHeader."Source Type"::"In Bound";
                    InspectDataHeader."External Document No." := PurchRcptHeader."Vendor Shipment No.";
                    InspectDataHeader."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
                    InspectDataHeader."Spec Version" := PurchRcptLine."Spec Version B2B";
                    InspectDataHeader."Item Tracking Exists" := true;
                    InspectDataHeader."Quality Before Receipt" := false;
                    InspectDataHeader."Item No." := InspLot."Item No.";
                    InspectDataHeader."Item Description" := InspLot."Item Description";
                    InspectDataHeader.Quantity := InspLot.Quantity;
                    CheckSpecCertified(InspLot."Spec ID");
                    InspectDataHeader."Spec ID" := InspLot."Spec ID";
                    InspectDataHeader."Purch. Line No" := InspLot."Purch. Line No.";
                    InspectDataHeader.validate("Lot No.", InspLot."Lot No.");
                    InspectDataHeader."Vendor Lot No_B2B" := InspLot."Vendor Lot No_B2B";
                    InspectDataHeader."Qty. per Unit of Measure" := PurchRcptLine."Qty. per Unit of Measure";
                    InspectDataHeader."Base Unit of Measure" := Item."Base Unit of Measure";
                    InspectDataHeader."Quantity (Base)" := PurchRcptLine."Quantity (Base)";
                    InspectDataHeader."Shortcut Dimension 1 Code" := PurchRcptHeader."Shortcut Dimension 1 Code";
                    InspectDataHeader."Shortcut Dimension 2 Code" := PurchRcptHeader."Shortcut Dimension 2 Code";
                    OnAfterInitInspectionHeaderInsTypePurchaseLot(InspectDataHeader, PurchRcptHeader, PurchRcptLine, InspLot);
                end;
            InspectionType::Rework:
                begin
                    InspectDataHeader.Description := InspectionReceipt."Vendor No.";
                    InspectDataHeader."Receipt No." := InspectionReceipt."Receipt No.";
                    InspectDataHeader."Order No." := InspectionReceipt."Order No.";
                    InspectDataHeader."Purch. Line No" := InspectionReceipt."Purch Line No";
                    InspectDataHeader."Lot No." := InspectionReceipt."Lot No.";
                    InspectDataHeader."Vendor Lot No_B2B" := InspectionReceipt."Vendor Lot No_B2B";
                    InspectDataHeader."Posting Date" := InspectionReceipt."Posting Date";
                    InspectDataHeader."Document Date" := InspectionReceipt."Document Date";
                    InspectDataHeader."Vendor No." := InspectionReceipt."Vendor No.";
                    InspectDataHeader."Vendor Name" := InspectionReceipt."Vendor Name";
                    InspectDataHeader."Vendor Name 2" := InspectionReceipt."Vendor Name 2";
                    InspectDataHeader.Address := InspectionReceipt.Address;
                    InspectDataHeader."Address 2" := InspectionReceipt."Address 2";
                    InspectDataHeader."Contact Person" := InspectionReceipt."Contact Person";
                    if InspectionReceipt."Item Tracking Exists" then
                        if DeliveryReceipt.GET(InspectionReceipt."Rework Reference Document No.") then
                            InspectDataHeader."Serial No." := DeliveryReceipt."Serial No.";
                    InspectDataHeader."Item Tracking Exists" := InspectionReceipt."Item Tracking Exists";
                    InspectDataHeader."DC Inbound Ledger Entry" := InspectionReceipt."DC Inbound Ledger Entry.";
                    InspectDataHeader."Item No." := InspectionReceipt."Item No.";
                    InspectDataHeader."Item Description" := InspectionReceipt."Item Description";
                    InspectDataHeader."External Document No." := InspectionReceipt."External Document No.";
                    InspectDataHeader."Unit of Measure Code" := InspectionReceipt."Unit of Measure Code";
                    InspectDataHeader."Spec Version" := InspectionReceipt."Spec Version";
                    InspectDataHeader.Quantity := InspectionReceipt."Qty. to Receive(Rework)";
                    CheckSpecCertified(InspectionReceipt."Spec ID");
                    InspectDataHeader."Spec ID" := InspectionReceipt."Spec ID";
                    InspectDataHeader."Rework Level" := InspectionReceipt."Last Rework Level";
                    InspectDataHeader."Rework Reference No." := InspectionReceipt."No.";
                    InspectDataHeader.Location := InspectionReceipt."Location Code";
                    InspectDataHeader."Item Ledger Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    if (InspectDataHeader."Item Ledger Entry No." = 0) and (not InspectionReceipt."From Hold") then
                        InspectDataHeader."Item Ledger Entry No." := InspectDataHeader."DC Inbound Ledger Entry";
                    InspectDataHeader."Quality Before Receipt" := InspectionReceipt."Quality Before Receipt";
                    InspectDataHeader."Source Type" := InspectionReceipt."Source Type";
                    if InspectionReceipt."Source Type" = InspectionReceipt."Source Type"::"In Bound" then begin
                        QualitySetup.TestField("Purchase Consignment No.");
                        InspectDataHeader."Purchase Consignment No." := NoSeriesMgt.GetNextNo(QualitySetup."Purchase Consignment No.", 0D, true)
                    end else begin
                        QualitySetup.TESTFIELD("Production Batch No.");
                        InspectDataHeader."Production Batch No." := NoSeriesMgt.GetNextNo(QualitySetup."Production Batch No.", 0D, true);
                    end;
                    InspectDataHeader."Prod. Order No." := InspectionReceipt."Prod. Order No.";
                    InspectDataHeader."Prod. Order Line" := InspectionReceipt."Prod. Order Line";
                    InspectDataHeader."Routing Reference No." := InspectionReceipt."Routing Reference No.";
                    InspectDataHeader."Routing No." := InspectionReceipt."Routing No.";
                    InspectDataHeader."Operation No." := InspectionReceipt."Operation No.";
                    InspectDataHeader."Operation Description" := InspectionReceipt."Operation Description";
                    InspectDataHeader."Sub Assembly Code" := InspectionReceipt."Sub Assembly Code";
                    InspectDataHeader."Sub Assembly Description" := InspectionReceipt."Sub Assembly Description";
                    InspectDataHeader."In Process" := InspectionReceipt."In Process";
                    InspectDataHeader."Production Batch No." := InspectionReceipt."Production Batch No.";
                    InspectDataHeader."Shortcut Dimension 1 Code" := InspectionReceipt."Shortcut Dimension 1 Code";
                    InspectDataHeader."Shortcut Dimension 2 Code" := InspectionReceipt."Shortcut Dimension 2 Code";
                    InspectDataHeader."From Hold" := InspectionReceipt."From Hold"; //QC1.2
                    OnAfterInitInspectionHeaderInsTypeRework(InspectDataHeader, InspectionReceipt, PurchRcptLine);
                end;
            InspectionType::Hold:
                begin
                    InspectDataHeader.Description := InspectionReceipt."Vendor No.";
                    InspectDataHeader."Receipt No." := InspectionReceipt."Receipt No.";
                    InspectDataHeader."Order No." := InspectionReceipt."Order No.";
                    InspectDataHeader."Purch. Line No" := InspectionReceipt."Purch Line No";
                    InspectDataHeader."Lot No." := InspectionReceipt."Lot No.";
                    InspectDataHeader."Vendor Lot No_B2B" := InspectionReceipt."Vendor Lot No_B2B";
                    InspectDataHeader."Posting Date" := InspectionReceipt."Posting Date";
                    InspectDataHeader."Document Date" := InspectionReceipt."Document Date";
                    InspectDataHeader."Vendor No." := InspectionReceipt."Vendor No.";
                    InspectDataHeader."Vendor Name" := InspectionReceipt."Vendor Name";
                    InspectDataHeader."Vendor Name 2" := InspectionReceipt."Vendor Name 2";
                    InspectDataHeader.Address := InspectionReceipt.Address;
                    InspectDataHeader."Address 2" := InspectionReceipt."Address 2";
                    InspectDataHeader."Contact Person" := InspectionReceipt."Contact Person";
                    if InspectionReceipt."Item Tracking Exists" then
                        if DeliveryReceipt.GET(InspectionReceipt."Rework Reference Document No.") then
                            InspectDataHeader."Serial No." := DeliveryReceipt."Serial No.";
                    InspectDataHeader."Item Tracking Exists" := InspectionReceipt."Item Tracking Exists";
                    InspectDataHeader."DC Inbound Ledger Entry" := InspectionReceipt."DC Inbound Ledger Entry.";
                    InspectDataHeader."Item No." := InspectionReceipt."Item No.";
                    InspectDataHeader."Item Description" := InspectionReceipt."Item Description";
                    InspectDataHeader."External Document No." := InspectionReceipt."External Document No.";
                    InspectDataHeader."Unit of Measure Code" := InspectionReceipt."Unit of Measure Code";
                    InspectDataHeader."Spec Version" := InspectionReceipt."Spec Version";
                    InspectDataHeader.Quantity := InspectionReceipt."Qty. to Receive(Hold)";
                    CheckSpecCertified(InspectionReceipt."Spec ID");
                    InspectDataHeader."Spec ID" := InspectionReceipt."Spec ID";
                    //InspectDataHeader."Rework Level" := InspectionReceipt."Rework Level" + 1;
                    InspectDataHeader."From Hold" := true;
                    InspectDataHeader."Rework Reference No." := InspectionReceipt."No.";
                    InspectDataHeader.Location := InspectionReceipt."Location Code";
                    InspectDataHeader."Item Ledger Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    InspectDataHeader."Quality Before Receipt" := InspectionReceipt."Quality Before Receipt";
                    InspectDataHeader."Source Type" := InspectionReceipt."Source Type";
                    if InspectionReceipt."Source Type" = InspectionReceipt."Source Type"::"In Bound" then begin
                        QualitySetup.TestField("Purchase Consignment No.");
                        InspectDataHeader."Purchase Consignment No." := NoSeriesMgt.GetNextNo(QualitySetup."Purchase Consignment No.", 0D, true)
                    end else begin
                        QualitySetup.TESTFIELD("Production Batch No.");
                        InspectDataHeader."Production Batch No." := NoSeriesMgt.GetNextNo(QualitySetup."Production Batch No.", 0D, true);
                    end;
                    InspectDataHeader."Prod. Order No." := InspectionReceipt."Prod. Order No.";
                    InspectDataHeader."Prod. Order Line" := InspectionReceipt."Prod. Order Line";
                    InspectDataHeader."Routing Reference No." := InspectionReceipt."Routing Reference No.";
                    InspectDataHeader."Routing No." := InspectionReceipt."Routing No.";
                    InspectDataHeader."Operation No." := InspectionReceipt."Operation No.";
                    InspectDataHeader."Operation Description" := InspectionReceipt."Operation Description";
                    InspectDataHeader."Sub Assembly Code" := InspectionReceipt."Sub Assembly Code";
                    InspectDataHeader."Sub Assembly Description" := InspectionReceipt."Sub Assembly Description";
                    InspectDataHeader."In Process" := InspectionReceipt."In Process";
                    InspectDataHeader."Production Batch No." := InspectionReceipt."Production Batch No.";
                    InspectDataHeader."Shortcut Dimension 1 Code" := InspectionReceipt."Shortcut Dimension 1 Code";
                    InspectDataHeader."Shortcut Dimension 2 Code" := InspectionReceipt."Shortcut Dimension 2 Code";
                    OnAfterInitInspectionHeaderInsTypeHold(InspectDataHeader, InspectionReceipt, PurchRcptLine);
                end;
        end;

        if itemrec.get(InspectDataHeader."Item No.") then
            InspectDataHeader."New Location" := Itemrec."Rejection Location B2B";
    end;

    procedure InsertInspectionDataHeader(ShortCutDimension1Code: Code[20]);
    var
        InspectGroup: Code[20];
    begin
        SpecLine.RESET();
        SpecLine.SETRANGE("Spec ID", InspectDataHeader."Spec ID");
        SpecLine.SETCURRENTKEY("Inspection Group Code");
        if SpecLine.FIND('-') then begin
            InspectGroup := SpecLine."Inspection Group Code";
            SpecLine.MARK(true);
        end;
        if SpecLine.NEXT() <> 0 then
            repeat
                if InspectGroup <> SpecLine."Inspection Group Code" then begin
                    InspectGroup := SpecLine."Inspection Group Code";
                    SpecLine.MARK(true);
                end;
            until SpecLine.NEXT() = 0;
        SpecLine.MARKEDONLY(true);

        if SpecLine.FIND('-') then
            repeat
                if ShortCutDimension1Code = 'DOM' then
                    InspectDataHeader."No." := NoSeriesMgt.GetNextNo(QualitySetup."Inspection Datasheet Nos.", 0D, true)
                else
                    if ShortCutDimension1Code = 'EOU' then
                        InspectDataHeader."No." := NoSeriesMgt.GetNextNo(QualitySetup."Inspection Datasheet Nos.(Eou)", 0D, true);
                InspectDataHeader."Inspection Group Code" := SpecLine."Inspection Group Code";
                InsertInspectionDataLine(SpecLine."Inspection Group Code");
                if Flag then begin
                    OnBeforeInsertInspectionDataHeader(InspectDataHeader, SpecLine);
                    InspectDataHeader.INSERT(true);
                    OnAfterInsertInspectionDataHeader(InspectDataHeader, SpecLine);
                end;
            until SpecLine.NEXT() = 0;
    end;

    procedure InsertInspectionDataLine(InspectCode: Code[20]);
    var

        CharGroupNo: Integer;
    begin
        Flag := false;
        SpecLine1.RESET();
        SpecLine1.SETRANGE("Spec ID", InspectDataHeader."Spec ID");
        SpecLine1.SETCURRENTKEY("Inspection Group Code");
        SpecLine1.SETRANGE("Inspection Group Code", InspectCode);
        InspectLineNo := 1;
        CharGroupNo := 0;
        Samplesize := 0;
        if SpecLine1.FIND('-') then
            repeat
                if SpecLine1."Character Type" = SpecLine1."Character Type"::Standard then
                    Samplesize := Samplesize + FindSamplingSize(InspectDataHeader, SpecLine1)
                else
                    Samplesize := Samplesize + 1;
                CharGroupNo := CharGroupNo + 1;
                while (InspectLineNo <= Samplesize) do begin
                    InspectDataLine.INIT();
                    InspectDataLine."Document No." := InspectDataHeader."No.";
                    InspectDataLine."Line No." := InspectLineNo;
                    InspectDataLine."Character Type" := SpecLine1."Character Type";
                    InspectDataLine.Indentation := SpecLine1.Indentation;
                    InspectDataLine."Character Code" := SpecLine1."Character Code";
                    InspectDataLine.Description := SpecLine1.Description;
                    InspectDataLine."Sampling Plan Code" := SpecLine1."Sampling Code";
                    InspectDataLine.Qualitative := SpecLine1.Qualitative;
                    InspectDataLine."Normal Value (Num)" := SpecLine1."Normal Value (Num)";
                    InspectDataLine."Min. Value (Num)" := SpecLine1."Min. Value (Num)";
                    InspectDataLine."Max. Value (Num)" := SpecLine1."Max. Value (Num)";
                    InspectDataLine."Normal Value (Text)" := SpecLine1."Normal Value (Char)";
                    InspectDataLine."Min. Value (Text)" := SpecLine1."Min. Value (Char)";
                    InspectDataLine."Max. Value (Text)" := SpecLine1."Max. Value (Char)";
                    InspectDataLine."Unit of Measure Code" := SpecLine1."Unit of Measure Code";
                    InspectDataLine."Character Group No." := CharGroupNo;
                    InspectDataLine."Lot Size - Min" := LotMin;
                    InspectDataLine."Lot Size - Max" := LotMax;
                    InspectDataLine."Sampling Size" := SamplingSize;
                    InspectDataLine."Allowable Defects - Min" := 0;
                    InspectDataLine."Allowable Defects - Max" := AllowableDefects;
                    OnBeforeInsertInspectionDataLine(InspectDataLine, SpecLine1);
                    InspectDataLine.INSERT();
                    OnAfterInsertInspectionDataLine(InspectDataLine, SpecLine1);
                    InspectLineNo := InspectLineNo + 1;
                    Flag := true
                end;
            until SpecLine1.NEXT() = 0;
    end;

    procedure CheckVendorQualityApproval(PurchRcptLine: Record "Purch. Rcpt. Line"; LotNo: Boolean): Boolean;
    var

        PurchRcptHeaderLRec: Record "Purch. Rcpt. Header";
        PostingDate: Date;
    begin
        VendorItemQA.reset();
        VendorItemQA.SETRANGE("Vendor No.", PurchRcptLine."Buy-from Vendor No.");
        VendorItemQA.SETRANGE("Item No.", PurchRcptLine."No.");
        if VendorItemQA.FIND('-') then begin
            PurchRcptHeaderLRec.GET(PurchRcptLine."Document No.");
            PostingDate := PurchRcptHeaderLRec."Posting Date";
            repeat
                if (PostingDate > VendorItemQA."Starting Date") and (PostingDate < VendorItemQA."Ending Date") then
                    if CONFIRM(Text007Qst) then
                        exit(true)
                    else
                        exit(false);
            until VendorItemQA.NEXT() = 0;
        end;
        exit(true);
    end;

    procedure FindSamplingSize(InspectDSHeader: Record "Ins Datasheet Header B2B"; SpecLine3: Record "Specification Line B2B"): Decimal;
    var
        SampPlanHeader: Record "Sampling Plan Header B2B";
        SamplingPlan: Record "Sampling Plan Line B2B";
        CheckSamplePlan: Boolean;
        SampleSizeCalculated: Decimal;
    begin
        LotMin := 0;
        LotMax := 0;
        AllowableDefects := 0;
        SpecLine3.TESTFIELD("Sampling Code");
        SampPlanHeader.GET(SpecLine3."Sampling Code");
        SampPlanHeader.TESTFIELD(Status, SampPlanHeader.Status::Certified);

        case SampPlanHeader."Sampling Type" of
            SampPlanHeader."Sampling Type"::"Complete Lot":
                SampleSizeCalculated := InspectDSHeader.Quantity;
            SampPlanHeader."Sampling Type"::"Fixed Quantity":
                begin
                    SampPlanHeader.TESTFIELD("Fixed Quantity");
                    SampleSizeCalculated := SampPlanHeader."Fixed Quantity";
                end;
            SampPlanHeader."Sampling Type"::"Percentage Lot":
                begin
                    SampPlanHeader.TESTFIELD("Lot Percentage");
                    SampleSizeCalculated := InspectDSHeader.Quantity * SampPlanHeader."Lot Percentage" / 100;
                    QCSetup();
                    case QualitySetup."Sampling Rounding" of
                        QualitySetup."Sampling Rounding"::Nearest:
                            SampleSizeCalculated := ROUND(SampleSizeCalculated, 1, '=');
                        QualitySetup."Sampling Rounding"::Up:
                            SampleSizeCalculated := ROUND(SampleSizeCalculated, 1, '>');
                        QualitySetup."Sampling Rounding"::Down:
                            SampleSizeCalculated := ROUND(SampleSizeCalculated, 1, '<');
                    end;
                end;
            SampPlanHeader."Sampling Type"::"Variable Quantity":
                begin
                    CheckSamplePlan := false;
                    SamplingPlan.SETRANGE("Sampling Code", SpecLine3."Sampling Code");
                    if SamplingPlan.FIND('-') then
                        repeat
                            SamplingPlan.TESTFIELD("Sampling Size");
                            if (InspectDSHeader.Quantity >= SamplingPlan."Lot Size - Min") and
                               (InspectDSHeader.Quantity <= SamplingPlan."Lot Size - Max")
                            then begin
                                SampleSizeCalculated := SamplingPlan."Sampling Size";
                                CheckSamplePlan := true;
                                LotMin := SamplingPlan."Lot Size - Min";
                                LotMax := SamplingPlan."Lot Size - Max";
                                AllowableDefects := SamplingPlan."Allowable Defects - Max";
                                SamplingSize := SamplingPlan."Sampling Size";
                            end;
                        until SamplingPlan.NEXT() = 0;
                    if not CheckSamplePlan then
                        ERROR(Text006Err, SpecLine3."Sampling Code", InspectDSHeader."Lot No.")
                end;
        end;

        exit(SampleSizeCalculated);
    end;

    procedure CopyItemTrackingLots(PurchRcptLine: Record "Purch. Rcpt. Line");
    var

        LineNo: Integer;
    begin
        ItemEntryRelation.SETCURRENTKEY("Source ID", "Source Type");
        ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Purch. Rcpt. Line");
        ItemEntryRelation.SETRANGE("Source Subtype", 0);
        ItemEntryRelation.SETRANGE("Source ID", PurchRcptLine."Document No.");
        ItemEntryRelation.SETRANGE("Source Batch Name", '');
        ItemEntryRelation.SETRANGE("Source Prod. Order Line", 0);
        ItemEntryRelation.SETRANGE("Source Ref. No.", PurchRcptLine."Line No.");
        TempItemLedgEntry.DELETEALL();
        LineNo := 10000;
        if ItemEntryRelation.FIND('-') then
            repeat
                ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                ItemLedgEntry1.INIT();
                ItemLedgEntry1.TRANSFERFIELDS(ItemLedgEntry);
                ItemLedgEntry1.INSERT();
                AddTempRecordSet(TempItemLedgEntry);
            until ItemEntryRelation.NEXT() = 0;

        if TempItemLedgEntry.FIND('-') then begin
            InspectLot.reset();
            InspectLot.SETRANGE("Document No.", PurchRcptLine."Document No.");
            InspectLot.SETRANGE("Purch. Line No.", PurchRcptLine."Line No.");
            if InspectLot.FIND('+') then
                LineNo := InspectLot."Line No.";
            InspectLot.INIT();
            repeat
                InspectLot."Document No." := PurchRcptLine."Document No.";
                InspectLot."Purch. Line No." := PurchRcptLine."Line No.";
                InspectLot."Lot No." := TempItemLedgEntry."Lot No.";
                InspectLot."Vendor Lot No_B2B" := TempItemLedgEntry."Vendor Lot No_B2B";
                InspectLot."Line No." := LineNo;
                InspectLot.Quantity := TempItemLedgEntry.Quantity;
                InspectLot."Item Ledger Entry No." := TempItemLedgEntry."Entry No.";
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

    procedure CheckSpecCertified(Spec: Code[20]);
    var
        SpecHeader: Record "Specification Header B2B";
    begin
        SpecHeader.GET(Spec);
        SpecHeader.TESTFIELD(Status, SpecHeader.Status::Certified);
    end;

    procedure QCSetup();
    begin
        if not QCSetupRead then
            QualitySetup.GET();
        QCSetupRead := true;
    end;

    procedure CreatePurchOrderInspectDS(PurchHeader2: Record "Purchase Header");
    var
        NoOfInspectDS: Integer;
    begin
        PurchHeader.COPY(PurchHeader2);
        PurchLine.RESET();
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        PurchLine.SETRANGE("QC Enabled B2B", true);

        NoOfInspectDS := 0;
        if PurchLine.FIND('-') then
            repeat
                if PurchLine."Qty. Sending to Quality B2B" <> 0 then begin
                    NoOfInspectDS := NoOfInspectDS + 1;
                    InitInspectionHeader(InspectionType::"Purchase Before Inspection");
                    InsertInspectionDataHeader(PurchHeader."Shortcut Dimension 1 Code");
                    PurchLine."Qty. Sent to Quality B2B" := PurchLine."Qty. Sent to Quality B2B" + PurchLine."Qty. Sending to Quality B2B";
                    PurchLine."Qty. Sending to Quality B2B" := 0;
                    PurchLine.MODIFY();
                end;
            until PurchLine.NEXT() = 0;
        if NoOfInspectDS = 0 then
            MESSAGE(Text003Msg)
        else
            MESSAGE(Text004Msg, NoOfInspectDS);
    end;


    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectionHeaderInsTypePurchase(var InspectDataHeader: Record "Ins Datasheet Header B2B"; PurchRcptHeader: record "Purch. Rcpt. Header"; PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectioHeaderInsTypePurchaseBeforeInspection(var InspectDataHeader: Record "Ins Datasheet Header B2B"; PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectionHeaderInsTypeProductionOrder(var InspectDataHeader: Record "Ins Datasheet Header B2B"; ProdOrderLine: Record "Prod. Order Line"; PurchRcptLine: Record "Purch. Rcpt. Line"; ProdOrderRoutingLine: Record "Prod. Order Routing Line"; ProdOrderLine1: Record "Prod. Order Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectionHeaderInsTypePurchaseLot(var InspectDataHeader: Record "Ins Datasheet Header B2B"; PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchRcptLine: Record "Purch. Rcpt. Line"; InspLot: Record "Inspection Lot B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectionHeaderInsTypeRework(var InspectDataHeader: Record "Ins Datasheet Header B2B"; InspectionReceipt: Record "Inspection Receipt Header B2B"; PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInsertInspectionDataLine(var InspectDataLine: Record "Inspection Datasheet Line B2B"; SpecLine1: Record "Specification Line B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertInspectionDataLine(var InspectDataLine: Record "Inspection Datasheet Line B2B"; SpecLine1: Record "Specification Line B2B")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnAfterInsertInspectionDataHeader(var InspectDataHeader: Record "Ins Datasheet Header B2B"; SpecLine: Record "Specification Line B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertInspectionDataHeader(var InspectDataHeader: Record "Ins Datasheet Header B2B"; SpecLine: Record "Specification Line B2B")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInitInspectionHeaderInsTypeHold(var InspectDataHeader: Record "Ins Datasheet Header B2B"; InspectionReceipt: Record "Inspection Receipt Header B2B"; PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
    end;

    var
        InspectLot: Record "Inspection Lot B2B";

        SpecLine1: Record "Specification Line B2B";
        ItemEntryRelation: Record "Item Entry Relation";

        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        VendorItemQA: Record "Vendor Item Qty Approval B2B";
        ItemRec: Record Item;

}


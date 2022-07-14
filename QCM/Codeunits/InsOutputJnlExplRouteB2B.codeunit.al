codeunit 33000256 "Ins Output Jnl.Expl.Route B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    Permissions = TableData "Item Journal Line" = imd,
                  TableData "Prod. Order Line" = r,
                  TableData "Prod. Order Routing Line" = r;
    TableNo = "Item Journal Line";

    trigger OnRun();
    var

        NextLineNo: Integer;
        LineSpacing: Integer;
        BaseQtyToPost: Decimal;
    begin
        if Rec."Order No." = '' then
            exit;

        ProdOrderLine.RESET();
        ProdOrderLine.SETRANGE(Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE("Prod. Order No.", Rec."Order No.");
        if Rec."Order Line No." <> 0 then
            ProdOrderLine.SETRANGE("Line No.", Rec."Order Line No.");
        if Rec."Item No." <> '' then
            ProdOrderLine.SETRANGE("Item No.", Rec."Item No.");
        if Rec."Routing Reference No." <> 0 then
            ProdOrderLine.SETRANGE("Routing Reference No.", Rec."Routing Reference No.");
        if Rec."Routing No." <> '' then
            ProdOrderLine.SETRANGE("Routing No.", Rec."Routing No.");

        ProdOrderRtngLine.reset();
        ProdOrderRtngLine.SETRANGE(Status, ProdOrderRtngLine.Status::Released);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", Rec."Order No.");
        if Rec."Operation No." <> '' then
            ProdOrderRtngLine.SETRANGE("Operation No.", Rec."Operation No.");
        ProdOrderRtngLine.SETFILTER("Routing Status", '<> %1', ProdOrderRtngLine."Routing Status"::Finished);

        Rec."Order Line No." := 0;
        Rec."Item No." := '';
        Rec."Routing Reference No." := 0;
        Rec."Routing No." := '';

        ItemJnlLine := Rec;

        ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        if ItemJnlLine.FIND('>') then begin
            LineSpacing :=
              (ItemJnlLine."Line No." - Rec."Line No.") div
              (1 + ProdOrderLine.COUNT() * ProdOrderRtngLine.COUNT());
            if LineSpacing = 0 then
                ERROR(Text000Err);
        end else
            LineSpacing := 10000;

        NextLineNo := Rec."Line No.";

        if not ProdOrderLine.FIND('-') then
            ERROR(Text001Err);
        repeat
            ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
            ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
            if ProdOrderRtngLine.FIND('-') then
                repeat
                    InsertOutputJnlLine(
                      Rec, NextLineNo, LineSpacing,
                      ProdOrderLine."Line No.",
                      ProdOrderLine."Item No.",
                      ProdOrderLine."Variant Code",
                      ProdOrderLine."Location Code",
                      ProdOrderLine."Bin Code",
                      ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.",
                      ProdOrderRtngLine."Operation No.",
                      ProdOrderLine."Unit of Measure Code",
                      BaseQtyToPost / ProdOrderLine."Qty. per Unit of Measure", ProdOrderRtngLine."Inspection Receipt No.");
                until ProdOrderRtngLine.NEXT() = 0
            else
                if ProdOrderLine."Remaining Quantity" > 0 then
                    InsertOutputJnlLine(
                      Rec, NextLineNo, LineSpacing,
                      ProdOrderLine."Line No.",
                      ProdOrderLine."Item No.",
                      ProdOrderLine."Variant Code",
                      ProdOrderLine."Location Code",
                      ProdOrderLine."Bin Code",
                      ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.", '',
                      ProdOrderLine."Unit of Measure Code",
                      ProdOrderLine."Remaining Quantity", ProdOrderRtngLine."Inspection Receipt No.");
        until ProdOrderLine.NEXT() = 0;
        Rec.DELETE();
    end;

    var
        LastItemJnlLine: Record "Item Journal Line";
        Text000Err: Label 'There are not enough free line numbers to explode the route.';
        Text001Err: Label 'There is nothing to explode.';

    procedure InsertOutputJnlLine(ItemJnlLine: Record "Item Journal Line"; var NextLineNo: Integer; var LineSpacing: Integer; ProdOrderLineNo: Integer; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; BinCode: Code[20]; RoutingNo: Code[20]; RoutingRefNo: Integer; OperationNo: Code[10]; UnitOfMeasureCode: Code[10]; QtyToPost: Decimal; InspectReceiptNo: Code[20]);
    begin
        NextLineNo := NextLineNo + LineSpacing;

        ItemJnlLine."Line No." := NextLineNo;
        ItemJnlLine.VALIDATE("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.VALIDATE("Order Line No.", ProdOrderLineNo);
        ItemJnlLine.VALIDATE("Item No.", ItemNo);
        ItemJnlLine.VALIDATE("Variant Code", VariantCode);
        ItemJnlLine.VALIDATE("Location Code", LocationCode);
        if BinCode <> '' then
            ItemJnlLine.VALIDATE("Bin Code", BinCode);
        ItemJnlLine.VALIDATE("Routing No.", RoutingNo);
        ItemJnlLine.VALIDATE("Routing Reference No.", RoutingRefNo);
        ItemJnlLine.VALIDATE("Operation No.", OperationNo);
        ItemJnlLine.VALIDATE("Unit of Measure Code", UnitOfMeasureCode);
        ItemJnlLine.VALIDATE("Setup Time", 0);
        ItemJnlLine.VALIDATE("Run Time", 0);
        ItemJnlLine.VALIDATE("Output Quantity", 0);
        ItemJnlLine."After Inspection B2B" := true;
        ItemJnlLine."Inspection Receipt No. B2B" := InspectReceiptNo;
        ItemJnlLine.INSERT();
        LastItemJnlLine := ItemJnlLine;
    end;

    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Rework Routing Line B2B";
        ItemJnlLine: Record "Item Journal Line";
}


report 33000265 "Calc.Inspect Consumption B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Report.

    Caption = 'Calc. Consumption';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") WHERE(Status = CONST(Released));
            RequestFilterFields = "No.";
            dataitem("Rework Component"; "Rework Component B2B")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                RequestFilterFields = "Item No.";

                trigger OnAfterGetRecord();
                var
                    NeededQty: Decimal;
                begin
                    Window.UPDATE(2, "Item No.");

                    CLEAR(ItemJnlLine);
                    Item.GET("Item No.");
                    UnitOfMeasConv := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                    ProdOrderLine.GET(Status, "Prod. Order No.", "Prod. Order Line No.");

                    NeededQty := "Rework Component"."Expected Quantity";

                    if NeededQty <> 0 then begin
                        if LocationCode <> '' then
                            CreateConsumpJnlLine(LocationCode, '', NeededQty)
                        else
                            CreateConsumpJnlLine("Location Code", "Bin Code", NeededQty);
                        LastItemJnlLine := ItemJnlLine;
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                Window.UPDATE(1, "No.");
            end;

            trigger OnPreDataItem();
            begin
                ItemJnlLine.SETRANGE("Journal Template Name", ToTemplateName);
                ItemJnlLine.SETRANGE("Journal Batch Name", ToBatchName);
                if ItemJnlLine.FIND('+') then
                    NextConsumpJnlLineNo := ItemJnlLine."Line No." + 10000
                else
                    NextConsumpJnlLineNo := 10000;

                Window.OPEN(
                  Text000Msg +
                  Text001Msg +
                  Text002Msg +
                  Text003Msg);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Item: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        ItemJnlLine: Record "Item Journal Line";
        LastItemJnlLine: Record "Item Journal Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        Text000Msg: Label 'Calculating consumption...\\';
        Text001Msg: Label 'Prod. Order No.   #1##########\', Comment = '%1 = Order No';
        Text002Msg: Label 'Item No.          #2##########\', Comment = '%2 = Item No';
        Text003Msg: Label 'Quantity          #3##########', Comment = '%3 = Quantity';
        Window: Dialog;
        PostingDate: Date;
        CalcBasedOn: Option "Actual Output","Expected Output";
        UnitOfMeasConv: Decimal;

        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        NextConsumpJnlLineNo: Integer;

    procedure InitializeRequest(NewPostingDate: Date; NewCalcBasedOn: Option);
    begin
        PostingDate := NewPostingDate;
        CalcBasedOn := NewCalcBasedOn;
    end;

    local procedure CreateConsumpJnlLine(LocationCodePar: Code[10]; BinCode: Code[20]; QtyToPost: Decimal);
    var

    begin
        Window.UPDATE(3, QtyToPost);

        if (ItemJnlLine."Item No." = "Rework Component"."Item No.") and
           (LocationCodePar = ItemJnlLine."Location Code") and
           (BinCode = ItemJnlLine."Bin Code")
        then begin
            if Item."Rounding Precision" > 0 then
                ItemJnlLine.VALIDATE(Quantity, ItemJnlLine.Quantity + ROUND(QtyToPost, Item."Rounding Precision", '>'))
            else
                ItemJnlLine.VALIDATE(Quantity, ItemJnlLine.Quantity + ROUND(QtyToPost, 0.00001));
            ItemJnlLine."After Inspection B2B" := true;
            ItemJnlLine.MODIFY();
        end else begin
            ItemJnlLine.INIT();
            ItemJnlLine."Journal Template Name" := ToTemplateName;
            ItemJnlLine."Journal Batch Name" := ToBatchName;
            ItemJnlLine.SetUpNewLine(LastItemJnlLine);
            ItemJnlLine."Line No." := NextConsumpJnlLineNo;

            ItemJnlLine.VALIDATE("Entry Type", ItemJnlLine."Entry Type"::Consumption);
            ItemJnlLine.VALIDATE("Order No.", "Rework Component"."Prod. Order No.");
            ItemJnlLine.VALIDATE("Source No.", ProdOrderLine."Item No.");
            ItemJnlLine.VALIDATE("Posting Date", PostingDate);
            ItemJnlLine.VALIDATE("Item No.", "Rework Component"."Item No.");
            ItemJnlLine.VALIDATE("Unit of Measure Code", "Rework Component"."Unit of Measure Code");
            ItemJnlLine.Description := "Rework Component".Description;
            if Item."Rounding Precision" > 0 then
                ItemJnlLine.VALIDATE(Quantity, ROUND(QtyToPost, Item."Rounding Precision", '>'))
            else
                ItemJnlLine.VALIDATE(Quantity, ROUND(QtyToPost, 0.00001));
            ItemJnlLine.VALIDATE("Location Code", LocationCodePar);
            if BinCode <> '' then
                ItemJnlLine.VALIDATE("Bin Code", BinCode);
            ItemJnlLine."Variant Code" := "Rework Component"."Variant Code";
            ItemJnlLine."Order Line No." :=
              "Rework Component"."Prod. Order Line No.";
            ItemJnlLine.VALIDATE("Prod. Order Comp. Line No.", "Rework Component"."Line No.");
            ItemJnlLine."After Inspection B2B" := true;
            ItemJnlLine."Inspection Receipt No. B2B" := "Rework Component"."Inspection Receipt No.";
            ItemJnlLine.INSERT();
        end;

        NextConsumpJnlLineNo := NextConsumpJnlLineNo + 10000;
    end;

    procedure SetTemplateAndBatchName(TemplateName: Code[10]; BatchName: Code[10]);
    begin
        ToTemplateName := TemplateName;
        ToBatchName := BatchName;
    end;

    var
        LocationCode: Code[10];
}


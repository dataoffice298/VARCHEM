pageextension 33000312 ReleasedProdOrdLinesExtB2B extends "Released Prod. Order Lines"
{
    layout
    {
        addafter(Description)
        {
            field("WIP QC Enabled B2B"; Rec."WIP QC Enabled B2B")
            {
                ApplicationArea = All;
                Caption = 'WIP QC Enabled';
                ToolTip = 'work in process Inspection Data Sheets are created only if the item is WIP QC Enabled';
            }
            field("WIP Spec ID B2B"; Rec."WIP Spec ID B2B")
            {
                ApplicationArea = All;
                Caption = 'WIP Spec ID';
                ToolTip = 'work in process Specification is a group of characteristics to be inspected of an item';
            }
            field("Quantity Sent to Quality B2B"; Rec."Quantity Sent to Quality B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sent to Quality';
                tooltip = 'how much Qty sent to Quanlity';
            }
            field("Quantity Sending to Quality B2B"; Rec."Qty Sending to Quality B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sending to Quality';
                ToolTip = 'which Quantity sending to Quality';
                trigger OnValidate()
                var
                    ProdOrderRoutingLine: Record 5409;
                    TempQtySendingtoQuality: Decimal;
                    i: Integer;
                    Text33000250Txt: Label 'Quantity Sending to Quality Should not be greater than Prod. Ord Line Qty Acceted';
                    Text33000251Txt: Label 'Quantity Sending to Quality Should not be greater than Prod. Order Line Total Qty';
                    Text33000252Txt: Label 'Should not be greater than  Rework Qty.';
                    Text33000253Txt: Label 'Should not be greater than ...';
                BEGIN
                    ProdOrderRoutingLine.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
                    ProdOrderRoutingLine.SETRANGE("Routing Reference No.", Rec."Line No.");
                    IF ProdOrderRoutingLine.FIND('-') THEN
                        REPEAT
                            IF ProdOrderRoutingLine."QC Enabled B2B" THEN BEGIN
                                ProdOrderRoutingLine.CALCFIELDS(ProdOrderRoutingLine."Quantity Accepted B2B");
                                IF i = 0 THEN BEGIN
                                    TempQtySendingtoQuality := ProdOrderRoutingLine."Quantity Accepted B2B" + ProdOrderRoutingLine."Prev. Qty B2B";
                                    i := i + 1;
                                END ELSE
                                    IF (ProdOrderRoutingLine."Quantity Accepted B2B" + ProdOrderRoutingLine."Prev. Qty B2B") < TempQtySendingtoQuality THEN
                                        TempQtySendingtoQuality := ProdOrderRoutingLine."Quantity Accepted B2B" + ProdOrderRoutingLine."Prev. Qty B2B";
                                IF (Rec."Qty Sending to Quality B2B" + Rec."Quantity Sent to Quality B2B") > TempQtySendingtoQuality THEN
                                    ERROR(Text33000250Txt);
                            END;
                        UNTIL ProdOrderRoutingLine.NEXT() = 0;

                    Rec.CALCFIELDS("Quantity Accepted B2B", "Quantity Rejected B2B", "Quantity Rework B2B");
                    IF (Rec."Quantity Sent to Quality B2B" = 0) AND (Rec."Quantity Accepted B2B" = 0) AND
                       (Rec."Quantity Rejected B2B" = 0) AND (Rec."Quantity Rework B2B" = 0)
                    THEN BEGIN
                        IF Rec."Qty Sending to Quality B2B" > Rec.Quantity THEN
                            ERROR(Text33000251Txt)
                    END ELSE
                        IF Rec."Quantity Sent to Quality B2B" = (Rec."Quantity Accepted B2B" + Rec."Quantity Rejected B2B" + Rec."Quantity Rework B2B") THEN
                            IF Rec."Qty Sending to Quality B2B" <= Rec.Quantity - (Rec."Quantity Accepted B2B" + Rec."Quantity Rejected B2B") THEN
                                Rec."Qty Sending to Quality B2B" := Rec."Qty Sending to Quality B2B"
                            ELSE
                                ERROR(Text33000252Txt)
                        ELSE
                            IF Rec."Qty Sending to Quality B2B" <= Rec."Quantity Rejected B2B" - (Rec."Quantity Sent to Quality B2B" - Rec.Quantity) THEN
                                Rec."Qty Sending to Quality B2B" := Rec."Qty Sending to Quality B2B"
                            ELSE
                                ERROR(Text33000253Txt);
                    Rec.MODIFY();
                END;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Accepted';
                ToolTip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';

            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rejected';
                tooltip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rework';
                ToolTip = 'any remark quantity send to vendor is the rework quantity';
            }
        }
    }
    actions
    {
        addlast("&Line")
        {
            group("I&nspectionB2B")
            {
                Caption = 'Inspection';
                action("Inspection Data Sheets B2B")
                {
                    Caption = '&Inspection Data Sheets';
                    ToolTip = 'the Quality department carry out the quality activities by using the IDS';
                    Image = Insert;
                    ApplicationArea = All;
                    RunObject = Page "Inspection Data Sheet List B2B";
                    RunPageLink = "Prod. Order No." = FIELD("Prod. Order No."),
                                      "Operation No." = FILTER('');
                }
                action("Posted Inspection Data Sheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    ToolTip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    Image = Indent;
                    ApplicationArea = All;
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "Prod. Order No." = FIELD("Prod. Order No."),
                                      "Operation No." = FILTER('');
                }
                action("Inspection Receipt B2B")
                {
                    Caption = 'Inspection &Receipt';
                    ToolTip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                    Image = Receipt;
                    ApplicationArea = All;
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Prod. Order No." = FIELD("Prod. Order No."),
                                      Status = CONST(False),
                                      "Operation No." = FILTER('');
                }
                action("Posted Inspection Receipt B2B")
                {
                    Caption = 'Posted I&nspection Receipt';
                    tooltip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    Image = PostedReceipt;
                    ApplicationArea = All;
                    RunObject = Page 33000267;
                    RunPageLink = "Prod. Order No." = FIELD("Prod. Order No."),
                                      Status = CONST(True),
                                      "Operation No." = FILTER('');
                }
            }
        }
    }





    procedure CreateInspDataSheets();
    begin
        // Start  B2BQC1.00.00 - 01 Create Inspection Data Sheets

        Rec.CreateInspectionDataSheets();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowDataSheets();
    var

    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Data Sheets

        ShowDataSheets();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowPostDataSheets();
    var

    begin
        //B2BQC1.00.00 To Show Posted Inspection Data Sheets

        ShowPostDataSheets();

        //B2BQC1.00.00 To Show Posted Inspection Data Sheets
    end;

    procedure ShowInspectReceipt();
    var

    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Receipt

        ShowInspectReceipt();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowPostInspectReceipt();
    var

    begin
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Receipt

        ShowPostInspectReceipt();

        // Stop   B2BQC1.00.00 - 01
    end;
}
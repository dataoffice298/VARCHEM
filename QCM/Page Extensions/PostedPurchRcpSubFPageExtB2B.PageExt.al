pageextension 33000304 "PostedPurchRcpSubFPageExt B2B" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {



            field("Spec ID B2B"; Rec."Spec ID B2B")
            {
                ApplicationArea = all;
                ToolTip = 'Specification is a group of characteristics to be inspected of an item';
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                //Editable = "Quantity AcceptedEditable";
                ApplicationArea = all;
                ToolTip = 'satsified the quantity inspection process that is quantity Accepted editable';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")

            {
                //Editable = "Quantity ReworkEditable";
                ApplicationArea = all;
                ToolTip = 'the rework items must be sent for rework to the vendor for the edit quantity gor send the vendor';
            }
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = all;
                ToolTip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                //Editable = "Quantity RejectedEditable";
                ApplicationArea = all;
                tooltip = 'rejected quantity send location for the edit quantity use the quantity rejected editable';
            }
            field("Quality Before Receipt B2B"; Rec."Quality Before Receipt B2B")
            {
                ApplicationArea = all;
                ToolTip = 'Inspection is done before the material offered by the vendor is taken into the inventory';

            }

        }
    }

    actions
    {
        modify("&Undo Receipt")
        {

            trigger OnBeforeAction();
            begin
                UndoReceiptLineQCCheck();
            end;
        }
        addlast("&Line")
        {
            group("Inspection B2B")
            {
                Caption = 'I&nspection';
                action("InspDataSheets B2B")
                {
                    Caption = '&Inspection Data Sheets';
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                    RunObject = Page "Inspection Data Sheet List B2B";
                    RunPageLink = "Order No." = FIELD("Order No.");
                    RunPageView = SORTING("Rework Level");
                    ApplicationArea = all;
                    Image = ShowInventoryPeriods;
                }
                action("PostedInspDataSheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    ToolTip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "Order No." = FIELD("Order No.");
                    RunPageView = SORTING("Rework Level");
                    ApplicationArea = all;
                    Image = PostDocument;
                }
                action("Inspection Receipts B2B")
                {
                    Caption = 'Inspection &Receipts';
                    tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Order No." = FIELD("Order No."),
                                      Status = FILTER(FALSE);
                    RunPageView = SORTING("Rework Level");
                    ApplicationArea = all;
                    Image = Receipt;
                }
                action("PostedInspReceipts B2B")
                {
                    Caption = 'Posted I&nspection Receipts';
                    ToolTip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Order No." = FIELD("Order No."),
                                      Status = FILTER(<> fALSE);
                    RunPageView = SORTING("Rework Level");
                    ApplicationArea = all;
                    Image = PostedReceipt;
                }
            }
            action("InspectionLots B2B")
            {
                Caption = 'Inspection &Lots';
                ToolTip = 'Defines the Inspection Lots  ';

                ApplicationArea = all;
                Image = LotInfo;
                trigger OnAction();
                begin
                    //CurrPage.PurchReceiptLines.FORM.ShowInspectLots;
                    ShowInspectLots();
                end;
            }
        }
    }

    var


        InspectDataSheet: Record 33000255;
        PostedInspectDataSheet: Record 33000263;
        InspectReportHeader: Record 33000269;
        InspectLots: Record 33000259;
        PostInspLot: Codeunit 33000251;
        Text33000250Err: Label 'Inspection Data Sheets already exists for atleast one of the Inspection Lots.\Inspection Data sheets cannot be created here.';

    procedure ShowDataSheet();
    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Data Sheets

        InspectDataSheet.SETRANGE("Receipt No.", Rec."Document No.");
        InspectDataSheet.SETRANGE("Item No.", Rec."No.");
        InspectDataSheet.SETRANGE("Purch. Line No", Rec."Line No.");
        InspectDataSheet.SETCURRENTKEY("Rework Level");
        PAGE.RUN(PAGE::"Inspection Data Sheet List B2B", InspectDataSheet);

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowPostedDataSheet();
    begin
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Data Sheets

        PostedInspectDataSheet.SETRANGE("Receipt No.", Rec."Document No.");
        PostedInspectDataSheet.SETRANGE("Item No.", Rec."No.");
        PostedInspectDataSheet.SETRANGE("Purch. Line No", Rec."Line No.");
        PostedInspectDataSheet.SETCURRENTKEY("Rework Level");
        PAGE.RUN(PAGE::"Posted Ins DataSheet List B2B", PostedInspectDataSheet);

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowInspectReport(Status: Boolean);
    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Report

        InspectReportHeader.SETRANGE("Receipt No.", Rec."Document No.");
        InspectReportHeader.SETRANGE("Purch Line No", Rec."Line No.");
        InspectReportHeader.SETFILTER(InspectReportHeader.Status, '%1', Status);
        InspectReportHeader.SETCURRENTKEY("Rework Level");
        PAGE.RUN(PAGE::"Inspection Receipt List B2B", InspectReportHeader);
        InspectReportHeader.RESET();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowInspectLots();
    var
    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Lots

        Rec.TESTFIELD("QC Enabled B2B");
        IF Rec.Type = Rec.Type::Item THEN BEGIN
            InspectLots.RESET();
            InspectLots.SETRANGE("Document No.", Rec."Document No.");
            InspectLots.SETRANGE("Purch. Line No.", Rec."Line No.");
            InspectLots.SETRANGE("Item No.", Rec."No.");
            PAGE.RUN(PAGE::"Inspection Lots B2B", InspectLots);
        END;

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure CreateInpDataSheets();
    begin
        // Start  B2BQC1.00.00 - 01 Create Inspection Data Sheets

        IF Rec.Type = Rec.Type::Item THEN BEGIN
            Rec.TESTFIELD("Spec ID B2B");
            InspectLots.SETRANGE("Document No.", Rec."Document No.");
            InspectLots.SETRANGE("Purch. Line No.", Rec."Line No.");
            InspectLots.SETRANGE("Item No.", Rec."No.");
            InspectLots.SETRANGE("Inspect. Data Sheet Created", TRUE);
            IF NOT InspectLots.FIND('-') THEN BEGIN
                InspectLots.SETRANGE("Inspect. Data Sheet Created");
                IF InspectLots.FIND('-') THEN
                    REPEAT
                        PostInspLot.RUN(InspectLots);
                    UNTIL InspectLots.NEXT() = 0;
            END ELSE
                ERROR(Text33000250Err);
        END;

        // Stop   B2BQC1.00.00 - 01
    end;

    local procedure UndoReceiptLineQCCheck();
    var

        PIDS: Record 33000263;
        PIDSL: Record 33000264;
        Text000Err: Label 'You cannot UndoReceipt as Inspections Reciept are Posted';
    begin
        // Start  B2BQC1.00.00 - 01 UndoReceitLine
        IF Rec."QC Enabled B2B" = TRUE THEN BEGIN
            IDS.reset();
            IDS.SETRANGE("Receipt No.", Rec."Document No.");
            IDS.SETRANGE("Purch. Line No", Rec."Line No.");
            IF NOT IDS.FIND('-') THEN begin
                // ERROR(Text000Err);
                IRs.Reset();
                IRs.SetRange("Receipt No.", Rec."Document No.");
                IRs.SetRange("Purch Line No", Rec."Line No.");
                if IRs.Find('-') then begin
                    if irs.Status then begin

                        if IRs.Quantity <> IRs."Qty. Accepted" then
                            Error(Text000Err)
                    end;

                    IRs."Quality Status" := IRs."Quality Status"::Cancel;
                    IRs.Status := true;
                    Irs.Modify();
                    if rec."Item Rcpt. Entry No." <> 0 then begin
                        QILE.Reset();
                        QILE.SETRANGE("Document No.", IRs."Receipt No.");
                        QILE.SETRANGE("item No.", IRs."Item No.");
                        QILE.SetRange("Entry No.", Rec."Item Rcpt. Entry No.");
                        IF QILE.FindSet() then
                            //REPEAT
                            QILE.DeleteAll();
                        //UNTIL QILE.NEXT() = 0;
                    end else begin
                        ILE.Reset();
                        ILE.SetRange("Document No.", Rec."Document No.");
                        ILE.SetRange("Document Line No.", Rec."Line No.");
                        if ILE.FindSet() then
                            repeat
                                QILE.Reset();
                                QILE.SetRange("Entry No.", ILE."Entry No.");
                                if QILE.FindSet() then
                                    QILE.DeleteAll();
                            until ILE.Next() = 0;
                        //QILE.SetRange(li);
                    end;

                end;


            end ELSE BEGIN
                REPEAT
                    PIDS.TRANSFERFIELDS(IDS);
                    PIDS."Quality Status" := PIDS."Quality Status"::Cancel;
                    PIDS.INSERT();
                    IDS.DELETE();
                    IDSL.SETRANGE("Document No.", IDS."No.");
                    IF IDSL.FIND('-') THEN BEGIN
                        REPEAT
                            PIDSL.TRANSFERFIELDS(IDSL);
                            PIDSL.INSERT();
                        UNTIL IDSL.NEXT() = 0;
                        IDSL.DELETEALL();
                    END;
                UNTIL IDS.NEXT() = 0;
                if rec."Item Rcpt. Entry No." <> 0 then begin
                    QILE.Reset();
                    //QILE.SETRANGE("Document No.", Rec."Document No.");
                    //QILE.SETRANGE("item No.", Rec."No.");
                    QILE.SetRange("Entry No.", Rec."Item Rcpt. Entry No.");
                    IF QILE.FindSet() then
                        //REPEAT
                            QILE.DeleteAll();
                    //UNTIL QILE.NEXT() = 0;
                end else begin
                    ILE.Reset();
                    ILE.SetRange("Document No.", Rec."Document No.");
                    ILE.SetRange("Document Line No.", Rec."Line No.");
                    if ILE.FindSet() then
                        repeat
                            QILE.Reset();
                            QILE.SetRange("Entry No.", ILE."Entry No.");
                            if QILE.FindSet() then
                                QILE.DeleteAll();
                        until ILE.Next() = 0;
                    //QILE.SetRange(li);
                end;

                /*QILE.SETRANGE("Document No.", IDS."Receipt No.");

                IF QILE.FIND('-') THEN
                    REPEAT
                        QILE.DELETE();
                    UNTIL QILE.NEXT() = 0;*/

            END;
        END;
    end;



    var
        IDS: Record 33000255;
        IDSL: Record 33000256;
        QILE: Record 33000262;
        IRs: Record 33000269;
        PostedPurcHdr: Record 120;
        ILE: Record "Item Ledger Entry";

}
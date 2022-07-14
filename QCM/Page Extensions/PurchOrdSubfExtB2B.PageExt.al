pageextension 33000308 "PurchOrdSubfExt B2B" extends "Purchase Order Subform"
{

    layout
    {
        addafter(ShortcutDimCode8)
        {

            field("Spec ID B2B"; Rec."Spec ID B2B")
            {
                ApplicationArea = all;
                Caption = 'Spec ID';
                ToolTip = 'Specification is a group of characteristics to be inspected of an item';
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = all;
                Caption = 'Quantity Accepted';
                tooltip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                ApplicationArea = all;
                Caption = 'Quantity Rework';
                tooltip = 'any remark the quantity send the vendor is the rework quantity';
            }
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = all;
                Caption = 'QC Enabled';
                ToolTip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = all;
                Caption = 'Quantity Rejected';
                ToolTip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';

            }
            field("Quality Before Receipt B2B"; Rec."Quality Before Receipt B2B")
            {
                ApplicationArea = all;
                Caption = 'Quality Before Receipt';
                ToolTip = 'Inspection is done before the material offered by the vendor is taken into the inventory';
            }
            field("Qty. Sending to Quality B2B"; Rec."Qty. Sending to Quality B2B")
            {
                ApplicationArea = all;
                Caption = 'Qty. Sending to Quality';
                ToolTip = 'which Qty.sending to Quality';
            }
            field("Qty. Sent to Quality B2B"; Rec."Qty. Sent to Quality B2B")
            {
                ApplicationArea = all;
                Caption = 'Qty. Sent to Quality';
                tooltip = 'how much Qty.sent to Quality';
            }
            field("Qty. Sending to Quality(R) B2B"; Rec."Qty. Sending to Quality(R) B2B")
            {
                ApplicationArea = all;
                Caption = 'Qty. Sending to Quality(R)';
                ToolTip = 'which Qty sending to Quality (R)';
            }

        }
    }
    actions
    {

        addlast("&Line")
        {
            group("Inspection B2B")
            {
                Caption = 'I&nspection';
                tooltip = 'inspoecteion is approved during each phase in order to detect and correct quantity problem';
                action("InspDataSheetsB2B")
                {
                    Caption = '&Inspection Data Sheets';
                    ToolTip = 'the Quality department carry out the quality activities by using the IDS';
                    ApplicationArea = all;
                    Image = ShowInventoryPeriods;

                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowDataSheetsIns();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("PostedInspDataSheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    ToolTip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    ApplicationArea = all;
                    Image = PostDocument;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowPostDataSheetsIns()

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("InspReceipts B2B")
                {
                    Caption = 'Inspection &Receipts';
                    ToolTip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                    ApplicationArea = all;
                    Image = Receipt;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowInsReceipt();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("PostedInspReceipts B2B")
                {
                    Caption = 'Posted I&nspection Receipts';
                    ToolTip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    ApplicationArea = all;
                    Image = PostedReceipt;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        //ShowSubOrderRcptForm;
                        ShowPostInsReceipt();
                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
            }
        }
    }


    var
        Text50001Err: label 'Inspection datasheets already created.';


    procedure CreateInspecDataSheets();
    Begin
        // Start  B2BQC1.00.00 - 01 Create Inspection Data Sheets

        //B2B1.2 Start
        //Commented
        //CreateInspectionDataSheets;
        IF Rec.Quantity >= (Rec."Qty. Sending to Quality B2B" + Rec."Qty. Sent to Quality B2B") THEN
            Rec.CreateInspectionDataSheets()
        ELSE
            ERROR(Text50001Err);
        //B2B1.2 Start End;
        // Stop   B2BQC1.00.00 - 01
    End;

    procedure ShowDataSheetsIns();
    var
    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Data Sheets

        Rec.ShowDataSheets();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowPostDataSheetsIns();
    var
    begin
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Data Sheets

        Rec.ShowPostDataSheets();

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowInsReceipt();
    var
    begin
        // Start  B2BQC1.00.00 - 01 Show Inspection Receipt

        Rec.ShowInspectReceipt();
        // Stop   B2BQC1.00.00 - 01
    end;

    procedure ShowPostInsReceipt();
    var
    begin
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Receipt

        Rec.ShowPostInspectReceipt();

        // Stop   B2BQC1.00.00 - 01
    end;

}
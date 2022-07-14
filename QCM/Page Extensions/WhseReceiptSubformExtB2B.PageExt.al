pageextension 33000314 "WhseReceiptSubformExt B2B" extends "Whse. Receipt Subform"
{

    actions
    {
        addlast("&Line")
        {
            group("Inspection B2B")
            {
                Caption = 'I&nspection';
                tooltip = 'inspection and approved during each phase in order to detect and correct quality problems';
                action("InspDataSheets B2B")
                {
                    Caption = '&Inspection Data Sheets';
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                    ApplicationArea = all;
                    Image = ShowInventoryPeriods;
                    trigger OnAction()
                    begin
                        ShowDataSheets();
                    end;
                }
                action("PostedInspDataSheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    ApplicationArea = all;
                    Image = PostDocument;
                    trigger OnAction()
                    begin
                        ShowPostDataSheets();
                    end;
                }
                action("InspectionReceipts B2B")
                {
                    Caption = 'Inspection &Receipts';
                    ToolTip = 'nspection receipt through which the user actually accepts, rejects or sends for rework';
                    ApplicationArea = all;
                    Image = Receipt;
                    trigger OnAction()
                    begin
                        ShowInspectReceipt();
                    end;
                }
                action("PostedInspReceipts B2B")
                {
                    Caption = 'Posted I&nspection Receipts';
                    ToolTip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    ApplicationArea = all;
                    Image = PostedReceipt;
                    trigger OnAction()
                    begin
                        ShowPostInspectReceipt();
                    end;
                }
            }
        }
    }

    procedure CreateInspectionDataSheets();
    begin
        // Start  B2BQC1.00.00 - 01 Create Inspection Data Sheets

        CreateInspectionDataSheets();

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
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Data Sheets

        ShowPostDataSheets();

        // Stop   B2BQC1.00.00 - 01
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
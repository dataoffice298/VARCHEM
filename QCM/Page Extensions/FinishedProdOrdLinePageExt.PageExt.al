pageextension 33000301 FinishedProdOrdLinePageExtB2B extends "Finished Prod. Order Lines"

{
    layout
    {
        addlast("Control1")
        {
            field("WIP QC Enabled B2B"; Rec."WIP QC Enabled B2B")

            {
                ApplicationArea = All;
                Caption = 'WIP QC Enabled';
                ToolTip = '  Inspection Data Sheets are created only if the item is MFG process tested items Wip QC';
            }

            field("Quantity Sent to Quality B2B"; Rec."Quantity Sent to Quality B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sent to Quality';
                ToolTip = 'how much Quantity sent to Quality ';
            }
            field("Quantity Sending to Quality B2B"; Rec."Qty Sending to Quality B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sending to Quality ';
                ToolTip = 'which Quantity sending to Quality';
                Editable = true;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Accepted';
                ToolTip = 'satisfied inspection items quantity Accepted';
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rejected';
                tooltip = 'disatisfied inspection items quantity Rejected';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rework';
                ToolTip = 'any remark items send to vendor for rework Quantity';
            }
        }
    }




    actions
    {
        addlast("&Line")
        {
            group("I&nspection B2B")
            {
                Caption = 'I&nspection';
                action("Inspection Data Sheets B2B")
                {
                    Caption = '&Inspection Data Sheets';
                    ToolTip = 'the Quality department carry out the quality activities by using the IDS';
                    ApplicationArea = All;
                    Image = Indent;

                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowDataSheets();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("Posted Inspection Data Sheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    ToolTip = 'Posted Characteristic valuse should be stored  ';
                    Image = PostedOrder;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowPostDataSheets();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("Inspection Receipts B2B")
                {
                    Caption = 'Inspection &Receipts';
                    tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework.';
                    ApplicationArea = All;
                    Image = Receipt;

                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowInspectReceipt();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
                action("Posted Inspection Receipt B2B")
                {
                    Caption = 'Posted I&nspection Receipt';
                    tooltip = 'any rework quantity send to vendor at time to receive rework quantity';
                    Image = PostedReceipt;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        ShowPostInspectReceipt();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
            }
        }
    }

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
        //B2BQC1.00.00 - To Show Inspection Receipt

        ShowInspectReceipt();

        //B2BQC1.00.00 - To Show Inspection Receipt
    end;

    procedure ShowPostInspectReceipt();
    var

    begin
        // Start  B2BQC1.00.00 - 01 Show Posted Inspection Receipt

        ShowPostInspectReceipt();

        // Stop   B2BQC1.00.00 - 01
    end;

}
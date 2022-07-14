pageextension 33000307 ProdRoutLinesPageExtB2B extends "Prod. Order Routing"
{
    layout
    {
        addlast("Control1")
        {
            field("Quantity B2B"; Rec."Quantity B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity';
                ToolTip = 'the amount or number of something, especially that can be measured ';
            }
            field("Sub Assembly B2B"; Rec."Sub Assembly B2B")
            {
                ApplicationArea = All;
                Caption = 'Sub Assembly';
                ToolTip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
            }
            field("Spec ID B2B"; Rec."Spec ID B2B")
            {
                ApplicationArea = All;
                Caption = 'Spec ID';
                ToolTip = 'Specification is a group of characteristics to be inspected of an item';
            }
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = All;
                Caption = 'QC Enabled';
                tooltip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';
            }
            field("Quantity Sent to Quality B2B"; Rec."Quantity Sent to Quality B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sent to Quality';
                tooltip = 'how much quantity sent to quality';
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
                ToolTip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';

            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rework';
                tooltip = 'any remark the quantity send the vendor is therework quantity ';
            }
        }

    }

    actions
    {
        addlast("&Line")
        {
            group(InspectionB2B)
            {
                Caption = 'I&nspection';
                ToolTip = 'inspection and approved during each phase in order to detect and correct quality problems';
                action("Inspection Data Sheets B2B")
                {
                    Caption = '&Inspection Data Sheets';
                    ToolTip = 'the Quality department carry out the quality activities by using the IDS';
                    Image = Insert;
                    ApplicationArea = All;
                    RunObject = Page "Inspection Data Sheet List B2B";
                    RunPageLink = "Source Type" = CONST(WIP),
                                    "Prod. Order No." = FIELD("Prod. Order No."),
                                    "Routing Reference No." = FIELD("Routing Reference No."),
                                    "Routing No." = FIELD("Routing No."), "Operation No." = FIELD("Operation No.");

                }
                action("Posted Inspection Data Sheets B2B")
                {
                    Caption = '&Posted Inspection Data Sheets';
                    ToolTip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    Image = Indent;
                    ApplicationArea = All;
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "Source Type" = CONST(WIP),
                                    "Prod. Order No." = FIELD("Prod. Order No."),
                                    "Routing Reference No." = FIELD("Routing Reference No."),
                                    "Routing No." = FIELD("Routing No."),
                                    "Operation No." = FIELD("Operation No.");
                }
                action("Inspection Receipts B2B")
                {
                    Caption = 'Inspection &Receipts';
                    ToolTip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                    Image = Receipt;
                    ApplicationArea = All;
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Source Type" = CONST(WIP),
                                    "Prod. Order No." = FIELD("Prod. Order No."),
                                    "Routing Reference No." = FIELD("Routing Reference No."),
                                    "Routing No." = FIELD("Routing No."),
                                    "Operation No." = FIELD("Operation No."),
                                    Status = CONST(false);
                }
                action("Posted Inspection Receipts B2B")
                {
                    Caption = 'Posted I&nspection Receipts';
                    ToolTip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    Image = PostedReceipt;
                    ApplicationArea = All;
                    RunObject = Page "Posted Ins Receipt List B2B";
                    RunPageLink = "Source Type" = CONST(WIP),
                                    "Prod. Order No." = FIELD("Prod. Order No."),
                                    "Routing Reference No." = FIELD("Routing Reference No."),
                                    "Routing No." = FIELD("Routing No."),
                                    "Operation No." = FIELD("Operation No."),
                                    Status = CONST(True);
                }
            }
        }

    }

}
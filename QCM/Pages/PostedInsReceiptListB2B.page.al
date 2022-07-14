page 33000267 "Posted Ins Receipt List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Posted Inspect. Receipt List';
    CardPageID = "Posted Inspection Receipt B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Inspection Receipt Header B2B";
    SourceTableView = WHERE(Status = FILTER(true));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the number selected no.series from set up numbering tabs';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = all;
                    tooltip = ' Receipt no. on which the sample as received';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor number ';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name the vendor';
                }
                field("Rework Reference No."; Rec."Rework Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'At the time of receipt of the material back from the vendor, open the same document rework reference number';
                }
                field("Rework Inspect DS Created"; Rec."Rework Inspect DS Created")
                {
                    ApplicationArea = all;
                    tooltip = 'material back from the the vendor again testing the material to created IDS & IR';
                }
                field("Last Rework Level"; Rec."Last Rework Level")
                {
                    ApplicationArea = all;
                    tooltip = 'number of  last times sending for vendor';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'any item transaction maintain the document is automatically generated the number  item ledger entry number ';
                }
                field("Rework Level"; Rec."Rework Level")
                {
                    ApplicationArea = all;
                    tooltip = 'no of times sending for vendor';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the items number';
                }
                field("Purch Line No"; Rec."Purch Line No")
                {
                    ApplicationArea = all;
                    ToolTip = 'purchase order the lines mention the items ,uom ,quantity is the single line number ';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Qty. Accepted"; Rec."Qty. Accepted")
                {
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';
                }
                field("Qty. Rejected"; Rec."Qty. Rejected")
                {
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to “Certified”';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                separator("---")
                {
                    Caption = '---';
                }
                action("Purchase Receipt")
                {
                    Caption = 'Purchase Receipt';
                    Image = Purchase;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "No." = FIELD("Receipt No.");
                    ApplicationArea = all;
                    tooltip = 'purchase Receipts used for reporting and vendor analysis';
                }
            }
        }
    }

    var

}


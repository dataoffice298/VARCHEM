page 33000271 "Inspection Receipt List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Inspection Receipt List';
    CardPageID = "Inspection Receipt B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Inspection Receipt Header B2B";
    SourceTableView = WHERE(Status = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the number';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = all;
                    tooltip = ' Receipt no. on which the sample as received';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor number selected the no.series from setup numbering tab';
                }
                field("Rework Level"; Rec."Rework Level")
                {
                    ApplicationArea = all;
                    tooltip = 'number of times sending for vendor';
                }
                field("Rework Reference No."; Rec."Rework Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'At the time of receipt of the material back from the vendor, open the same document reference number';
                }
                field("Rework Inspect DS Created"; Rec."Rework Inspect DS Created")
                {
                    ApplicationArea = all;
                    tooltip = 'material back from the the vendor again testing the material to created IDS & IR';
                }
                field("Last Rework Level"; Rec."Last Rework Level")
                {
                    ApplicationArea = all;
                    ToolTip = 'last number of times sending for vendor';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'item tranaction the automatic generated the number for item ledger entry number';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name ';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the item number selected the no.series from  inventory setup numbering tab';
                }
                field("Purch Line No"; Rec."Purch Line No")
                {
                    ApplicationArea = all;
                    tooltip = 'purchase order the  line mention the items ,uom ,quantity is the single line number';
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
                    ToolTip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
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
                action("Purchase Receipt")
                {
                    Caption = 'Purchase Receipt';
                    Image = Receipt;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "No." = FIELD("Receipt No.");
                    ApplicationArea = all;
                    tooltip = 'purchase receipt used for reporting and vendor analysis';
                }
            }
        }
    }

    var

}


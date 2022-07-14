page 33000281 "Delivery/Receipt Entries B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Delivery/Receipt Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Delivery/Receipt Entry B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'items transaction to document of the entry no';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'item number selected the no.series from inventory setup numbering tab';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the source number';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = all;
                    tooltip = 'any transaction in single lines the order line number ';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the document the number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    tooltip = 'Mention the location code from which the inventory is to be dispatched';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field Showcasing Remaining Quantity';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Application Entry no should be Displayed';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines Open Quantities';

                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = all;
                    ToolTip = 'This field Defines type of entry';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'selected the type of source';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field("Applies-To- Entry"; Rec."Applies-To- Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Enries Applied for DeliveryReceipt ';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field Defines Unique No For Item Ledgers';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                    tooltip = 'setting the setuo  the series number';
                }
                field("Item Ledger Lot No."; Rec."Item Ledger Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'which item mention item tracking the item ledger lot  number ';
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ApplicationArea = all;
                    tooltip = 'this date for defect is the warranty date';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                    tooltip = 'items to date expired by expiration date';
                }
                field("Rework Level"; Rec."Rework Level")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Fileld Defines Level of Rework';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                    tooltip = 'Used for Changing location';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor number is identify the users';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the ordrr number';
                }
                field("Inbound Item Ledger Entry No."; Rec."Inbound Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'in bound item entry the company that is purchase type  item ledger entry number';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    ApplicationArea = all;
                    tooltip = 'this field tenter the code of the subassembly ';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    tooltip = 'which types use the document';
                }
            }
        }
    }

    actions
    {
    }
}


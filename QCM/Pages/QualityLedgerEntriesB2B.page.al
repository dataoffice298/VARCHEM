page 33000275 "Quality Ledger Entries B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Quality Ledger Entry B2B";
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
                    ToolTip = 'Unique id for Quality ledger Entries';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the item Number';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the code from subassembly';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                    tooltip = 'setting the serial no.from setup ';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines Type of Entry';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the source Number';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Defines no of Lines in a Order';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the Document Number';
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
                    ToolTip = 'Remaining Quantity need to assign';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines Application Entry no';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = all;
                    ToolTip = 'Used to open selected pages';
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = all;
                    ToolTip = 'Classify Type of Entry';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    tooltip = 'Selected the Source type like Purchase,Sale,Transfer';
                }
                field("<Lot No2>"; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field("Applies-to QLE Entry"; Rec."Applies-to QLE Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Application Entry Of QLE';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = all;
                    tooltip = 'It Describes Reasons for Rejection Quantities ';
                }
                field("In bound Item Ledger Entry No."; Rec."In bound Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'in bound item entry the company that is item ledger entry number';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Any order transaction the automatic generated the item ledger entry number';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                    tooltip = 'create new location stored the new items';
                }
            }
        }
    }

    actions
    {
    }
}


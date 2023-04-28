pageextension 50042 "PurchaseQuoteSubf" extends "Purchase Quote Subform"
{
    layout
    {
        addlast(Control1)
        {

            field("Available Inventory"; Rec."Available Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Available Inventory field.';
            }
            field("PO Qty"; Rec."PO Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PO Qty field.';
            }
            field(Make; Rec.Make)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Make field.';
            }
            field(Model; Rec.Model)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Model field.';
            }
            field("Shortage Qty"; Rec."Shortage Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortage Qty field.';
            }
            field("Open Quote Qty"; Rec."Open Quote Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Open Quote Qty field.';
            }
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify(ShortcutDimCode7)
        {
            Visible = false;
        }
        modify(ShortcutDimCode8)
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
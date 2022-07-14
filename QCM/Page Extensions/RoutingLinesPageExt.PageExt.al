pageextension 33000311 RoutingLinesPageExtB2B extends "Routing Lines"
{

    layout
    {
        addlast("Control1")
        {

            field("Sub Assembly B2B"; Rec."Sub Assembly B2B")
            {
                ApplicationArea = All;
                Caption = 'Sub Assembly';
                ToolTip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
            }
            field("Qty. Produced B2B"; Rec."Qty. Produced B2B")
            {
                ApplicationArea = All;
                Caption = 'Qty. Produced';
                ToolTip = 'quantity of the commodity slod the market quantities consumed or used by the Qty.producers';
            }
            field("Sub Assembly UOM Code B2B"; Rec."Sub Assembly UOM Code B2B")
            {
                ApplicationArea = All;
                Caption = 'Sub Assembly UOM Code';
                ToolTip = 'sub Assembly unit of measured code used to assembly product measure for the piece,box';
            }
            field("Spec ID B2B"; Rec."Spec ID B2B")
            {
                ApplicationArea = All;
                Caption = 'Spec ID';
                tooltip = 'Specification is a group of characteristics to be inspected of an item';
            }
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = All;
                Caption = 'QC Enabled';
                tooltip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';
            }
        }
    }
}
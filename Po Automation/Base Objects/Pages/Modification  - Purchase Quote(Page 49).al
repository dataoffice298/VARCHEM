pageextension 50000 pageextension70000001 extends "Purchase Quote"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO1.0

    layout
    {
        addafter("Document Date")
        {
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = All;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Quote No."; Rec."Vendor Quote No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Quote No. field.';
            }
            field("Vendor Quote Date"; Rec."Vendor Quote Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Quote Date field.';
            }
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }


    }

    //Unsupported feature: PropertyChange. Please convert manually.

}


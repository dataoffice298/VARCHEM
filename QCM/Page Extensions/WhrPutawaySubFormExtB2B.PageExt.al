pageextension 33000315 "WhrPutawaySubFormExt B2B" extends "Whse. Put-away Subform"
{
    layout
    {
        addafter("Cross-Dock Information")
        {

            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                Caption = 'Quantity Accepted';
                ApplicationArea = all;
                ToolTip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                caption = 'Quantity Rework';
                ApplicationArea = all;
                ToolTip = 'any remark quantity send to vendor is the rework Quantity';
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                Caption = 'Quantity Rejected';
                ApplicationArea = all;
                ToolTip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
            }
            field("Qty. Sending to Quality B2B"; Rec."Qty. Sending to Quality B2B")
            {
                Caption = 'Qty. Sending to Quality';
                ApplicationArea = all;
                ToolTip = 'which Qty to sending to Quality';
            }
            field("Qty. Sent to Quality B2B"; Rec."Qty. Sent to Quality B2B")
            {
                Caption = 'Qty. Sent to Quality';
                ApplicationArea = all;
                tooltip = 'how much Qty.sent to Quality';
            }
        }
    }

}
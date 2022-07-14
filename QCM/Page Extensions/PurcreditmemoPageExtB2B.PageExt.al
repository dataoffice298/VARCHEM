pageextension 33000289 "PurcreditmemoPageExt B2B" extends "Purchase Credit Memo"
{
    actions
    {
        addlast("P&osting")
        {
            group("QC B2B")
            {
                Caption = '&Receipt';
                action("CopyQltyRejItems B2B")
                {
                    Caption = 'Copy Quality &Rejected Items';
                    ToolTip = 'Used to copy the rejected items';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01
                        Rec.CopyQRItemstoCreditMemo();
                        // Stop   B2BQC1.00.00 - 01
                    end;
                }

            }

        }
    }
}
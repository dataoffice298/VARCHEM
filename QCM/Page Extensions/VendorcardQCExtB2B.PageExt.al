pageextension 33000317 "VendorcardQCExt B2B" extends "Vendor card"
{
    layout
    {
        addlast(General)
        {
            group("Quality B2B")
            {
                Caption = 'Quality';
                field("Rework Location B2B"; Rec."Rework Location B2B")
                {
                    ApplicationArea = All;
                    Caption = 'Rework Location';
                    ToolTip = 'quantity rework stored the location';

                }
            }
        }
    }
    actions
    {
        addafter("VendorReportSelections")
        {
            action("QualityApproval B2B")
            {
                Caption = 'Quality Approval';
                ToolTip = 'Quantity is the testing for accept is the Quantity Approval';
                RunObject = page 33000273;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Approval;
            }
        }
    }
}
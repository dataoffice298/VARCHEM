pageextension 33000309 "PurchOrdPageExt B2B" extends "Purchase Order"
{
    actions
    {


        addlast(Warehouse)
        {
            group("Quality B2B")
            {
                Caption = '&Receipt';
                action("CreateInspectionDataSheets B2B")
                {
                    Caption = 'Create Inspection Data &Sheets';
                    ToolTip = 'we can create inspected data sheet is any item testing using for new ids created';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        CurrPage.PurchLines.PAGE.CreateInspecDataSheets();
                    end;
                }
                //B2BESGOn09Feb2022++
                action("Purchase Order Report")
                {
                    Caption = 'Purchase Order Report';
                    Promoted = true;
                    PromotedCategory = Report;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        PurchaseReport: Report PurchaseOrder;
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader.Reset();
                        PurchaseHeader.SetRange("No.", Rec."No.");
                        if PurchaseHeader.FindFirst() then
                            Report.RunModal(33000269, true, false, PurchaseHeader);
                    end;
                }
                //B2BESGOn09Feb2022--

            }

        }
    }
}
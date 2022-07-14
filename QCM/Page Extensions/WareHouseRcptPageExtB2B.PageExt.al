pageextension 33000316 "WareHouseRcptPageExt B2B" extends "Warehouse Receipt"
{

    actions
    {

        addlast("F&unctions")
        {
            group("QC B2B")
            {
                Caption = 'QC';
                action("CreateInspDataSheets B2B")
                {
                    Caption = 'Create Inspection Data &Sheets';
                    ToolTip = 'we can create inspected data sheet is any item testing using for new ids created';
                    ApplicationArea = all;
                    Image = CreateDocument;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        CurrPage.WhseReceiptLines.PAGE.CreateInspectionDataSheets();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
            }
        }
    }

}
pageextension 50006 RelProdOrd extends "Released Production Order"
{
    layout
    {

    }

    actions
    {
        addafter(RefreshProductionOrder)
        {
            action("Shortage Report")
            {
                Image = Report;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ShrtReport: Report "Shortage Report";
                begin
                    ShrtReport.GetInden(rec."No.", rec."Shortcut Dimension 2 Code", rec.Quantity, rec."Source No.");
                    ShrtReport.Run();
                end;
            }
        }
        addlast("F&unctions")
        {
            action("Create Inspection Data Sheets B2B")
            {
                Caption = 'Create Inspection Data &Sheets';
                ToolTip = 'we can create inspected data sheet is any item testing using for new ids created';
                Image = MakeOrder;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    // Start  B2BQC1.00.00 - 01

                    CurrPage.ProdOrderLines.PAGE.CreateInspDataSheets();

                    // Stop   B2BQC1.00.00 - 01
                end;
            }
        }
    }

    var
        myInt: Integer;
}
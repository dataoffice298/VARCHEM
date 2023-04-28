page 50027 "Quotation Comparison List"
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = 50005;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
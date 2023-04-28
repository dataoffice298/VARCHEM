page 50001 "Indent Line"
{
    // version PH1.0,PO1.0

    AutoSplitKey = true;
    //DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";


    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Department; rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Delivery Location"; rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("Req.Quantity"; rec."Req.Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Indent Status"; rec."Indent Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = All;
                }
                //B2BJK >>
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = all;
                }
                field("Enquiry Qty"; "Enquiry Qty")
                {
                    ApplicationArea = all;
                }
                field("Available Inventory"; Rec."Available Inventory")
                {
                    ApplicationArea = all;
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
        }
    }

    actions
    {
    }

    var
        ItemLedgerEntry: Record 32;
}


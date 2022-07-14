page 50011 "Indent SubForm List"
{
    // version PO1.0

    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Delivery Location"; Rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("Avail.Qty"; Rec."Avail.Qty")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Item No.", Rec."No.");
                        ItemLedgerEntry.SETRANGE("Variant Code", Rec."Variant Code");
                        //ItemLedgerEntry.SETRANGE("Location Code","Delivery Location");
                        PAGE.RUNMODAL(0, ItemLedgerEntry);
                    end;
                }
                field("Req.Quantity"; Rec."Req.Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Preferred Vendor';
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
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


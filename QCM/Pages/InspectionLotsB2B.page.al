page 33000266 "Inspection Lots B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Inspection Lots';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Inspection Lot B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'This is the total number of items being ordered';
                    trigger OnValidate();
                    begin
                        Rec.TESTFIELD("Lot No.");
                        PostPurchRcptLine.SETRANGE("Document No.", Rec."Document No.");
                        PostPurchRcptLine.SETRANGE("Line No.", Rec."Purch. Line No.");
                        if PostPurchRcptLine.FIND('-') then
                            Qty := PostPurchRcptLine.Quantity;

                        InspLot.SETRANGE("Document No.", Rec."Document No.");
                        InspLot.SETRANGE("Purch. Line No.", Rec."Purch. Line No.");
                        InspLot.SETFILTER("Lot No.", '<>%1', Rec."Lot No.");
                        InspLot.CALCSUMS(Quantity);
                        if InspLot.Quantity + Rec.Quantity > Qty then
                            ERROR(Text001Err, InspLot.Quantity + Rec.Quantity, Qty);

                    end;
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("Inspect. Data Sheet Created"; Rec."Inspect. Data Sheet Created")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'the Quality department carry out the quality activities by using the  created new one IDS';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Inspection Data Sheets")
                {
                    Caption = 'Inspection Data Sheets';
                    Image = InsuranceLedger;
                    RunObject = Page "Inspection Data Sheet List B2B";
                    RunPageLink = "Receipt No." = FIELD("Document No."),
                                  "Purch. Line No" = FIELD("Purch. Line No."),
                                  "Lot No." = FIELD("Lot No.");
                    ApplicationArea = all;
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                }
                action("Posted Inspection Data Sheets")
                {
                    Caption = 'Posted Inspection Data Sheets';
                    Image = PostApplication;
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "Receipt No." = FIELD("Document No."),
                                  "Purch. Line No" = FIELD("Purch. Line No."),
                                  "Lot No." = FIELD("Lot No.");
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                }
                action("Inspection Receipt")
                {
                    Caption = 'Inspection Receipt';
                    Image = Import;
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Receipt No." = FIELD("Document No."),
                                  "Purch Line No" = FIELD("Purch. Line No."),
                                  "Lot No." = FIELD("Lot No.");
                    ApplicationArea = all;
                    tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                }
                action("Posted Inspection Receipt")
                {
                    Caption = 'Posted Inspection Receipt';
                    Image = PostDocument;
                    RunObject = Page "Posted Inspection Receipt B2B";
                    RunPageLink = "Receipt No." = FIELD("Document No."),
                                  "Purch Line No" = FIELD("Purch. Line No."),
                                  "Lot No." = FIELD("Lot No."),
                                  Status = FILTER(<> false);
                    ApplicationArea = all;
                    tooltip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                }
            }
        }
    }

    var
        PostPurchRcptLine: Record "Purch. Rcpt. Line";
        InspLot: Record "Inspection Lot B2B";
        Text001Err: Label 'Total Lots Quantity %1  should not more than Receipt Quantity %2.', Comment = '%1 = InspLot.Quantity ;%2 = Rec.qty';
        Qty: Decimal;
}


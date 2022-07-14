page 33000276 "Ins Item Tracking Lines B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Inspection Item Tracking Lines';
    PageType = Worksheet;
    SourceTable = "Quality Item Ledger Entry B2B";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'setting to setup the series number';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Sending to Rework"; Rec."Sending to Rework")
                {
                    ApplicationArea = all;
                    tooltip = 'whuch quantity sending the rework to vendor';
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Showcasing Warranty Date of the item';
                }
                field("Accept Under Deviation"; Rec."Accept Under Deviation")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field allows Deviation Quantities Under Accept';
                }
                field("Inspection Status"; Rec."Inspection Status")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'inspection status is the good or bad is testing process';
                }
                field(Accept; Rec.Accept)
                {
                    ApplicationArea = all;
                    tooltip = ' any items is taken a approval the testing process is the accept';
                }
                field(Rework; Rec.Rework)
                {
                    ApplicationArea = all;
                    tooltip = 'any remark the item to rework ';
                }
                field(Reject; Rec.Reject)
                {
                    ApplicationArea = all;
                    tooltip = ' any items is taken a approval the testing process is the reject';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'any materials due to time id expired is the expiration data';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    var
        CaptionText1: Text[20];
    //CaptionText2: Text[100];
    begin
        CaptionText1 := Rec."Item No.";
        /*
        if CaptionText1 <> '' then begin
            CaptionText2 := CurrPage.CAPTION();
            CurrPage.CAPTION := STRSUBSTNO(Text001Msg, CaptionText1, CaptionText2);
        end;
        */
        CurrPage.CAPTION := CaptionText1;
    end;

    var
    //Text001Msg: Label '%1 - %2';
}


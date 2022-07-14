page 33000282 "Acceptance Levels B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Acceptance Levels';
    PageType = List;
    SourceTable = "Acceptance Level B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    tooltip = 'enter the code of source';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    tooltip = ' this list of the all order';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                    tooltip = 'reason define which define the levels of acceptance, rejections/reworks at the time of Inspection Receipts';
                }
                field("Vendor Rating"; Rec."Vendor Rating")
                {
                    ApplicationArea = all;
                    tooltip = 'vendor rating the number';
                }
            }
        }
    }

    actions
    {
    }
}


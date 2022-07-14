page 33000250 "Inspection Groups B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Inspection Groups';
    PageType = List;
    SourceTable = "Inspection Group B2B";
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
                    ApplicationArea = All;
                    ToolTip = 'system of words,letters,or signs uesd to represent a code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name the items';
                }
            }
        }
    }

    actions
    {
    }
}


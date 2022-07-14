page 33000252 "Sampling Plan List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Sampling Plan List';
    CardPageID = "Sampling Plan B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Sampling Plan Header B2B";
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

                    ToolTip = 'system of words,letter,or signs used to represent code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user.';
                }
            }
        }
    }

    actions
    {
    }
}


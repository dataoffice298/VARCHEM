page 33000293 "Quality Comment List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    AutoSplitKey = true;
    Caption = 'Comment List';
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Quality Comment Line B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    tooltip = 'selected which type users';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    tooltip = ' automatic numbering using generic number series';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    tooltip = 'mention the date order';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                    tooltip = 'The user can add comments to a specification';
                }
            }
        }
    }

    actions
    {
    }
}


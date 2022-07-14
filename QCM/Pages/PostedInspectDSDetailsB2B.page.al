page 33000272 "Posted Inspect. DS Details B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Posted Inspect. DS Details';
    Editable = false;
    PageType = List;
    SourceTable = "Posted Ins DatasheetHeader B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter ther number slected from no.series';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = all;
                    tooltip = 'which order posted';
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ApplicationArea = all;
                    tooltip = 'which data is the posted data';
                }
                field("Posted Time"; Rec."Posted Time")
                {
                    ApplicationArea = all;
                    tooltip = 'which time to post';


                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Show")
            {
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "Posted Ins Data Sheet B2B";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = all;
                tooltip = 'This shows the Document';
            }
        }
    }
}


page 33000280 "Assay List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Assay List';
    CardPageID = "Assay B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Assay Header B2B";
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
                    tooltip = ' automatic numbering using generic number series';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Sampling Plan Code"; Rec."Sampling Plan Code")
                {
                    ApplicationArea = all;
                    tooltip = 'sampling plan that is applicable to the set of characters to be inspected by the inspection group';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
                }
                field("Inspection Group Code"; Rec."Inspection Group Code")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection group that is responsible for inspection of the group of characters enlisted between Begin and end';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102154002; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        /*
        area(navigation)
        {
            Caption = '<Action1102154000>';
            group("<Action1102154001>")
            {
                Caption = '&Assay';
            }
        }
        */
    }
}


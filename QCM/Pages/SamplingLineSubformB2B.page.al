page 33000261 "Sampling Line Subform B2B"
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
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Sampling Plan Line B2B";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Lot Size - Min"; Rec."Lot Size - Min")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'That is, enter the min value of the selected range in the “Lot Size-min” ';

                }
                field("Lot Size - Max"; Rec."Lot Size - Max")
                {
                    ApplicationArea = all;
                    tooltip = 'That is, enter the max value of the selected range in the “Lot Size-Max”';
                }
                field("Sampling Size"; Rec."Sampling Size")
                {
                    ApplicationArea = all;
                    tooltip = 'sample size to be considered to assess the quality of the item';
                }
                field("Allowable Defects - Max"; Rec."Allowable Defects - Max")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field Defines Maximum Alloe';
                }
            }
        }
    }

    actions
    {
    }

    var

}


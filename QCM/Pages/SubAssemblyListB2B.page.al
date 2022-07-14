page 33000285 "Sub Assembly List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Sub Assembly List';
    CardPageID = "Sub Assembly Card B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Sub Assembly B2B";
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
                    tooltip = 'automatic numbering using generic number series';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                    tooltip = 'ant name search ';
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("QC Enabled"; Rec."QC Enabled")
                {
                    ApplicationArea = all;
                    tooltip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    tooltip = ' unit of measure code from item unit of measure where the quantity to customer is to be dispatched';
                }
                field(Block; Rec.Block)
                {
                    ApplicationArea = all;
                    tooltip = 'any order user the block';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102154001; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}


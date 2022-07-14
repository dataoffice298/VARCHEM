page 33000260 "Sampling Plan B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Sampling Plan';
    PageType = ListPlus;
    SourceTable = "Sampling Plan Header B2B";
    UsageCategory = Administration;
    ApplicationArea = all;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = ' Code Number which can be set to be chosen manually or set the number series';
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user.';
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'After entry of the relevant data, the status must be changed';
                }
                field("Standard Reference"; Rec."Standard Reference")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines standard References for sampling plan';
                }
                field("AQL Percentage"; Rec."AQL Percentage")
                {
                    ApplicationArea = all;
                    ToolTip = ' Defines Acceptable Quality Limit Percentage';
                }
                field("Sampling Type"; Rec."Sampling Type")
                {
                    ApplicationArea = all;
                    tooltip = ' Sampling type can be defined which may vary for each QC type. Based on the Specification defined here, the QC activities can be performed';
                }
                field("Fixed Quantity"; Rec."Fixed Quantity")
                {
                    ApplicationArea = all;
                    tooltip = 'Irrespective of the lot size, the system considers only the sample size specified in the “fixed Quantity';
                }
                field("Lot Percentage"; Rec."Lot Percentage")
                {
                    ApplicationArea = all;
                    tooltip = 'Here the sample size can be defined as percentage of the lot size';
                }
            }
            part(Control1000000006; "Sampling Line Subform B2B")
            {
                SubPageLink = "Sampling Code" = FIELD(Code);
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}


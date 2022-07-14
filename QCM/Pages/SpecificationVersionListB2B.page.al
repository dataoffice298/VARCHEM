page 33000292 "Specification Version List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Specification Version List';
    CardPageID = "Specification Version B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Specification Version B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1102152000)
            {
                field("Version Code"; Rec."Version Code")
                {
                    ApplicationArea = all;
                    tooltip = 'mention the version code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the planning the manufacturing process start the  starting date';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = all;
                    tooltip = 'which date last modified the order it last date modified';
                }
            }
        }
    }

    actions
    {
    }
}


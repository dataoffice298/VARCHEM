page 33000251 "Characteristics B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Characteristics';
    PageType = List;
    SourceTable = "Characteristic B2B";
    ApplicationArea = all;
    UsageCategory = Lists;

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
                    ToolTip = 'Description for Identification purpose for  the user.';
                }
                field(Qualitative; Rec.Qualitative)
                {
                    ApplicationArea = all;
                    tooltip = ' for those attributes that are qualitative in nature.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'unit of measure code is the assign the measure the pieces,box';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if Rec.Code <> '' then
            Rec.CALCFIELDS(Attachment);
    end;
}


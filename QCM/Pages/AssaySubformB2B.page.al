page 33000279 "Assay Subform B2B"
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
    SourceTable = "Assay Line B2B";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Character Code"; Rec."Character Code")
                {
                    ApplicationArea = all;
                    tooltip = 'The character or attribute of the item that is to be observed for quality assessment';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Normal Value (Num)"; Rec."Normal Value (Num)")
                {
                    ApplicationArea = all;
                    tooltip = 'Normal value of the characteristics in numbers numeric test data';
                }
                field("Min. Value (Num)"; Rec."Min. Value (Num)")
                {
                    ApplicationArea = all;
                    tooltip = 'Minimum permitted value to acceptance in number ';
                }
                field("Max. Value (Num)"; Rec."Max. Value (Num)")
                {
                    ApplicationArea = all;
                    tooltip = 'Maximum permitted value to acceptance in numbe';
                }
                field("Normal Value (Char)"; Rec."Normal Value (Char)")
                {
                    ApplicationArea = all;
                    tooltip = 'Normal permitted value to acceptance in character e.g. Colour = Blue';
                }
                field("Min. Value (Char)"; Rec."Min. Value (Char)")
                {
                    ApplicationArea = all;
                    tooltip = 'Minimum permitted value to acceptance in character';
                }
                field("Max. Value (Char)"; Rec."Max. Value (Char)")
                {
                    ApplicationArea = all;
                    tooltip = 'Maximum permitted value to acceptance in character';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    tooltip = ' unit of measure code from item unit of measure where the quantity is to be dispatched';
                }
                field(Qualitative; Rec.Qualitative)
                {
                    ApplicationArea = all;
                    tooltip = 'those attributes that are qualitative in nature';
                }
            }
        }
    }

    actions
    {
    }
}


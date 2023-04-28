page 33000254 "Specification Subform B2B"
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
    SourceTable = "Specification Line B2B";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("Character Code"; Rec."Character Code")
                {
                    Caption = 'Character Code';
                    tooltip = 'The character or attribute of the item that is to be observed for quality ';
                    ApplicationArea = all;
                }
                field("Character Type"; Rec."Character Type")
                {
                    ApplicationArea = all;

                    tooltip = 'For identifying the line ,heading,standard,egin,end';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Description for Identification purpose for  the use';
                    ApplicationArea = all;
                }
                field("Inspection Group Code"; Rec."Inspection Group Code")
                {
                    Caption = 'Inspection Group Code';
                    ApplicationArea = all;
                    tooltip = 'The Inspection group should be selected from the lookup button on the lines that have the character type as Begin';
                }
                field("Sampling Code"; Rec."Sampling Code")
                {
                    Caption = 'Sampling Code';
                    tooltip = 'Specify the number of units to be tested here Characteristics group level to all Characteristics of that group ';
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                    ToolTip = 'Define Unit of Measure of the items to be tested';
                    ApplicationArea = all;
                }
                field(Qualitative; Rec.Qualitative)
                {
                    ApplicationArea = all;
                    tooltip = 'those attributes that are qualitative in nature.';
                }
                field("Normal Value (Num)"; Rec."Normal Value (Num)")
                {
                    Caption = 'Normal Value (Num)';
                    ApplicationArea = all;
                    tooltip = 'Normal value of the characteristics in numbers normal data test ';
                }
                field("Min. Value (Num)"; Rec."Min. Value (Num)")
                {
                    Caption = 'Min. Value (Num)';
                    tooltip = 'Minimum permitted value to acceptance in number ';
                    ApplicationArea = all;
                }
                field("Max. Value (Num)"; Rec."Max. Value (Num)")
                {
                    Caption = 'Max. Value (Num)';
                    tooltip = 'Maximum permitted value to acceptance in number ';
                    ApplicationArea = all;
                }
                field("Normal Value (Char)"; Rec."Normal Value (Char)")
                {
                    Caption = 'Normal Value (Char)';
                    tooltip = '-Normal permitted value to acceptance in character (ex-colour =blue';
                    ApplicationArea = all;
                }
                field("Min. Value (Char)"; Rec."Min. Value (Char)")
                {
                    Caption = 'Min. Value (Char)';
                    tooltip = '-Minimum permitted value to acceptance in character ';
                    ApplicationArea = all;
                }
                field("Max. Value (Char)"; Rec."Max. Value (Char)")
                {
                    Caption = 'Max. Value (Char)';
                    tooltip = 'Maximum permitted value to acceptance in character';
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        DescriptionIndent := 0;
        CharacterCodeOnFormat();
        DescriptionOnFormat();


    end;

    var
        [InDataSet]
        "Character CodeEmphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        DescriptionIndent: Integer;



    local procedure CharacterCodeOnFormat();
    begin
        "Character CodeEmphasize" := Rec."Character Type" <> Rec."Character Type"::Standard;
    end;

    local procedure DescriptionOnFormat();
    begin
        DescriptionEmphasize := Rec."Character Type" <> Rec."Character Type"::Standard;
        DescriptionIndent := Rec.Indentation;
    end;
}


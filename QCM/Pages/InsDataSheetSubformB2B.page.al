page 33000258 "Ins Data Sheet Subform B2B"
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
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Inspection Datasheet Line B2B";

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
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Quality control tests are done for various parameters such as identification, density, absorbance, color, assay ';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Sampling Plan Code"; Rec."Sampling Plan Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'sampling plan that is applicable to the set of characters to be inspected by the inspection group';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Define Unit of Measure of the items to be tested';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                    tooltip = 'reason codes are attached to the Acceptance Levels';
                }
                field(Qualitative; Rec.Qualitative)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'those attributes that are qualitative in nature';
                }
                field("Normal Value (Num)"; Rec."Normal Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Normal value of the characteristics in numbers numeric test data';
                }
                field("Min. Value (Num)"; Rec."Min. Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Minimum permitted value to acceptance in number ';
                }
                field("Max. Value (Num)"; Rec."Max. Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Maximum permitted value to acceptance in number ';
                }
                field(Accept; Rec.Accept)
                {
                    ApplicationArea = all;
                    tooltip = 'if quantity all property approval is the accept ';
                }
                field("Actual Value (Num)"; Rec."Actual Value (Num)")
                {
                    BlankZero = true;
                    ApplicationArea = all;
                    tooltip = ' Actual values  value to acceptance in number';
                }
                field("Normal Value (Text)"; Rec."Normal Value (Text)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Normal value of the characteristics in numbers numeric test data';
                }
                field("Min. Value (Text)"; Rec."Min. Value (Text)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Minimum permitted value to acceptance in number ';
                }
                field("Max. Value (Text)"; Rec."Max. Value (Text)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Maximum permitted value to acceptance in number ';
                }
                field("Actual  Value (Text)"; Rec."Actual  Value (Text)")
                {
                    ApplicationArea = all;
                    tooltip = 'actual permitted value to acceptance in number ';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    tooltip = 'any quantity remarks the quantity';
                }
                field("Inspection Persons"; Rec."Inspection Persons")
                {
                    ApplicationArea = all;
                    tooltip = 'which person testing the items is the inspection person';
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
        "Character CodeEmphasize": Boolean;
        DescriptionEmphasize: Boolean;
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


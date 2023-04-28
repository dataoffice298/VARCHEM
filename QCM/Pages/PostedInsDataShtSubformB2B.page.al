page 33000263 "PostedIns DataSht Subform B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Ins Datasheet Line B2B";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the line number';
                }
                field("Character Code"; Rec."Character Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'The character or attribute of the item that is to be observed for quality assessment';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user.';
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
                    tooltip = ' unit of measure code from item unit of measure where the quantity to customer is to be dispatched';
                }
                field("Normal Value (Num)"; Rec."Normal Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Normal value of the characteristics in numbers numeric test data';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                    tooltip = 'Reason Codes are normally used during the Quality Operations';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    tooltip = 'any quantity rework is remark';
                }
                field("Inspection Persons"; Rec."Inspection Persons")
                {
                    ApplicationArea = all;
                    tooltip = 'which person the tested items is the inspection person';
                }
                field("Min. Value (Num)"; Rec."Min. Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Minimum permitted value to acceptance in number';
                }
                field(Accept; Rec.Accept)
                {
                    ApplicationArea = all;
                    tooltip = 'any quantity is approval is the accept';
                }
                field("Max. Value (Num)"; Rec."Max. Value (Num)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Maximum permitted value to acceptance in number ';
                }
                field("Actual Value (Num)"; Rec."Actual Value (Num)")
                {
                    ApplicationArea = all;
                    tooltip = 'actual  permitted value to acceptance in number ';
                    StyleExpr = Rec."Style Expression"; //4.06
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
                    tooltip = 'Maximum permitted value to acceptance in number';
                }
                field("Actual  Value (Text)"; Rec."Actual  Value (Text)")
                {
                    ApplicationArea = all;
                    tooltip = 'actual permitted value to acceptance in number';
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


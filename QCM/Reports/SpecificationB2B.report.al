report 33000253 "Specification B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Report.
    DefaultLayout = RDLC;
    RDLCLayout = './Specification.rdlc';

    Caption = 'Specification';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Specification Header"; "Specification Header B2B")
        {
            RequestFilterFields = "Spec ID";
            column(USERID; USERID())
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY(), 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(Specification_Header__Spec_ID_; "Spec ID")
            {
            }
            column(Specification_Header_Description; Description)
            {
            }
            column(SpecificationCaption; SpecificationCaptionLbl)
            {
            }
            column(Specification_Header_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Specification_Header__Spec_ID_Caption; FIELDCAPTION("Spec ID"))
            {
            }
            dataitem("Specification Line"; "Specification Line B2B")
            {
                DataItemLink = "Spec ID" = FIELD("Spec ID");
                DataItemTableView = SORTING("Spec ID", "Character Code", "Line No.");
                column(Specification_Line__Line_No__; "Line No.")
                {
                }
                column(Specification_Line__Character_Code_; "Character Code")
                {
                }
                column(Specification_Line_Description; Description)
                {
                }
                column(Specification_Line__Sampling_Code_; "Sampling Code")
                {
                }
                column(Specification_Line__Normal_Value__Num__; "Normal Value (Num)")
                {
                }
                column(Specification_Line__Min__Value__Num__; "Min. Value (Num)")
                {
                }
                column(Specification_Line__Max__Value__Num__; "Max. Value (Num)")
                {
                }
                column(Specification_Line__Normal_Value__Char__; "Normal Value (Char)")
                {
                }
                column(Specification_Line__Min__Value__Char__; "Min. Value (Char)")
                {
                }
                column(Specification_Line__Max__Value__Char__; "Max. Value (Char)")
                {
                }
                column(Specification_Line__Inspection_Group_Code_; "Inspection Group Code")
                {
                }
                column(Specification_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Specification_Line__Line_No__Caption; FIELDCAPTION("Line No."))
                {
                }
                column(Specification_Line__Character_Code_Caption; FIELDCAPTION("Character Code"))
                {
                }
                column(Specification_Line_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Specification_Line__Sampling_Code_Caption; FIELDCAPTION("Sampling Code"))
                {
                }
                column(Specification_Line__Normal_Value__Num__Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Specification_Line__Min__Value__Num__Caption; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Specification_Line__Max__Value__Num__Caption; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Specification_Line__Normal_Value__Char__Caption; FIELDCAPTION("Normal Value (Char)"))
                {
                }
                column(Specification_Line__Min__Value__Char__Caption; FIELDCAPTION("Min. Value (Char)"))
                {
                }
                column(Specification_Line__Max__Value__Char__Caption; FIELDCAPTION("Max. Value (Char)"))
                {
                }
                column(Specification_Line__Inspection_Group_Code_Caption; FIELDCAPTION("Inspection Group Code"))
                {
                }
                column(Specification_Line__Unit_of_Measure_Code_Caption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Specification_Line_Spec_ID; "Spec ID")
                {
                }
                column(Specification_Line_Version_Code; "Version Code")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        SpecificationCaptionLbl: Label 'Specification';
}


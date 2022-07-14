report 33000252 "Posted Ins Data Sheet B2B"
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
    RDLCLayout = './Posted Inspection Data Sheet.rdlc';

    Caption = 'Posted Inspection Data Sheet';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Posted Inspect DatasheetHeader"; "Posted Ins DatasheetHeader B2B")
        {
            RequestFilterFields = "No.", "Inspection Group Code", "Vendor No.", "Posting Date";
            column(USERID; USERID())
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY(), 0, 4))
            {
            }
            column(Posted_Inspect_DatasheetHeader_Quantity; Quantity)
            {
            }
            column(Posted_Inspect_DatasheetHeader__Item_Description_; "Item Description")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Item_No__; "Item No.")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Order_No__; "Order No.")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Posting_Date_; "Posting Date")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Document_Date_; "Document Date")
            {
            }
            column(Posted_Inspect_DatasheetHeader_Address; Address)
            {
            }
            column(Posted_Inspect_DatasheetHeader__Spec_ID_; "Spec ID")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Receipt_No__; "Receipt No.")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Vendor_Name_; "Vendor Name")
            {
            }
            column(Posted_Inspect_DatasheetHeader_Description; Description)
            {
            }
            column(Posted_Inspect_DatasheetHeader__Vendor_No__; "Vendor No.")
            {
            }
            column(Posted_Inspect_DatasheetHeader__No__; "No.")
            {
            }
            column(Posted_Inspect_DatasheetHeader__Inspection_Group_Code_; "Inspection Group Code")
            {
            }
            column(Posted_Inspection_Data_SheetCaption; Posted_Inspection_Data_SheetCaptionLbl)
            {
            }
            column(Posted_Inspect_DatasheetHeader_QuantityCaption; FIELDCAPTION(Quantity))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Order_No__Caption; FIELDCAPTION("Order No."))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Document_Date_Caption; FIELDCAPTION("Document Date"))
            {
            }
            column(Posted_Inspect_DatasheetHeader_AddressCaption; FIELDCAPTION(Address))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Spec_ID_Caption; FIELDCAPTION("Spec ID"))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Receipt_No__Caption; FIELDCAPTION("Receipt No."))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Vendor_Name_Caption; FIELDCAPTION("Vendor Name"))
            {
            }
            column(Posted_Inspect_DatasheetHeader_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(Posted_Inspect_DatasheetHeader__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Posted_Inspect_DatasheetHeader__Inspection_Group_Code_Caption; FIELDCAPTION("Inspection Group Code"))
            {
            }
            dataitem("Posted Inspect Datasheet Line"; "Posted Ins Datasheet Line B2B")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Character Code", "Character Group No.");
                column(Posted_Inspect_Datasheet_Line_Description; Description)
                {
                }
                column(Posted_Inspect_Datasheet_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Character_Code_; "Character Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Num__; "Normal Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Num__; "Min. Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Num__; "Max. Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Text__; "Normal Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Text__; "Min. Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Text__; "Max. Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Sampling_Plan_Code_; "Sampling Plan Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Text___Control1102152054; "Max. Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Text___Control1102152056; "Min. Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Text___Control1102152058; "Normal Value (Text)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Num___Control1102152060; "Normal Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Num___Control1102152061; "Min. Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Num___Control1102152062; "Max. Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Unit_of_Measure_Code__Control1102152063; "Unit of Measure Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line_Description_Control1102152068; Description)
                {
                }
                column(Posted_Inspect_Datasheet_Line__Sampling_Plan_Code__Control1102152070; "Sampling Plan Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Character_Code__Control1102152072; "Character Code")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Actual_Value__Num__; "Actual Value (Num)")
                {
                }
                column(Posted_Inspect_Datasheet_Line__Actual__Value__Text__; "Actual  Value (Text)")
                {
                }
                column(SampleNo; SampleNo)
                {
                }
                column(Posted_Inspect_Datasheet_Line__Character_Code_Caption; FIELDCAPTION("Character Code"))
                {
                }
                column(Posted_Inspect_Datasheet_Line_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Unit_of_Measure_Code_Caption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Num__Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Num__Caption; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Num__Caption; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Text__Caption; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Text__Caption; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Text__Caption; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Actual_Value__Num__Caption; Actual_Value__Num__CaptionLbl)
                {
                }
                column(Actual__Value__Text__Caption; Actual__Value__Text__CaptionLbl)
                {
                }
                column(Posted_Inspect_Datasheet_Line__Sampling_Plan_Code_Caption; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Text___Control1102152054Caption; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Text___Control1102152056Caption; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Text___Control1102152058Caption; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Min__Value__Num___Control1102152061Caption; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Normal_Value__Num___Control1102152060Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Unit_of_Measure_Code__Control1102152063Caption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Max__Value__Num___Control1102152062Caption; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Posted_Inspect_Datasheet_Line_Description_Control1102152068Caption; FIELDCAPTION(Description))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Sampling_Plan_Code__Control1102152070Caption; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Posted_Inspect_Datasheet_Line__Character_Code__Control1102152072Caption; FIELDCAPTION("Character Code"))
                {
                }
                column(Actual_Value__Num_Caption; Actual_Value__Num_CaptionLbl)
                {
                }
                column(Actual__Value__Text_Caption; Actual__Value__Text_CaptionLbl)
                {
                }
                column(S_NoCaption; S_NoCaptionLbl)
                {
                }
                column(Posted_Inspect_Datasheet_Line_Document_No_; "Document No.")
                {
                }
                column(Posted_Inspect_Datasheet_Line_Line_No_; "Line No.")
                {
                }
                column(Posted_Inspect_Datasheet_Line_Character_Group_No_; "Character Group No.")
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
        SampleNo: Integer;
        Posted_Inspection_Data_SheetCaptionLbl: Label 'Posted Inspection Data Sheet';
        Actual_Value__Num__CaptionLbl: Label '<Actual Value (Num)>';
        Actual__Value__Text__CaptionLbl: Label '<Actual  Value (Text)>';
        Actual_Value__Num_CaptionLbl: Label 'Actual Value (Num)';
        Actual__Value__Text_CaptionLbl: Label 'Actual  Value (Text)';
        S_NoCaptionLbl: Label 'S.No';
}


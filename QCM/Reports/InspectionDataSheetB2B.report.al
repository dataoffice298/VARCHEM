report 33000250 "Inspection Data Sheet B2B"
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
    RDLCLayout = './Inspection Data Sheet.rdlc';

    Caption = 'Inspection Data Sheet';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(InspectDataHeader; "Ins Datasheet Header B2B")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Inspection Group Code", "Vendor No.", "Posting Date";
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            {
            }
            column(USERID; USERID())
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY(), 0, 4))
            {
            }
            column(InspectDataHeader_Quantity; Quantity)
            {
            }
            column(InspectDataHeader__Item_Description_; "Item Description")
            {
            }
            column(InspectDataHeader__Item_No__; "Item No.")
            {
            }
            column(InspectDataHeader__Order_No__; "Order No.")
            {
            }
            column(InspectDataHeader__Posting_Date_; "Posting Date")
            {
            }
            column(InspectDataHeader__Document_Date_; "Document Date")
            {
            }
            column(InspectDataHeader_Address; Address)
            {
            }
            column(InspectDataHeader__Spec_ID_; "Spec ID")
            {
            }
            column(InspectDataHeader__Receipt_No__; "Receipt No.")
            {
            }
            column(InspectDataHeader__Vendor_Name_; "Vendor Name")
            {
            }
            column(InspectDataHeader_Description; Description)
            {
            }
            column(InspectDataHeader__Vendor_No__; "Vendor No.")
            {
            }
            column(InspectDataHeader__No__; "No.")
            {
            }
            column(InspectDataHeader__Inspection_Group_Code_; "Inspection Group Code")
            {
            }
            column(SourceType_InspectDataHeader; InspectDataHeader."Source Type")
            {
            }
            column(Inspection_Data_SheetCaption; Inspection_Data_SheetCaptionLbl)
            {
            }
            column(InspectDataHeader_QuantityCaption; FIELDCAPTION(Quantity))
            {
            }
            column(InspectDataHeader__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(InspectDataHeader__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(InspectDataHeader__Order_No__Caption; FIELDCAPTION("Order No."))
            {
            }
            column(InspectDataHeader__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
            {
            }
            column(InspectDataHeader__Document_Date_Caption; FIELDCAPTION("Document Date"))
            {
            }
            column(InspectDataHeader_AddressCaption; FIELDCAPTION(Address))
            {
            }
            column(InspectDataHeader__Spec_ID_Caption; FIELDCAPTION("Spec ID"))
            {
            }
            column(InspectDataHeader__Receipt_No__Caption; FIELDCAPTION("Receipt No."))
            {
            }
            column(InspectDataHeader__Vendor_Name_Caption; FIELDCAPTION("Vendor Name"))
            {
            }
            column(InspectDataHeader_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(InspectDataHeader__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(InspectDataHeader__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(InspectDataHeader__Inspection_Group_Code_Caption; FIELDCAPTION("Inspection Group Code"))
            {
            }
            column(SourceTypeCaption; SourceTypeCaptionLbl)
            {
            }
            dataitem("Inspection Datasheet Line"; "Inspection Datasheet Line B2B")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Character Code", "Character Group No.") WHERE(Qualitative = FILTER(true));
                column(Qualitative_InspectionDataSheetLine; "Inspection Datasheet Line".Qualitative)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text__; "Normal Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code_; "Sampling Plan Code")
                {
                }
                column(Inspection_Datasheet_Line_Description; Description)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num__; "Normal Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Inspection_Datasheet_Line__Character_Code_; "Character Code")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text__; "Min. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num__; "Min. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text__; "Max. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num__; "Max. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text___Control1000000029; "Max. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text___Control1000000031; "Min. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text___Control1000000033; "Normal Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num___Control1000000035; "Normal Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num___Control1000000036; "Min. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num___Control1000000037; "Max. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code__Control1000000038; "Unit of Measure Code")
                {
                }
                column(Inspection_Datasheet_Line_Description_Control1000000043; Description)
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code__Control1000000045; "Sampling Plan Code")
                {
                }
                column(Inspection_Datasheet_Line__Character_Code__Control1000000047; "Character Code")
                {
                }
                column(Inspection_Datasheet_Line__Actual_Value__Num__; "Actual Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Actual__Value__Text__; "Actual  Value (Text)")
                {
                }
                column(SampleNo1; SampleNo1)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text__Caption; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code_Caption; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text__Caption; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text__Caption; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num__Caption; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num__Caption; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num__Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code_Caption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Inspection_Datasheet_Line__Character_Code_Caption; FIELDCAPTION("Character Code"))
                {
                }
                column(Actual_Value__Num__Caption; Actual_Value__Num__CaptionLbl)
                {
                }
                column(Actual__Value__Text__Caption; Actual__Value__Text__CaptionLbl)
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text___Control1000000029Caption; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text___Control1000000031Caption; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text___Control1000000033Caption; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num___Control1000000036Caption; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num___Control1000000035Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code__Control1000000038Caption; UnitofMeasureCaptionLbl)
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num___Control1000000037Caption; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line_Description_Control1000000043Caption; FIELDCAPTION(Description))
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code__Control1000000045Caption; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Inspection_Datasheet_Line__Character_Code__Control1000000047Caption; FIELDCAPTION("Character Code"))
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
                column(Inspection_Datasheet_Line_Document_No_; "Document No.")
                {
                }
                column(Inspection_Datasheet_Line_Line_No_; "Line No.")
                {
                }
                column(Inspection_Datasheet_Line_Character_Group_No_; "Character Group No.")
                {
                }
                column(MinValueText_InspectionDataSheetLine; "Inspection Datasheet Line"."Min. Value (Text)")
                {
                }
                column(MaxValueText_InspectionDataSheetLine; "Inspection Datasheet Line"."Max. Value (Text)")
                {
                }
                column(MinValueTextCaption; MinValueTextCaptionLbl)
                {
                }
                column(MaxValueTextCaption; MaxValueTextCaptionLbl)
                {
                }
                column(QualitativeValueTrue; QualitativeValueTrue)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if "Inspection Datasheet Line"."Line No." <> 0 then
                        if "Character Code" <> '' then
                            SampleNo1 := SampleNo1 + 1;
                    CLEAR(QualitativeValueTrue);
                    QualitativeValueTrue := 'True'
                end;

                trigger OnPreDataItem();
                begin
                    CLEAR(SampleNo1);
                end;
            }
            dataitem("<Inspection Datasheet Line1>"; "Inspection Datasheet Line B2B")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Character Code", "Character Group No.") WHERE(Qualitative = FILTER(false));
                column(Qualitative_InspectionDataSheetLine1; "Inspection Datasheet Line".Qualitative)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text__1; "Normal Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code_1; "Sampling Plan Code")
                {
                }
                column(Inspection_Datasheet_Line_Description1; Description)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num__1; "Normal Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code_1; "Unit of Measure Code")
                {
                }
                column(Inspection_Datasheet_Line__Character_Code_1; "Character Code")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text__1; "Min. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num__1; "Min. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text__1; "Max. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num__1; "Max. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text___Control1000000029_1; "Max. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text___Control1000000031_1; "Min. Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text___Control1000000033_1; "Normal Value (Text)")
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num___Control1000000035_1; "Normal Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num___Control1000000036_1; "Min. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num___Control1000000037_1; "Max. Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code__Control1000000038_1; "Unit of Measure Code")
                {
                }
                column(Inspection_Datasheet_Line_Description_Control1000000043_1; Description)
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code__Control1000000045_1; "Sampling Plan Code")
                {
                }
                column(Inspection_Datasheet_Line__Character_Code__Control1000000047_1; "Character Code")
                {
                }
                column(Inspection_Datasheet_Line__Actual_Value__Num___1; "Actual Value (Num)")
                {
                }
                column(Inspection_Datasheet_Line__Actual__Value__Text___1; "Actual  Value (Text)")
                {
                }
                column(SampleNo1_1; SampleNo1)
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text__Caption_1; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code_Caption_1; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text__Caption_1; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text__Caption_1; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line_DescriptionCaption_1; FIELDCAPTION(Description))
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num__Caption_1; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num__Caption_1; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num__Caption_1; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code_Caption_1; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Inspection_Datasheet_Line__Character_Code_Caption_1; FIELDCAPTION("Character Code"))
                {
                }
                column(Actual_Value__Num__Caption_1; Actual_Value__Num__CaptionLbl)
                {
                }
                column(Actual__Value__Text__Caption_1; Actual__Value__Text__CaptionLbl)
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Text___Control1000000029Caption_1; FIELDCAPTION("Max. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Text___Control1000000031Caption_1; FIELDCAPTION("Min. Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Text___Control1000000033Caption_1; FIELDCAPTION("Normal Value (Text)"))
                {
                }
                column(Inspection_Datasheet_Line__Min__Value__Num___Control1000000036Caption_1; FIELDCAPTION("Min. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Normal_Value__Num___Control1000000035Caption_1; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line__Unit_of_Measure_Code__Control1000000038Caption_1; UnitofMeasureCaptionLbl)
                {
                }
                column(Inspection_Datasheet_Line__Max__Value__Num___Control1000000037Caption_1; FIELDCAPTION("Max. Value (Num)"))
                {
                }
                column(Inspection_Datasheet_Line_Description_Control1000000043Caption_1; FIELDCAPTION(Description))
                {
                }
                column(Inspection_Datasheet_Line__Sampling_Plan_Code__Control1000000045Caption_1; FIELDCAPTION("Sampling Plan Code"))
                {
                }
                column(Inspection_Datasheet_Line__Character_Code__Control1000000047Caption_1; FIELDCAPTION("Character Code"))
                {
                }
                column(Actual_Value__Num_Caption_1; Actual_Value__Num_CaptionLbl)
                {
                }
                column(Actual__Value__Text_Caption_1; Actual__Value__Text_CaptionLbl)
                {
                }
                column(S_NoCaption_1; S_NoCaptionLbl)
                {
                }
                column(Inspection_Datasheet_Line_Document_No__1; "Document No.")
                {
                }
                column(Inspection_Datasheet_Line_Line_No__1; "Line No.")
                {
                }
                column(Inspection_Datasheet_Line_Character_Group_No__1; "Character Group No.")
                {
                }
                column(MinValueText_InspectionDataSheetLine_1; "Inspection Datasheet Line"."Min. Value (Text)")
                {
                }
                column(MaxValueText_InspectionDataSheetLine_1; "Inspection Datasheet Line"."Max. Value (Text)")
                {
                }
                column(MinValueTextCaption_1; MinValueTextCaptionLbl)
                {
                }
                column(MaxValueTextCaption_1; MaxValueTextCaptionLbl)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if "Line No." <> 0 then
                        if "Character Code" <> '' then
                            SampleNo1 := SampleNo1 + 1;
                end;

                trigger OnPreDataItem();
                begin
                    CLEAR(SampleNo1);
                end;
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

    trigger OnPreReport();
    begin
        CompanyInfo.GET();
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Inspection_Data_SheetCaptionLbl: Label 'Inspection Data Sheet';
        Actual_Value__Num__CaptionLbl: Label 'Actual Value (Num)';
        Actual__Value__Text__CaptionLbl: Label 'Actual  Value (Text)';
        Actual_Value__Num_CaptionLbl: Label 'Actual Value (Num)';
        Actual__Value__Text_CaptionLbl: Label 'Actual  Value (Text)';
        S_NoCaptionLbl: Label 'S.No';
        SourceTypeCaptionLbl: Label 'Source Type:';
        MinValueTextCaptionLbl: Label 'Min Value (Text)';
        MaxValueTextCaptionLbl: Label 'Max Value(Text)';
        UnitofMeasureCaptionLbl: Label 'UOM';
        SampleNo1: Integer;
        QualitativeValueTrue: Text;
}


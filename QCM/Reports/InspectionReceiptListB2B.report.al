report 33000267 "Inspection Receipt List B2B"
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
    RDLCLayout = './Inspection Receipt List.rdlc';

    Caption = 'Inspection Receipt List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            DataItemTableView = SORTING("Document Date", "Source Type", "Vendor No.", "Prod. Order No.") WHERE("Source Type" = CONST("In Bound"));
            RequestFilterFields = "Document Date", "Vendor No.", "Order No.";
            // ReqFilterHeading = 'Inspection Receipt';
            column(COMPANYNAME; COMPANYNAME())
            {
            }

            column(Inspection_Receipt_Header__Document_Date_; "Document Date")
            {
            }
            column(Vendor_No_________Vendor_Name_; "Vendor No." + '  ' + "Vendor Name")
            {
            }
            column(Inspection_Receipt_Header__No__; "No.")
            {
            }
            column(Inspection_Receipt_Header__Item_No__; "Item No.")
            {
            }
            column(Item_Description_______Desc; "Item Description" + '  ' + Desc)
            {
            }
            column(Inspection_Receipt_Header_Quantity; Quantity)
            {
            }
            column(Qty__Accepted_____Qty__Accepted_Under_Deviation_; "Qty. Accepted" + "Qty. Accepted Under Deviation")
            {
            }
            column(Inspection_Receipt_Header__Qty__Rejected_; "Qty. Rejected")
            {
            }
            column(Inspection_Receipt_Header__Qty__Rework_; "Qty. Rework")
            {
            }
            column(Inspection_Receipt_Header__Rework_Reference_No__; "Rework Reference No.")
            {
            }
            column(UOM; UOM)
            {
            }
            column(Inspection_Receipt_Header__Order_No__; "Order No.")
            {
            }
            column(Material_Receipt_and_Inspection_ReportCaption; Material_Receipt_and_Inspection_ReportCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(Vendor_No_____NameCaption; Vendor_No_____NameCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(AcceptedCaption; AcceptedCaptionLbl)
            {
            }
            column(ReworkCaption; ReworkCaptionLbl)
            {
            }
            column(RejectedCaption; RejectedCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Rework_Reference_No__Caption; FIELDCAPTION("Rework Reference No."))
            {
            }
            column(Unit_Of_MeasureCaption; Unit_Of_MeasureCaptionLbl)
            {
            }
            column(Order_No_Caption; Order_No_CaptionLbl)
            {
            }
            column(RemarksCaption; RemarksCaptionLbl)
            {
            }
            column(Inspected_byCaption; Inspected_byCaptionLbl)
            {
            }
            column(Approved_ByCaption; Approved_ByCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header_Vendor_No_; "Vendor No.")
            {
            }
            column(Inspection_Receipt_Header_Receipt_No_; "Receipt No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Item.GET("Item No.") then
                    Desc := Item."Description 2";

                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.SETRANGE("Document No.", "Order No.");
                PurchaseLine.SETRANGE("Line No.", "Purch Line No");
                if PurchaseLine.FIND('-') then
                    UOM := PurchaseLine."Unit of Measure Code";
            end;
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
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
        //Text005Msg: Label 'Page %1';
        Desc: Text[50];
        UOM: Code[20];

        Material_Receipt_and_Inspection_ReportCaptionLbl: Label 'Material Receipt and Inspection Report';
        DateCaptionLbl: Label 'Date';
        Vendor_No_____NameCaptionLbl: Label 'Vendor No. &  Name';
        No_CaptionLbl: Label '"  No."';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        TotalCaptionLbl: Label 'Total';
        QuantityCaptionLbl: Label 'Quantity';
        AcceptedCaptionLbl: Label 'Accepted';
        ReworkCaptionLbl: Label 'Rework';
        RejectedCaptionLbl: Label 'Rejected';
        Unit_Of_MeasureCaptionLbl: Label 'Unit Of Measure';
        Order_No_CaptionLbl: Label 'Order No.';
        RemarksCaptionLbl: Label 'Remarks';
        Inspected_byCaptionLbl: Label 'Inspected by';
        Approved_ByCaptionLbl: Label 'Approved By';
}


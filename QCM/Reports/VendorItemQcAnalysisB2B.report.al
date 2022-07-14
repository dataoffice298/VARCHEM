report 33000261 "Vendor Item Qc Analysis B2B"
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
    RDLCLayout = './Vendor Item Qc Analysis.rdl';

    Caption = 'Vendor Item Qc Analysis';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            DataItemTableView = SORTING("Vendor No.", "Item No.") WHERE(Status = FILTER(<> false), "Source Type" = CONST("In Bound"));
            RequestFilterFields = "Vendor No.", "Item No.";
            column(Picture_CompanyInfo; CompInfo.Picture)
            {
            }
            column(Inspection_Receipt_Header__No__; "No.")
            {
            }
            column(CompAddr_1_; CompAddr[1])
            {
            }
            column(CompAddr_2_; CompAddr[2])
            {
            }
            column(CompAddr_3_; CompAddr[3])
            {
            }
            column(CompAddr_4_; CompAddr[4])
            {
            }
            column(VendorInfo_3_; VendorInfo[3])
            {
            }
            column(VendorInfo_2_; VendorInfo[2])
            {
            }
            column(VendorInfo_1_; VendorInfo[1])
            {
            }
            column(Rej; Rej)
            {
            }
            column(Accpt; Accpt)
            {
            }
            column(RejQty; RejQty)
            {
            }
            column(AccptQty; AccptQty)
            {
            }
            column(TotalQty; TotalQty)
            {
            }
            column(Inspection_Receipt_Header__Item_Description_; "Item Description")
            {
            }
            column(Inspection_Receipt_Header__Item_No__; "Item No.")
            {
            }
            column(Inspection_Receipt_Header__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Vendor___Item_Quality_AnalysisCaption; Vendor___Item_Quality_AnalysisCaptionLbl)
            {
            }
            column(Company_Name__Caption; Company_Name__CaptionLbl)
            {
            }
            column(Compnay_Address__Caption; Compnay_Address__CaptionLbl)
            {
            }
            column(Compnay_Address2__Caption; Compnay_Address2__CaptionLbl)
            {
            }
            column(City__Caption; City__CaptionLbl)
            {
            }
            column(Rej__Caption; Rej__CaptionLbl)
            {
            }
            column(Accepted__Caption; Accepted__CaptionLbl)
            {
            }
            column(Qty_RejectedCaption; Qty_RejectedCaptionLbl)
            {
            }
            column(Qty_AcceptedCaption; Qty_AcceptedCaptionLbl)
            {
            }
            column(Total_QtyCaption; Total_QtyCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Item_Description_Caption; Inspection_Receipt_Header__Item_Description_CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Item_No__Caption; Inspection_Receipt_Header__Item_No__CaptionLbl)
            {
            }
            column(AddressCaption; AddressCaptionLbl)
            {
            }
            column(Vendor_NameCaption; Vendor_NameCaptionLbl)
            {
            }
            column(Vendor_No_Caption; Vendor_No_CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header_Vendor_No_; "Vendor No.")
            {
            }
            column(Details; Details)
            {
            }
            column(QtyAccepted_InspectionReceiptHdr; "Inspection Receipt Header"."Qty. Accepted")
            {
            }
            column(QtyRejected_InspectionReceiptHdr; "Inspection Receipt Header"."Qty. Rejected")
            {
            }
            column(QtyRework_InspectionReceiptHdr; "Inspection Receipt Header"."Qty. Rework")
            {
            }
            column(ReworkRefNo_InspectionReceiptHdr; "Inspection Receipt Header"."Rework Reference No.")
            {
            }
            column(OrdrNo_InspectionRceiptHdr; "Inspection Receipt Header"."Order No.")
            {
            }
            column(QtyAcceptedUndrDev_InspectionReceiptHdr; "Inspection Receipt Header"."Qty. Accepted Under Deviation")
            {
            }
            column(DocDate_InspectionReceiptHdr; "Inspection Receipt Header"."Document Date")
            {
            }
            column(PurchOrdrNoCaption; PurchOrdrNoCaptionLbl)
            {
            }
            column(QtyReworkCaption; QtyReworkCaptionLbl)
            {
            }
            column(QtyUnderDevCaption; QtyUnderDevCaptionLbl)
            {
            }
            column(PurchOrdrDateCaption; PurchOrdrDateCaptionLbl)
            {
            }
            column(IRNoCaption; IRNoCaptionLbl)
            {
            }
            column(ReworkRefNoCaption; ReworkRefNoCaptionLbl)
            {
            }
            column(ReworkRefNo; "Inspection Receipt Header"."Rework Reference No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                VendorInfo[1] := "Vendor No.";
                VendorInfo[2] := "Vendor Name";
                VendorInfo[3] := Address;
                VendorInfo[4] := "Address 2";
                COMPRESSARRAY(VendorInfo);


                CLEAR(AccptQty);
                CLEAR(RejQty);
                CLEAR(TotalQty);
                CLEAR(Accpt);
                CLEAR(Rej);

                /*
                 if Status = Status::"0" then
                     AccptQty := Quantity
                 else
                     if Status = Status::"1" then
                         RejQty := Quantity;
                 TotalQty := AccptQty + RejQty;
                 if TotalQty = 0 then
                     exit;
                     */
                TotalQty := Quantity;
                if TotalQty <> 0 then begin
                    Accpt := (("Qty. Accepted" + "Qty. Accepted Under Deviation" + "Qty. Rework") / TotalQty) * 100;
                    Rej := ("Qty. Rejected" / TotalQty) * 100;
                end;
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET();
                CompAddr[1] := CompInfo.Name;
                CompAddr[2] := CompInfo.Address;
                CompAddr[3] := CompInfo."Address 2";
                CompAddr[4] := CompInfo.City;
                COMPRESSARRAY(CompAddr);
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Details; Details)
                {
                    ApplicationArea = all;
                    Caption = 'Show Details';
                    ToolTip = 'Defines to capture the details of vendor';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInfo: Record "Company Information";
        VendorInfo: array[4] of Text[50];
        TotalQty: Integer;
        AccptQty: Integer;
        RejQty: Integer;
        Accpt: Decimal;
        Rej: Decimal;
        CompAddr: array[4] of Text[100];
        Vendor___Item_Quality_AnalysisCaptionLbl: Label 'Vendor - Item Quality Analysis';
        Company_Name__CaptionLbl: Label 'Company Name :';
        Compnay_Address__CaptionLbl: Label 'Compnay Address :';
        Compnay_Address2__CaptionLbl: Label 'Compnay Address2 :';
        City__CaptionLbl: Label 'City :';
        Rej__CaptionLbl: Label 'Rej %';
        Accepted__CaptionLbl: Label 'Accepted %';
        Qty_RejectedCaptionLbl: Label 'Qty Rejected';
        Qty_AcceptedCaptionLbl: Label 'Qty Accepted';
        Total_QtyCaptionLbl: Label 'Total Qty';
        Inspection_Receipt_Header__Item_Description_CaptionLbl: Label 'Item Description';
        Inspection_Receipt_Header__Item_No__CaptionLbl: Label 'Item No.';
        AddressCaptionLbl: Label 'Address';
        Vendor_NameCaptionLbl: Label 'Vendor Name';
        Vendor_No_CaptionLbl: Label 'Vendor No.';
        Details: Boolean;
        PurchOrdrNoCaptionLbl: Label 'Purch.Ordr No.';
        QtyReworkCaptionLbl: Label 'Qty.Rework';
        QtyUnderDevCaptionLbl: Label 'Qty.Under Deviation';
        PurchOrdrDateCaptionLbl: Label 'Purch.Order Date';
        IRNoCaptionLbl: Label 'IR No.';
        ReworkRefNoCaptionLbl: Label 'Rework Ref No.';
}


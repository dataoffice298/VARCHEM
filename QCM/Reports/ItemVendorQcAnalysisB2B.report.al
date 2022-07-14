report 33000263 "Item Vendor Qc Analysis B2B"
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
    RDLCLayout = './Item Vendor Qc Analysis.rdl';

    Caption = 'Item Vendor Qc Analysis';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            DataItemTableView = SORTING("Item No.", "Vendor No.") WHERE(Status = FILTER(<> false), "Source Type" = FILTER("In Bound"));
            RequestFilterFields = "Item No.", "Vendor No.";
            column(Picture_CompanyInfo; CompInfo.Picture)
            {
            }
            column(Inspection_Receipt_Header__No__; "No.")
            {
            }
            column(CompAddr_4_; CompAddr[4])
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
            column(Inspection_Receipt_Header__Item_Description_; "Item Description")
            {
            }
            column(Inspection_Receipt_Header__Item_No__; "Item No.")
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__; "Vendor No.")
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_; "Vendor Name")
            {
            }
            column(TotalQty; "Inspection Receipt Header".Quantity)
            {
            }
            column(AccptQty; AccptQty)
            {
            }
            column(RejQty; RejQty)
            {
            }
            column(Accpt; Accpt)
            {
            }
            column(Rej; Rej)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Item___Vendor_QC_AnalysisCaption; Item___Vendor_QC_AnalysisCaptionLbl)
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
            column(Rejected__Caption; Rejected__CaptionLbl)
            {
            }
            column(Accept__Caption; Accept__CaptionLbl)
            {
            }
            column(Rej__QtyCaption; Rej__QtyCaptionLbl)
            {
            }
            column(Accept_QtyCaption; Accept_QtyCaptionLbl)
            {
            }
            column(Total_QtyCaption; Total_QtyCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_Caption; Inspection_Receipt_Header__Vendor_Name_CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__Caption; Inspection_Receipt_Header__Vendor_No__CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Inspection_Receipt_Header__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(QtyUndrDev_inspctnHdr; "Inspection Receipt Header"."Qty. Accepted Under Deviation")
            {
            }
            column(QtyAccepted_InspectionHdr; "Inspection Receipt Header"."Qty. Accepted")
            {
            }
            column(QtyRej_InspectionHdr; "Inspection Receipt Header"."Qty. Rejected")
            {
            }
            column(QtyUnderDevCaption; QtyUnderDevCaptionLbl)
            {
            }
            column(Details; Details)
            {
            }
            column(OrdrNo_InspectionRecptHdr; "Inspection Receipt Header"."Order No.")
            {
            }
            column(PurchOrdrNoCaption; PurchOrdrNoCaptionLbl)
            {
            }
            column(PurchOrdrDateCaption; PurchOrdrDateCaptionLbl)
            {
            }
            column(PurchOrdrDate; "Inspection Receipt Header"."Document Date")
            {
            }
            column(QtyReworkCaption; QtyReworkCaptionLbl)
            {
            }
            column(Rework_InspectnRecptHdr; "Inspection Receipt Header"."Qty. Rework")
            {
            }
            column(IRNoCaption; IRNoCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(Rework_InspectionReceiptHdr; "Inspection Receipt Header"."Qty. Rework")
            {
            }
            column(TotalQuantity; AccepedTotalQuantity)
            {
            }
            column(ReworkRefNo_InspectionreceptHdr; "Inspection Receipt Header"."Rework Reference No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                /*

                if Status = Status::"0" then
                    AccptQty := Quantity
                else
                    if Status = Status::"1" then
                        RejQty := Quantity;

                TotalQty := AccptQty + RejQty;
                AccepedTotalQuantity += "Inspection Receipt Header"."Qty. Accepted";

                if TotalQty = 0 then
                    exit;
                    
*/

                TotalQty := Quantity;
                if TotalQty <> 0 then begin
                    Accpt := (("Qty. Accepted" + "Qty. Accepted Under Deviation" + "Inspection Receipt Header"."Qty. Rework") / TotalQty) * 100;
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
                CLEAR(AccptQty);
                CLEAR(RejQty);
                CLEAR(TotalQty);
                CLEAR(Accpt);
                CLEAR(Rej);

                CLEAR(AccptQty);
                CLEAR(RejQty);
                CLEAR(TotalQty);
                CLEAR(Accpt);
                CLEAR(Rej);

                CompInfo.CALCFIELDS(CompInfo.Picture);
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
        AccptQty: Integer;
        TotalQty: Integer;
        RejQty: Integer;
        Accpt: Decimal;
        Rej: Decimal;
        CompAddr: array[4] of Text[100];
        No_CaptionLbl: Label 'No.';
        Item___Vendor_QC_AnalysisCaptionLbl: Label 'Item - Vendor QC Analysis';
        Company_Name__CaptionLbl: Label 'Company Name :';
        Compnay_Address__CaptionLbl: Label 'Compnay Address :';
        Compnay_Address2__CaptionLbl: Label 'Compnay Address2 :';
        City__CaptionLbl: Label 'City :';
        Rejected__CaptionLbl: Label 'Rejected %';
        Accept__CaptionLbl: Label 'Accept %';
        Rej__QtyCaptionLbl: Label 'Rej. Qty';
        Accept_QtyCaptionLbl: Label 'Accept Qty';
        Total_QtyCaptionLbl: Label 'Total Qty';
        Inspection_Receipt_Header__Vendor_Name_CaptionLbl: Label 'Vendor Name';
        Inspection_Receipt_Header__Vendor_No__CaptionLbl: Label 'Vendor No';
        QtyUnderDevCaptionLbl: Label 'Qty Under Deviation';
        Details: Boolean;
        PurchOrdrNoCaptionLbl: Label 'Purch.Order No';
        PurchOrdrDateCaptionLbl: Label 'Purch.Order Date';
        QtyReworkCaptionLbl: Label 'Qty.Rework';
        IRNoCaptionLbl: Label 'IR No:';
        PageCaptionLbl: Label 'Page:';
        AccepedTotalQuantity: Decimal;
}


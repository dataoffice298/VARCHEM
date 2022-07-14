report 33000259 "Item Receipt B2B"
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
    RDLCLayout = './Item Receipt.rdlc';

    Caption = 'Item Receipt';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            DataItemTableView = SORTING("Item No.");
            RequestFilterFields = "Receipt No.";
            column(Inspection_Receipt_Header__Receipt_No__; "Receipt No.")
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__; "Vendor No.")
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_; "Vendor Name")
            {
            }
            column(Inspection_Receipt_Header_Address; Address)
            {
            }
            column(Inspection_Receipt_Header__Item_No__; "Item No.")
            {
            }
            column(Inspection_Receipt_Header__Item_Description_; "Item Description")
            {
            }
            column(TotalQty; TotalQty)
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
            column(AcceptedQty_InspectionHdr; "Inspection Receipt Header"."Qty. Accepted")
            {
            }
            column(RejQty_InspectionHdr; "Inspection Receipt Header"."Qty. Rejected")
            {
            }
            column(UndrProgressQty; UndrProgressQty)
            {
            }
            column(UnderProgQty; UnderProgQty)
            {
            }
            column(Receipt_Wise_QC_AnalysisCaption; Receipt_Wise_QC_AnalysisCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Receipt_No__Caption; FIELDCAPTION("Receipt No."))
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_Caption; FIELDCAPTION("Vendor Name"))
            {
            }
            column(Address_Inspection_Receipt_Header; FIELDCAPTION(Address))
            {
            }
            column(Inspection_Receipt_Header__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Inspection_Receipt_Header__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Total_QtyCaption; Total_QtyCaptionLbl)
            {
            }
            column(Qty_AcceptedCaption; Qty_AcceptedCaptionLbl)
            {
            }
            column(Qty_Rej_Caption; Qty_Rej_CaptionLbl)
            {
            }
            column(Accept__Caption; Accept__CaptionLbl)
            {
            }
            column(Rej__Caption; Rej__CaptionLbl)
            {
            }
            column(Qty_Under_ProgressCaption; Qty_Under_ProgressCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header_No_; "No.")
            {
            }
            column(ItemNo; ItemNoFilter)
            {
            }

            trigger OnAfterGetRecord();
            begin
                /*
                if Status = Status::0 then
                    AccptQty := Quantity
                else
                    if Status = Status::"1" then
                        RejQty := Quantity;
                if (Status = Status::"0") or (Status = Status::"1") then begin
                    UnderProgQty := 0;
                    TotalQty := AccptQty + RejQty;
                end;
                if TotalQty = 0 then;
                if Status = Status::"0" then begin
                    UnderProgQty := Quantity;
                    AccptQty := 0;
                    RejQty := 0;
                    TotalQty := UnderProgQty + AccptQty + RejQty;
                end;
                */
                UndrProgressQty := (Quantity - ("Qty. Accepted" + "Qty. Rejected"));
                TotalQty := Quantity;

                if TotalQty <> 0 then begin
                    Accpt := (("Qty. Accepted" + "Qty. Accepted Under Deviation") / TotalQty) * 100;
                    Rej := ("Qty. Rejected" / TotalQty) * 100;
                end;
            end;

            trigger OnPreDataItem();
            begin
                Evaluate(ItemNoFilter, "Inspection Receipt Header".GETFILTER("Item No."));
                UndrProgressQty := 0;
                CompInfo.GET();
                CompAddr[1] := CompInfo.Name;
                CompAddr[2] := CompInfo.Address;
                CompAddr[3] := CompInfo."Address 2";
                CompAddr[4] := CompInfo.City;
                COMPRESSARRAY(CompAddr);
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
        CompInfo: Record "Company Information";
        AccptQty: Integer;
        RejQty: Integer;
        TotalQty: Integer;
        Accpt: Decimal;
        Rej: Decimal;
        UnderProgQty: Integer;
        Receipt_Wise_QC_AnalysisCaptionLbl: Label 'Receipt Wise QC Analysis';
        Total_QtyCaptionLbl: Label 'Total Qty';
        Qty_AcceptedCaptionLbl: Label 'Qty Accepted';
        Qty_Rej_CaptionLbl: Label 'Qty Rej.';
        Accept__CaptionLbl: Label 'Accept %';
        Rej__CaptionLbl: Label 'Rej %';
        Qty_Under_ProgressCaptionLbl: Label 'Qty Under Progress';
        UndrProgressQty: Integer;


        CompAddr: array[4] of Text[100];
        ItemNoFilter: Code[250];
}


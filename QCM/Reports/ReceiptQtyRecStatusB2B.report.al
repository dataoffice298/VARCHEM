report 33000258 "Receipt-Qty Rec Status B2B"
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
    RDLCLayout = './Receipt - Qty Received Status.rdl';

    Caption = 'Receipt - Qty Received Status';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            DataItemTableView = SORTING("Receipt No.", "Item No.") WHERE(Quantity = FILTER(<> 0));
            RequestFilterFields = "Receipt No.";
            column(CompAddr_1_; CompAddr[1])
            {
            }
            column(CompAddr_4_; CompAddr[4])
            {
            }
            column(CompAddr_2_; CompAddr[2])
            {
            }
            column(CompAddr_3_; CompAddr[3])
            {
            }
            column(Inspection_Receipt_Header_Address; Address)
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_; "Vendor Name")
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__; "Vendor No.")
            {
            }
            column(Inspection_Receipt_Header__Receipt_No__; "Receipt No.")
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
            column(UnderProgQty; UnderProgQty)
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
            column(Receipt_Wise___Quantity_Received__Status_ReportCaption; Receipt_Wise___Quantity_Received__Status_ReportCaptionLbl)
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
            column(Inspection_Receipt_Header_AddressCaption; FIELDCAPTION(Address))
            {
            }
            column(Inspection_Receipt_Header__Vendor_Name_Caption; FIELDCAPTION("Vendor Name"))
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(Inspection_Receipt_Header__Receipt_No__Caption; FIELDCAPTION("Receipt No."))
            {
            }
            column(Received_QtyCaption; Received_QtyCaptionLbl)
            {
            }
            column(Qty_Under_ProgressCaption; Qty_Under_ProgressCaptionLbl)
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
            column(Item_No___Caption; Item_No___CaptionLbl)
            {
            }
            column(Description__Caption; Description__CaptionLbl)
            {
            }
            column(Inspection_Receipt_Header_No_; "No.")
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
                TotalQty := Quantity;

                if TotalQty <> 0 then begin

                    Accpt := (AccptQty / TotalQty) * 100;
                    Rej := (RejQty / TotalQty) * 100;

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
        CompAddr: array[4] of Text[100];
        Receipt_Wise___Quantity_Received__Status_ReportCaptionLbl: Label 'Receipt Wise - Quantity Received  Status Report';
        Company_Name__CaptionLbl: Label 'Company Name :';
        Compnay_Address__CaptionLbl: Label 'Compnay Address :';
        Compnay_Address2__CaptionLbl: Label 'Compnay Address2 :';
        City__CaptionLbl: Label 'City :';
        Received_QtyCaptionLbl: Label 'Received Qty';
        Qty_Under_ProgressCaptionLbl: Label 'Qty Under Progress';
        Qty_AcceptedCaptionLbl: Label 'Qty Accepted';
        Qty_Rej_CaptionLbl: Label 'Qty Rej.';
        Accept__CaptionLbl: Label 'Accept %';
        Rej__CaptionLbl: Label 'Rej %';
        Item_No___CaptionLbl: Label 'Item No. :';
        Description__CaptionLbl: Label 'Description :';
}


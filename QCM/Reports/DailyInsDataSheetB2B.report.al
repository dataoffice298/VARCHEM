report 33000270 "Daily Ins Data Sheet B2B"
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
    RDLCLayout = './Daily Inspection Data Sheet.rdlc';

    Caption = 'Daily Inspection Data Sheet';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Datasheet Header"; "Ins Datasheet Header B2B")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Created Date", "Vendor No.", "Order No.";
            // ReqFilterHeading = 'Inspection Datasheet';
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY(), 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }

            column(USERID; USERID())
            {
            }
            column(Inspection_Datasheet_Header__No__; "No.")
            {
            }
            column(Inspection_Datasheet_Header__Created_Date_; "Created Date")
            {
            }
            column(Inspection_Datasheet_Header__Source_Type_; "Source Type")
            {
            }
            column(Inspection_Datasheet_Header__Item_No__; "Item No.")
            {
            }
            column(Inspection_Datasheet_Header__Item_Description_; "Item Description")
            {
            }
            column(Inspection_Datasheet_Header_Quantity; Quantity)
            {
            }
            column(Inspection_Datasheet_Header__Rework_Reference_No__; "Rework Reference No.")
            {
            }
            column(Inspection_Datasheet_Header__Vendor_No__; "Vendor No.")
            {
            }
            column(Inspection_Datasheet_Header__Vendor_Name_; "Vendor Name")
            {
            }
            column(Inspection_Datasheet_Header__Order_No__; "Order No.")
            {
            }
            column(OrderLineNO; OrderLineNO)
            {
            }
            column(Inspection_Datasheet_Header__Prod__Order_No__; "Prod. Order No.")
            {
            }
            column(Inspection_Datasheet_Header__Routing_No__; "Routing No.")
            {
            }
            column(Operation_No__________Operation_Description_; "Operation No." + '  ' + "Operation Description")
            {
            }
            column(Sl_No__; "Sl.No.")
            {
            }
            column(Inspection_Datasheet_Header__Created_By_; "Created By")
            {
            }
            column(Inspection_Datasheet_Header__Created_Date__Control1000000017; "Created Date")
            {
            }
            column(Inspection_Datasheet_Header__Posted_Date_; "Posted Date")
            {
            }
            column(Inspection_Datasheet_Header__Posted_By_; "Posted By")
            {
            }
            column(Daily_Inspection_Datasheet_HeaderCaption; Daily_Inspection_Datasheet_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Material_Receipt___Inspection_ReportCaption; Material_Receipt___Inspection_ReportCaptionLbl)
            {
            }
            column(IDS_No_Caption; IDS_No_CaptionLbl)
            {
            }
            column(Inspection_Datasheet_Header__Created_Date_Caption; FIELDCAPTION("Created Date"))
            {
            }
            column(Inspection_Datasheet_Header__Source_Type_Caption; FIELDCAPTION("Source Type"))
            {
            }
            column(Inspection_Datasheet_Header__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Inspection_Datasheet_Header__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Qty_Caption; Qty_CaptionLbl)
            {
            }
            column(Rework_Ref__No_Caption; Rework_Ref__No_CaptionLbl)
            {
            }
            column(Vendor_No_____NameCaption; Vendor_No_____NameCaptionLbl)
            {
            }
            column(Inspection_Datasheet_Header__Order_No__Caption; FIELDCAPTION("Order No."))
            {
            }
            column(Line_NoCaption; Line_NoCaptionLbl)
            {
            }
            column(Routing_No___Opr_No__DescCaption; Routing_No___Opr_No__DescCaptionLbl)
            {
            }
            column(Sl_No_Caption; Sl_No_CaptionLbl)
            {
            }
            column(Inspection_Datasheet_Header__Created_By_Caption; FIELDCAPTION("Created By"))
            {
            }
            column(Inspection_Datasheet_Header__Created_Date__Control1000000017Caption; FIELDCAPTION("Created Date"))
            {
            }
            column(Stores_InchargeCaption; Stores_InchargeCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(Inspection_Datasheet_Header__Posted_Date_Caption; FIELDCAPTION("Posted Date"))
            {
            }
            column(Inspection_Datasheet_Header__Posted_By_Caption; FIELDCAPTION("Posted By"))
            {
            }

            trigger OnAfterGetRecord();
            begin
                "Sl.No." := "Sl.No." + 1;
                if (Rawmat = true) then
                    OrderLineNO := "Inspection Datasheet Header"."Purch. Line No";

                if ("Semi.finished" = true) or (finished = true) then
                    OrderLineNO := "Inspection Datasheet Header"."Prod. Order Line";
            end;

            trigger OnPostDataItem();
            begin
                Rawmat := false;
                "Semi.finished" := false;
                finished := false;
            end;

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("No.");
                "Sl.No." := 0;
                if (Rawmat = true) then
                    "Inspection Datasheet Header".SETFILTER("Source Type", 'In Bound');


                if ("Semi.finished" = true) then begin
                    "Inspection Datasheet Header".SETFILTER("Source Type", 'WIP');
                    "Inspection Datasheet Header".SETFILTER("Inspection Datasheet Header"."Operation No.", '>0')
                end;

                if (finished = true) then begin
                    "Inspection Datasheet Header".SETFILTER("Source Type", 'WIP');
                    "Inspection Datasheet Header".SETRANGE("Inspection Datasheet Header"."Operation No.", '')
                end;
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
        LastFieldNo: Integer;
        "Sl.No.": Integer;
        OrderLineNO: Integer;
        Rawmat: Boolean;
        "Semi.finished": Boolean;
        finished: Boolean;
        Daily_Inspection_Datasheet_HeaderCaptionLbl: Label 'Daily Inspection Datasheet Header';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Material_Receipt___Inspection_ReportCaptionLbl: Label 'Material Receipt & Inspection Report';
        IDS_No_CaptionLbl: Label 'IDS No.';
        Qty_CaptionLbl: Label 'Qty.';
        Rework_Ref__No_CaptionLbl: Label 'Rework Ref. No.';
        Vendor_No_____NameCaptionLbl: Label 'Vendor No. &  Name';
        Line_NoCaptionLbl: Label 'Line No';
        Routing_No___Opr_No__DescCaptionLbl: Label 'Routing No.  Opr.No.&Desc';
        Sl_No_CaptionLbl: Label 'Sl.No.';
        Stores_InchargeCaptionLbl: Label 'Stores Incharge';
        DateCaptionLbl: Label 'Date';
}


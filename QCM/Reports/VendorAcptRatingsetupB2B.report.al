report 33000271 "Vendor Acpt Ratingsetup B2B"
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
    RDLCLayout = './Vendor Acceptance Ratingsetup.rdlc';

    Caption = 'Vendor Acceptance Ratingsetup';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Vendor Rating"; "Vendor Rating B2B")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Item No.", "Vendor No.";
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(Rating; Rating)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Reject; "Vendor Rating".Reject)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Rework; "Vendor Rating".Rework)
            {
            }
            column(Vendor_Rating__Vendor_Rating___Accepted_UD_; "Vendor Rating"."Accepted UD")
            {
            }
            column(Vendor_Rating__Vendor_Rating__Accepted; "Vendor Rating".Accepted)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Inspected; "Vendor Rating".Inspected)
            {
            }
            column(Vendor_Rating__Item_No__; "Item No.")
            {
            }
            column(Vendor_Rating__Vendor_No__; "Vendor No.")
            {
            }
            column(Vendor_Rating__Item_No___Control1000000000; "Item No.")
            {
            }
            column(Vendor_Rating__Vendor_No___Control1000000002; "Vendor No.")
            {
            }
            column(Rating_PointsCaption; Rating_PointsCaptionLbl)
            {
            }
            column(Vendor_Rating__Vendor_Rating__RejectCaption; FIELDCAPTION(Reject))
            {
            }
            column(Vendor_Rating__Vendor_Rating__ReworkCaption; FIELDCAPTION(Rework))
            {
            }
            column(Vendor_Rating__Vendor_Rating___Accepted_UD_Caption; FIELDCAPTION("Accepted UD"))
            {
            }
            column(Vendor_Rating__Vendor_Rating__AcceptedCaption; FIELDCAPTION(Accepted))
            {
            }
            column(InspectedCaption; InspectedCaptionLbl)
            {
            }
            column(Vendor_Rating__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Vendor_Rating__Vendor_No___Control1000000002Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(Vendor_RatingCaption; Vendor_RatingCaptionLbl)
            {
            }
            column(IR_Acceptance_Levels_QuantityCaption; "IR Acceptance Levels".FIELDCAPTION(Quantity))
            {
            }
            column(IR_Acceptance_Levels__Reason_Code_Caption; "IR Acceptance Levels".FIELDCAPTION("Reason Code"))
            {
            }
            column(IR_Acceptance_Levels__Acceptance_Code_Caption; "IR Acceptance Levels".FIELDCAPTION("Acceptance Code"))
            {
            }
            column(IR_Acceptance_Levels__Quality_Type_Caption; "IR Acceptance Levels".FIELDCAPTION("Quality Type"))
            {
            }
            column(Vendor_Rating__Item_No___Control1000000000Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Vendor_Rating__Vendor_No___Control1000000002Caption_Control1000000003; FIELDCAPTION("Vendor No."))
            {
            }
            dataitem("IR Acceptance Levels"; "IR Acceptance Levels B2B")
            {
                DataItemLink = "Item No." = FIELD("Item No."), "Vendor No." = FIELD("Vendor No.");
                DataItemTableView = SORTING("Item No.", "Vendor No.", "Acceptance Code") WHERE(Status = CONST(true));
                column(IR_Acceptance_Levels__Quality_Type_; "Quality Type")
                {
                }
                column(IR_Acceptance_Levels__Acceptance_Code_; "Acceptance Code")
                {
                }
                column(IR_Acceptance_Levels__Reason_Code_; "Reason Code")
                {
                }
                column(IR_Acceptance_Levels_Quantity; Quantity)
                {
                }
                column(IR_Acceptance_Levels_Quantity_Control1000000013; Quantity)
                {
                }
                column(VendorRating; VendorRating)
                {
                }
                column(Total_QuantityCaption; Total_QuantityCaptionLbl)
                {
                }
                column(IR_Acceptance_Levels_Inspection_Receipt_No_; "Inspection Receipt No.")
                {
                }
                column(IR_Acceptance_Levels_Line_No_; "Line No.")
                {
                }
                column(IR_Acceptance_Levels_Item_No_; "Item No.")
                {
                }
                column(IR_Acceptance_Levels_Vendor_No_; "Vendor No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                VendorRating := 0;
                if (Option = Option::FixedRating) then begin
                    CALCFIELDS(Inspected, Accepted, Reject, Rework, "Accepted UD");
                    ReceivedItems := "Vendor Rating".Inspected;
                    AcceptedItems := 0;
                    "Acc.UDItems" := 0;
                    ReworkItems := 0;
                    RejectedItems := 0;

                    if Inspected <> 0 then begin
                        AcceptedItems := (100 / ReceivedItems) * "Vendor Rating".Accepted;
                        "Acc.UDItems" := (100 / ReceivedItems) * "Vendor Rating"."Accepted UD";
                        RejectedItems := (100 / ReceivedItems) * "Vendor Rating".Reject;
                        ReworkItems := (100 / ReceivedItems) * "Vendor Rating".Rework;
                        // Rating := AcceptedItems * RatingForAccepted + "Acc.UDItems" * RatingForAccUD + ReworkItems * RatingForRework
                        //             + RejectedItems * RatingForRejected;
                        Rating := AcceptedItems * "Acc.UDItems" * ReworkItems * RejectedItems;
                    end;
                end;

                if (Option = Option::QCSetup) then begin
                    qcsetuprec.GET();
                    CALCFIELDS(Inspected, Accepted, Reject, Rework, "Accepted UD");
                    ReceivedItems := "Vendor Rating".Inspected;
                    AcceptedItems := 0;
                    "Acc.UDItems" := 0;
                    ReworkItems := 0;
                    RejectedItems := 0;

                    if Inspected <> 0 then begin
                        AcceptedItems := (100 / ReceivedItems) * "Vendor Rating".Accepted;
                        "Acc.UDItems" := (100 / ReceivedItems) * "Vendor Rating"."Accepted UD";
                        RejectedItems := (100 / ReceivedItems) * "Vendor Rating".Reject;
                        ReworkItems := (100 / ReceivedItems) * "Vendor Rating".Rework;
                        Rating := (AcceptedItems * qcsetuprec."Rating Per Accepted Qty.") + ("Acc.UDItems" * qcsetuprec."Rating Per Accepted UD Qty.") + (ReworkItems * qcsetuprec."Rating Per Rework Qty.") + (RejectedItems * qcsetuprec."Rating Per Rejected Qty.");
                    end;
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
        qcsetuprec: Record "Quality Control Setup B2B";
        VendorRating: Decimal;
        ReceivedItems: Decimal;
        AcceptedItems: Decimal;
        RejectedItems: Decimal;
        "Acc.UDItems": Decimal;
        ReworkItems: Decimal;
        Rating: Decimal;

        Option: Option FixedRating,QCSetup,Acclevel;
        Rating_PointsCaptionLbl: Label 'Rating Points';
        InspectedCaptionLbl: Label 'Inspected';
        Vendor_RatingCaptionLbl: Label 'Vendor Rating';
        Total_QuantityCaptionLbl: Label 'Total Quantity';
}


report 33000266 "Vendor Rating B2B"
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
    RDLCLayout = './Vendor Rating.rdlc';

    Caption = 'Vendor Rating';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Vendor Rating"; "Vendor Rating B2B")
        {
            RequestFilterFields = "Vendor No.", "Item No.", "Date Filter";
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(Vendor_Rating__Vendor_Rating___Accepted_UD_; "Vendor Rating"."Accepted UD")
            {
            }
            column(Vendor_Rating__Vendor_Rating__Rework; "Vendor Rating".Rework)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Reject; "Vendor Rating".Reject)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Accepted; "Vendor Rating".Accepted)
            {
            }
            column(Vendor_Rating__Vendor_Rating__Inspected; "Vendor Rating".Inspected)
            {
            }
            column(Rating; Rating)
            {
            }
            column(Vendor_Rating__Item_No__; "Item No.")
            {
            }
            column(Vendor_Rating__Vendor_No__; "Vendor No.")
            {
            }
            column(Vendor_Rating__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
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
            column(Rating_PointsCaption; Rating_PointsCaptionLbl)
            {
            }
            column(Vendor_Rating__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }

            trigger OnAfterGetRecord();
            begin
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
                    Rating := AcceptedItems * RatingForAccepted + "Acc.UDItems" * RatingForAccUD + ReworkItems * RatingForRework + RejectedItems * RatingForRejected;
                end;
            end;

            trigger OnPreDataItem();
            begin
                QCSetup.GET();
                RatingForAccepted := QCSetup."Rating Per Accepted Qty.";
                RatingForAccUD := QCSetup."Rating Per Accepted UD Qty.";
                RatingForRework := QCSetup."Rating Per Rework Qty.";
                RatingForRejected := QCSetup."Rating Per Rejected Qty.";
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
        QCSetup: Record "Quality Control Setup B2B";
        ReceivedItems: Decimal;
        AcceptedItems: Decimal;
        RejectedItems: Decimal;
        "Acc.UDItems": Decimal;
        ReworkItems: Decimal;
        Rating: Decimal;
        RatingForAccepted: Decimal;
        RatingForAccUD: Decimal;
        RatingForRework: Decimal;
        RatingForRejected: Decimal;
        InspectedCaptionLbl: Label 'Inspected';
        Rating_PointsCaptionLbl: Label 'Rating Points';
}


report 33000268 "Items In Quality B2B"
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
    RDLCLayout = './Items In Quality.rdlc';

    Caption = 'Items In Quality';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "QC Enabled B2B", "Spec ID B2B", "WIP QC Enabled B2B", "WIP Spec ID B2B";
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Un_Inspected_QtyCaption; Un_Inspected_QtyCaptionLbl)
            {
            }
            column(Pending_QtyCaption; Pending_QtyCaptionLbl)
            {
            }
            column(Rework_QtyCaption; Rework_QtyCaptionLbl)
            {
            }
            column(Rejected_QtyCaption; Rejected_QtyCaptionLbl)
            {
            }
            dataitem("Inspection Datasheet Header"; "Ins Datasheet Header B2B")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Purchase Consignment No.") WHERE("Source Type" = CONST("In Bound"));

                trigger OnAfterGetRecord();
                begin
                    InspectReceiptHeader.SETRANGE("Purchase Consignment", "Inspection Datasheet Header"."Purchase Consignment No.");
                    if not InspectReceiptHeader.FIND('-') then
                        UnInspectedQty := UnInspectedQty + InspectReceiptHeader.Quantity;
                end;
            }
            dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("No.") WHERE("Source Type" = CONST("In Bound"), Status = CONST(false));

                trigger OnAfterGetRecord();
                begin
                    PendingQty := PendingQty + "Inspection Datasheet Header".Quantity;
                end;
            }
            dataitem("Inspection Receipt Header2"; "Inspection Receipt Header B2B")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("No.") WHERE("Source Type" = CONST("In Bound"), Status = CONST(true));

                trigger OnAfterGetRecord();
                begin
                    RejectedQty := RejectedQty + "Inspection Receipt Header2"."Qty. Rejected" - "Inspection Receipt Header2"."Qty. sent to Vendor(Rejected)";
                    ReworkQty := ReworkQty + "Inspection Receipt Header2"."Qty. Rework" - "Inspection Receipt Header2"."Qty. sent to Vendor(Rework)";
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(UnInspectedQty; UnInspectedQty)
                {
                }
                column(PendingQty; PendingQty)
                {
                }
                column(ReworkQty; ReworkQty)
                {
                }
                column(RejectedQty; RejectedQty)
                {
                }
                column(Integer_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                UnInspectedQty := 0;
                PendingQty := 0;
                RejectedQty := 0;
                ReworkQty := 0;
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
        InspectReceiptHeader: Record "Inspection Receipt Header B2B";
        UnInspectedQty: Decimal;
        PendingQty: Decimal;
        RejectedQty: Decimal;
        ReworkQty: Decimal;
        Un_Inspected_QtyCaptionLbl: Label 'Un Inspected Qty';
        Pending_QtyCaptionLbl: Label 'Pending Qty';
        Rework_QtyCaptionLbl: Label 'Rework Qty';
        Rejected_QtyCaptionLbl: Label 'Rejected Qty';
}


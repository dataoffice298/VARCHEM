report 33000254 "Inspection Receipt B2B"
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
    RDLCLayout = './Inspection Receipt.rdlc';

    Caption = 'Inspection Receipt';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Inspection Receipt Header"; "Inspection Receipt Header B2B")
        {
            column(Inspection_Receipt_Header__Document_Date_; "Document Date")
            {
            }
            column(Inspection_Receipt_Header__Posting_Date_; "Posting Date")
            {
            }
            column(Inspection_Receipt_Header__Lot_No__; "Lot No.")
            {
            }
            column(Inspection_Receipt_Header__Spec_ID_; "Spec ID")
            {
            }
            column(Inspection_Receipt_Header__No__; "No.")
            {
            }
            column(Inspection_Receipt_Header__Rework_Reference_No__; "Rework Reference No.")
            {
            }
            column(Inspection_Receipt_Header__Sub_Assembly_Description_; "Sub Assembly Description")
            {
            }
            column(Inspection_Receipt_Header__Operation_Description_; "Operation Description")
            {
            }
            column(Inspection_Receipt_Header__Prod__Description_; "Prod. Description")
            {
            }
            column(Inspection_Receipt_Header__Prod__Order_Line_; "Prod. Order Line")
            {
            }
            column(Inspection_Receipt_Header__Routing_No__; "Routing No.")
            {
            }
            column(Inspection_Receipt_Header__Prod__Order_No__; "Prod. Order No.")
            {
            }
            column(Inspection_Receipt_Header__Production_Batch_No__; "Production Batch No.")
            {
            }
            column(Inspection_Receipt_Header__Source_Type_; "Source Type")
            {
            }
            column(Inspection_Receipt_Header__Receipt_No__; "Receipt No.")
            {
            }
            column(Inspection_Receipt_Header__Order_No__; "Order No.")
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
            column(Inspection_Receipt_Header__Purch_Line_No_; "Purch Line No")
            {
            }
            column(Inspection_Receipt_Header__Contact_Person_; "Contact Person")
            {
            }
            column(Inspection_Receipt_Header__Purchase_Consignment_; "Purchase Consignment")
            {
            }
            column(Inspection_Receipt_Header_Quantity; Quantity)
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_; "Qty. Accepted")
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_Under_Deviation_; "Qty. Accepted Under Deviation")
            {
            }
            column(Inspection_Receipt_Header__Qty__Rework_; "Qty. Rework")
            {
            }
            column(Inspection_Receipt_Header__Qty__Rejected_; "Qty. Rejected")
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_UD_Reason_; "Qty. Accepted UD Reason")
            {
            }
            column(Inspection_Receipt_Header__Item_No__; "Item No.")
            {
            }
            column(Inspection_Receipt_Header__Item_Description_; "Item Description")
            {
            }
            column(Inspection_Receipt_Header__Qty__sent_to_Vendor_Rejected__; "Qty. sent to Vendor(Rejected)")
            {
            }
            column(Inspection_Receipt_Header__Qty__sent_to_Vendor_Rework__; "Qty. sent to Vendor(Rework)")
            {
            }
            column(Inspection_Receipt_Header__Qty__to_Vendor_Rejected__; "Qty. to Vendor(Rejected)")
            {
            }
            column(Inspection_Receipt_Header__Qty__to_Vendor_Rework__; "Qty. to Vendor(Rework)")
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(ShipToPC; ShipToPC)
            {
            }
            column(ShipToCity; ShipToCity)
            {
            }
            column(ShipToAddr; ShipToAddr)
            {
            }
            column(ShipToName; ShipToName)
            {
            }
            column(Inspection_Receipt_Header__Document_Date_Caption; FIELDCAPTION("Document Date"))
            {
            }
            column(Inspection_Receipt_Header__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
            {
            }
            column(Inspection_Receipt_Header__Lot_No__Caption; FIELDCAPTION("Lot No."))
            {
            }
            column(Inspection_Receipt_Header__Spec_ID_Caption; FIELDCAPTION("Spec ID"))
            {
            }
            column(Inspection_Receipt_Header__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Inspection_ReceiptCaption; Inspection_ReceiptCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Rework_Reference_No__Caption; FIELDCAPTION("Rework Reference No."))
            {
            }
            column(Inspection_Receipt_Header__Sub_Assembly_Description_Caption; FIELDCAPTION("Sub Assembly Description"))
            {
            }
            column(Inspection_Receipt_Header__Operation_Description_Caption; FIELDCAPTION("Operation Description"))
            {
            }
            column(Inspection_Receipt_Header__Prod__Description_Caption; FIELDCAPTION("Prod. Description"))
            {
            }
            column(Inspection_Receipt_Header__Prod__Order_Line_Caption; FIELDCAPTION("Prod. Order Line"))
            {
            }
            column(Inspection_Receipt_Header__Routing_No__Caption; FIELDCAPTION("Routing No."))
            {
            }
            column(Inspection_Receipt_Header__Prod__Order_No__Caption; FIELDCAPTION("Prod. Order No."))
            {
            }
            column(Production_DetailsCaption; Production_DetailsCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Production_Batch_No__Caption; FIELDCAPTION("Production Batch No."))
            {
            }
            column(Receipt_DetailsCaption; Receipt_DetailsCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Receipt_No__Caption; FIELDCAPTION("Receipt No."))
            {
            }
            column(Inspection_Receipt_Header__Order_No__Caption; FIELDCAPTION("Order No."))
            {
            }
            column(Vendor_Name_and_AddressCaption; Vendor_Name_and_AddressCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(Inspection_Receipt_Header__Purch_Line_No_Caption; FIELDCAPTION("Purch Line No"))
            {
            }
            column(Inspection_Receipt_Header__Contact_Person_Caption; FIELDCAPTION("Contact Person"))
            {
            }
            column(Inspection_Receipt_Header__Purchase_Consignment_Caption; FIELDCAPTION("Purchase Consignment"))
            {
            }
            column(Inspection_DetailsCaption; Inspection_DetailsCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header_QuantityCaption; FIELDCAPTION(Quantity))
            {
            }
            column(Inspection_Receipt_Header__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Inspection_Receipt_Header__Item_No__Caption; FIELDCAPTION("Item No."))
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_Caption; FIELDCAPTION("Qty. Accepted"))
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_Under_Deviation_Caption; FIELDCAPTION("Qty. Accepted Under Deviation"))
            {
            }
            column(Inspection_Receipt_Header__Qty__Rework_Caption; FIELDCAPTION("Qty. Rework"))
            {
            }
            column(Inspection_Receipt_Header__Qty__Rejected_Caption; FIELDCAPTION("Qty. Rejected"))
            {
            }
            column(Inspection_Receipt_Header__Qty__Accepted_UD_Reason_Caption; FIELDCAPTION("Qty. Accepted UD Reason"))
            {
            }
            column(Shipping_DetailsCaption; Shipping_DetailsCaptionLbl)
            {
            }
            column(Inspection_Receipt_Header__Qty__sent_to_Vendor_Rejected__Caption; FIELDCAPTION("Qty. sent to Vendor(Rejected)"))
            {
            }
            column(Inspection_Receipt_Header__Qty__sent_to_Vendor_Rework__Caption; FIELDCAPTION("Qty. sent to Vendor(Rework)"))
            {
            }
            column(Inspection_Receipt_Header__Qty__to_Vendor_Rejected__Caption; FIELDCAPTION("Qty. to Vendor(Rejected)"))
            {
            }
            column(Inspection_Receipt_Header__Qty__to_Vendor_Rework__Caption; FIELDCAPTION("Qty. to Vendor(Rework)"))
            {
            }
            column(Shipping_AddressCaption; Shipping_AddressCaptionLbl)
            {
            }
            dataitem("Inspection Receipt Line"; "Inspection Receipt Line B2B")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Receipt No.", "Item No.");
                column(Inspection_Receipt_Line__Character_Code_; "Character Code")
                {
                }
                column(Inspection_Receipt_Line_Description; Description)
                {
                }
                column(Inspection_Receipt_Line__Normal_Value__Num__; "Normal Value (Num)")
                {
                }
                column(Inspection_Receipt_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Inspection_Receipt_Line__Accepted_Qty_; "Accepted Qty")
                {
                }
                column(Inspection_Receipt_Line__Rejected_Qty_; "Rejected Qty")
                {
                }
                column(Inspection_Receipt_Line__Total_Qty_; "Total Qty")
                {
                }
                column(Inspection_Receipt_Line__Character_Code_Caption; FIELDCAPTION("Character Code"))
                {
                }
                column(Inspection_Receipt_Line_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Inspection_Receipt_Line__Unit_of_Measure_Code_Caption; FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Inspection_Receipt_Line__Normal_Value__Num__Caption; FIELDCAPTION("Normal Value (Num)"))
                {
                }
                column(Inspection_Receipt_Line__Accepted_Qty_Caption; FIELDCAPTION("Accepted Qty"))
                {
                }
                column(Inspection_Receipt_Line__Rejected_Qty_Caption; FIELDCAPTION("Rejected Qty"))
                {
                }
                column(Inspection_Receipt_Line__Total_Qty_Caption; FIELDCAPTION("Total Qty"))
                {
                }
                column(Inspection_Receipt_Line_Document_No_; "Document No.")
                {
                }
                column(Inspection_Receipt_Line_Line_No_; "Line No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                if PurchRectHeader.GET("Receipt No.") then begin
                    ShipToName := PurchRectHeader."Ship-to Name";
                    ShipToAddr := PurchRectHeader."Ship-to Address";
                    ShipToCity := PurchRectHeader."Ship-to City";
                    ShipToPC := PurchRectHeader."Ship-to Post Code";
                end;


                PageGroupNo := NextPageGroupNo;
                NextPageGroupNo := PageGroupNo + 1;

            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
                NextPageGroupNo := 1;
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
        PurchRectHeader: Record "Purch. Rcpt. Header";
        ShipToName: Text[100];
        ShipToAddr: Text[100];
        ShipToCity: Text[30];
        ShipToPC: Text[30];
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        Inspection_ReceiptCaptionLbl: Label 'Inspection Receipt';
        Production_DetailsCaptionLbl: Label 'Production Details';
        Receipt_DetailsCaptionLbl: Label 'Receipt Details';
        Vendor_Name_and_AddressCaptionLbl: Label 'Vendor Name and Address';
        Inspection_DetailsCaptionLbl: Label 'Inspection Details';
        Shipping_DetailsCaptionLbl: Label 'Shipping Details';
        Shipping_AddressCaptionLbl: Label 'Shipping Address';
}


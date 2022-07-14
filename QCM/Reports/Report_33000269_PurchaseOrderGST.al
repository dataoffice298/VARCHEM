report 33000269 PurchaseOrder
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseOrderGST.rdl';
    Caption = 'Purchase Order GST Report';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.";
            column(No_PurchHdr; "No.")
            { }
            column(Order_Date; "Order Date")
            {

            }
            column(TotalAmountExlValue; TotalAmountExlValue)
            { }
            Column(CompanyInfor_name; CompanyInfor.Name)
            {

            }
            column(CompanyInfor_Address; CompanyInfor.Address)
            {

            }
            column(CompanyInfor_Address2; CompanyInfor."Address 2")
            {

            }
            column(CompanyAddr_city; CompanyInfor.City)
            {

            }
            column(CompanyInfor_PhoneNo; CompanyInfor."Phone No.")
            {

            }
            column(CompanyInfor_Picture; CompanyInfor.Picture)
            {

            }
            column(Vend_Name; VendorRecG.Name)
            { }
            column(vendAdd; VendorRecG.Address)
            { }
            column(VendorRecG_Addr2; VendorRecG."Address 2")
            { }
            column(VendorRecG_city; VendorRecG.City)
            { }
            column(VendorRecG_PostCode; VendorRecG."Post Code")
            { }
            column(VendorRecG_countryRegion; VendorRecG."Country/Region Code")
            { }
            column(SlNoCap; SlNoCap)
            { }

            column(PONoCaption; PONoCaption)
            { }
            column(PODateCaption; PODateCaption)
            { }
            column(GSTNumberCaption; GSTNumberCaption)
            { }
            column(ProposalNoCaption; ProposalNoCaption)
            { }
            column(ProposalDateCaption; ProposalDateCaption)
            { }
            column(BillnShipCaption; BillnShipCaption)
            { }
            column(SupplierCaption; SupplierCaption)
            { }
            column(SNoCaption; SNoCaption)
            { }
            column(Desc_Caption; Desc_Caption)
            { }
            column(UOM_Caption; UOM_Caption)
            { }
            column(Qty_Caption; Qty_Caption)
            { }
            column(UnitPriceCaption; UnitPriceCaption)
            { }
            column(TotalAmountCaption; TotalAmountCaption)
            { }
            column(TotalAmountExlCaption; TotalAmountExlCaption)
            { }
            column(TotalAmountWordsCaption; TotalAmountWordsCaption)
            { }
            column(TermsCaption; TermsCaption)
            { }
            column(GoodsAndServieceCaption; GoodsAndServieceCaption)
            { }
            column(TotalInrCaption; TotalInrCaption)
            { }
            column(ForCompanyCaption; ForCompanyCaption)
            { }
            column(AuthorizedSigCaption; AuthorizedSigCaption)
            {

            }
            column(Location_Name; Location.Name)
            { }
            column(Location_Address; Location.Address)
            { }
            column(Location_Address2; Location."Address 2")
            { }



            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = FIELD("No."), "Document Type" = field("Document Type");

                column(Document_No_; "Document No.")
                {

                }
                column(No_PurchLine; "No.")
                {

                }


                column(Description; Description)
                {

                }
                column(Description_2; "Description 2")
                { }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Price__LCY_; "Unit Price (LCY)")
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }

                trigger OnAfterGetRecord()
                begin
                    if VendorRecG.Get("Buy-from Vendor No.") then;
                    if Location.Get("Location Code") then;
                end;
            }

        }

        /*     requestpage
            {
                layout
                {
                    area(Content)
                    {
                        group(GroupName)
                        {
                            field(Name; SourceExpression)
                            {
                                ApplicationArea = All;

                            }
                        }
                    }
                } */

        /*    actions
           {
               area(processing)
               {
                   action(ActionName)
                   {
                       ApplicationArea = All;
                   }
               }
           }
       } */
        /*local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value";
         PurchaseLine: Record "Purchase Line";
         GSTSetup: Record "GST Setup")
        var
            ComponentName: Code[30];
        begin
            ComponentName := GetComponentName("Purchase Line", GSTSetup);

            if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                if TaxTransactionValue.FindSet() then
                    repeat
                        case TaxTransactionValue."Value ID" of
                            6:
                                begin
                                    SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                    SGSTPer += TaxTransactionValue.Percent;
                                end;
                            2:
                                begin
                                    CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                    CGSTPer += TaxTransactionValue.Percent;
                                end;
                            3:
                                begin
                                    IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                    IGSTPer += TaxTransactionValue.Percent;
                                end;
                        end;
                    until TaxTransactionValue.Next() = 0;
            end;
        end;*/

        /*local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
           GSTSetup: Record "GST Setup"): Code[30]
        var
            ComponentName: Code[30];
        begin
            if GSTSetup."GST Tax Type" = GSTLbl then
                if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                    ComponentName := IGSTLbl
                else
                    ComponentName := CGSTLbl
            else
                if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                    ComponentName := CESSLbl;
            exit(ComponentName)
        end;*/

        /*procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
        var
            //TaxComponent: Record "Tax Component";
            //GSTSetup: Record "GST Setup";
            GSTRoundingPrecision: Decimal;
        begin
            if not GSTSetup.Get() then
                exit;
            GSTSetup.TestField("GST Tax Type");

            TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxComponent.SetRange(Name, ComponentName);
            TaxComponent.FindFirst();
            if TaxComponent."Rounding Precision" <> 0 then
                GSTRoundingPrecision := TaxComponent."Rounding Precision"
            else
                GSTRoundingPrecision := 1;
            exit(GSTRoundingPrecision);
        end;*/

    }

    var
        PurchLine: Record "Purchase Line" temporary;
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        PrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PrepmtVATBaseAmount: Decimal;
        VendorRecG: Record Vendor;

        /* ReportCheck: Report Check;
                          // ReportCheck: Codeunit NumbertoText;
                          //PaymentTerms: Record "Payment Terms And Conditions";
                          ApprovalEntry: Record "Approval Entry";
                          UserSetup: Record "User Setup";
                          currency: Record Currency;
                          CurrencyValue: Text;
                          NoText: array[2] of text;
                          AmountVendorRecG: Decimal;
                          AmountVendorRecG1: Decimal;
                          AmountInWords: Text;
                          DescriptionVAr: Text;
                          TotalPriceValue: Text;
                          TotalPriceCap: Label 'Total Price(%1)';*/
        DearSirCap: Label 'Dear Sir,';
        SubCap: Label 'Sub: Purchase order for ';
        RefCap: label 'Ref: Your E-Mail quote no %1 ,Dated %2 ';
        RefCap1: Label 'With reference to the above subject, we are pleased to place a purchase order as per the following terms and conditions.';
        RefValue: Text;
        SlNoCap: Label 'Sl.No';

        PartNoCap: label 'Part Number';
        IndianRupeeCap: Label 'Indian Rupees';
        DescriptionCap: Label 'Description';
        ServiceDurationCap: Label 'Service Duration(Months)';
        QuantityCap: Label 'Qty';
        UnitPriceCap: Label 'Unit Price';
        UnitPriceValue: Text;
        PaymentCap: Label '1. Payment';
        DeliveryCap: Label '2. Delivery';
        TaxesCap: Label '3. Taxes ';
        TermsconditionsCap: Label '4. Terms & Conditions';
        BillingAddrCap: Label '5. Billing Address ';
        DeliveryAddrCap: Label '6. Delivery Address ';

        EndTextCap: Label 'Please sign a copy of this letter as a token of your acceptance.';
        OthersCaption: Label 'Others';

        ThankingCap: Label 'Thanking you.';
        YourSincerelyCap: Label 'Yours sincerely,';
        PurchaseorderCap: Label 'PURCHASE ORDER';
        AuthoriseSignatoryCap: Label 'Authorised Signatory';
        GstNoCap: Label 'GST No-';
        TotalCap: Label 'Total';
        TempPrepmtPurchLine: Record "Purchase Line" temporary;
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";

        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line";
        TempPrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrepmtDimSetEntry: Record "Dimension Set Entry";
        TempPrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";

        //PurchCountPrinted: Codeunit "Purch.Header-Printed";
        //FormatAdd: Codeunit "Format Address";
        //PurchPost: Codeunit "Purch.-Post";
        //PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        TDSCompAmount: array[20] of Decimal;
        CessAmount: Decimal;
        GSTComponentCodeName: array[20] of Code[20];
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopy: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        TDSAmt: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        OtherTaxesAmount: Decimal;
        GSTTot: Decimal;
        GstTotal: Decimal;
        ChargesAmount: Decimal;
        [InDataSet]
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalTaxAmount: Decimal;
        GLAccountNo: Code[20];
        TotalGSTAmount: Decimal;
        IsGSTApplicable: Boolean;
        PrepmtLoopLineNo: Integer;
        VatAmtSpecLbl: Label 'VAT Amount Specification in ';
        LocalCurrencyLbl: Label 'Local Currency';
        ExchangeRateLbl: Label 'Exchange rate: %1/%2', Comment = '%1 = Relational Exch. Rate Amount %2 = Exchange Rate Amount';
        TotalIncTaxLbl: Label 'Total %1 Incl. Taxes', Comment = '%1 Total Inc Tax';
        TotalExclTaxLbl: Label 'Total %1 Excl. Taxes', Comment = '%1 Total Excl Tax';
        PurchLbl: Label 'Purchaser';
        TotalLbl: Label 'Total %1', Comment = '%1 Total';
        CopyLbl: Label 'COPY';
        OrderLbl: Label 'Order %1', Comment = '%1 Order';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        OrderNoCaptionLbl: Label 'Order No.';
        PageCaptionLbl: Label 'Page';
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        DiscPercentCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        LineDiscAmtCaptionLbl: Label 'Line Discount Amount';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        TaxAmtCaptionLbl: Label 'Tax Amount';
        OtherTaxesAmtCaptionLbl: Label 'Other Taxes Amount';
        ChrgsAmtCaptionLbl: Label 'Charges Amount';
        TotalTDSIncleSHECessCaptionLbl: Label 'Total TDS Amount';
        VATDiscAmtCaptionLbl: Label 'Payment Discount on VAT';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        PmtDetailsCaptionLbl: Label 'Payment Details';
        VendNoCaptionLbl: Label 'VendorRecG No.';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        DescCaptionLbl: Label 'Description';
        GLAccNoCaptionLbl: Label 'G/L Account No.';
        PrepmtSpecCaptionLbl: Label 'Prepayment Specification';
        PrepmtVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification';
        PrepmtVATIdentCaptionLbl: Label 'VAT Identifier';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        VATPercentCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentCaptionLbl: Label 'VAT Identifier';
        TotalCaptionLbl: Label 'Total';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PrepmtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        CompanyRegistrationLbl: Label 'Company Registration No.';
        VendorRecGRegistrationLbl: Label 'VendorRecG GST Reg No.';
        PaymentTermsLine: Boolean;
        PurchaseLineBool: Boolean;
        PONoCaption: Label 'PO No.:';
        PODateCaption: Label 'PO Date:';
        GSTNumberCaption: Label 'GST Number:';
        ProposalNoCaption: Label 'Proposal Number:';
        ProposalDateCaption: Label 'Proposal Date';
        BillnShipCaption: Label 'Bill to & Ship to Address';
        SupplierCaption: Label 'Supplier Name & Address';
        SNoCaption: Label 'S.No.';
        Desc_Caption: Label 'Description';
        UOM_Caption: Label 'Unit of Measure';
        Qty_Caption: Label 'Quantity';
        UnitPriceCaption: Label 'Unit Price';
        TotalAmountCaption: Label 'Total Amount(%1)';
        TotalAmountValue: Text;
        TotalAmountExlCaption: Label 'Total Amount exclusive of Taxes (%1)';
        TotalAmountExlValue: Text;
        TotalAmountWordsCaption: Label 'Total Amount in Words:';
        GoodsAndServieceCaption: Label 'Goods and services tax  @';
        TotalInrCaption: Label 'Total (INR)';
        TermsCaption: Label 'Terms and Conditions:';
        Terms1Caption: Label '1. Po is valid for %1 days.';
        Terms2Caption: Label '2. Supplier  shall deliver goods within %1 days.';
        Terms3Caption: Label '3. Supplier shall be responsible to comply with all applicable labour statutes.';
        Terms4Caption: Label '4. Supplier shall indemnify  Charnham India Private Limited against any loss incurred  on account of non compliance of any laws by supplier.';
        Terms5Caption: Label '5. Supplier shall comply with GST regulations and provisions.';
        Terms6Caption: Label '6. Supplier shall file GST returns on regular basis and ensure that Charnham India Private Limited gets the input credit reflected in GSTR 2.';
        Terms7Caption: Label '7. Advance payment of  %1 shall be paid along with this PO.';
        Terms8Caption: Label '8. Balance payment shall be paid upon delivery of goods.';
        Terms9Caption: Label '9. Payments shall be made to the account provided by Supplier either through cheques or electronic transfer.';
        Terms10Caption: Label '10.	Both the parties here by unconditionally agree to abide by standard conditions enclosed along with this PO in addition to other conditions.';
        Terms11Caption: Label '11. Balance payment shall be paid upon delivery of the goods.';
        Terms12Caption: Label '12. Payments shall be made to the account provided by Supplier either through cheque or electronic transfer.';
        Terms13Caption: Label '13. Both the parties here by unconditionally agree to abide by standard conditions enclosed along with this PO in addition to other conditions.';
        ForCompanyCaption: Label 'For Charnham India Private Limited ';
        AuthorizedSigCaption: Label 'Authorised Signatory';
        Location: Record Location;
        TotalAmountInrCaption: Label 'Total Amount %1';
        TotalAmountInrValue: Text;
        RowNo: Integer;
        CompanyInfor: Record "Company Information";
        //StateRec: Record State;

        CountryRec: Record "Country/Region";
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        GSTPertotal: Decimal;



    trigger OnPreReport()
    var

    begin
        CompanyInfor.get;
        CompanyInfor.CalcFields(Picture);
        if CountryRec.Get(CompanyInfor.County) then;

    end;


}
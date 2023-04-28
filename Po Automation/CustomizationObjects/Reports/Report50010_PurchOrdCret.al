report 50010 "Purchase Order Creation New"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = all;
    UsageCategory = Lists;
    Caption = 'Purchase Order Creation_50005';

    dataset
    {
        dataitem("Quotation Comparison1";
        "Quotation Comparison Test")
        {
            DataItemTableView = //SORTING("Vendor No.")
                                WHERE("Carry Out Action" = FILTER(true),
                                      Level = FILTER(1));


            trigger OnPreDataItem();
            begin
                SetCurrentKey("Vendor No.", "Item No.");
                SetRange("RFQ No.", RFQNum);
            end;

            trigger OnAfterGetRecord();
            var
                PurchseOrdHdrLRec: Record "Purchase Line";

            begin
                if VendorNoGvar <> "Vendor No." then begin
                    VendorNoGvar := "Vendor No.";
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE("No.", "Parent Quote No.");
                    PurchaseHeader.SetRange("Buy-from Vendor No.", "Vendor No.");
                    IF PurchaseHeader.FindFirst() THEN BEGIN
                        PurchaseHeaderOrder."Document Type" := PurchaseHeaderOrder."Document Type"::Order;
                        PPSetup.GET;
                        PurchaseHeaderOrder."No." := NoSeriesMgt.GetNextNo(NoSeiesGvar, WORKDATE, TRUE);
                        PurchaseHeaderOrder."No. Series" := NoSeiesGvar;
                        VendorL.GET(PurchaseHeader."Buy-from Vendor No.");

                        IF PurchaseLineOrder2.GET(PurchaseHeaderOrder."Document Type"::Order, PurchaseHeaderOrder."No.") THEN
                            ERROR('Record already Existed.');
                        PurchaseHeaderOrder.INSERT(true);
                        //PurchaseHeaderOrder."Posting Date" := WORKDATE();
                        PurchaseHeaderOrder."Posting Date" := Today;
                        PurchaseHeaderOrder."Document Date" := WORKDATE();
                        PurchaseHeaderOrder.Validate("Order Date", WorkDate());
                        PurchaseHeaderOrder.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        PurchaseHeaderOrder."Quotation No." := "Parent Quote No.";
                        PurchaseHeaderOrder."Quote No." := "Parent Quote No.";
                        PurchaseHeaderOrder.Validate("Expected Receipt Date", "Quotation Comparison1"."Due Date");
                        //PurchaseHeaderOrder."Validate(Currency Code","Quotation Comparison1"."Currency Code");
                        PurchaseHeaderOrder.Validate("Currency Code", "Quotation Comparison1"."Currency Code");
                        PurchaseHeaderOrder.Validate("Shortcut Dimension 1 Code", "Quotation Comparison1"."Shortcut Dimension 1 Code");
                        PurchaseHeaderOrder.Validate("Shortcut Dimension 2 Code", "Quotation Comparison1"."Shortcut Dimension 2 Code");
                        PurchaseHeaderOrder.Modify(true);
                        QutComLine.RESET;
                        QutComLine.SetRange("Quot Comp No.", "Quot Comp No.");
                        //QutComLine.SetRange("Line No.", "Line No.");
                        QutComLine.SetRange("Vendor No.", "Vendor No.");
                        IF QutComLine.FindSet() THEN BEGIN
                            repeat
                                QutComLine."Po No." := OrderNo;
                                QutComLine.modify;
                            until QutComLine.Next() = 0;
                        END;
                    end;
                    Message('Order Created %1', PurchaseHeaderOrder."No.");
                end;
                if ItemNoGvar <> "Item No." then begin
                    ItemNoGvar := "Item No.";
                    PurchaseLine.Reset();
                    PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Quote);
                    PurchaseLine.SETRANGE("Document No.", "Parent Quote No.");
                    PurchaseLine.SETRANGE("Buy-from Vendor No.", "Vendor No.");
                    PurchaseLine.SetRange("No.", "Item No.");
                    IF PurchaseLine.FindFirst() THEN BEGIN
                        repeat
                            clear(LneLVar);
                            PurchseOrdHdrLRec.Reset();
                            PurchseOrdHdrLRec.SetRange("Document Type", PurchaseHeaderOrder."Document Type");
                            PurchseOrdHdrLRec.SetRange("Document No.", PurchaseHeaderOrder."No.");
                            if PurchseOrdHdrLRec.FindLast() then
                                LneLVar := PurchseOrdHdrLRec."Line No." + 10000
                            else
                                LneLVar := 10000;

                            //LneLVar := PurchaseLine."Line No." + 10000;
                            //PurchaseLineOrder.RESET();
                            PurchaseLineOrder.INIT();
                            PurchaseLineOrder."Document Type" := PurchaseHeaderOrder."Document Type";
                            PurchaseLineOrder."Document No." := PurchaseHeaderOrder."No.";
                            PurchaseLineOrder."Line No." := LneLVar;
                            PurchaseLineOrder.INSERT(true);
                            PurchaseLineOrder."Buy-from Vendor No." := PurchaseHeaderOrder."Buy-from Vendor No.";
                            PurchaseLineOrder.VALIDATE("Buy-from Vendor No.");
                            PurchaseLineOrder.Type := PurchaseLine.type;
                            PurchaseLineOrder.VALIDATE("No.", "Quotation Comparison1"."Item No.");
                            PurchaseLineOrder."Description 2" := "Quotation Comparison1".Description2;
                            PurchaseLineOrder.VALIDATE(Quantity, "Quotation Comparison1".Quantity);
                            PurchaseLineOrder."Direct Unit Cost" := "Quotation Comparison1".Rate;
                            PurchaseLineOrder.VALIDATE("Direct Unit Cost");
                            PurchaseLineOrder.VALIDATE("Variant Code", "Quotation Comparison1"."Variant Code");
                            PurchaseLineOrder."Location Code" := "Quotation Comparison1"."Location Code";
                            PurchaseLineOrder."Shortcut Dimension 1 Code" := "Quotation Comparison1"."Shortcut Dimension 1 Code";
                            PurchaseLineOrder."Shortcut Dimension 2 Code" := "Quotation Comparison1"."Shortcut Dimension 2 Code";
                            PurchaseLineOrder."Dimension Set ID" := "Quotation Comparison1"."Dimension Set ID";
                            PurchaseLineOrder."Shortcut Dimension 1 Code" := "Quotation Comparison1"."Shortcut Dimension 1 Code";
                            PurchaseLineOrder."Shortcut Dimension 2 Code" := "Quotation Comparison1"."Shortcut Dimension 2 Code";
                            PurchaseLineOrder."Dimension Set ID" := "Quotation Comparison1"."Dimension Set ID";
                            PurchaseLineOrder."Currency Code" := "Quotation Comparison1"."Currency Code";
                            //B2BJK >>
                            PurchaseLineOrder.Make := "Quotation Comparison1".Make;
                            PurchaseLineOrder.Model := "Quotation Comparison1".Model;
                            PurchaseLineOrder."Shortage Qty" := "Quotation Comparison1"."Shortage Qty";
                            //B2BJK <<

                            PurchaseLineOrder.Validate("Shortcut Dimension 1 Code");
                            PurchaseLineOrder.validate("Shortcut Dimension 2 Code");
                            PurchaseLineOrder.Validate("Dimension Set ID");
                            PurchaseLineOrder.Modify(true);
                        //LneLVar += 10000;
                        until PurchaseLine.Next() = 0;
                    END;
                end;






            END;

            trigger OnPostDataItem();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin

                RFQNumbers.RESET;
                RFQNumbers.SETRANGE("RFQ No.", RFQNum);
                IF RFQNumbers.FIND('-') THEN BEGIN
                    RFQNumbers.Completed := TRUE;
                    RFQNumbers.MODIFY();
                END;
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
        Noseries2: Code[20];
        RFQNum: Code[20];
        OrderNo: Code[20];
        QutComLine: Record "Quotation Comparison Test";
        invposset: Record "Inventory Posting Setup";
        itemgv: Record Item;
        NoSeiesGvar: Code[20];
        VendorNoGvar: Text;
        //B2BJK On 28Apr2023 >>
        ItemNoGvar: Text;
        //B2BJK On 28Apr2023 >>
        PurchaseHeaderOrder: Record "Purchase Header";
        PurchaseLineOrder: Record "Purchase Line";
        PPSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLineOrder2: Record "Purchase Line";
        VendorL: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        FixeAss: Record "Fixed Asset";
        FixedAssBool: Boolean;
        FixedAset: Record "Fixed Asset";
        FxdAset: Record "Fixed Asset";
        LneLVar: Integer;
        GLAcc: Record "G/L Account";
        GLAccBool: Boolean;
        FADepBook: Record "FA Depreciation Book";
    //NoSeriesMgt : Codeunit NoSeriesManagement;


    procedure GetValues(RFQNUmbr: code[20]; NoSeriesPar: Code[20]);
    begin
        RFQNum := RFQNUmbr;
        NoSeiesGvar := NoSeriesPar;
    end;
}


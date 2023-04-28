page 50030 "Quotation Comparison New" //PKON22J1
{
    // version PH1.0,PO1.0

    // PROJECT : WindlassHealthCare
    // *********************************************************************************************************************************************************
    // SIGN
    // *********************************************************************************************************************************************************
    // B2B : B2B Software Technologies
    // *********************************************************************************************************************************************************
    // VER       SIGN       USERID          DATE         DESCRIPTION
    // *********************************************************************************************************************************************************
    // 1.1       B2B        Srikar        13-May-15 -->  Added Function CheckQtyBeforePO.
    // 1.1       B2B        Srikar        13-May-15 -->  Added Code In OnOpenPage and SelectCurrentRFQNo.
    // 1.0       B2B        Raju          16-Dec-2016--> Added New Function PrintQC;old Code Commented.

    PageType = Worksheet;
    SourceTable = 50005;
    UsageCategory = Tasks;
    //ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(RFQNumber; RFQNumber)
            {
                Caption = 'RFQ Number';
                TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = CONST(false));
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    RFQNumberOnAfterValidate;
                end;
            }
            field(Noseries2; Noseries2)
            {
                Caption = 'No Series';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PPsetup.GET;
                    NoSeries.SETRANGE(Code, PPsetup."Order Nos.");
                    IF PAGE.RUNMODAL(458, NoSeries) = ACTION::LookupOK THEN
                        Noseries2 := NoSeries."Series Code";
                end;
            }

            repeater("Control")
            {
                field(ActualExpansionStatus; ActualExpansionStatus)
                {
                    Caption = 'Expand';
                    Editable = false;
                    //OptionCaption = 'Integer';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        ActualExpansionStatusOnPush;
                    end;
                }
                field("Quote No."; "Quote No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Amount"; "Total Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quality; Quality)
                {
                    ApplicationArea = All;
                }
                field("Payment Terms"; "Payment Terms")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Rate; Rate)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Carry Out Action"; "Carry Out Action")
                {
                    ApplicationArea = All;
                }
                field(Price; Price)
                {
                    BlankZero = true;
                    Caption = 'Price Weightage';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Delivery; Delivery)
                {
                    BlankZero = true;
                    Caption = 'Delivery Weightage';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Weightage"; "Total Weightage")
                {
                    BlankZero = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Delivery Date"; "Delivery Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                //B2BJK >>
               field("PO Qty";"PO Qty")
               {
                ApplicationArea = all;
               }
                field("Available Inventory"; "Available Inventory")
                {
                    ApplicationArea = all;
                }
                //B2BJK <<
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Expand")
            {
                Caption = '&Expand';
                action("E&xpand All")
                {
                    Caption = 'E&xpand All';
                    Image = ExplodeBOM;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ExpandAll;
                    end;
                }
                action("C&ollapse All")
                {
                    Caption = 'C&ollapse All';
                    Image = CollapseDepositLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        InitTempTable;
                    end;
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 66;
                    ApplicationArea = All;
                    RunPageLink = "RFQ No." = FIELD("RFQ No."),
                                  "Vendor No." = FIELD("Vendor No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Calculate Plan")
                {
                    Caption = '&Calculate Plan';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin

                        POAutomation.InsertQuotationLines(RFQNumber);
                        QuoteCompare.RESET;
                        CurrPage.UPDATE(FALSE);
                        InitTempTable;
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }

                action("C&arryout Action")
                {
                    Caption = 'C&arryout Action';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    var
                        QuoteCompareLocal: Record 50005;
                    begin
                        /*
                        QuoteCompareArchive.SETRANGE("RFQ No.","RFQ No.");
                        IF QuoteCompareArchive.FIND('-') THEN
                          REPEAT
                            QuoteCompareArchive.DELETE;
                          UNTIL QuoteCompareArchive.NEXT=0;
                        QuoteCompareArchive.RESET;
                        QuoteCompareArchive.SETFILTER("Line No.",'>%1',1);
                        QuoteCompareArchive.SETRANGE("RFQ No.",'');
                        IF QuoteCompareArchive.FIND('-') THEN
                          QuoteCompareArchive.DELETE;
                        QuotationComparisionDelete.RESET;
                        REPEAT
                          ArchiveQCS(QuotationComparisionDelete);
                        UNTIL QuotationComparisionDelete.NEXT=0;
                        
                        //REPORT.RUN(REPORT::"Purchase Order Creation"); //REP1.0
                        QuotationComparisionDelete.DELETEALL;
                        CurrPage.UPDATE;
                        
                        *///B2B1.1

                        IF Noseries2 = '' THEN
                            ERROR('Please select the No.Series');

                        CheckQtyBeforePO;

                        QuoteCompareArchive.SETRANGE("RFQ No.", "RFQ No.");
                        IF QuoteCompareArchive.FIND('-') THEN
                            REPEAT
                                QuoteCompareArchive.DELETE;
                            UNTIL QuoteCompareArchive.NEXT = 0;
                        QuoteCompareArchive.RESET;
                        QuoteCompareArchive.SETFILTER("Line No.", '>%1', 1);
                        QuoteCompareArchive.SETRANGE("RFQ No.", '');
                        IF QuoteCompareArchive.FIND('-') THEN
                            QuoteCompareArchive.DELETE;
                        QuotationComparisionDelete.RESET;
                        REPEAT
                            ArchiveQCS(QuotationComparisionDelete);
                        UNTIL QuotationComparisionDelete.NEXT = 0;

                        POCreationReport.GetValues(Noseries2);
                        POCreationReport.RUN;

                        //B2B1.1START

                        QuotationComparisionDelete.RESET;
                        QuotationComparisionDelete.SETRANGE("Carry Out Action", TRUE);
                        IF QuotationComparisionDelete.FINDFIRST THEN BEGIN
                            QuotationComparisionDelete.DELETE;//B2B1.1
                        END;

                        //END B2B1.1
                        CurrPage.UPDATE;

                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Quotation Comparision")
                {
                    Caption = 'Quotation Comparision';
                    Image = print;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        // ReqLine.RESET;
                        // ReqLine.SETRANGE("RFQ No.",RFQNumber);
                        // REPORT.RUN(33002901,TRUE,FALSE,ReqLine);
                        //PrintQC;//B2B1.0 GR 16Dec2016
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetExpansionStatus;
        OnAfterGetCurrRecord;
        QuoteNoOnFormat;
        VendorNoOnFormat;
        DescriptionOnFormat;
        TotalAmountOnFormat;
        LocationCodeOnFormat;
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        TempReqLine := Rec;

        WHILE (TempReqLine.NEXT <> 0) AND (TempReqLine.Level > Level) DO
            TempReqLine.DELETE(TRUE);
        TempReqLine := Rec;
        EXIT(TempReqLine.DELETE);
    end;

    trigger OnFindRecord(Which: Text): Boolean;
    var
        Found: Boolean;
    begin
        TempReqLine.COPY(Rec);
        Found := TempReqLine.FIND(Which);
        Rec := TempReqLine;
        EXIT(Found);
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        MODIFY(TRUE);
        TempReqLine := Rec;
        IF "Line No." <> 0 THEN
            TempReqLine.MODIFY;
        EXIT(FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    var
        ResultSteps: Integer;
    begin
        TempReqLine.COPY(Rec);
        ResultSteps := TempReqLine.NEXT(Steps);
        Rec := TempReqLine;
        EXIT(ResultSteps);
    end;

    trigger OnOpenPage();
    begin
        //B2B1.1 START

        RFQNumbers.RESET;
        RFQNumbers.SETRANGE(RFQNumbers."RFQ No.", '');

        //END
        RFQNumber := "RFQ No.";
        IF RFQNumber <> '' THEN
            IF NOT RFQNumbers.GET(RFQNumber) THEN
                RFQNumber := '';

        IF RFQNumber = '' THEN BEGIN
            //RFQNumbers.SETRANGE("Location Code",FALSE);//REACH UD
            RFQNumbers.SETRANGE(Completed, FALSE);
            IF RFQNumbers.FIND('-') THEN
                RFQNumber := RFQNumbers."RFQ No."
            ELSE
                RFQNumber := '';
        END;
        SelectCurrentRFQNo;
        RFQNumber := '';
        InitTempTable;
        SetRecFilters;
        CurrPage.UPDATE(FALSE);
    end;

    var
        ActualExpansionStatus: Integer;
        ReqLine: Record 50005;
        TempReqLine: Record 50005 temporary;
        RFQNumber: Code[20];
        RFQNumbers: Record 50004;
        QuoteCompare: Record 50005;
        QuotationComparisionDelete: Record 50005;
        POAutomation: Codeunit 50000;
        QuoteCompareArchive: Record 50008;
        Item: Record 27;
        [InDataSet]
        "Quote No.Emphasize": Boolean;
        [InDataSet]
        "Vendor No.Emphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        "Total AmountEmphasize": Boolean;
        [InDataSet]
        "Location CodeEmphasize": Boolean;
        Text19068734: Label 'RFQ No.';
        "-B2B1.1-": Integer;
        Noseries2: Code[20];
        PPsetup: Record 312;
        NoSeries: Record 310;
        POQty: Decimal;
        PQQty: Decimal;
        PORaiseQty: Decimal;
        PurchHeader: Record 38;
        PurchLine: Record 39;
        Text50000: Label 'Quantity Exceeded than  Order Raised';
        POCreationReport: Report 50000;

    local procedure IsExpanded(ActualReqLine: Record 50005): Boolean;
    begin
        TempReqLine := ActualReqLine;
        IF TempReqLine.NEXT = 0 THEN
            EXIT(FALSE);
        EXIT(TempReqLine.Level > ActualReqLine.Level);
    end;

    local procedure ToggleExpandCollapse();
    var
        ReqLine: Record 50005;
    begin
        IF ActualExpansionStatus = 0 THEN BEGIN // Has children, but not expanded
            ReqLine.SETRANGE(Level, Level, Level + 1);
            ReqLine := Rec;
            IF ReqLine.NEXT <> 0 THEN
                REPEAT
                    IF ReqLine.Level > Level THEN BEGIN
                        TempReqLine := ReqLine;
                        IF TempReqLine.INSERT THEN;
                    END;
                UNTIL (ReqLine.NEXT = 0) OR (ReqLine.Level = Level);
        END ELSE
            IF ActualExpansionStatus = 1 THEN BEGIN // Has children and is already expanded
                TempReqLine := Rec;
                WHILE (TempReqLine.NEXT <> 0) AND (TempReqLine.Level > Level) DO
                    TempReqLine.DELETE;
            END;
        CurrPage.UPDATE;
    end;

    procedure SetExpansionStatus();
    begin
        CASE TRUE OF
            IsExpanded(Rec):
                ActualExpansionStatus := 1;
            Level = 0:
                ActualExpansionStatus := 0
            ELSE
                ActualExpansionStatus := 2;
        END;
    end;

    procedure InitTempTable();
    begin
        ReqLine.RESET;
        ReqLine.COPYFILTERS(TempReqLine);
        TempReqLine.DELETEALL;
        //IF RFQNumber <>'' THEN
        //ReqLine.SETRANGE("RFQ No.",RFQNumber);
        IF ReqLine.FIND('-') THEN
            REPEAT
                IF ReqLine.Level = 0 THEN BEGIN
                    TempReqLine := ReqLine;
                    TempReqLine.INSERT;
                END;
            UNTIL ReqLine.NEXT = 0;
    end;

    local procedure ExpandAll();
    var
        ReqLine: Record 50005;
    begin
        ReqLine.RESET;
        ReqLine.COPYFILTERS(TempReqLine);
        TempReqLine.DELETEALL;

        IF ReqLine.FIND('-') THEN
            REPEAT
                TempReqLine := ReqLine;
                TempReqLine.INSERT;
            UNTIL ReqLine.NEXT = 0;
    end;

    procedure SetRecFilters();
    begin
        RESET;
        FILTERGROUP(2);
        FILTERGROUP(0);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure SelectCurrentRFQNo();
    begin
        /*SETRANGE("RFQ No.",RFQNumber);
        CurrPage.UPDATE(FALSE);
        */

        //B2B1.1 START

        RESET;
        SETRANGE("RFQ No.", RFQNumber);
        //InitTempTable;
        //END

    end;

    procedure ArchiveQCS(QuotationComparision2: Record 50005);
    begin
        QuoteCompareArchive.RESET;
        QuoteCompareArchive.INIT;
        QuoteCompareArchive.TRANSFERFIELDS(QuotationComparision2);
        IF NOT (QuoteCompareArchive."Line No." = 0) THEN
            QuoteCompareArchive.INSERT(TRUE);
    end;

    local procedure RFQNumberOnAfterValidate();
    begin
        SelectCurrentRFQNo;
    end;

    local procedure OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        IF GET("Line No.") THEN BEGIN
            TempReqLine := Rec;
            IF "Line No." <> 0 THEN
                TempReqLine.MODIFY
        END ELSE
            IF TempReqLine.GET("Line No.") THEN
                TempReqLine.DELETE;
    end;

    local procedure ActualExpansionStatusOnPush();
    begin
        ToggleExpandCollapse;
    end;

    local procedure QuoteNoOnFormat();
    begin
        IF Level = 0 THEN
            "Quote No.Emphasize" := TRUE
        ELSE
            "Quote No.Emphasize" := FALSE;
    end;

    local procedure VendorNoOnFormat();
    begin
        IF Level = 0 THEN
            "Vendor No.Emphasize" := TRUE
        ELSE
            "Vendor No.Emphasize" := FALSE;
    end;

    local procedure DescriptionOnFormat();
    begin
        IF Level = 0 THEN
            DescriptionEmphasize := TRUE
        ELSE
            DescriptionEmphasize := FALSE;
    end;

    local procedure TotalAmountOnFormat();
    begin
        IF Level = 0 THEN
            "Total AmountEmphasize" := TRUE
        ELSE
            "Total AmountEmphasize" := FALSE;
    end;

    local procedure LocationCodeOnFormat();
    begin
        IF Level = 0 THEN
            "Location CodeEmphasize" := TRUE
        ELSE
            "Location CodeEmphasize" := FALSE;
    end;

    procedure "---B2B1.1---"();
    begin
    end;

    procedure CheckQtyBeforePO();
    begin
        IF RFQNumber = '' THEN
            ERROR('Please select the RFQ Number');

        POQty := 0;
        PQQty := 0;
        PORaiseQty := 0;

        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET THEN BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETRANGE("No.", "Item No.");
            IF PurchLine.FINDSET THEN
                REPEAT
                    PQQty += PurchLine.Quantity;
                UNTIL PurchLine.NEXT = 0;
        END;

        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET THEN
            REPEAT
                PurchLine.RESET;
                PurchLine.SETRANGE("Document No.", PurchHeader."No.");
                PurchLine.SETRANGE("No.", "Item No.");
                IF PurchLine.FINDSET THEN
                    REPEAT
                        POQty += PurchLine.Quantity;
                    UNTIL PurchLine.NEXT = 0;
            UNTIL PurchHeader.NEXT = 0;

        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETRANGE("Carry Out Action", TRUE);
        QuoteCompare.SETRANGE("Item No.", "Item No.");
        IF QuoteCompare.FINDSET THEN
            REPEAT
                PORaiseQty += QuoteCompare.Quantity;
            UNTIL QuoteCompare.NEXT = 0;
        IF (PORaiseQty + POQty) > PQQty THEN
            ERROR(Text50000);
    end;

    local procedure "---B2B1.0---"();
    begin
    end;

    /*local procedure PrintQC();
    var
        QuotationComparisonCopy1: Report 80000;
    begin
        CLEAR(QuotationComparisonCopy1);
        QuotationComparisonCopy1.SETRFQ(RFQNumber);
        QuotationComparisonCopy1.RUN;
    end;*/
}


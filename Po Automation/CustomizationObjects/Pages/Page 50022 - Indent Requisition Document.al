page 50022 "Indent Requisition Document"
{
    // version PO1.0

    PageType = Document;
    SourceTable = "Indent Req Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code_B2B"; Rec."Shortcut Dimension 1 Code_B2B")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code_B2B"; Rec."Shortcut Dimension 2 Code_B2B")
                {
                    ApplicationArea = All;
                    //Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
            part(Indentrequisations; 50021)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Requisition Lines")
            {
                Caption = 'Get Requisition Lines';
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Rec.TestField("Shortcut Dimension 1 Code_B2B");
                    Rec.TestField("Shortcut Dimension 2 Code_B2B");
                    IndentReqLines.GetValue(Rec."No.", Rec."Resposibility Center", Rec."Shortcut Dimension 1 Code_B2B", Rec."Shortcut Dimension 2 Code_B2B");
                    IndentReqLines.RUN;
                end;
            }
            action("Create &Enquiry")
            {
                Caption = 'Create &Enquiry';
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Enquiry);
                    Rec.TestField("Shortcut Dimension 1 Code_B2B");
                    Rec.TestField("Shortcut Dimension 2 Code_B2B");
                    Carry := 0;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;
                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');
                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text003) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CreateIndents.SetRange(Created, false); //B2BJK on nov11
                        if CreateIndents.FindFirst() then begin //B2BJK on nov11
                            CLEAR(VendorList);
                            VendorList.LOOKUPMODE(TRUE);
                            IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                if Confirm('Do you want to proceed with selected vendors') then begin
                                    VendorList.SetSelection(Vendor);
                                    IF Vendor.COUNT >= 1 THEN BEGIN
                                        POAutomation.CreateEnquiries(CreateIndents, Vendor, Rec."No.Series");
                                        MESSAGE(Text0010)
                                    END ELSE
                                        EXIT;
                                end else begin
                                    exit;
                                end;
                            END else begin
                                exit;
                            end;
                        end else begin //B2BJK on nov11
                            Message('Enquiries have already been created for this requisition lines'); //B2BJK on nov11
                        end;
                    END;
                end;
            }
            action("Create &Quote")
            {
                Caption = 'Create &Quote';
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                begin

                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Quote);
                    Rec.TestField("Shortcut Dimension 1 Code_B2B");
                    Rec.TestField("Shortcut Dimension 2 Code_B2B");
                    Carry := 0;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;

                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');

                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text004) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CreateIndents.SetRange(Created, false); //B2BJK on nov11
                        if CreateIndents.FindFirst() then begin //B2BJK on nov11
                            CLEAR(VendorList);
                            VendorList.LOOKUPMODE(TRUE);
                            IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                if Confirm('Do you want to proceed with selected vendors') then begin
                                    VendorList.SetSelection(Vendor);
                                    IF Vendor.COUNT >= 1 THEN BEGIN
                                        POAutomation.CreateQuotes(CreateIndents, Vendor, Rec."No.Series");
                                        MESSAGE(Text0011)
                                    END ELSE
                                        EXIT;
                                end else begin
                                    exit
                                end;
                            end else begin
                                exit;
                            end;
                        end else begin //B2BJK on nov11
                            Message('Quotes have already been created for this requisition lines'); //B2BJK on nov11
                        end;
                    END;
                end;
            }
            action("Create &Purchase Order")
            {
                Caption = 'Create &Purchase Order';
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Order);
                    Rec.TestField("Shortcut Dimension 1 Code_B2B");
                    Rec.TestField("Shortcut Dimension 2 Code_B2B");
                    Carry := 0;
                    //raju
                    CheckRemainingQuantity;
                    //raju
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;
                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');
                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text005) THEN
                            EXIT;
                        /*CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        //B2B.1.3 S
                        
                         CLEAR(VendorList);
                         VendorList.LOOKUPMODE(TRUE);
                         VendorList.RUNMODAL;
                         VendorList.SetSelection(Vendor);

                         IF Vendor.COUNT>=1 THEN BEGIN
                         

                        UpdateReqQty;
                        POAutomation.CreateOrder2(CreateIndents, Vendor, Rec."No.Series");

                        
                        MESSAGE(Text001);
                       END ELSE
                       EXIT;*/
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CreateIndents.SetRange(Created, false); //B2BJK on nov11
                        if CreateIndents.FindSet() then begin //B2BJK on nov11
                                                              // CLEAR(VendorList);
                                                              // VendorList.LOOKUPMODE(TRUE);

                            // IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            // if Confirm('Do you want to proceed with selected vendors') then begin
                            //  VendorList.SetSelection(Vendor);
                            //IF Vendor.COUNT >= 1 THEN BEGIN
                            Vendor.Reset();
                            if Vendor.FindSet() then;
                            if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then begin
                                POAutomation.CreateOrder(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(Text0012)
                            END ELSE
                                EXIT;
                            // end else begin
                            //    exit
                            // end;
                            // end else begin
                            //   exit;
                            //end;
                        end else begin //B2BJK on nov11
                            Message('orders have already been created for this requisition lines'); //B2BJK on nov11
                        end;

                        //B2B.1.3 E
                    END;

                end;
            }
            action("Re&lease")
            {
                Caption = 'Re&lease';
                Image = ReleaseDoc;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                begin
                    //B2BESGOn19May2022++
                    IndentReqLine.Reset();
                    IndentReqLine.SetRange("Document No.", Rec."No.");
                    if not IndentReqLine.FindFirst() then begin
                        Error('No Lines Found');
                    end;
                    //B2BESGOn19May2022--

                    Rec.TESTFIELD("Document Date");
                    Rec.TestField("Shortcut Dimension 1 Code_B2B");
                    Rec.TestField("Shortcut Dimension 2 Code_B2B");
                    IF Rec.Status = Rec.Status::Release THEN
                        EXIT
                    ELSE
                        Rec.Status := Rec.Status::Release;
                    Rec.MODIFY;
                end;
            }
            action("Re&open")
            {
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction();
                begin

                    IF Rec.Status = Rec.Status::Open THEN
                        EXIT
                    ELSE
                        Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;
            }
        }
        area(navigation)
        {
            group(Orders)
            {
                action("Created &Order")
                {
                    Image = Card;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        CreatedOrders;
                    end;
                }
            }
        }
    }

    var
        Carry: Integer;
        IndentReqHeader: Record 50009;
        Indentreqline: Record 50003;
        POAutomation: Codeunit 50000;
        CreateIndents: Record 50003;
        Vendor: Record 23;
        VendorList: Page 27;
        PurchaseOrder: Record 38;
        Usermgt: Codeunit 5700;
        "-----Mail": Integer;
        Email: Text[50];
        StrVar: Text[50];
        Chr: Char;
        MailCreated: Boolean;
        "---": Integer;
        UserSetupApproval: Page 119;
        UserSetup2: Record 91;
        IndentReqLines: Report 50004;
        Text001: Label 'Orders are created successfully.';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        Text005: Label 'Do you want to create Orders?';
        Text0010: Label 'Enquiries Created Successfully';
        Text0011: Label 'Quotes Created Successfully';
        Text0012: Label 'Orders Created Successfully';

    procedure CheckRemainingQuantity();
    var
        IndentReqHeaderCheck: Record 50009;
        IndentRequisitionsCheck: Record 50003;
        CountVar: Integer;
        Text001: Label 'You Cannot create PO . Quantity not more than Zero.';
    begin
        CountVar := 0;
        IndentReqHeaderCheck.RESET;
        IndentReqHeaderCheck.SETRANGE("No.", Rec."No.");
        IF IndentReqHeaderCheck.FINDFIRST THEN
            IndentRequisitionsCheck.RESET;
        IndentRequisitionsCheck.SETRANGE("Document No.", IndentReqHeaderCheck."No.");
        IF IndentRequisitionsCheck.FINDSET THEN
            REPEAT
                //  IF IndentRequisitionsCheck."Remaining Quantity" <> 0 THEN
                CountVar += 1;
            UNTIL IndentRequisitionsCheck.NEXT = 0;
        IF CountVar = 0 THEN
            ERROR(Text001);
    end;

    procedure CreatedOrders();
    var
        PurchHeader: Record 38;
    begin
        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
        IF PurchHeader.FINDSET THEN
            PAGE.RUNMODAL(0, PurchHeader);
    end;

    procedure UpdateReqQty();
    var
        IndenReqRec: Record 50003;
        IndentLineRec: Record 50002;
        IndentReqHeaderRec: Record 50009;
        QuantyLvar: Decimal;
        IndentLineRec2: Record 50002;
    begin
        //B2B.1.4 START
        IndenReqRec.RESET;
        IndenReqRec.SETRANGE("Document No.", Rec."No.");
        IF IndenReqRec.FINDSET THEN BEGIN
            REPEAT

                CLEAR(QuantyLvar);
                IF IndenReqRec."Qty. To Order" > IndenReqRec."Vendor Min.Ord.Qty" THEN
                    QuantyLvar := IndenReqRec."Qty. To Order"
                ELSE
                    // QuantyLvar := IndenReqRec."Vendor Min.Ord.Qty" ;
                    IndentLineRec.RESET;
                IndentLineRec.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '<>%1', 0);
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '>=%1', QuantyLvar);
                IF IndentLineRec.FINDSET THEN BEGIN
                    IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - QuantyLvar;
                    IF IndentLineRec."Req.Quantity" < 0 THEN
                        IndentLineRec."Req.Quantity" := 0;
                    IndentLineRec.MODIFY;
                    CLEAR(QuantyLvar);
                END ELSE
                    IndentLineRec2.RESET;
                IndentLineRec2.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec2.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec2.SETFILTER("Req.Quantity", '<>%1', 0);
                IndentLineRec2.SETFILTER("Req.Quantity", '<%1', QuantyLvar);
                IF IndentLineRec2.FINDSET THEN
                    REPEAT

                        IF ((QuantyLvar <> 0) AND (QuantyLvar >= IndentLineRec2."Req.Quantity")) THEN BEGIN
                            QuantyLvar -= IndentLineRec2."Req.Quantity";
                            IndentLineRec2."Req.Quantity" := 0;
                            IndentLineRec2.MODIFY;
                        END ELSE
                            IF ((QuantyLvar <> 0) AND (QuantyLvar < IndentLineRec2."Req.Quantity")) THEN BEGIN
                                IndentLineRec2."Req.Quantity" -= QuantyLvar;
                                IndentLineRec2.MODIFY;
                                CLEAR(QuantyLvar);
                            END;

                    UNTIL IndentLineRec2.NEXT = 0;

            UNTIL IndenReqRec.NEXT = 0;
        END;

        //Commented //B2B.1.4
        /*
        IndenReqRec.RESET;
        IndenReqRec.SETRANGE("Document No.","No.");
        IF IndenReqRec.FINDSET THEN BEGIN
            IF IndentLineRec.GET(IndenReqRec."Indent No.",IndenReqRec."Indent Line No.") THEN BEGIN
                IF IndenReqRec."Qty. To Order" > IndenReqRec."Vendor Min.Ord.Qty" THEN
                  IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - IndenReqRec."Qty. To Order"
                ELSE IF IndenReqRec."Qty. To Order" < IndenReqRec."Vendor Min.Ord.Qty" THEN BEGIN
                  IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - IndenReqRec."Vendor Min.Ord.Qty";
                  IF IndentLineRec."Req.Quantity" < 0 THEN
                    IndentLineRec."Req.Quantity" := 0;
                END;
                IndentLineRec.MODIFY;
            END;
          UNTIL IndenReqRec.NEXT = 0;
        END;
        
         */
        //B2B.1.4 END

    end;

    trigger OnInit()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    trigger OnOpenPage()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
    end;
}


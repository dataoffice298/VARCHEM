page 33000269 "Inspection Receipt B2B"
{
    // version B2BQC1.00.00
    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.
    Caption = 'Inspection Receipt';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Inspection Receipt Header B2B";
    SourceTableView = SORTING("No.")
                      WHERE(Status = FILTER(false));
    UsageCategory = Documents;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the number';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'selected the no.series from inventory setup numbering tab';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter item name';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'enter the unit of measure ';
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ' base unit of measure if what you need ';
                }
                field("Quantity(Base)"; Rec."Quantity(Base)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'This date is used to calculate the customers payment due date and finance charges';
                }
                field("Rework Reference No."; Rec."Rework Reference No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'At the time of receipt of the material back from the vendor, open the same document rework reference number';
                }
                field("Source Type"; Rec."Source Type")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'selected the source type';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
                }
                field("Spec Version"; Rec."Spec Version")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'specification version group of characteristics changed  the quality structure process';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                //4.14 >>
                field("QC Certificate(s) Status"; "QC Certificate(s) Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'QC Certificate Status';
                }
                field("Certificate Remarks"; "Certificate Remarks")
                {
                    ApplicationArea = all;
                    ToolTip = 'Certificate Remarks';
                }
                //4.14 <<
                //CHB2B27SEP2022>>
                field("Quality Remarks"; "Quality Remarks")
                {
                    ApplicationArea = all;
                    ToolTip = 'Quality Remarks';
                }
                //CHB2B27SEP2022<<
            }
            part(Control1000000032; "Inspection Receipt Subform B2B")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Purch Line No." = FIELD("Purch Line No");
                ApplicationArea = all;

            }
            group(Receipt)
            {
                Caption = 'Receipt';
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor number';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vender name ';
                }
                field("Vendor Name 2"; Rec."Vendor Name 2")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name 2';
                }
                field(Address; Rec.Address)
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the address 2';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the contact person ';
                }
                field("Order No."; Rec."Order No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the order number';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Receipt no. on which the sample as received';
                }
                field("Purch Line No"; Rec."Purch Line No")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'purchase order the  line mention the items ,uom ,quantity is the single line number';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'External Document number';
                }
                field("Purchase Consignment"; Rec."Purchase Consignment")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines no for Purchase consignment';
                }
                field("Item Tracking Exists"; Rec."Item Tracking Exists")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Need to Assign Item Tracking For Item';
                }
                field("Quality Before Receipt"; Rec."Quality Before Receipt")
                {
                    ApplicationArea = all;
                    tooltip = 'Inspection is done before the material offered by the vendor is taken into the inventory.';
                }
            }
            group(Production)
            {
                Caption = 'Production';
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'selected the no.series from the manufacturing setup numbering tabs';
                }
                field("Prod. Order Line"; Rec."Prod. Order Line")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'prod. order line  the mention the items ,uom ,quantity is the single line number';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'routing no.. This includes both numbers and letters';
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'routing reference no. any operation the maintain the document is the number';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Operation number for the routing line. Every line of the routing has an operation number, which the program uses for various ';
                }
                field("Prod. Description"; Rec."Prod. Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the name prod. description';
                }
                field("Operation Description"; Rec."Operation Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ' operation description Name of the machine center or work center';
                }
                field("Production Batch No."; Rec."Production Batch No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the production batch number';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the subassembly words, letter';
                }
                field("Sub Assembly Description"; Rec."Sub Assembly Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the name subassembly description';
                }
                field("In Process"; Rec."In Process")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Inprocess Quality Control is used to inspect the required Specification at different stages of a particular Production Order';
                }
            }
            group(Inspection)
            {
                Caption = 'Inspection';
                field("<Quantity1>"; Rec.Quantity)
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field(UndefinedQtyCap; UndefinedQty)
                {
                    Caption = 'Undefined Quantity';
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'This Field Defines Undefine Quantities';
                }
                field("Qty. Accepted"; Rec."Qty. Accepted")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Accepted);

                        CalculateUndefinedQty();
                    end;
                }
                field("Qty. Accepted Under Deviation"; Rec."Qty. Accepted Under Deviation")
                {
                    ApplicationArea = all;
                    tooltip = 'To register the number of items Accepted under Deviation';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::"Accepted Under Deviation");
                        CalculateUndefinedQty();
                    end;
                }
                field("Qty. Rework"; Rec."Qty. Rework")
                {
                    ApplicationArea = all;
                    tooltip = 'If items are sent to be sent for re-work, in the Vendor card';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rework);
                        CalculateUndefinedQty();
                    end;
                }
                field("Qty. Rejected"; Rec."Qty. Rejected")
                {
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rejected);
                        
                        CalculateUndefinedQty();
                    end;
                }
                field("Qty. Hold"; Rec."Qty. Hold")
                {
                    ApplicationArea = all;
                    tooltip = 'If items are sent to be sent for re-work, in the Vendor card';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Hold);
                        CalculateUndefinedQty();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ' Mention the location code from which the inventory is to be dispatched';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                    tooltip = ' create new the location code from which the inventory is to be dispatched. ';
                }
                field("Qty. Accepted UD Reason"; Rec."Qty. Accepted UD Reason")
                {
                    ApplicationArea = all;
                    tooltip = 'this field accepted quantity under deviation reason';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = all;
                    tooltip = 'reason codes are attached to the Acceptance Levels';
                }
                field("Nature Of Rejection"; Rec."Nature Of Rejection")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines Rejection Reason';

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                action("<Action1102154000>")
                {
                    Caption = 'List';
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+L';
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'Inspection receipt list through which the user actually accepts, rejects or sends for rework';
                    Image = Receipt;
                }
                action("&Inspection Data Sheets")
                {
                    Caption = '&Inspection Data Sheets';
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                    Image = InsuranceLedger;
                    RunObject = Page "Inspection Data Sheet List B2B";
                    RunPageLink = "Receipt No." = FIELD("Receipt No."),
                                  "Order No." = FIELD("Order No."),
                                  "Purch. Line No" = FIELD("Purch Line No"),
                                  "Lot No." = FIELD("Lot No.");
                    ApplicationArea = all;
                }
                action("P&osted Inspect. Data Sheets")
                {
                    Caption = 'P&osted Inspect. Data Sheets';
                    Image = PostApplication;
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "Inspection Receipt No." = FIELD("No.");
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                }
                separator("-----")
                {
                    Caption = '-----';
                }
                action("&Purchase Receipt")
                {
                    Caption = '&Purchase Receipt';
                    Image = Purchase;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "No." = FIELD("Receipt No.");
                    ApplicationArea = all;
                    tooltip = 'posted purchase receipt  used for reporting and vendor analysis';
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'dimensions and dimension values to business documents before posting them and moving the resulting entries to G/L';
                    trigger OnAction();
                    begin
                        Rec.ShowDocDim();
                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ApplicationArea = all;
                    ToolTip = 'Navigate to Item Tracking lines';
                    trigger OnAction();
                    var
                        IRAcceptanceLevelsB2B: Record "IR Acceptance Levels B2B";//B2B22DEC22
                        LineNum: Integer;//B2B22DEC22
                        QualityItemLedgEntry1: Record "Quality Item Ledger Entry B2B";//B2B22DEC22



                    begin

                        if not Rec."Quality Before Receipt" then
                            Rec.ShowItemTrackingLines();
                        //B2B22DEC22>>
                        IRAcceptanceLevelsB2B.REset;
                        IRAcceptanceLevelsB2B.Setrange("Inspection Receipt No.", Rec."No.");
                        if IRAcceptanceLevelsB2B.FindSet() then
                            IRAcceptanceLevelsB2B.DeleteAll();
                        LineNum := 1000;

                        QualityItemLedgEntry1.Reset;

                        if (Rec."Rework Level" = 0) and not Rec."From Hold" then
                            QualityItemLedgEntry1.SETRANGE("Document No.", Rec."Receipt No.")
                        else
                            if Rec."From Hold" then begin
                                QualityItemLedgEntry1.SETRANGE("Document No.", Rec."No.");
                                //QualityItemLedgEntry1.SETRANGE(Hold, false);
                            end else
                                QualityItemLedgEntry1.SETRANGE("Document No.", Rec."Rework Reference No.");

                        QualityItemLedgEntry1.setrange("Inspection Status", QualityItemLedgEntry1."Inspection Status"::"Under Inspection");
                        if QualityItemLedgEntry1.Findset then begin

                            repeat

                                IRAcceptanceLevelsB2B.init;

                                IRAcceptanceLevelsB2B."Inspection Receipt No." := Rec."No.";
                                IRAcceptanceLevelsB2B."Line No." := LineNum;
                                IRAcceptanceLevelsB2B."Serial No." := QualityItemLedgEntry1."Serial No.";
                                IRAcceptanceLevelsB2B.Quantity := QualityItemLedgEntry1.Quantity;
                                if QualityItemLedgEntry1.Accept then
                                    IRAcceptanceLevelsB2B."Quality Type" := IRAcceptanceLevelsB2B."Quality Type"::Accepted


                                else
                                    if QualityItemLedgEntry1.Reject then
                                        IRAcceptanceLevelsB2B."Quality Type" := IRAcceptanceLevelsB2B."Quality Type"::Rejected

                                    else
                                        if QualityItemLedgEntry1.Rework then
                                            IRAcceptanceLevelsB2B."Quality Type" := IRAcceptanceLevelsB2B."Quality Type"::Rework

                                        else
                                            if QualityItemLedgEntry1."Accept Under Deviation" then
                                                IRAcceptanceLevelsB2B."Quality Type" := IRAcceptanceLevelsB2B."Quality Type"::"Accepted Under Deviation"
                                            else
                                                if QualityItemLedgEntry1.Hold then
                                                    IRAcceptanceLevelsB2B."Quality Type" := IRAcceptanceLevelsB2B."Quality Type"::Hold;

                                IRAcceptanceLevelsB2B."Item No." := "Item No.";
                                IRAcceptanceLevelsB2B."Vendor No." := "Vendor No.";
                                IRAcceptanceLevelsB2B."Source Type" := "Source Type";
                                IRAcceptanceLevelsB2B."Production Order No." := "Prod. Order No.";
                                IRAcceptanceLevelsB2B."Rework Level" := "Rework Level";
                                IRAcceptanceLevelsB2B."ILE No." := QualityItemLedgEntry1."Entry No.";
                                IRAcceptanceLevelsB2B."Acceptance Code" := GetAccepanceCode(IRAcceptanceLevelsB2B."Quality Type");

                                IRAcceptanceLevelsB2B.insert;
                                LineNum += 1000;
                            until QualityItemLedgEntry1.next = 0;
                        end;
                        CurrPage.Update();
                    end;
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    tooltip = 'post the material dispatch and receive used ';
                    trigger OnAction();
                    begin
                        //Rec.TestField("QC Certificate(s) Status", Rec."QC Certificate(s) Status"::Available);//4.14
                        Rec.TestField("Quality Remarks");
                        if not CONFIRM(Text003Qst) then
                            exit;
                        IF ("Lot No." <> '') or ("Serial No." <> '') THEN//B2BESGOn12Dec2022
                            CancelReservation(Rec);
                        InspectJnlLine.RUN(Rec);
                        Rec.Status := true;
                        CurrPage.SAVERECORD();
                        MESSAGE(Text001Msg, Rec."No.");
                        CurrPage.UPDATE(true);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        CalculateUndefinedQty();
    end;


    var
        InspectJnlLine: Codeunit "Inspection Jnl. Post Line B2B";
        Text001Msg: Label 'Inspection receipt %1 posted successfully.', Comment = '%1 = No';
        QualityType: Option Accepted,"Accepted Under Deviation",Rework,Rejected,Hold;
        UndefinedQty: Decimal;
        Text003Qst: Label 'Do you want to Post the Inspection Receipt?';

    procedure CalculateUndefinedQty();
    begin
        UndefinedQty := Rec.Quantity - Rec."Qty. Accepted" - Rec."Qty. Rejected" - Rec."Qty. Rework" - Rec."Qty. Accepted Under Deviation" - Rec."Qty. Hold";
    end;

    procedure CancelReservation(var InspectionReceipt: Record "Inspection Receipt Header B2B");
    var

        ReservEngineMgtExt: Codeunit 33000263;
    begin
        ReservationEntry.SETRANGE("Item No.", InspectionReceipt."Item No.");
        ReservationEntry.SETRANGE("Source Ref. No.", InspectionReceipt."Item Ledger Entry No.");
        if ReservationEntry.FIND('-') then begin
            ReservationEntry2.SETRANGE("Entry No.", ReservationEntry."Entry No.");
            ReservationEntry2.SETRANGE("Reservation Status", ReservationEntry2."Reservation Status"::Reservation,
            ReservationEntry2."Reservation Status"::Tracking);
            if ReservationEntry2.FIND('-') then
                repeat
                    ReservEngineMgtExt.CloseReservEntryTracking(ReservationEntry2);
                    COMMIT();
                until ReservationEntry2.NEXT() = 0;

        end;
    end;

    procedure GetAccepanceCode(QualityType: Option Accepted,"Accepted Under Deviation",Rework,Rejected,Hold): code[20];
    var
        AcceptanceCode: Code[20];
        AcceptanceLevelB2B: Record "Acceptance Level B2B";
    begin
        clear(AcceptanceCode);
        AcceptanceLevelB2B.Reset;
        AcceptanceLevelB2B.setrange(type, QualityType);
        if AcceptanceLevelB2B.FindFirst() then
            AcceptanceCode := AcceptanceLevelB2B.Code;
        exit(AcceptanceCode);

    end;

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
}


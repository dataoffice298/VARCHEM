page 33000268 "Posted Inspection Receipt B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Posted Inspection Receipt';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Inspection Receipt Header B2B";
    SourceTableView = WHERE(Status = FILTER(true));
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
                    tooltip = 'the number selected from the setup numbering tabs ';

                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the item number';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the name of the item description';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Define Unit of Measure of the items to be teste';
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
                    tooltip = ' You may need to create a base unit of measure if what you need is not on the default list';
                }
                field("Quantity(Base)"; Rec."Quantity(Base)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
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
                field("Rework Inspect DS Created"; Rec."Rework Inspect DS Created")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'material back from the the vendor again testing the material to created IDS & IR';
                }
                field("Source Type"; Rec."Source Type")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'selected the sorce types';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Default is new. After entry of the relevant data, the status must be changed to “Certified”.';

                }
                field("Spec Version"; Rec."Spec Version")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'specification version group of characteristics changed  the quality structure process ';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
            }
            part(Control1000000032; "Inspection Receipt Subform B2B")
            {
                Editable = false;
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
                    tooltip = 'enter the vendor name';
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
                    tooltip = 'enter the vendor addres 2';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the contact persons';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Receipt no. on which the sample as received';
                }
                field("Order No."; Rec."Order No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the order number';
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
                    tooltip = 'Enter the External document number';
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
                    ToolTip = 'Need to Assign Item Tracking';
                }
                field("Quality Before Receipt"; Rec."Quality Before Receipt")
                {
                    ApplicationArea = all;
                    tooltip = 'Inspection is done before the material offered by the vendor is taken into the inventory';
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
                    tooltip = 'the action of making or manufacturing  from components or raw materials, or the process out the finished products';
                }
                field("Prod. Order Line"; Rec."Prod. Order Line")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'prod.order line to mention the items,quantity ,uom is the single lne';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'This includes both numbers and letters.';
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
                    tooltip = 'Every line of the routing has an operation number, which the program uses for various ';
                }
                field("Operation Description"; Rec."Operation Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the name operation description ';
                }
                field("Prod. Description"; Rec."Prod. Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the prod. description';
                }
                field("Production Batch No."; Rec."Production Batch No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the production batch no';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the subassembly code';
                }
                field("Sub Assembly Description"; Rec."Sub Assembly Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the name subassembly ';

                }
                field("In Process"; Rec."In Process")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Before performing the Inprocess Quality Inspection, Specification for each stage is to be defined based on which the inspection process is carried out';
                }
            }
            group(Inspection)
            {
                Caption = 'Inspection';
                field("<Quantity2>"; Rec.Quantity)
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Qty. Accepted"; Rec."Qty. Accepted")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic  approval is the accepted quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Accepted);
                    end;
                }
                field("Qty. Accepted Under Deviation"; Rec."Qty. Accepted Under Deviation")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'this fields the accepted quantity under deviation';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::"Accepted Under Deviation");
                    end;
                }
                field("Qty. Rework"; Rec."Qty. Rework")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Now the rework items must be sent for rework to the vendor';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rework);
                    end;
                }
                field("Qty. Rejected"; Rec."Qty. Rejected")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rejected);
                    end;
                }
                field("Qty. Accepted UD Reason"; Rec."Qty. Accepted UD Reason")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'this field accept under deviation reason the quantity';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'enter the name of damage,rework,accept reason description';
                }
                field("Nature Of Rejection"; Rec."Nature Of Rejection")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'this field qyuantity rejected to nature like odour';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ': Mention the location code from which the inventory is to be dispatched';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ': create the new location code from which the inventory is to be stored';
                }
                field("Rework Completed"; Rec."Rework Completed")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'any rework quantity completed rework process';
                }
            }
            group(Returns)
            {
                Caption = 'Returns';
                field("<Qty. Rework2>"; Rec."Qty. Rework")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'how much rework quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rework);
                    end;
                }
                field("Qty. to Vendor(Rework)"; Rec."Qty. to Vendor(Rework)")
                {
                    Editable = QtyToVendorReworkEditable;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'the rework items must be sent for rework to the vendor';
                }
                field("Qty. sent to Vendor(Rework)"; Rec."Qty. sent to Vendor(Rework)")
                {
                    Editable = false;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'which quantity sent to vendor (rework)';
                }
                field("<Qty. Rejected2>"; Rec."Qty. Rejected")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'the inspection data sheet is quantity characteristic is not approval the rejected quantity';
                    trigger OnAssistEdit();
                    begin
                        Rec.QualityAcceptanceLevels(QualityType::Rejected);
                    end;
                }
                field("Qty. to Vendor(Rejected)"; Rec."Qty. to Vendor(Rejected)")
                {
                    ApplicationArea = all;
                    tooltip = ' the rejected items must be sent for rejected to the vendor';
                }
                field("Qty. sent to Vendor(Rejected)"; Rec."Qty. sent to Vendor(Rejected)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'which quantity sent to vendor (rejected)';
                }
                field("Rework Reference Document No."; Rec."Rework Reference Document No.")
                {
                    MultiLine = true;
                    ApplicationArea = all;
                    tooltip = 'At the time of receipt of the material back from the vendor, open the same document rework reference document number';
                    trigger OnValidate();
                    begin
                        if DeliveryReceiptEntry.GET(Rec."Rework Reference Document No.") then
                            Rec."Qty. to Receive(Rework)" := DeliveryReceiptEntry."Remaining Quantity";
                    end;
                }
                field("Qty. to Receive(Rework)"; Rec."Qty. to Receive(Rework)")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the quantity to items to be received in the Qty. To Receive (Re work) field';
                    trigger OnValidate();
                    begin
                        Rec.TESTFIELD("Rework Reference Document No.");
                        if Rec."Rework Reference Document No." <> 0 then
                            if DeliveryReceiptEntry.GET(Rec."Rework Reference Document No.") then
                                if Rec."Qty. to Receive(Rework)" > DeliveryReceiptEntry."Remaining Quantity" then
                                    ERROR(Text000Err);
                    end;
                }
                field("Qty. Received(Rework)"; Rec."Qty. Received(Rework)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'Enter the quantity to items to be received in the Qty. To Receive (Re work) field';
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
                    RunObject = Page "Posted Ins Receipt List B2B";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+L';
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'total order all list';
                    Image = Receipt;
                }
                action("Posted &Inspect. DS Details")
                {
                    Caption = 'Posted &Inspect. DS Details';
                    Image = PostApplication;
                    RunObject = Page "Posted Inspect. DS Details B2B";
                    RunPageLink = "Inspection Receipt No." = FIELD("No.");
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet  details used for reporting and vendor analysis';
                }
                action("&Rework Receipts")
                {
                    Caption = '&Rework Receipts';
                    Image = PostDocument;
                    RunObject = Page "Inspection Receipt List B2B";
                    RunPageLink = "Rework Reference No." = FIELD("No.");
                    ApplicationArea = all;
                    tooltip = 'At the time of receipt of the material back from the vendor, the rework document receipts ';
                }
                separator("----")
                {
                    Caption = '----';
                }
                action("&Purchase Receipt")
                {
                    Caption = '&Purchase Receipt';
                    Image = Purchase;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "No." = FIELD("Receipt No.");
                    ApplicationArea = all;
                    tooltip = 'Receipts used for reporting and vendor analysis';
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                action("Ro&uting")
                {
                    Caption = 'Ro&uting';
                    Image = Route;
                    ApplicationArea = all;
                    tooltip = 'Routing, the sequence of manufacturing can be define';
                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Qty. Rework");
                        Rec.TESTFIELD("Prod. Order No.");
                        Rec.TESTFIELD("Routing Reference No.");
                        Rec.TESTFIELD("Routing No.");

                        ProdOrderInspectRtng.SETRANGE(Status, ProdOrderInspectRtng.Status::Released);
                        ProdOrderInspectRtng.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
                        ProdOrderInspectRtng.SETRANGE("Routing Reference No.", Rec."Routing Reference No.");
                        ProdOrderInspectRtng.SETRANGE("Routing No.", Rec."Routing No.");
                        ProdOrderInspectRtng.SETRANGE("Inspection Receipt No.", Rec."No.");

                        PAGE.RUN(PAGE::"Ins Prod. Order Routing B2B", ProdOrderInspectRtng);
                    end;
                }
                action(Components)
                {
                    Caption = 'Components';
                    Image = Components;
                    ApplicationArea = all;
                    tooltip = 'component means one part of whole thing';
                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Qty. Rework");
                        Rec.TESTFIELD("Prod. Order No.");
                        Rec.TESTFIELD("Routing Reference No.");
                        Rec.TESTFIELD("Routing No.");

                        ProdOrderComp.SETRANGE(Status, ProdOrderComp.Status::Released);
                        ProdOrderComp.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
                        ProdOrderComp.SETRANGE("Prod. Order Line No.", Rec."Prod. Order Line");
                        ProdOrderComp.SETRANGE("Inspection Receipt No.", Rec."No.");

                        PAGE.RUN(PAGE::"Prod. Order Ins Components B2B", ProdOrderComp);
                    end;
                }
                action("Quality Ledger Entries")
                {
                    Caption = 'Quality Ledger Entries';
                    Image = QualificationOverview;
                    RunObject = Page "Quality Ledger Entries B2B";
                    RunPageLink = "Document No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+N';
                    ApplicationArea = all;
                    tooltip = 'To access the quality ledger entries for that particularItem';
                }
                action("Delivery/Receipt Entries")
                {
                    Caption = 'Delivery/Receipt Entries';
                    Image = Delivery;
                    RunObject = Page "Delivery/Receipt Entries B2B";
                    RunPageLink = "Document No." = FIELD("No.");
                    ApplicationArea = all;
                    ToolTip = 'Defines Entry no of Delivery Receipt';
                }
                separator(Separator1102152008)
                {
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    tooltip = 'dimensions and dimension values to business documents before posting them and moving the resulting entries to G/L';
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
                    ToolTip = 'Defines lines of Item Tracking ';
                    trigger OnAction();
                    begin
                        if not Rec."Quality Before Receipt" then
                            Rec.ShowItemTrackingLines();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Send &To Vendor/Work Shop")
                {
                    Caption = 'Send &To Vendor/Work Shop';
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    tooltip = 'vendor rework items send to workshops';
                    trigger OnAction();
                    begin
                        if Rec."Item Tracking Exists" then
                            InspectJnlPostLine.UpdateSentBackToVendor(Rec)
                        else
                            InspectJnlPostLine.FillReworkItemJnlLineAndPost(Rec);
                        CurrPage.UPDATE();
                    end;
                }
                action(Receive)
                {
                    Caption = 'Receive';
                    Image = ReceiveLoaner;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    tooltip = 'quantity to receive the order';
                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Qty. to Receive(Rework)");
                        if Rec."Item Tracking Exists" then
                            InspectJnlPostLine.UpdateReceiveRework(Rec)
                        else
                            InspectJnlPostLine.ReceiveReworkAndPost(Rec);
                        CurrPage.UPDATE();
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                tooltip = 'print generating a hardcopy to the electronic data being print';
                trigger OnAction();
                begin
                    InspectRcpt.SETRANGE(InspectRcpt."No.", Rec."No.");
                    REPORT.RUN(33000254, true, false, InspectRcpt);
                    InspectRcpt.SETRANGE(InspectRcpt."No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.SETRANGE("No.");
        Rec.SETRANGE("Rework Reference No.");
    end;

    trigger OnInit();
    begin
        QtyToVendorReworkEditable := true;
    end;

    var
        ProdOrderInspectRtng: Record "Rework Routing Line B2B";
        ProdOrderComp: Record "Rework Component B2B";
        InspectRcpt: Record "Inspection Receipt Header B2B";
        DeliveryReceiptEntry: Record "Delivery/Receipt Entry B2B";
        InspectJnlPostLine: Codeunit "Inspection Jnl. Post Line B2B";
        QualityType: Option Accepted,"Accepted Under Deviation",Rework,Rejected;
        QtyToVendorReworkEditable: Boolean;
        Text000Err: Label 'You can not receive more against this reference document no.';

    local procedure QtyToVendorReworkOnBeforeInput();
    begin
        if Rec."Item Tracking Exists" then
            QtyToVendorReworkEditable := false;
        CurrPage.UPDATE();
    end;
}


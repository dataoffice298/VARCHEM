page 33000257 "Inspection Data Sheet B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Inspection Data Sheet';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Ins Datasheet Header B2B";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'enter the number select the no.series';
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Item No."; Rec."Item No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'The program is preset with automatic numbering using generic number series.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the name of the item. ';
                }
                field(Quantity; Rec.Quantity)
                {
                    DecimalPlaces = 0 : 0;
                    ApplicationArea = all;
                    tooltip = 'Quantity is amount,measure or number';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = ' unit of measure code from item unit of measure where the quantity';
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("Spec Version"; Rec."Spec Version")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item change the production structure';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'You may need to create a base unit of measure if what you need is not on the default list';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = all;
                    tooltip = 'An amount that causes the program to check for sufficient inventory in the location to fulfil';
                }
                field("Inspection Group Code"; Rec."Inspection Group Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'inspection group that is responsible for inspection of the group of characters enlisted between Begin and end.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries ';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    tooltip = 'date is used to calculate the customers payment due date and finance charge';
                }
                field("Inspection Receipt No."; Rec."Inspection Receipt No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'inspectio receipt no. select the  no.series in quality setup numbering';
                }
                field("Rework Reference No."; Rec."Rework Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'rework reference no.Selected from the No.series definquality setup numbering tab';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    tooltip = 'Specify the source type against which you are creating source type like item, raw material,finished goods';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to certified';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = ' item tracking by lot number as well as the operational area where the tracking is applied';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = all;
                    tooltip = 'Depending on the company, a default location for the order  stored items in location';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'dimension set ID  posting them and moving the resulting entries to G/L';
                }
            }
            part(subform; "Ins Data Sheet Subform B2B")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = all;

            }
            group(Receipt)
            {
                Caption = 'Receipt';
                Editable = false;
                field("Vendor No."; Rec."Vendor No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'vendor no.Selected from the No.series defined purchase and payable setup numbering tab';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name ';
                }
                field("Vendor Name 2"; Rec."Vendor Name 2")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name 2';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor  Address 2';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the contact person ';

                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the receipt number';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the order no';
                }
                field("Purch. Line No"; Rec."Purch. Line No")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter purhase line number';
                }
                field("Purchase Consignment No."; Rec."Purchase Consignment No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines no for Purchase consignment';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the external document no ';
                }
                field("Item Tracking Exists"; Rec."Item Tracking Exists")
                {
                    ApplicationArea = all;
                    ToolTip = 'It Means Need to Assign Item Tracking';
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
                Editable = false;
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = ' prod.order No.Selected from the No.series defined manufacturing setup setup numbering tab';
                }
                field("Prod. Order Line"; Rec."Prod. Order Line")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = ' enter the production order line ';
                }
                field("Prod. Description"; Rec."Prod. Description")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the name of the prod.Description';
                }
                field("Production Batch No."; Rec."Production Batch No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the production Batch no';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Unique identifier for the routing number. ';
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the routing reference number ';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Operation number for the routing line. Every line of the routing has an operation number, which the program uses for various reference';

                }
                field("Operation Description"; Rec."Operation Description")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name operation description name';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    ApplicationArea = all;

                    tooltip = 'enter the code subbassembly';
                }
                field("Sub Assembly Description"; Rec."Sub Assembly Description")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name sub assembly description';
                }
                field("In Process"; Rec."In Process")
                {
                    ApplicationArea = all;
                    tooltip = 'In process in step by step manufacturing process';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    tooltip = 'dimensions and dimension values to business documents before posting them and moving the resulting entries to G/L';
                    Image = Dimensions;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.ShowDocDim();
                    end;
                }
            }
            group("&Data Sheet")
            {
                Caption = '&Data Sheet';
                separator(Separator1000000049)
                {
                }
                action("Purch. Receipt")
                {
                    Caption = 'Purch. Receipt';
                    tooltip = ' purchase Receipts used for reporting and vendor analysis';
                    Image = Purchase;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "No." = FIELD("Receipt No.");
                    ApplicationArea = all;
                }
                action(Action1102152012)
                {
                    Caption = 'Dimensions';
                    tooltip = 'dimensions and dimension values to business documents before posting them and moving the resulting entries to G/L';
                    Image = Dimensions;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.ShowDocDim();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                tooltip = 'functions operator the keys points';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    tooltip = 'release is used for any order send to vendor and customer';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = all;
                    trigger OnAction();
                    var
                        InspectHeader: Record "Ins Datasheet Header B2B";
                        "Count": Integer;
                        InspectDataSheetLineLrec: Record "Inspection Datasheet Line B2B";
                    begin
                        Count := 0;
                        DataSheetLine.SETRANGE("Document No.", Rec."No.");
                        if DataSheetLine.FIND('-') then
                            repeat
                                check := false;
                                if (DataSheetLine."Normal Value (Text)" <> '') or (DataSheetLine."Min. Value (Text)" <> '') or
                                   (DataSheetLine."Max. Value (Text)" <> '')
                                then
                                    if DataSheetLine."Actual  Value (Text)" = '' then begin
                                        Count := Count + 1;
                                        check := true;
                                    end;
                                if (check = false) and ((DataSheetLine."Normal Value (Num)" <> 0) or (DataSheetLine."Min. Value (Num)" <> 0) or
                                   (DataSheetLine."Max. Value (Num)" <> 0))
                                then
                                    if DataSheetLine."Actual Value (Num)" = 0 then
                                        Count := Count + 1;
                            until DataSheetLine.NEXT() = 0;
                        InspectDataSheetLineLrec.Reset();
                        InspectDataSheetLineLrec.SetRange("Document No.", Rec."No.");
                        InspectDataSheetLineLrec.SetFilter("Character Code", '<>%1', '');
                        if InspectDataSheetLineLrec.FindSet() then
                            repeat
                                if InspectDataSheetLineLrec.Qualitative then
                                    InspectDataSheetLineLrec.TestField("Actual  Value (Text)")
                                else
                                    InspectDataSheetLineLrec.TestField("Actual Value (Num)");
                            until InspectDataSheetLineLrec.Next() = 0;
                        InspectHeader.GET(Rec."No.");
                        if Count = 0 then begin
                            if CONFIRM(Text001Qst, false, Count) then
                                InspectHeader.Status := InspectHeader.Status::Released;
                        end else
                            if CONFIRM(Text000Qst, false, Count) then
                                InspectHeader.Status := InspectHeader.Status::Released;
                        InspectHeader.MODIFY();
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    tooltip = 'any order edit process used by reopen ';
                    trigger OnAction();
                    begin
                        Rec.Status := Rec.Status::Open;
                        CurrPage.UPDATE();
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                tooltip = 'The items posted as accepted  is only be used for any further transaction';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    tooltip = 'When the Purchase & sale Order is posted';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        if CONFIRM(Text002Qst) then begin
                            PostInspectData.RUN(Rec);
                            CurrPage.UPDATE();
                        end;
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    tooltip = 'print generating a hardcopy to the electronic data being print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        InspectDataSheet.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(33000250, true, false, InspectDataSheet);
                    end;
                }
            }
            action(Comment)
            {
                Caption = 'Comment';
                Image = ViewComments;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "Quality Comment Sheet B2B";
                RunPageLink = Type = CONST("Inspection Data Sheets"),
                              "No." = FIELD("No.");
                ToolTip = 'The user can add comments to a specification ';
                ApplicationArea = all;

            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OnAfterGetCurrRecordCust();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        OnAfterGetCurrRecordCust();
    end;

    var
        DataSheetLine: Record "Inspection Datasheet Line B2B";
        InspectDataSheet: Record "Ins Datasheet Header B2B";
        PostInspectData: Codeunit "Post-Inspection Data Sheet B2B";

        check: Boolean;
        Text001Qst: Label 'Do you want to release the document?';
        Text002Qst: Label 'Do you want to post the Inspection Data Sheets?';
        Text000Qst: Label 'Actual Values are not entered for %1 lines.\Do You want to release the Document?', Comment = '%1 = Count';

    local procedure OnAfterGetCurrRecordCust();
    begin
        xRec := Rec;
        Rec.SETRANGE("No.");
    end;
}


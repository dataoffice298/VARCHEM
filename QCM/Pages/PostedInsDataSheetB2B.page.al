page 33000262 "Posted Ins Data Sheet B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Posted Inspection Data Sheet';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Posted Ins DatasheetHeader B2B";
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
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter no.series the setup numbering tab';
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
                    tooltip = ' For more information on selecting from number series, refer to the "Create a New Item';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the name of the item';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    tooltip = ' unit of measure if what you need is not on the default list';
                }
                field(Quantity; Rec.Quantity)
                {
                    DecimalPlaces = 0 : 0;
                    ApplicationArea = all;
                    tooltip = ' Quantity required by the customer need to be mentioned';
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("Base Unit Of Measure"; Rec."Base Unit Of Measure")
                {
                    ApplicationArea = all;
                    tooltip = ' You may need to create a base unit of measure if what you need ';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = ' Required quantity is to be entered here';
                }
                field("Inspection Group Code"; Rec."Inspection Group Code")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection group that is responsible for inspection of the group of characters enlisted between Begin and end.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the document is created. This date is used to calculate the customers payment due date and finance charges';
                }
                field("Inspection Receipt No."; Rec."Inspection Receipt No.")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection receipt no.selected from the No.series defined quality setup numbering tab';
                }
                field("Rework Reference No."; Rec."Rework Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'identified the user enter the rework reference no';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    tooltip = 'selected the source type like purchase,sale';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to “Certified”.';
                }
                field("Spec Version"; Rec."Spec Version")
                {
                    ApplicationArea = all;
                    tooltip = 'specification version group of characteristics changed  the quality structure process';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = all;
                    tooltip = 'default company selected the item stored is the location';
                }
            }
            part(Control1000000034; "PostedIns DataSht Subform B2B")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = all;

            }
            group(Receipt)
            {
                Caption = 'Receipt';
                field("Vendor No."; Rec."Vendor No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Displays the list of all the Posted Material Receipts for that particular Document';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name';
                }
                field("Vendor Name 2"; Rec."Vendor Name 2")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor name 2';
                }
                field(Address; Rec.Address)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'enter the vendor address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the vendor addres 2';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the contact person number';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = all;
                    tooltip = ' Receipt no. on which the sample as received';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the order number';
                }
                field("Purch. Line No"; Rec."Purch. Line No")
                {
                    ApplicationArea = all;
                    tooltip = 'Defines Line no of Purchase order';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Enter the external document number';
                }
                field("Purchase Consignment No."; Rec."Purchase Consignment No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Defines to Track the purchase order';
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
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'the action of making or manufacturing  from components or raw materials, or the process out the finished products';
                }
                field("Prod. Order Line"; Rec."Prod. Order Line")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'prod.order line  mention the items ,uom ,quantity is the single line number';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Routing no.This includes both numbers and letters';
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Routing reference No. defaults automatically';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Operation number for the routing line. Every line of the routing has an operation number, which the program uses for various ';
                }
                field("Operation Description"; Rec."Operation Description")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name operation descrption';
                }
                field("Production Batch No."; Rec."Production Batch No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the number batch no';
                }
                field("Prod. Description"; Rec."Prod. Description")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name of production descrption';
                }
                field("Sub Assembly Code"; Rec."Sub Assembly Code")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the code for sub assembly code';
                }
                field("Sub Assembly Description"; Rec."Sub Assembly Description")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the name subassembly descrption';
                }
                field("In Process"; Rec."In Process")
                {
                    ApplicationArea = all;
                    tooltip = 'Based on the routing,Inspection Data Sheets are raised for the stage where Inprocess QC is defined';
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
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    tooltip = 'dimensions and dimension values to business documents before posting them and moving the resulting entries to G/L';
                    trigger OnAction();
                    begin
                        Rec.ShowDocDim();
                    end;
                }
            }
            group("<Action1102154000>")
            {
                Caption = '&DataSheet';
                Visible = false;
                action("PostedInspectDataSheetList")
                {
                    Caption = 'List';
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+L';
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet list used for reporting and vendor analysis';
                    Image = PostDocument;
                }
            }
        }
        area(processing)
        {
            action(Comment)
            {
                Caption = 'Comment';
                Image = ViewComments;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "Quality Comment Sheet B2B";
                RunPageLink = Type = CONST("Posted Inspection Data Sheets"),
                              "No." = FIELD("No.");
                ToolTip = 'Comment';
                ApplicationArea = all;
            }
        }
    }
}


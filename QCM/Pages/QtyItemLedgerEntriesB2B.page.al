page 33000274 "Qty Item Ledger Entries B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Item Ledger Entries';
    //Editable = false;
    PageType = List;
    SourceTable = "Quality Item Ledger Entry B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Unique no Generated at the time of IDS Creation';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the item number';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'Date the order will post to G/L, customer, and item ledger entries';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines the Type of Entry';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the soruce number';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the document number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    tooltip = ' Mention the location code from which the inventory ';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    tooltip = 'This is the total number of items being ordered';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                    tooltip = 'quantity sending the extra quantity  is the remaining quantity';
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'how much quantity shipped should be equal to quantity invoiced ';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Application Entryshould applies while posting ';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = all;
                    tooltip = 'any document or order  show the open ';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    tooltip = 'selected the source type like purchase sale  transfer orders';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    tooltip = 'this date is used to calculate the customers payment due date and finance charges';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the external document no';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the production order number identified the user';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    tooltip = 'variant code is the different packing size';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = all;
                    tooltip = 'which quantity measure to use Qty. per unit of measure';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    tooltip = 'the unit of measure code given is different from Base UOM';
                }
                field("Originally Ordered No."; Rec."Originally Ordered No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines order number';
                }
                field("Originally Ordered Var. Code"; Rec."Originally Ordered Var. Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines Order var.code';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines the Category of Item';
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = all;
                    tooltip = 'which product transaction of the quantity maintain the document ';
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines the Line No Of Production Order SubForm ';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                    tooltip = ' enter serial numbers';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    tooltip = 'lot numbers but it is required by the item tracking code applied to this item';
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ApplicationArea = all;
                    tooltip = 'This Field Defines ';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                    tooltip = 'any items expired life time complete is the expiration data';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = all;
                    tooltip = 'any items return back to vendor reason code mention damage, rework';
                }
                field("Declared Goods"; Rec."Declared Goods")
                {
                    ApplicationArea = all;
                    ToolTip = 'Fields Allows to Declared goods Quantity';
                }
                field("Inspection Status"; Rec."Inspection Status")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection status is good or bad inspection process';
                }
                field("Quality Ledger Entry No."; Rec."Quality Ledger Entry No.")
                {
                    ApplicationArea = all;
                    tooltip = 'quality ledger entry no number selected the no.series from quality setup numbering tab';
                }
                field(Accept; Rec.Accept)
                {
                    ApplicationArea = all;
                    tooltip = 'accept an item is taken a approval is the testing process';
                }
                field(Rework; Rec.Rework)
                {
                    ApplicationArea = all;
                    tooltip = 'any remark items is the rework';
                }
                field(Reject; Rec.Reject)
                {
                    ApplicationArea = all;
                    tooltip = 'reject an item is taken not approval is the testing process';
                }
                field("Accept Under Deviation"; Rec."Accept Under Deviation")
                {
                    ApplicationArea = all;
                    tooltip = 'This Field Allows to Enter Accept Under Deviation Quantities';
                }
                field(Hold; Rec.Hold)
                {
                    ApplicationArea = all;
                    tooltip = 'This Field Allows to Enter Hold Quantities';
                }
            }
        }
    }

    actions
    {
    }
}


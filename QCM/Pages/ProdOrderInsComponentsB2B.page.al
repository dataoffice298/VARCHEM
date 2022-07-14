page 33000288 "Prod. Order Ins Components B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    AutoSplitKey = true;
    Caption = 'Prod. Order Components';
    DataCaptionExpression = Rec.Caption();
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Rework Component B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the item number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Calculation Formula"; Rec."Calculation Formula")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Allows to enter calculation Formaula';

                }
                field(Length; Rec.Length)
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'Defines the lenght of the field';
                }
                field(Width; Rec.Width)
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'Defines the width of the field';
                }
                field(Weight; Rec.Weight)
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'amount or quantity of heaviness or mass amount a thing weight';
                }
                field(Depth; Rec.Depth)
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'the distance from the top or surface to the bottom of something';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    tooltip = ' unit of measure code from item unit of measure where the quantity to customer is to be dispatched';
                    ApplicationArea = all;
                }
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Defines the Quantity that need to produced';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                    tooltip = 'Defines the Quantity need to produce';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'Mention the location code from which the inventory is to be dispatched';
                }
                field("Quantity Consumed"; Rec."Quantity Consumed")
                {
                    Editable = false;
                    ApplicationArea = all;
                    tooltip = 'how much quantity quantity consumed';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'price of each items is the unit cost';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'each item price is cost of amount';
                }
                field(Position; Rec.Position)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Defines the level of position';
                }
                field("Position 2"; Rec."Position 2")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Defines the level of position';
                }
                field("Position 3"; Rec."Position 3")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Defines the level of position';
                }
                field("Production Lead Time"; Rec."Production Lead Time")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Defines the time need to produce the item';
                }
            }
        }
    }

    actions
    {
    }

    var
}


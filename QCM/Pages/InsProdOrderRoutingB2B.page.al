page 33000287 "Ins Prod. Order Routing B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Prod. Order Routing';
    DataCaptionExpression = Rec.Caption();
    PageType = List;
    SourceTable = "Rework Routing Line B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Schedule Manually"; Rec."Schedule Manually")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'Only when the user posts through the consumption or production journals';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = all;
                    tooltip = 'Operation number for the routing line. Every line of the routing has an operation number';
                }
                field("Previous Operation No."; Rec."Previous Operation No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'before operation number';
                }
                field("Next Operation No."; Rec."Next Operation No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'after the operation number';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    tooltip = 'which type used';

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    tooltip = ' automatic numbering using generic number series';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    ApplicationArea = all;
                    tooltip = 'which date start manufacturing process';
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    Visible = false;
                    ApplicationArea = all;

                    tooltip = 'which time the manufacturing the startig time';
                    trigger OnValidate();
                    begin
                        StartingTimeOnAfterValidate();
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'which date start the manufacturing process';
                    trigger OnValidate();
                    begin
                        StartingDateOnAfterValidate();
                    end;
                }
                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                    ApplicationArea = all;
                    tooltip = 'which date -time planning complete the manufacturing process';
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'manufacturing process complete the time is the ending time ';
                    trigger OnValidate();
                    begin
                        EndingTimeOnAfterValidate();
                    end;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'manufacturing process complete the items  ending date';
                    trigger OnValidate();
                    begin
                        EndingDateOnAfterValidate();
                    end;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = all;
                    tooltip = 'The time that is required to set up the machine or work center to convert from production of the last good item in a lot to the first good item of the next lot.';
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = all;
                    tooltip = 'The time that is required to process or manufacture an item for a specific operation. Run time does not include setup time';
                }
                field("Wait Time"; Rec."Wait Time")
                {
                    ApplicationArea = all;
                    tooltip = 'work center after an operation is finished until it is moved to the next operation. It is often expressed as part of move time';
                }
                field("Move Time"; Rec."Move Time")
                {
                    ApplicationArea = all;
                    tooltip = 'The time a production lot or batch spends in transit from one operation to the next';
                }
                field("Fixed Scrap Quantity"; Rec."Fixed Scrap Quantity")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = ' fixed scrap quantity for the manufacturing process';
                }
                field("Scrap Factor %"; Rec."Scrap Factor %")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'mention the scrap factor percentage';
                }
                field("Send-Ahead Quantity"; Rec."Send-Ahead Quantity")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'This field refers to the quantity of the current operation that must be completed before the next operation can be started';
                }
                field("Concurrent Capacities"; Rec."Concurrent Capacities")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'This is the total quantity defined of the simultaneously available machines';
                }
                field("Unit Cost per"; Rec."Unit Cost per")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'prices per each items';
                }
                field("Expected Operation Cost Amt."; Rec."Expected Operation Cost Amt.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'This Field defines the operational cost of particular field ';
                }
                field("Expected Capacity Ovhd. Cost"; Rec."Expected Capacity Ovhd. Cost")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'This Field defines the Overhead cost of particular field ';
                }
                field("Expected Capacity Need"; Rec."Expected Capacity Need")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'This Field defines the needed Expected Capacity of operation ';
                }
                field("Routing Status"; Rec."Routing Status")
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'routing status for operation performs';
                }
            }
        }
    }

    actions
    {
    }

    local procedure StartingTimeOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;

    local procedure StartingDateOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;

    local procedure EndingTimeOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;

    local procedure EndingDateOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;
}


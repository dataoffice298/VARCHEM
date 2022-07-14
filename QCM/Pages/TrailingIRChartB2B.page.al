page 33000302 "Trailing IR Chart B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Trailing Inspection Receipts';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusTextCap; StatusText)
            {
                Caption = 'Status Text';
                ShowCaption = false;
                ApplicationArea = all;
                tooltip = ' enter the status';
            }
            field(BusinessChart; '')
            {
                Caption = 'Business Chart';
                ApplicationArea = all;
                tooltip = 'bussiness profit and loss to show the chart ';
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                Visible = false;
                tooltip = 'any document show';
                action(AllOrders)
                {
                    Caption = 'All Orders';
                    Enabled = AllOrdersEnabled;
                    ApplicationArea = all;
                    tooltip = 'all order the transaction the process';

                    Image = AllLines;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetShowOrders(TrailingIRSetup."Show IR"::"All IR");
                        UpdateStatus();
                    end;
                }
                action(OrdersUntilToday)
                {
                    Caption = 'Orders Until Today';
                    Enabled = OrdersUntilTodayEnabled;
                    ApplicationArea = all;
                    ToolTip = 'Define the total orders until today';
                    Image = Order;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetShowOrders(TrailingIRSetup."Show IR"::"IR Until Today");
                        UpdateStatus();
                    end;
                }
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    Caption = 'Day';
                    Enabled = DayEnabled;
                    ApplicationArea = all;
                    tooltip = 'enter the day';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetPeriodLength(TrailingIRSetup."Period Length"::Day);
                        UpdateStatus();
                    end;
                }
                action(Week)
                {
                    Caption = 'Week';
                    Enabled = WeekEnabled;
                    ApplicationArea = all;
                    tooltip = 'which week use the order';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetPeriodLength(TrailingIRSetup."Period Length"::Week);
                        UpdateStatus();
                    end;
                }
                action(Month)
                {
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ApplicationArea = all;
                    tooltip = 'which month user';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetPeriodLength(TrailingIRSetup."Period Length"::Month);
                        UpdateStatus();
                    end;
                }
                action(Quarter)
                {
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;
                    ApplicationArea = all;
                    tooltip = 'which 6 month user';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetPeriodLength(TrailingIRSetup."Period Length"::Quarter);
                        UpdateStatus();
                    end;
                }
                action(Year)
                {
                    Caption = 'Year';
                    Enabled = YearEnabled;
                    ApplicationArea = all;
                    tooltip = 'enter the year';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIRSetup.SetPeriodLength(TrailingIRSetup."Period Length"::Year);
                        UpdateStatus();
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    Caption = 'Value to Calculate';
                    Image = Calculate;
                    Visible = false;
                    action(Amount)
                    {
                        Caption = 'Amount';
                        Enabled = AmountEnabled;
                        ApplicationArea = all;
                        ToolTip = 'this field mention the amount';
                        Image = AmountByPeriod;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetValueToCalcuate(TrailingIRSetup."Value to Calculate"::"Amount Excl. VAT");
                            UpdateStatus();
                        end;
                    }
                    action(NoofOrders)
                    {
                        Caption = 'No. of Orders';
                        Enabled = NoOfOrdersEnabled;
                        ApplicationArea = all;
                        tooltip = 'enter the number of the order';
                        Image = Order;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetValueToCalcuate(TrailingIRSetup."Value to Calculate"::"No. of IR");
                            UpdateStatus();
                        end;
                    }
                }
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        Caption = 'Stacked Area';
                        Enabled = StackedAreaEnabled;
                        ApplicationArea = all;
                        ToolTip = 'Displays the Evolution of the value of several groups';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetChartType(TrailingIRSetup."Chart Type"::"Stacked Area");
                            UpdateStatus();
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;
                        ApplicationArea = all;
                        ToolTip = 'Displays the Evolution of the value of several groups Percentage';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetChartType(TrailingIRSetup."Chart Type"::"Stacked Area (%)");
                            UpdateStatus();
                        end;
                    }
                    action(StackedColumn)
                    {
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;
                        ApplicationArea = all;
                        ToolTip = 'Defines to allow part-to-whole comparisons over time';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetChartType(TrailingIRSetup."Chart Type"::"Stacked Column");
                            UpdateStatus();
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        Caption = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;
                        ApplicationArea = all;
                        ToolTip = 'Defines to allow part-to-whole comparisons over time Percentage';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIRSetup.SetChartType(TrailingIRSetup."Chart Type"::"Stacked Column (%)");
                            UpdateStatus();
                        end;
                    }
                }
            }
            separator(Separator25)
            {
            }
            action(Refresh)
            {
                Caption = 'Refresh';
                Image = Refresh;
                ApplicationArea = all;
                ToolTip = 'Defines to Refrish the Charts';
                trigger OnAction();
                begin
                    NeedsUpdate := true;
                    UpdateStatus();
                end;
            }
            separator(Separator27)
            {
            }
            action(Setup)
            {
                Caption = 'Setup';
                Image = Setup;
                ApplicationArea = all;
                ToolTip = 'Defines to Setup the page';
                trigger OnAction();
                begin
                    RunSetup();
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        UpdateChart();
        IsChartDataReady := true;

        if not (IsChartAddInReady) then
            SetActionsEnabled();
    end;

    trigger OnOpenPage();
    begin
        SetActionsEnabled();
    end;

    var
        TrailingIRSetup: Record "Trailing IR Setup B2B";
        OldTrailingIRSetup: Record "Trailing IR Setup B2B";
        TrailingIRMgt: Codeunit "Trailing IR Mgt B2B";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllOrdersEnabled: Boolean;
        [InDataSet]
        OrdersUntilTodayEnabled: Boolean;
        [InDataSet]
        DelayedOrdersEnabled: Boolean;
        [InDataSet]
        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        NoOfOrdersEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;

    local procedure UpdateChart();
    begin
        if not NeedsUpdate then
            exit;
        if not (IsChartAddInReady) then
            exit;
        TrailingIRMgt.UpdateData(Rec);
        //Update(CurrPage.BusinessChart);
        UpdateStatus();
        NeedsUpdate := false;
    end;

    procedure UpdateStatus();
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length") or
          (OldTrailingIRSetup."Show IR" <> TrailingIRSetup."Show IR") or
          (OldTrailingIRSetup."Use Work Date as Base" <> TrailingIRSetup."Use Work Date as Base") or
          (OldTrailingIRSetup."Value to Calculate" <> TrailingIRSetup."Value to Calculate") or
          (OldTrailingIRSetup."Chart Type" <> TrailingIRSetup."Chart Type");

        OldTrailingIRSetup := TrailingIRSetup;

        if NeedsUpdate then
            StatusText := TrailingIRSetup.GetCurrentSelectionText();

        SetActionsEnabled();
    end;

    procedure RunSetup();
    begin
        PAGE.RUNMODAL(PAGE::"Trailing IDS Setup B2B", TrailingIRSetup);
        TrailingIRSetup.GET(USERID());
        UpdateStatus();
    end;

    procedure SetActionsEnabled();
    begin
        AllOrdersEnabled := (TrailingIRSetup."Show IR" <> TrailingIRSetup."Show IR"::"All IR") and
          IsChartAddInReady;
        OrdersUntilTodayEnabled := false;
        DelayedOrdersEnabled := false;

        DayEnabled := (TrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length"::Day) and
          IsChartAddInReady;
        WeekEnabled := (TrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (TrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (TrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (TrailingIRSetup."Period Length" <> TrailingIRSetup."Period Length"::Year) and
          IsChartAddInReady;
        AmountEnabled := false;

        NoOfOrdersEnabled :=
          (TrailingIRSetup."Value to Calculate" <> TrailingIRSetup."Value to Calculate"::"No. of IR") and
          IsChartAddInReady;
        StackedAreaEnabled := (TrailingIRSetup."Chart Type" <> TrailingIRSetup."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingIRSetup."Chart Type" <> TrailingIRSetup."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (TrailingIRSetup."Chart Type" <> TrailingIRSetup."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (TrailingIRSetup."Chart Type" <> TrailingIRSetup."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
    /*
    SetDrillDownIndexes(point);
    TrailingIRMgt.DrillDown(Rec);
    */
    //end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
    /*
    */
    //end;

    //event BusinessChart();
    //begin
    /*
    IsChartAddInReady := true;
    TrailingIRMgt.OnOpenPage(TrailingIRSetup);
    UpdateStatus;
    if IsChartDataReady then
      UpdateChart;
    */
    //end;
}


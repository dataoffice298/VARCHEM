page 33000300 "Trailing IDS Chart B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Trailing Inspection Datasheets';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusTextDCap; StatusText)
            {
                Caption = 'Status Text';
                ShowCaption = false;
                ApplicationArea = all;
                ToolTip = 'Define the Status of the text';

            }
            field(BusinessChartCap; '')
            {
                Caption = 'Business Chart';
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35';
                ApplicationArea = all;
                tooltip = 'Defines measurement of business value';
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
                action(AllOrders)
                {
                    Caption = 'All Orders';
                    Enabled = AllOrdersEnabled;
                    ApplicationArea = all;
                    tooltip = 'this field used for list of all order';
                    image = AllLines;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetShowOrders(TrailingIDSSetup."Show IDS"::"All IDS");
                        UpdateStatus();
                    end;
                }
                action(OrdersUntilToday)
                {
                    Caption = 'Orders Until Today';
                    Enabled = OrdersUntilTodayEnabled;
                    ApplicationArea = all;
                    ToolTip = 'Shows the available order until today';
                    Image = Order;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetShowOrders(TrailingIDSSetup."Show IDS"::"IDS Until Today");
                        UpdateStatus();
                    end;
                }
                /*
                action(DelayedOrders)
                {
                    Caption = 'Delayed Orders';
                    Enabled = DelayedOrdersEnabled;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetShowOrders(TrailingIDSSetup."Show Orders"::"Delayed Orders");
                        UpdateStatus;  
                    end;
                }
                */
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
                    tooltip = 'this field mention the day';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetPeriodLength(TrailingIDSSetup."Period Length"::Day);
                        UpdateStatus();
                    end;
                }
                action(Week)
                {
                    Caption = 'Week';
                    Enabled = WeekEnabled;
                    ApplicationArea = all;
                    tooltip = 'ths field  used mention the week ';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetPeriodLength(TrailingIDSSetup."Period Length"::Week);
                        UpdateStatus();
                    end;
                }
                action(Month)
                {
                    Caption = 'Month';
                    Enabled = MonthEnabled;
                    ApplicationArea = all;
                    tooltip = 'This field used for mention the month';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetPeriodLength(TrailingIDSSetup."Period Length"::Month);
                        UpdateStatus();
                    end;
                }
                action(Quarter)
                {
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;
                    ApplicationArea = all;
                    tooltip = 'This field used for mention  quarter';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetPeriodLength(TrailingIDSSetup."Period Length"::Quarter);
                        UpdateStatus();
                    end;
                }
                action(Year)
                {
                    Caption = 'Year';
                    Enabled = YearEnabled;
                    ApplicationArea = all;
                    tooltip = 'This field used for mention the year';
                    Image = Calendar;
                    trigger OnAction();
                    begin
                        TrailingIDSSetup.SetPeriodLength(TrailingIDSSetup."Period Length"::Year);
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
                        tooltip = 'This field mention the total amount';
                        Image = AmountByPeriod;
                        trigger OnAction();
                        begin
                            TrailingIDSSetup.SetValueToCalcuate(TrailingIDSSetup."Value to Calculate"::"Amount Excl. VAT");
                            UpdateStatus();
                        end;
                    }
                    action(NoofOrders)
                    {
                        Caption = 'No. of Orders';
                        Enabled = NoOfOrdersEnabled;
                        ApplicationArea = all;
                        tooltip = 'This field used for number of order';
                        Image = Order;
                        trigger OnAction();
                        begin
                            TrailingIDSSetup.SetValueToCalcuate(TrailingIDSSetup."Value to Calculate"::"No. of IDS");
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
                        ToolTip = 'Displays the evolution of the value of several groups';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIDSSetup.SetChartType(TrailingIDSSetup."Chart Type"::"Stacked Area");
                            UpdateStatus();
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;
                        ApplicationArea = all;
                        ToolTip = 'Displays the evolution of the value of several groups percentage';
                        Image = StaleCheck;
                        trigger OnAction();
                        begin
                            TrailingIDSSetup.SetChartType(TrailingIDSSetup."Chart Type"::"Stacked Area (%)");
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
                            TrailingIDSSetup.SetChartType(TrailingIDSSetup."Chart Type"::"Stacked Column");
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
                            TrailingIDSSetup.SetChartType(TrailingIDSSetup."Chart Type"::"Stacked Column (%)");
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
                ToolTip = 'used to refrish ';
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
                tooltip = 'any process setting the setup like no.series';
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
        TrailingIDSSetup: Record "Trailing IDS Setup B2B";
        OldTrailingIDSSetup: Record "Trailing IDS Setup B2B";
        TrailingIDSMgt: Codeunit "Trailing IDS Mgt B2B";
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
        TrailingIDSMgt.UpdateData(Rec);
        //Update(CurrPage.BusinessChart);
        UpdateStatus();
        NeedsUpdate := false;
    end;

    procedure UpdateStatus();
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length") or
          (OldTrailingIDSSetup."Show IDS" <> TrailingIDSSetup."Show IDS") or
          (OldTrailingIDSSetup."Use Work Date as Base" <> TrailingIDSSetup."Use Work Date as Base") or
          (OldTrailingIDSSetup."Value to Calculate" <> TrailingIDSSetup."Value to Calculate") or
          (OldTrailingIDSSetup."Chart Type" <> TrailingIDSSetup."Chart Type");

        OldTrailingIDSSetup := TrailingIDSSetup;

        if NeedsUpdate then
            StatusText := TrailingIDSSetup.GetCurrentSelectionText();

        SetActionsEnabled();
    end;

    procedure RunSetup();
    begin
        PAGE.RUNMODAL(PAGE::"Trailing IDS Setup B2B", TrailingIDSSetup);
        TrailingIDSSetup.GET(USERID());
        UpdateStatus();
    end;

    procedure SetActionsEnabled();
    begin
        AllOrdersEnabled := (TrailingIDSSetup."Show IDS" <> TrailingIDSSetup."Show IDS"::"All IDS") and
          IsChartAddInReady;

        OrdersUntilTodayEnabled := false;
        DelayedOrdersEnabled := false;

        DayEnabled := (TrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length"::Day) and
          IsChartAddInReady;
        WeekEnabled := (TrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (TrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (TrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (TrailingIDSSetup."Period Length" <> TrailingIDSSetup."Period Length"::Year) and
          IsChartAddInReady;

        AmountEnabled := false;

        NoOfOrdersEnabled :=
          (TrailingIDSSetup."Value to Calculate" <> TrailingIDSSetup."Value to Calculate"::"No. of IDS") and
          IsChartAddInReady;
        StackedAreaEnabled := (TrailingIDSSetup."Chart Type" <> TrailingIDSSetup."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingIDSSetup."Chart Type" <> TrailingIDSSetup."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (TrailingIDSSetup."Chart Type" <> TrailingIDSSetup."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (TrailingIDSSetup."Chart Type" <> TrailingIDSSetup."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;
    /*
        event BusinessChart(point: DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
        begin
            SetDrillDownIndexes(point);
            TrailingIDSMgt.DrillDown(Rec);
        end;
    */
    /*
        event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
        begin
        end;


         Event BusinessChart();
         begin

         IsChartAddInReady := true;
         TrailingIDSMgt.OnOpenPage(TrailingIDSSetup);
         UpdateStatus();
         if IsChartDataReady then
           UpdateChart();

         end;
         */
}


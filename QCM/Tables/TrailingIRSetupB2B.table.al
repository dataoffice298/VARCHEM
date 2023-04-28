table 33000289 "Trailing IR Setup B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Trailing IR Setup';

    fields
    {
        field(1; "User ID"; Text[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
            DataClassification = CustomerContent;
        }
        field(3; "Show IR"; Option)
        {
            Caption = 'Show IR';
            OptionCaption = 'All IR,IR Until Today';
            OptionMembers = "All IR","IR Until Today";
            DataClassification = CustomerContent;
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
            DataClassification = CustomerContent;
        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of IR';
            OptionMembers = "Amount Excl. VAT","No. of IR";
            DataClassification = CustomerContent;
        }
        field(6; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = "Stacked Area","Stacked Area (%)","Stacked Column","Stacked Column (%)";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001Txt: Label 'Updated at %1.', Comment = '%1 = Time';

    procedure GetCurrentSelectionText(): Text[100];
    begin
        exit(FORMAT("Show IR") + '|' +
          FORMAT("Period Length") + '|' +
          FORMAT("Value to Calculate") + '|. (' +
          STRSUBSTNO(Text001Txt, TIME()) + ')');
    end;

    procedure GetStartDate(): Date;
    var
        StartDate: Date;
    begin
        if "Use Work Date as Base" then
            StartDate := WORKDATE()
        else
            StartDate := TODAY();

        exit(StartDate);
    end;

    procedure GetChartType(): Integer;
    var
        BusinessChartBuf: Record "Business Chart Buffer";
    begin
        case "Chart Type" of
            "Chart Type"::"Stacked Area":
                exit(BusinessChartBuf."Chart Type"::StackedArea.AsInteger());
            "Chart Type"::"Stacked Area (%)":
                exit(BusinessChartBuf."Chart Type"::StackedArea100.AsInteger());
            "Chart Type"::"Stacked Column":
                exit(BusinessChartBuf."Chart Type"::StackedColumn.AsInteger());
            "Chart Type"::"Stacked Column (%)":
                exit(BusinessChartBuf."Chart Type"::StackedColumn100.AsInteger());
        end;
    end;

    procedure SetPeriodLength(PeriodLength: Option);
    begin
        "Period Length" := PeriodLength;
        MODIFY();
    end;

    procedure SetShowOrders(ShowOrders: Integer);
    begin
        "Show IR" := ShowOrders;
        MODIFY();
    end;

    procedure SetValueToCalcuate(ValueToCalc: Integer);
    begin
        "Value to Calculate" := ValueToCalc;
        MODIFY();
    end;

    procedure SetChartType(ChartType: Integer);
    begin
        "Chart Type" := ChartType;
        MODIFY();
    end;
}


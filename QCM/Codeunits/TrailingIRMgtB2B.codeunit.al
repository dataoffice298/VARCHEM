codeunit 33000258 "Trailing IR Mgt B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.


    trigger OnRun();
    begin
    end;

    var
        TrailingIRSetup: Record "Trailing IR Setup B2B";
        InspRcpttHeader: Record "Inspection Receipt Header B2B";
        PostInspRcptHeader: Record "Inspection Receipt Header B2B";
        Text330001Txt: Label 'Not Posted';
        Text330002Txt: Label 'Posted';

    procedure OnOpenPage(var TrailingIRSetup: Record "Trailing IR Setup B2B");
    begin
        if not TrailingIRSetup.GET(USERID()) then begin
            TrailingIRSetup."User ID" := Format(USERID());
            TrailingIRSetup."Use Work Date as Base" := true;
            TrailingIRSetup."Period Length" := TrailingIRSetup."Period Length"::Month;
            TrailingIRSetup."Value to Calculate" := TrailingIRSetup."Value to Calculate"::"No. of IR";
            TrailingIRSetup."Chart Type" := TrailingIRSetup."Chart Type"::"Stacked Column";
            TrailingIRSetup.INSERT();
        end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer");
    var
        ToDate: Date;
        Measure: Integer;
        XIndexValue: Text;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        TrailingIRSetup.GET(USERID());
        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        XIndexValue := BusChartBuf.GetMeasureValueString(Measure);
        if XIndexValue = '1' then begin
            InspRcpttHeader.SETRANGE(Status, false);
            InspRcpttHeader.SETRANGE("Document Date", 0D, ToDate);
            PAGE.RUN(PAGE::"Inspection Receipt List B2B", InspRcpttHeader);
        end else
            if XIndexValue = '2' then begin
                PostInspRcptHeader.SETRANGE(Status, true);
                PostInspRcptHeader.SETRANGE("Posting Date", 0D, ToDate);
                PAGE.RUN(PAGE::"Posted Ins Receipt List B2B", PostInspRcptHeader);
            end;
    end;

    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer");
    var
        ChartMap: array[2] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        IDSLoop: Integer;
        StatusText: Text[50];
    begin
        TrailingIRSetup.GET(USERID());
        BusChartBuf.Initialize();
        BusChartBuf."Period Length" := TrailingIRSetup."Period Length";
        BusChartBuf.SetPeriodXAxis();

        CreateMap(ChartMap);
        for IDSLoop := 1 to ARRAYLEN(ChartMap) do begin
            if ChartMap[IDSLoop] = 1 then
                StatusText := Text330001Txt
            else
                if ChartMap[IDSLoop] = 2 then
                    StatusText := Text330002Txt;
            BusChartBuf.AddMeasure(StatusText, IDSLoop, BusChartBuf."Data Type"::Decimal, TrailingIRSetup.GetChartType());
        end;

        if CalcPeriods(FromDate, ToDate, BusChartBuf) then begin
            BusChartBuf.AddPeriods(ToDate[1], ToDate[ARRAYLEN(ToDate)]);

            for IDSLoop := 1 to ARRAYLEN(ChartMap) do begin
                TotalValue := 0;
                for ColumnNo := 1 to ARRAYLEN(ToDate) do begin
                    Value := GetIRValue(ChartMap[IDSLoop], FromDate[ColumnNo], ToDate[ColumnNo]);
                    if ColumnNo = 1 then
                        TotalValue := Value
                    else
                        TotalValue += Value;
                    BusChartBuf.SetValueByIndex(IDSLoop - 1, ColumnNo - 1, TotalValue);
                end;
            end;
        end;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean;
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ARRAYLEN(ToDate);
        ToDate[MaxPeriodNo] := TrailingIRSetup.GetStartDate();
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := 0D;
        exit(true);
    end;



    local procedure GetIRValue(MapValue: Integer; FromDate: Date; ToDate: Date): Decimal;
    begin
        if TrailingIRSetup."Value to Calculate" = TrailingIRSetup."Value to Calculate"::"No. of IR" then
            exit(GetIRCount(MapValue, FromDate, ToDate));
    end;

    local procedure GetIRCount(MapValue: Integer; FromDate: Date; ToDate: Date): Integer;
    var
        IDSCount: Integer;
    begin
        if MapValue = 1 then begin
            InspRcpttHeader.SETRANGE(Status, false);
            InspRcpttHeader.SETRANGE("Document Date", FromDate, ToDate);
            IDSCount := InspRcpttHeader.COUNT();
        end else
            if MapValue = 2 then begin
                PostInspRcptHeader.SETRANGE(Status, true);
                PostInspRcptHeader.SETRANGE("Posting Date", FromDate, ToDate);
                IDSCount := PostInspRcptHeader.COUNT();
            end;
        exit(IDSCount);
    end;

    procedure CreateMap(var Map: array[2] of Integer);
    var
    begin
        Map[1] := 1; //UnPosted IDS
        Map[2] := 2; //Posted IDS
    end;
}


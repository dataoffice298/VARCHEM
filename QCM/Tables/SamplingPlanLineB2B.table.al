table 33000258 "Sampling Plan Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Sampling Plan Line';

    fields
    {
        field(1; "Sampling Code"; Code[20])
        {
            Caption = 'Sampling Code';
            NotBlank = true;
            TableRelation = "Sampling Plan Header B2B";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Lot Size - Min"; Decimal)
        {
            BlankZero = true;
            Caption = 'Lot Size - Min';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(4; "Lot Size - Max"; Decimal)
        {
            BlankZero = true;
            Caption = 'Lot Size - Max';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(5; "Sampling Size"; Decimal)
        {
            BlankZero = true;
            Caption = 'Sampling Size';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(6; "Allowable Defects - Min"; Decimal)
        {
            BlankZero = true;
            Caption = 'Allowable Defects - Min';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(7; "Allowable Defects - Max"; Decimal)
        {
            BlankZero = true;
            Caption = 'Allowable Defects - Max';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Sampling Code", "Line No.")
        {
        }
        key(Key2; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatus();
        CheckNextRec := false;
        CheckPrevRec := false;
        CheckRec := false;
        SamplePlanline.RESET();
        SamplePlanline.SETRANGE("Sampling Code", "Sampling Code");
        if SamplePlanline.FIND('-') then
            repeat
                if not CheckRec then
                    if SamplePlanline."Line No." = "Line No." then begin
                        CheckRec := true;
                        if SamplePlanline.NEXT(-1) <> 0 then begin
                            TempSamplePlanline1 := SamplePlanline;
                            SamplePlanline.NEXT(1);
                            CheckPrevRec := true;
                        end;
                        if SamplePlanline.NEXT(1) <> 0 then begin
                            TempSamplePlanline2 := SamplePlanline;
                            CheckNextRec := true;
                        end;
                    end;
            until SamplePlanline.NEXT() = 0;

        if CheckPrevRec and CheckNextRec then begin
            SamplePlanline := TempSamplePlanline2;
            SamplePlanline."Lot Size - Min" := TempSamplePlanline1."Lot Size - Max" + 1;
            SamplePlanline.MODIFY();
        end;
        if not CheckPrevRec and CheckNextRec then begin
            SamplePlanline := TempSamplePlanline2;
            SamplePlanline."Lot Size - Min" := 0;
            SamplePlanline.MODIFY();
        end;
    end;

    trigger OnInsert();
    begin
        TestStatus();
        CheckNextRec := false;
        CheckPrevRec := false;
        CheckRec := false;
        SamplePlanline.RESET();
        SamplePlanline.SETRANGE("Sampling Code", "Sampling Code");
        if SamplePlanline.FIND('-') then
            repeat
                if SamplePlanline."Line No." < "Line No." then begin
                    TempSamplePlanline1 := SamplePlanline;
                    CheckRec := true;
                    CheckPrevRec := true;
                end else
                    CheckRec := false;
                if not CheckRec and not CheckNextRec then begin
                    TempSamplePlanline2 := SamplePlanline;
                    CheckNextRec := true;
                end;
            until SamplePlanline.NEXT() = 0;

        if CheckPrevRec then
            if "Lot Size - Max" <= TempSamplePlanline1."Lot Size - Max" then
                ERROR(Text000Err);
        if CheckNextRec then
            if "Lot Size - Max" >= TempSamplePlanline2."Lot Size - Max" then
                ERROR(Text001Err)
            else begin
                SamplePlanline := TempSamplePlanline2;
                SamplePlanline."Lot Size - Min" := "Lot Size - Max" + 1;
                SamplePlanline.MODIFY();
            end;

        "Lot Size - Min" := TempSamplePlanline1."Lot Size - Max" + 1;
    end;

    trigger OnModify();
    begin
        TestStatus();
        CheckNextRec := false;
        CheckPrevRec := false;
        CheckRec := false;
        SamplePlanline.RESET();
        SamplePlanline.SETRANGE("Sampling Code", "Sampling Code");
        if SamplePlanline.FIND('-') then
            repeat
                if not CheckRec then
                    if SamplePlanline."Line No." = "Line No." then begin
                        CheckRec := true;
                        if SamplePlanline.NEXT(-1) <> 0 then begin
                            TempSamplePlanline1 := SamplePlanline;
                            SamplePlanline.NEXT(1);
                            CheckPrevRec := true;
                        end;
                        if SamplePlanline.NEXT(1) <> 0 then begin
                            TempSamplePlanline2 := SamplePlanline;
                            CheckNextRec := true;
                        end;
                    end;
            until SamplePlanline.NEXT() = 0;

        if CheckPrevRec then
            if "Lot Size - Max" <= TempSamplePlanline1."Lot Size - Max" then
                ERROR(Text000Err);
        if CheckNextRec then
            if "Lot Size - Max" >= TempSamplePlanline2."Lot Size - Max" then
                ERROR(Text001Err)
            else begin
                SamplePlanline := TempSamplePlanline2;
                SamplePlanline."Lot Size - Min" := "Lot Size - Max" + 1;
                SamplePlanline.MODIFY();
            end;
    end;

    var
        SamplePlanline: Record "Sampling Plan Line B2B";
        TempSamplePlanline1: Record "Sampling Plan Line B2B" temporary;
        TempSamplePlanline2: Record "Sampling Plan Line B2B" temporary;
        CheckPrevRec: Boolean;
        CheckNextRec: Boolean;
        CheckRec: Boolean;
        Text000Err: Label 'Lot Size - Max should not be less than previous line Lot Size - Max';
        Text001Err: Label 'Lot Size - Max should not be greater than next line Lot Size - Max';

    procedure check();
    begin
        CheckNextRec := false;
        CheckPrevRec := false;
        CheckRec := false;
        SamplePlanline.RESET();
        SamplePlanline.SETRANGE("Sampling Code", "Sampling Code");
        if SamplePlanline.FIND('-') then
            repeat
                if SamplePlanline."Line No." < "Line No." then begin
                    TempSamplePlanline1 := SamplePlanline;
                    CheckRec := true;
                    CheckPrevRec := true;
                end else
                    CheckRec := false;
                if not CheckRec and not CheckNextRec then begin
                    TempSamplePlanline2 := SamplePlanline;
                    CheckNextRec := true;
                end;
            until SamplePlanline.NEXT() = 0;

        if CheckPrevRec then
            if "Lot Size - Max" <= TempSamplePlanline1."Lot Size - Max" then
                ERROR(Text000Err);
        if CheckNextRec then
            if "Lot Size - Max" >= TempSamplePlanline2."Lot Size - Max" then
                ERROR(Text001Err)
            else begin
                SamplePlanline := TempSamplePlanline2;
                SamplePlanline."Lot Size - Min" := "Lot Size - Max" + 1;
                SamplePlanline.MODIFY();
            end;

        "Lot Size - Min" := TempSamplePlanline1."Lot Size - Max" + 1;
    end;

    procedure TestStatus();
    var
        SamplePlanHeader: Record "Sampling Plan Header B2B";
    begin
        SamplePlanHeader.GET("Sampling Code");
        SamplePlanHeader.TESTFIELD("Sampling Type", SamplePlanHeader."Sampling Type"::"Variable Quantity");
        if SamplePlanHeader.Status = SamplePlanHeader.Status::Certified then
            SamplePlanHeader.FIELDERROR(Status);
    end;
}


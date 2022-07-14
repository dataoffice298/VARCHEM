table 33000278 "Rework Routing Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Rework Routing Line';
    Permissions = TableData "Prod. Order Capacity Need" = rimd;

    fields
    {
        field(1; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
            DataClassification = CustomerContent;
        }
        field(3; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            NotBlank = true;
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                                                              "Routing Reference No." = FIELD("Routing Reference No."),
                                                                              "Routing No." = FIELD("Routing No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                GetLine();
                "Starting Time" := ProdOrderLine."Starting Time";
                "Ending Time" := ProdOrderLine."Ending Time";
                "Starting Date" := ProdOrderLine."Starting Date";
                "Ending Date" := ProdOrderLine."Ending Date";
            end;
        }
        field(5; "Next Operation No."; Code[30])
        {
            Caption = 'Next Operation No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                GetLine();
            end;
        }
        field(6; "Previous Operation No."; Code[30])
        {
            Caption = 'Previous Operation No.';
            DataClassification = CustomerContent;
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "No." := '';
                "Work Center No." := '';
                "Work Center Group Code" := '';
            end;
        }
        field(8; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Work Center")) "Work Center"
            ELSE
            IF (Type = CONST("Machine Center")) "Machine Center";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "No." = '' then
                    exit;

                case Type of
                    Type::"Work Center":
                        begin
                            WorkCenter.GET("No.");
                            WorkCenter.TESTFIELD(Blocked, false);
                            WorkCenterTransferfields();
                        end;
                    Type::"Machine Center":
                        begin
                            MachineCenter.GET("No.");
                            MachineCenter.TESTFIELD(Blocked, false);
                            MachineCtrTransferfields();
                        end;
                end;

                GetLine();
                if ProdOrderLine."Routing Type" = ProdOrderLine."Routing Type"::Serial then;
            end;
        }
        field(9; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            Editable = false;
            TableRelation = "Work Center";
            DataClassification = CustomerContent;
        }
        field(10; "Work Center Group Code"; Code[10])
        {
            Caption = 'Work Center Group Code';
            Editable = false;
            TableRelation = "Work Center Group";
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; "Setup Time"; Decimal)
        {
            Caption = 'Setup Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(13; "Run Time"; Decimal)
        {
            Caption = 'Run Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(14; "Wait Time"; Decimal)
        {
            Caption = 'Wait Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(15; "Move Time"; Decimal)
        {
            Caption = 'Move Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(16; "Fixed Scrap Quantity"; Decimal)
        {
            Caption = 'Fixed Scrap Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(17; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(18; "Scrap Factor %"; Decimal)
        {
            Caption = 'Scrap Factor %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(19; "Setup Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Setup Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(20; "Run Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Run Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(21; "Wait Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Wait Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(22; "Move Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Move Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(27; "Minimum Process Time"; Decimal)
        {
            Caption = 'Minimum Process Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(28; "Maximum Process Time"; Decimal)
        {
            Caption = 'Maximum Process Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(30; "Concurrent Capacities"; Decimal)
        {
            Caption = 'Concurrent Capacities';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(31; "Send-Ahead Quantity"; Decimal)
        {
            Caption = 'Send-Ahead Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(34; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";
            DataClassification = CustomerContent;
        }
        field(35; "Standard Task Code"; Code[10])
        {
            Caption = 'Standard Task Code';
            TableRelation = "Standard Task";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            begin
            end;
        }
        field(40; "Unit Cost per"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost per';
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                GLSetup.GET();
                "Direct Unit Cost" :=
                  ROUND(
                    ("Unit Cost per" - "Overhead Rate") /
                    (1 + "Indirect Cost %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(41; Recalculate; Boolean)
        {
            Caption = 'Recalculate';
            DataClassification = CustomerContent;
        }
        field(50; "Sequence No. (Forward)"; Integer)
        {
            Caption = 'Sequence No. (Forward)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(51; "Sequence No. (Backward)"; Integer)
        {
            Caption = 'Sequence No. (Backward)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52; "Fixed Scrap Qty. (Accum.)"; Decimal)
        {
            Caption = 'Fixed Scrap Qty. (Accum.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(53; "Scrap Factor % (Accumulated)"; Decimal)
        {
            Caption = 'Scrap Factor % (Accumulated)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(55; "Sequence No. (Actual)"; Integer)
        {
            Caption = 'Sequence No. (Actual)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(56; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Indirect Cost %");
            end;
        }
        field(57; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                GLSetup.GET();
                "Unit Cost per" :=
                  ROUND(
                    "Direct Unit Cost" * (1 + "Indirect Cost %" / 100) + "Overhead Rate",
                    GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(58; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Indirect Cost %");
            end;
        }
        field(70; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            DataClassification = CustomerContent;
        }
        field(71; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(72; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            DataClassification = CustomerContent;
        }
        field(73; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(74; Status; Option)
        {
            Caption = 'Status';
            InitValue = Released;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
            DataClassification = CustomerContent;
        }
        field(75; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Production Order"."No." WHERE(Status = FIELD(Status));
            DataClassification = CustomerContent;
        }
        field(76; "Unit Cost Calculation"; Option)
        {
            Caption = 'Unit Cost Calculation';
            OptionCaption = 'Time,Units';
            OptionMembers = Time,Units;
            DataClassification = CustomerContent;
        }
        field(77; "Input Quantity"; Decimal)
        {
            Caption = 'Input Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(78; "Critical Path"; Boolean)
        {
            Caption = 'Critical Path';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(79; "Routing Status"; Option)
        {
            Caption = 'Routing Status';
            InitValue = "In Progress";
            OptionCaption = '" ,Planned,In Progress,Finished"';
            OptionMembers = " ",Planned,"In Progress",Finished;
            DataClassification = CustomerContent;
        }
        field(81; "Flushing Method"; Option)
        {
            Caption = 'Flushing Method';
            InitValue = Manual;
            OptionCaption = 'Manual,Forward,Backward';
            OptionMembers = Manual,Forward,Backward;
            DataClassification = CustomerContent;
        }
        field(90; "Expected Operation Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(91; "Expected Capacity Need"; Decimal)
        {
            Caption = 'Expected Capacity Need';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(96; "Expected Capacity Ovhd. Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Capacity Ovhd. Cost';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(98; "Starting Date-Time"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Starting Date-Time';
            DecimalPlaces = 2 :;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Starting Date" := Datetime2Date("Starting Date-Time");
                "Starting Time" := Datetime2Time("Starting Date-Time");
            end;
        }
        field(99; "Ending Date-Time"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Ending Date-Time';
            DecimalPlaces = 2 :;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Ending Date" := Datetime2Date("Ending Date-Time");
                "Ending Time" := Datetime2Time("Ending Date-Time");
            end;
        }
        field(100; "Schedule Manually"; Boolean)
        {
            Caption = 'Schedule Manually';
            DataClassification = CustomerContent;
        }
        field(33000250; "Sub Assembly"; Code[20])
        {
            Caption = 'Sub Assembly';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Sub Assembly" = '' then begin
                    "Spec ID" := '';
                    "QC Enabled" := false;
                end else begin
                    SubAssembly.GET("Sub Assembly");
                    "Spec ID" := SubAssembly."Spec ID";
                    "QC Enabled" := SubAssembly."QC Enabled";
                    "Sub Assembly Description" := SubAssembly.Description;
                end;
            end;
        }
        field(33000251; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(33000252; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(33000253; "QC Enabled"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        field(33000254; "Sub Assembly UOM Code"; Code[20])
        {
            Caption = 'Sub Assembly UOM Code';
            TableRelation = "Sub Ass Unit of Measure B2B".Code;
            DataClassification = CustomerContent;
        }
        field(33000255; "Qty. to Produce"; Decimal)
        {
            Caption = 'Qty. to Produce';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Qty. to Produce" < 0 then
                    ERROR(Text007Err);
                if "Qty. to Produce" + "Quantity Produced" > Quantity then
                    MESSAGE(Text008Msg);
            end;
        }
        field(33000256; "Quantity Produced"; Decimal)
        {
            Caption = 'Quantity Produced';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Qty. to Produce" := Quantity - "Quantity Produced";
            end;
        }
        field(33000257; "Sub Assembly Description"; Text[30])
        {
            Caption = 'Sub Assembly Description';
            DataClassification = CustomerContent;
        }
        field(33000258; "Inspection Receipt No."; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Inspection Receipt No.")
        {
            SumIndexFields = "Expected Operation Cost Amt.", "Expected Capacity Need", "Expected Capacity Ovhd. Cost";
        }
        key(Key2; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Forward)")
        {
        }
        key(Key3; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Backward)")
        {
        }
        key(Key4; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Actual)")
        {
        }
        key(Key5; "Work Center No.")
        {
            SumIndexFields = "Expected Operation Cost Amt.";
        }
        key(Key6; Type, "No.", "Starting Date")
        {
            SumIndexFields = "Expected Operation Cost Amt.";
        }
        key(Key7; Status, "Work Center No.")
        {
        }
        key(Key8; "Prod. Order No.", Status, "Flushing Method")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        if Status = Status::Finished then
            ERROR(Text006Err, Status, TABLECAPTION())
        else
            if Status = Status::Released then begin
                CapLedgEntry.SETCURRENTKEY(
                  "Order No.", "Order Line No.",
                  "Routing No.", "Routing Reference No.", "Operation No.");
                CapLedgEntry.SETRANGE("Order No.", "Prod. Order No.");
                CapLedgEntry.SETRANGE("Routing Reference No.", "Routing Reference No.");
                CapLedgEntry.SETRANGE("Routing No.", "Routing No.");
                CapLedgEntry.SETRANGE("Operation No.", "Operation No.");
            end;
        CheckReworkStatus();
    end;

    trigger OnInsert();
    begin
        if Status = Status::Finished then
            ERROR(Text006Err, Status, TABLECAPTION());

        if "Next Operation No." = '' then
            SetNextOperations(Rec);
        CheckReworkStatus();

        "Starting Time" := TIME();
        "Starting Date" := WORKDATE();
        "Ending Date" := WORKDATE();
        "Ending Time" := TIME();
    end;

    trigger OnModify();
    begin
        if Status = Status::Finished then
            ERROR(Text006Err, Status, TABLECAPTION());
        CheckReworkStatus();
    end;

    trigger OnRename();
    begin
        ERROR(Text001Err, TABLECAPTION());
    end;

    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        ProdOrderLine: Record "Prod. Order Line";
        GLSetup: Record "General Ledger Setup";

        SubAssembly: Record "Sub Assembly B2B";
        Text001Err: Label 'You cannot rename a %1.', Comment = '%1 = Table Caption';
        Text006Err: Label 'A %1 %2 can not be inserted, modified, or deleted.', Comment = '%1 = Status; %2 = Table Caption';
        Text007Err: Label 'Qty.To be  Produced should not be negative.';
        Text008Msg: Label 'Quantity To Produce and Quantity Produced is more than Quantity.';


    procedure Caption(): Text[250];
    var
        ProdOrder: Record "Production Order";

    begin
        if GETFILTERS() = '' then
            exit('');

        if not ProdOrder.GET(Status, "Prod. Order No.") then
            exit('');

        EXIT(
           STRSUBSTNO('%1 %2 %3',
             "Prod. Order No.", ProdOrder.Description, "Routing No."));




    end;


    procedure GetLine();
    begin
        ProdOrderLine.SETRANGE(Status, Status);
        ProdOrderLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
        ProdOrderLine.SETRANGE("Routing No.", "Routing No.");
        ProdOrderLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
        ProdOrderLine.FIND('-');
    end;

    procedure WorkCenterTransferfields();
    begin
        "Work Center No." := WorkCenter."No.";
        "Work Center Group Code" := WorkCenter."Work Center Group Code";
        "Setup Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
        "Run Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
        "Wait Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
        "Move Time Unit of Meas. Code" := WorkCenter."Unit of Measure Code";
        Description := WorkCenter.Name;
        "Flushing Method" := WorkCenter."Flushing Method";
        "Unit Cost per" := WorkCenter."Unit Cost";
        "Direct Unit Cost" := WorkCenter."Direct Unit Cost";
        "Indirect Cost %" := WorkCenter."Indirect Cost %";
        "Overhead Rate" := WorkCenter."Overhead Rate";
        "Unit Cost Calculation" := WorkCenter."Unit Cost Calculation";
    end;

    procedure MachineCtrTransferfields();
    begin
        WorkCenter.GET(MachineCenter."Work Center No.");
        WorkCenterTransferfields();

        Description := MachineCenter.Name;
        "Setup Time" := MachineCenter."Setup Time";
        "Wait Time" := MachineCenter."Wait Time";
        "Move Time" := MachineCenter."Move Time";
        "Fixed Scrap Quantity" := MachineCenter."Fixed Scrap Quantity";
        "Scrap Factor %" := MachineCenter."Scrap %";
        "Minimum Process Time" := MachineCenter."Minimum Process Time";
        "Maximum Process Time" := MachineCenter."Maximum Process Time";
        "Concurrent Capacities" := MachineCenter."Concurrent Capacities";
        "Send-Ahead Quantity" := MachineCenter."Send-Ahead Quantity";
        "Setup Time Unit of Meas. Code" := MachineCenter."Setup Time Unit of Meas. Code";
        "Wait Time Unit of Meas. Code" := MachineCenter."Wait Time Unit of Meas. Code";
        "Move Time Unit of Meas. Code" := MachineCenter."Move Time Unit of Meas. Code";
        "Flushing Method" := MachineCenter."Flushing Method";
        "Unit Cost per" := MachineCenter."Unit Cost";
        "Direct Unit Cost" := MachineCenter."Direct Unit Cost";
        "Indirect Cost %" := MachineCenter."Indirect Cost %";
        "Overhead Rate" := MachineCenter."Overhead Rate";
    end;

    procedure SetNextOperations(var RtngLine: Record "Rework Routing Line B2B");
    var

    begin

        RtngLine2.reset();
        RtngLine2.SETRANGE(Status, RtngLine.Status);
        RtngLine2.SETRANGE("Prod. Order No.", RtngLine."Prod. Order No.");
        RtngLine2.SETRANGE("Routing Reference No.", RtngLine."Routing Reference No.");
        RtngLine2.SETRANGE("Routing No.", RtngLine."Routing No.");
        RtngLine2.SETFILTER("Operation No.", '>%1', RtngLine."Operation No.");

        if RtngLine2.FIND('-') then
            RtngLine."Next Operation No." := RtngLine2."Operation No."
        else begin
            RtngLine2.SETFILTER("Operation No.", '');
            RtngLine2.SETRANGE("Next Operation No.", '');
            if RtngLine2.FIND('-') then begin
                RtngLine2."Next Operation No." := RtngLine."Operation No.";
                RtngLine2.MODIFY();
            end;
        end;
    end;

    procedure CheckReworkStatus();
    var
        InspectReceipt: Record "Inspection Receipt Header B2B";
    begin
        if InspectReceipt.GET("Inspection Receipt No.") then
            InspectReceipt.TESTFIELD("Rework Completed", false);
    end;

    procedure Datetime2Date(Datetime: Decimal): Date;
    begin
        if Datetime = 0 then
            exit(0D);
        exit(00000101D + ROUND(Datetime / 86.4, 1, '<'));
    end;

    procedure Datetime2Time(Datetime: Decimal): Time;
    begin
        if Datetime = 0 then
            exit(000000T);
        exit(000000T + (Datetime mod 86.4) * 1000000);
    end;

    var
        RtngLine2: Record "Rework Routing Line B2B";
}


table 33000279 "Rework Component B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Rework Component';
    DataCaptionFields = Status, "Prod. Order No.";
    PasteIsValid = false;

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
            DataClassification = CustomerContent;
        }
        field(2; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." WHERE(Status = FIELD(Status));
            DataClassification = CustomerContent;
        }
        field(3; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = FIELD(Status),
                                                                 "Prod. Order No." = FIELD("Prod. Order No."));
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                Item.GET("Item No.");
                Description := Item.Description;
                Item.TESTFIELD("Base Unit of Measure");
                VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
            end;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                Item.GET("Item No.");
                GetGLSetup();

                "Unit Cost" := Item."Unit Cost";

                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                "Quantity (Base)" := CalcBaseQty(Quantity);

                "Unit Cost" :=
                  ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",
                    GLSetup."Unit-Amount Rounding Precision");

                "Indirect Cost %" := ROUND(Item."Indirect Cost %" * "Qty. per Unit of Measure", 0.00001);

                "Overhead Rate" :=
                  ROUND(Item."Overhead Rate" * "Qty. per Unit of Measure",
                   GLSetup."Unit-Amount Rounding Precision");

                "Direct Unit Cost" :=
                  ROUND(
                    ("Unit Cost" - "Overhead Rate") / (1 + "Indirect Cost %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(14; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; Position; Code[10])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
        }
        field(16; "Position 2"; Code[10])
        {
            Caption = 'Position 2';
            DataClassification = CustomerContent;
        }
        field(17; "Position 3"; Code[10])
        {
            Caption = 'Position 3';
            DataClassification = CustomerContent;
        }
        field(18; "Production Lead Time"; DateFormula)
        {
            Caption = 'Production Lead Time';
            DataClassification = CustomerContent;
        }
        field(19; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            begin
            end;
        }
        field(20; "Scrap %"; Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(25; "Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                if "Expected Quantity" <= "Remaining Quantity" + "Quantity Consumed" then
                    ERROR(Text002Err);
            end;
        }
        field(26; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(27; "Act. Consumption (Qty)"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Consumption),
                                                                   "Order No." = FIELD("Prod. Order No."),
                                                                   "Order Line No." = FIELD("Prod. Order Line No."),
                                                                   "Prod. Order Comp. Line No." = FIELD("Line No.")));
            Caption = 'Act. Consumption (Qty)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Flushing Method"; Option)
        {
            Caption = 'Flushing Method';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
            DataClassification = CustomerContent;
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            DataClassification = CustomerContent;
        }
        field(31; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(33; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
            begin
            end;

            trigger OnValidate();
            var
            begin
            end;
        }
        field(35; "Supplied-by Line No."; Integer)
        {
            Caption = 'Supplied-by Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = FIELD(Status),
                                                                 "Prod. Order No." = FIELD("Prod. Order No."),
                                                                 "Line No." = FIELD("Supplied-by Line No."));
            DataClassification = CustomerContent;
        }
        field(36; "Planning Level Code"; Integer)
        {
            Caption = 'Planning Level Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(37; "Item Low-Level Code"; Integer)
        {
            Caption = 'Item Low-Level Code';
            DataClassification = CustomerContent;
        }
        field(40; Length; Decimal)
        {
            Caption = 'Length';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(41; Width; Decimal)
        {
            Caption = 'Width';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(42; Weight; Decimal)
        {
            Caption = 'Weight';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(43; Depth; Decimal)
        {
            Caption = 'Depth';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Calculation Formula");
            end;
        }
        field(44; "Calculation Formula"; Option)
        {
            Caption = 'Calculation Formula';
            OptionCaption = '" ,Length,Length * Width,Length * Width * Depth,Weight"';
            OptionMembers = " ",Length,"Length * Width","Length * Width * Depth",Weight;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                case "Calculation Formula" of
                    "Calculation Formula"::" ":
                        Quantity := "Quantity per";
                    "Calculation Formula"::Length:
                        Quantity := ROUND(Length * "Quantity per", 0.00001);
                    "Calculation Formula"::"Length * Width":
                        Quantity := ROUND(Length * Width * "Quantity per", 0.00001);
                    "Calculation Formula"::"Length * Width * Depth":
                        Quantity := ROUND(Length * Width * Depth * "Quantity per", 0.00001);
                    "Calculation Formula"::Weight:
                        Quantity := ROUND(Weight * "Quantity per", 0.00001);
                end;
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(45; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("Item No.");
                VALIDATE("Calculation Formula");
            end;
        }
        field(50; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("Item No.");

                Item.GET("Item No.");
                GetGLSetup();
                if Item."Costing Method" = Item."Costing Method"::Standard then
                    if CurrFieldNo = FIELDNO("Unit Cost") then
                        ERROR(
                          Text99000003Err,
                          FIELDCAPTION("Unit Cost"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method")
                    else begin
                        "Unit Cost" :=
                          ROUND(
                            Item."Unit Cost" * "Qty. per Unit of Measure",
                            GLSetup."Unit-Amount Rounding Precision");

                        "Indirect Cost %" := ROUND(Item."Indirect Cost %" * "Qty. per Unit of Measure", 0.00001);

                        "Overhead Rate" :=
                          ROUND(
                            Item."Overhead Rate" * "Qty. per Unit of Measure",
                            GLSetup."Unit-Amount Rounding Precision");

                        "Direct Unit Cost" :=
                          ROUND(
                            "Unit Cost" / (1 + "Indirect Cost %" / 100) - "Overhead Rate",
                            GLSetup."Unit-Amount Rounding Precision");
                    end;
                VALIDATE("Calculation Formula");
            end;
        }
        field(51; "Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            begin
            end;
        }
        field(53; "Due Time"; Time)
        {
            Caption = 'Due Time';
            DataClassification = CustomerContent;
        }
        field(60; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(61; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(63; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)" WHERE("Reservation Status" = CONST(Reservation),
                                                                            "Source Type" = CONST(5407),
                                                                            "Source Subtype" = FIELD(Status),
                                                                            "Source ID" = FIELD("Prod. Order No."),
                                                                            "Source Batch Name" = CONST(''),
                                                                            "Source Prod. Order Line" = FIELD("Prod. Order Line No."),
                                                                            "Source Ref. No." = FIELD("Line No.")));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = true;
            FieldClass = FlowField;
        }
        field(71; "Reserved Quantity"; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry".Quantity WHERE("Reservation Status" = CONST(Reservation),
                                                                   "Source Type" = CONST(5407),
                                                                   "Source Subtype" = FIELD(Status),
                                                                   "Source ID" = FIELD("Prod. Order No."),
                                                                   "Source Batch Name" = CONST(''),
                                                                   "Source Prod. Order Line" = FIELD("Prod. Order Line No."),
                                                                   "Source Ref. No." = FIELD("Line No.")));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Expected Qty. (Base)"; Decimal)
        {
            Caption = 'Expected Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status <> Status::Simulated then begin
                    if Status in [Status::Released, Status::Finished] then
                        CALCFIELDS("Act. Consumption (Qty)");
                    "Remaining Quantity" := "Expected Quantity" - "Act. Consumption (Qty)";
                    "Remaining Qty. (Base)" := ROUND("Remaining Quantity" * "Qty. per Unit of Measure", 0.00001);
                end;
                "Cost Amount" := ROUND("Expected Quantity" * "Unit Cost");
                "Overhead Amount" :=
                  ROUND(
                    "Expected Quantity" *
                    (("Direct Unit Cost" * "Indirect Cost %" / 100) + "Overhead Rate"));
                "Direct Cost Amount" := ROUND("Expected Quantity" * "Direct Unit Cost");
            end;
        }
        field(76; "Due Date-Time"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Due Date-Time';
            DecimalPlaces = 2 :;
            DataClassification = CustomerContent;
        }
        field(5750; "Pick Qty."; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE("Activity Type" = FILTER(<> "Put-away"),
                                                                                  "Source Type" = CONST(5407),
                                                                                  "Source Subtype" = FIELD(Status),
                                                                                  "Source No." = FIELD("Prod. Order No."),
                                                                                  "Source Line No." = FIELD("Prod. Order Line No."),
                                                                                  "Source Subline No." = FIELD("Line No."),
                                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                                  "Action Type" = FILTER(" " | Place),
                                                                                  "Original Breakbulk" = CONST(false),
                                                                                  "Breakbulk No." = CONST(0)));
            Caption = 'Pick Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(7300; "Qty. Picked"; Decimal)
        {
            Caption = 'Qty. Picked';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7301; "Qty. Picked (Base)"; Decimal)
        {
            Caption = 'Qty. Picked (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7302; "Completely Picked"; Boolean)
        {
            Caption = 'Completely Picked';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7303; "Pick Qty. (Base)"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE("Activity Type" = FILTER(<> "Put-away"),
                                                                                         "Source Type" = CONST(5407),
                                                                                         "Source Subtype" = FIELD(Status),
                                                                                         "Source No." = FIELD("Prod. Order No."),
                                                                                         "Source Line No." = FIELD("Prod. Order Line No."),
                                                                                         "Source Subline No." = FIELD("Line No."),
                                                                                         "Action Type" = FILTER(" " | Place),
                                                                                         "Original Breakbulk" = CONST(false),
                                                                                         "Breakbulk No." = CONST(0)));
            Caption = 'Pick Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000250; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
            DataClassification = CustomerContent;
        }
        field(33000251; "Inspection Receipt No."; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(33000253; "Rework Completed"; Boolean)
        {
            Caption = 'Rework Completed';
            DataClassification = CustomerContent;
        }
        field(99000754; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(99000755; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Direct Unit Cost" :=
                  ROUND("Unit Cost" / (1 + "Indirect Cost %" / 100) - "Overhead Rate");

                VALIDATE("Unit Cost");
            end;
        }
        field(99000756; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Indirect Cost %");
            end;
        }
        field(99000757; "Direct Cost Amount"; Decimal)
        {
            Caption = 'Direct Cost Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(99000758; "Overhead Amount"; Decimal)
        {
            Caption = 'Overhead Amount';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Prod. Order Line No.", "Inspection Receipt No.", "Line No.")
        {
        }
        key(Key2; Status, "Prod. Order No.", "Prod. Order Line No.", "Due Date")
        {
            SumIndexFields = "Expected Quantity", "Cost Amount";
        }
        key(Key3; Status, "Prod. Order No.", "Prod. Order Line No.", "Item No.", "Line No.")
        {
        }
        key(Key4; Status, "Item No.", "Variant Code", "Location Code", "Due Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Expected Quantity", "Remaining Qty. (Base)", "Cost Amount", "Overhead Amount";
        }
        key(Key5; "Item No.", "Variant Code", "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Due Date")
        {
            Enabled = false;
            SumIndexFields = "Expected Quantity", "Remaining Qty. (Base)", "Cost Amount", "Overhead Amount";
        }
        key(Key6; Status, "Prod. Order No.", "Routing Link Code", "Flushing Method")
        {
        }
        key(Key7; Status, "Prod. Order No.", "Location Code")
        {
        }
        key(Key8; "Item No.", "Variant Code", "Location Code", Status, "Due Date")
        {
            SumIndexFields = "Expected Quantity", "Remaining Qty. (Base)", "Cost Amount", "Overhead Amount";
        }
        key(Key9; Status, "Prod. Order No.", "Prod. Order Line No.", "Item Low-Level Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
    begin
        if Status = Status::Finished then
            ERROR(Text000Err, Status, TABLECAPTION());
        CheckReworkStatus();
        if "Quantity Consumed" <> 0 then
            ERROR(Text001Err, TABLECAPTION());
    end;

    trigger OnInsert();
    begin
        if Status = Status::Finished then
            ERROR(Text000Err, Status, TABLECAPTION());
        CheckReworkStatus();
    end;

    trigger OnModify();
    begin
        if Status = Status::Finished then
            ERROR(Text000Err, Status, TABLECAPTION());
        CheckReworkStatus();
    end;

    trigger OnRename();
    begin
        ERROR(Text99000001Err, TABLECAPTION());
        //CheckReworkStatus();
    end;

    var
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        Location: Record Location;
        UOMMgt: Codeunit "Unit of Measure Management";
        Text000Err: Label 'A %1 %2 cannot be inserted, modified, or deleted.', Comment = '%1 = Status ; %2 = Table caption';
        Text001Err: Label '%1 cannot be deleted as consumption is posted.', Comment = '%1 = TableCaption';
        Text002Err: Label 'Expected Quantity should not be more than Remaining Quantity.';
        Text99000001Err: Label 'You cannot rename a %1.', Comment = '%1 = TableCaption';
        Text99000003Err: Label 'You cannot change %1 when %2 is %3.', Comment = '%1 = UnitCost; %2 = TableCaption; %3 = CostingMethod';
        GLSetupRead: Boolean;


    procedure Caption(): Text[250];
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        if not ProdOrder.GET(Status, "Prod. Order No.") then
            exit('');

        if not ProdOrderLine.GET(Status, "Prod. Order No.", "Prod. Order Line No.") then
            CLEAR(ProdOrderLine);

        exit(
        STRSUBSTNO('%1 %2 %3',
          "Prod. Order No.", ProdOrder.Description, ProdOrderLine."Item No."));
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure GetGLSetup();
    begin
        if not GLSetupRead then
            GLSetup.GET();
        GLSetupRead := true;
    end;

    local procedure GetLocation(LocationCode: Code[10]);
    begin
        if LocationCode = '' then
            CLEAR(Location)
        else
            if Location.Code <> LocationCode then
                Location.GET(LocationCode);
    end;

    procedure CheckReworkStatus();
    var
        InspectReceipt: Record "Inspection Receipt Header B2B";
    begin
        if InspectReceipt.GET("Inspection Receipt No.") then
            InspectReceipt.TESTFIELD("Rework Completed", false);
    end;
}


table 33000269 "Inspection Receipt Header B2B"
{
    // version B2BQC1.00.00
    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table
    Caption = 'Inspection Receipt Header';
    DrillDownPageID = "Posted Ins Receipt List B2B";
    LookupPageID = "Posted Ins Receipt List B2B";
    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header"."No.";
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(7; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(9; "Vendor Name 2"; Text[50])
        {
            Caption = 'Vendor Name 2';
            DataClassification = CustomerContent;
        }
        field(10; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(11; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(12; "Contact Person"; Text[50])
        {
            Caption = 'Contact Person';
            DataClassification = CustomerContent;
        }
        field(13; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(14; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(16; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            Editable = false;
            TableRelation = "Specification Header B2B"."Spec ID";
            DataClassification = CustomerContent;
        }
        field(20; "Purch Line No"; Integer)
        {
            Caption = 'Purch Line No';
            DataClassification = CustomerContent;
        }
        field(21; "Return Order Created"; Boolean)
        {
            Caption = 'Return Order Created';
            DataClassification = CustomerContent;
        }
        field(22; Status; Boolean)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(23; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(24; "Qty. Accepted"; Decimal)
        {
            Caption = 'Qty. Accepted';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                TESTFIELD(Status, false);
                if Quantity < "Qty. Accepted" + "Qty. Rejected" + "Qty. Rework" + "Qty. Accepted Under Deviation" then
                    ERROR(Text000Err);
                //if ("Item Tracking Exists") and ("Source Type" = "Source Type"::"In Bound") then
                //ERROR(Text001Err);
            end;
        }
        field(25; "Qty. Rejected"; Decimal)
        {
            Caption = 'Qty. Rejected';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                VALIDATE("Qty. Accepted");
            end;
        }
        field(26; "Data Entered By"; Code[50])
        {
            Caption = 'Data Entered By';
            DataClassification = CustomerContent;
        }
        field(27; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(28; "Posted Date"; Date)
        {
            Caption = 'Posted Date';
            DataClassification = CustomerContent;
        }
        field(29; "Posted Time"; Time)
        {
            Caption = 'Posted Time';
            DataClassification = CustomerContent;
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(31; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("Quality Before Receipt", false);
            end;
        }
        field(32; "Qty. Rework"; Decimal)
        {
            Caption = 'Qty. Rework';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                VALIDATE("Qty. Accepted");
            end;
        }
        field(33; "Qty. Accepted Under Deviation"; Decimal)
        {
            Caption = 'Qty. Accepted Under Deviation';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                VALIDATE("Qty. Accepted");
            end;
        }
        field(34; "Qty. Accepted UD Reason"; Code[20])
        {
            Caption = 'Qty. Accepted UD Reason';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ReasonCode.GET("Qty. Accepted UD Reason") then
                    "Reason Description" := ReasonCode.Description;
            end;
        }
        field(35; "Reason Description"; Text[250])
        {
            Caption = 'Reason Description';
            DataClassification = CustomerContent;
        }
        field(36; "Rework Level"; Integer)
        {
            Caption = 'Rework Level';
            DataClassification = CustomerContent;
        }
        field(37; "Rework Reference No."; Code[20])
        {
            Caption = 'Rework Reference No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(38; "Rework Inspect DS Created"; Boolean)
        {
            Caption = 'Rework Inspect DS Created';
            DataClassification = CustomerContent;
        }
        field(39; "Last Rework Level"; Integer)
        {
            Caption = 'Last Rework Level';
            DataClassification = CustomerContent;
        }
        field(40; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(41; "Item Tracking Exists"; Boolean)
        {
            Caption = 'Item Tracking Exists';
            DataClassification = CustomerContent;
        }
        field(42; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = "In Bound",WIP;
            DataClassification = CustomerContent;
        }
        field(43; "Quality Before Receipt"; Boolean)
        {
            Caption = 'Quality Before Receipt';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(44; "Purchase Consignment"; Code[20])
        {
            Caption = 'Purchase Consignment';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(45; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Quality Comment Line B2B" WHERE(Type = CONST("Inspection Receipt"),
                                                              "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(47; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(48; "Spec Version"; Code[20])
        {
            Caption = 'Spec Version';
            Editable = false;
            TableRelation = "Specification Version B2B"."Version Code" WHERE("Specification No." = FIELD("Spec ID"));
            DataClassification = CustomerContent;
        }
        field(49; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order"."No." WHERE(Status = FILTER(Released));
            DataClassification = CustomerContent;
        }
        field(51; "Prod. Order Line"; Integer)
        {
            Caption = 'Prod. Order Line';
            DataClassification = CustomerContent;
        }
        field(52; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            DataClassification = CustomerContent;
        }
        field(53; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            DataClassification = CustomerContent;
        }
        field(54; "Operation No."; Code[20])
        {
            Caption = 'Operation No.';
            DataClassification = CustomerContent;
        }
        field(55; "Prod. Description"; Text[30])
        {
            Caption = 'Prod. Description';
            DataClassification = CustomerContent;
        }
        field(56; "Operation Description"; Text[30])
        {
            Caption = 'Operation Description';
            DataClassification = CustomerContent;
        }
        field(57; "Production Batch No."; Code[20])
        {
            Caption = 'Production Batch No.';
            DataClassification = CustomerContent;
        }
        field(58; "Sub Assembly Code"; Code[20])
        {
            Caption = 'Sub Assembly Code';
            Editable = false;
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;
        }
        field(59; "Sub Assembly Description"; Text[30])
        {
            Caption = 'Sub Assembly Description';
            DataClassification = CustomerContent;
        }
        field(60; "In Process"; Boolean)
        {
            Caption = 'In Process';
            DataClassification = CustomerContent;
        }
        field(61; "Rework Completed"; Boolean)
        {
            Caption = 'Rework Completed';
            DataClassification = CustomerContent;
        }
        field(70; "Nature Of Rejection"; Text[30])
        {
            Caption = 'Nature Of Rejection';
            DataClassification = CustomerContent;
        }
        field(71; "Qty. to Vendor(Rejected)"; Decimal)
        {
            Caption = 'Qty. to Vendor(Rejected)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                if ("Source Type" = "Source Type"::"In Bound") and (not "Quality Before Receipt") then
                    TESTFIELD("Quality Before Receipt", true);

                if ("Qty. sent to Vendor(Rejected)" + "Qty. to Vendor(Rejected)") > "Qty. Rejected" then
                    ERROR(Text002Err);
            end;
        }
        field(72; "Qty. sent to Vendor(Rejected)"; Decimal)
        {
            Caption = 'Qty. sent to Vendor(Rejected)';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(73; "Qty. to Vendor(Rework)"; Decimal)
        {
            Caption = 'Qty. to Vendor(Rework)';
            Editable = true;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("Qty. sent to Vendor(Rework)" + "Qty. to Vendor(Rework)") > "Qty. Rework" then
                    ERROR(Text003Err);
            end;
        }
        field(74; "Qty. sent to Vendor(Rework)"; Decimal)
        {
            Caption = 'Qty. sent to Vendor(Rework)';
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(75; "Qty. to Receive(Rework)"; Decimal)
        {
            Caption = 'Qty. to Receive(Rework)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                if ("Qty. to Receive(Rework)" + "Qty. Received(Rework)") > "Qty. sent to Vendor(Rework)" then
                    ERROR(Text004Err);
            end;
        }
        field(76; "Qty. Received(Rework)"; Decimal)
        {
            Caption = 'Qty. Received(Rework)';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(77; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(78; "Quantity(Base)"; Decimal)
        {
            Caption = 'Quantity(Base)';
            DecimalPlaces = 0 : 9;
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 5;
        }
        field(90; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
        field(91; "Rework Reference Document No."; Integer)
        {
            Caption = 'Rework Reference Document No.';
            TableRelation = "Delivery/Receipt Entry B2B"."Entry No." WHERE("Document No." = FIELD("No."),
                                                                        Open = CONST(true));
            DataClassification = CustomerContent;
        }
        field(92; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(93; "DC Inbound Ledger Entry."; Integer)
        {
            Caption = 'DC Inbound Ledger Entry.';
            DataClassification = CustomerContent;
        }
        field(95; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                ShowDocDim();
            end;
        }
        field(97; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Receipt,Production,Transfer,"Item Inspection","Return Order",Rework,"Sample Lot";
            DataClassification = CustomerContent;
        }
        field(98; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(99; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        //4.14 >>
        field(50018; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
        field(50001; "QC Certificate(s) Status"; Enum "QC Certificate Status")
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Certificate Remarks"; Text[1024])
        {
            DataClassification = CustomerContent;
        }
        //4.14 <<
        //CHB2B27SEP2022>>
        field(50015; "Quality Remarks"; Text[500])
        {
            DataClassification = CustomerContent;
        }
        //CHB2B27SEP2022<<
        field(50003; "Qty. Hold"; Decimal)
        {
            Caption = 'Qty. Hold';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                VALIDATE("Qty. Accepted");
            end;
        }

        field(50012; "Qty. sent to Hold"; Decimal)
        {
            Caption = 'Qty. sent to Hold';
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50013; "Qty. to Receive(Hold)"; Decimal)
        {
            Caption = 'Qty. to Receive(Hold)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                if ("Qty. to Receive(Hold)" + "Qty. Received(Hold)") > "Qty. sent to Hold" then
                    ERROR(Text004Err);
            end;
        }
        field(50014; "Qty. Received(Hold)"; Decimal)
        {
            Caption = 'Qty. Received(Rework)';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(60001; "From Hold"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60002; "Quality Status"; Option)
        {
            Caption = 'Quality Status';
            OptionMembers = Open,Cancel;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Item No.")
        {
        }
        key(Key3; "Vendor No.")
        {
        }
        key(Key4; "Receipt No.", "Item No.")
        {
        }
        key(Key5; "Vendor No.", "Item No.")
        {
        }
        key(Key6; "Item No.", "Vendor No.")
        {
        }
        key(Key7; "Order No.", "Purch Line No", "Qty. Accepted", "Qty. Rejected")
        {
            SumIndexFields = "Qty. Accepted", "Qty. Rejected", "Qty. Accepted Under Deviation", "Qty. Rework";
        }
        key(Key8; "Rework Level")
        {
        }
        key(Key9; "Vendor No.", "Item No.", "Rework Level", Status, "Posting Date")
        {
            SumIndexFields = Quantity, "Qty. Accepted", "Qty. Rejected", "Qty. Accepted Under Deviation", "Qty. Rework";
        }
        key(Key10; "Document Date", "Source Type", "Vendor No.", "Prod. Order No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ReasonCode: Record "Reason Code";
        DimMgt: Codeunit DimensionManagement;
        IRAcceptanceLevels: Page "Inspect.Rcpt.Accept Levels B2B";
        Text000Err: Label 'Total Quantity should not be more than Quantity Received.';
        Text001Err: Label 'Item Tracking lines exists.';
        Text002Err: Label 'Rejected Quantity returns should not be more than Quantity Rejected.';
        Text003Err: Label 'Quantity sending to rework should not be more than Quantity Rework.';
        Text004Err: Label 'Quantity To receive should not be more than Quantity Sent To Rework.';



    procedure ShowItemTrackingLines();
    var
        PurchLine: Record "Purchase Line";

        InspectJnlLine: Codeunit "Inspection Jnl. Post Line B2B";
    begin
        if "Source Type" = "Source Type"::"In Bound" then begin
            if not "Quality Before Receipt" then
                InspectJnlLine.CallPostedItemTrackingForm(DATABASE::"Purch. Rcpt. Line", 0, "Receipt No.", '', 0, "Purch Line No", Rec)
            else begin
                PurchLine.GET(PurchLine."Document Type"::Order, "Order No.", "Purch Line No");
                PurchLine.OpenItemTrackingLines();
            end;
        end else begin
            TESTFIELD("In Process", false);
            ProdOrderLine.reset();
            ProdOrderLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderLine.SETRANGE("Line No.", "Prod. Order Line");
            ProdOrderLine.SETRANGE("Item No.", "Item No.");
            if ProdOrderLine.FIND('-') then
                ProdOrderLine.OpenItemTrackingLines();
        end;
    end;

    procedure QualityAcceptanceLevels(QualityType: Option Accepted,"Accepted Under Deviation",Rework,Rejected,Hold);
    var

    begin
        CLEAR(IRAcceptanceLevels);
        IRAcceptanceLevels.GetIRNumber("No.", Quantity, QualityType);
        IRAcceptanceLevels.RUNMODAL();
        InspectRcptAcptLevels.reset();
        InspectRcptAcptLevels.SETRANGE("Inspection Receipt No.", "No.");
        InspectRcptAcptLevels.SETRANGE("Quality Type", QualityType);
        //if not "Item Tracking Exists" then
        case QualityType of
            QualityType::Accepted:
                begin
                    "Qty. Accepted" := 0;
                    if InspectRcptAcptLevels.FIND('-') then
                        repeat
                            "Qty. Accepted" := "Qty. Accepted" + InspectRcptAcptLevels.Quantity;
                        until InspectRcptAcptLevels.NEXT() = 0;
                end;
            QualityType::"Accepted Under Deviation":
                begin
                    "Qty. Accepted Under Deviation" := 0;
                    if InspectRcptAcptLevels.FIND('-') then
                        repeat
                            "Qty. Accepted Under Deviation" := "Qty. Accepted Under Deviation" + InspectRcptAcptLevels.Quantity;
                        until InspectRcptAcptLevels.NEXT() = 0;
                end;
            QualityType::Rework:
                begin
                    "Qty. Rework" := 0;
                    if InspectRcptAcptLevels.FIND('-') then
                        repeat
                            "Qty. Rework" := "Qty. Rework" + InspectRcptAcptLevels.Quantity;
                        until InspectRcptAcptLevels.NEXT() = 0;
                end;
            QualityType::Rejected:
                begin
                    "Qty. Rejected" := 0;
                    if InspectRcptAcptLevels.FIND('-') then
                        repeat
                            "Qty. Rejected" := "Qty. Rejected" + InspectRcptAcptLevels.Quantity;
                        until InspectRcptAcptLevels.NEXT() = 0;
                end;
            QualityType::Hold:
                begin
                    "Qty. Hold" := 0;
                    if InspectRcptAcptLevels.FIND('-') then
                        repeat
                            "Qty. Hold" := "Qty. Hold" + InspectRcptAcptLevels.Quantity;
                        until InspectRcptAcptLevels.NEXT() = 0;
                end;
        end;
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then
            MODIFY();
    end;

    var
        InspectRcptAcptLevels: Record "IR Acceptance Levels B2B";
        ProdOrderLine: Record "Prod. Order Line";
}


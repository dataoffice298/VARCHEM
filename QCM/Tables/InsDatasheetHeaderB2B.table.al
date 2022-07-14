table 33000255 "Ins Datasheet Header B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Inspection Datasheet Header';
    LookupPageID = "Inspection Data Sheet List B2B";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            TableRelation = "Purch. Rcpt. Header"."No.";
            DataClassification = CustomerContent;
        }
        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(7; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(8; "Vendor Name"; Text[100])
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
        field(12; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
            DataClassification = CustomerContent;
        }
        field(13; "Item No."; Code[20])
        {
            Caption = 'Item No.';
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
        }
        field(16; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B"."Spec ID";
            DataClassification = CustomerContent;
        }
        field(17; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(18; "Inspection Group Code"; Code[20])
        {
            Caption = 'Inspection Group Code';
            TableRelation = "Inspection Group B2B";
            DataClassification = CustomerContent;
        }
        field(19; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
            DataClassification = CustomerContent;
        }
        field(20; "Purch. Line No"; Integer)
        {
            Caption = 'Purch. Line No';
            DataClassification = CustomerContent;
        }
        field(21; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
            trigger OnValidate();


            begin

                InspectionLot.reset();
                Inspectionlot.setrange("Document No.", "Receipt No.");
                InspectionLot.SETRANGE("Purch. Line No.", "Purch. Line No");
                InspectionLot.SETRANGE("Item No.", "Item No.");
                InspectionLot.SETRANGE("Lot No.", "Lot No.");
                IF InspectionLot.FIND('-') THEN BEGIN
                    VALIDATE("Spec ID", InspectionLot."Spec ID");
                    VALIDATE("Item Ledger Entry No.", InspectionLot."Item Ledger Entry No.");
                END;
            end;
        }
        field(22; "Created By"; Code[50])
        {
            Caption = 'Created By';
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(23; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
        field(24; "Created Time"; Time)
        {
            Caption = 'Created Time';
            DataClassification = CustomerContent;
        }
        field(25; "Posted Date"; Date)
        {
            Caption = 'Posted Date';
            DataClassification = CustomerContent;
        }
        field(26; "Posted Time"; Time)
        {
            Caption = 'Posted Time';
            DataClassification = CustomerContent;
        }
        field(27; "Posted By"; Code[20])
        {
            Caption = 'Posted By';
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(28; "Data Entered By"; Code[50])
        {
            Caption = 'Data Entered By';
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(29; "Inspection Receipt No."; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(30; Location; Code[20])
        {
            Caption = 'Location';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(31; "New Location"; Code[20])
        {
            Caption = 'New Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(32; "Rework Level"; Integer)
        {
            Caption = 'Rework Level';
            DataClassification = CustomerContent;
        }
        field(33; "Rework Reference No."; Code[20])
        {
            Caption = 'Rework Reference No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(34; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(35; "Item Tracking Exists"; Boolean)
        {
            Caption = 'Item Tracking Exists';
            DataClassification = CustomerContent;
        }
        field(36; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = "In Bound",WIP;
            DataClassification = CustomerContent;
        }
        field(37; "Quality Before Receipt"; Boolean)
        {
            Caption = 'Quality Before Receipt';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(38; "Purchase Consignment No."; Code[20])
        {
            Caption = 'Purchase Consignment No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(39; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(40; Comment; Boolean)
        {
            CalcFormula = Exist("Quality Comment Line B2B" WHERE(Type = CONST("Inspection Data Sheets"),
                                                              "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(41; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(42; "Spec Version"; Code[20])
        {
            Caption = 'Spec Version';
            TableRelation = "Specification Version B2B"."Version Code" WHERE("Specification No." = FIELD("Spec ID"));
            DataClassification = CustomerContent;
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(50; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
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
        field(56; "Operation Description"; Text[100])
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
        field(61; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(63; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(64; "DC Inbound Ledger Entry"; Integer)
        {
            Caption = 'DC Inbound Ledger Entry';
            DataClassification = CustomerContent;
        }
        field(100; "Quality Status"; Option)
        {
            Caption = 'Quality Status';
            OptionMembers = Open,Cancel;
            DataClassification = CustomerContent;
        }
        field(101; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Receipt,Production,Transfer,"Item Inspection","Return Order",Rework,"Sample Lot";
            DataClassification = CustomerContent;
        }
        field(102; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                ShowDocDim();
            end;
        }
        field(103; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(105; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Rework Level")
        {
        }
        key(Key3; "Purchase Consignment No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        InspectDataLine.LOCKTABLE();
        InspectDataLine.SETRANGE("Document No.", "No.");
        if InspectDataLine.FIND('-') then
            repeat
                InspectDataLine.DELETE();
            until InspectDataLine.NEXT() = 0;
    end;

    trigger OnModify();
    begin
        Evaluate("Data Entered By", UserId());
    end;

    var
        InspectDataLine: Record "Inspection Datasheet Line B2B";
        DimMgt: Codeunit DimensionManagement;

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
        InspectionLot: Record "Inspection Lot B2B";
}


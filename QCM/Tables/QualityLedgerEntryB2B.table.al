table 33000261 "Quality Ledger Entry B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Ledger Entry';
    DataCaptionFields = "Item No.", Description;
    DrillDownPageID = "Quality Ledger Entries B2B";
    LookupPageID = "Quality Ledger Entries B2B";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Accepted,Rework,Reject,Hold';
            OptionMembers = Accepted,Rework,Reject,Reworked,Hold;
            DataClassification = CustomerContent;
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
        }
        field(6; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            DataClassification = CustomerContent;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(11; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(12; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            DataClassification = CustomerContent;
        }
        field(13; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(14; Positive; Boolean)
        {
            Caption = 'Positive';
            DataClassification = CustomerContent;
        }
        field(15; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'In bound,WIP';
            OptionMembers = "In bound",WIP;
            DataClassification = CustomerContent;
        }
        field(16; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(17; "Applies-to QLE Entry"; Integer)
        {
            Caption = 'Applies-to QLE Entry';
            TableRelation = "Quality Ledger Entry B2B";
            DataClassification = CustomerContent;
        }
        field(18; "Accepted Under Dev. Reason"; Code[20])
        {
            Caption = 'Accepted Under Dev. Reason';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(19; "Reason Description"; Text[250])
        {
            Caption = 'Reason Description';
            DataClassification = CustomerContent;
        }
        field(20; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(21; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(22; "Item ledger Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(23; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
            DataClassification = CustomerContent;
        }
        field(24; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(25; "Rework Level"; Integer)
        {
            Caption = 'Rework Level';
            DataClassification = CustomerContent;
        }
        field(26; "New Location Code"; Code[20])
        {
            Caption = 'New Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(27; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(28; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
        }
        field(29; "In bound Item Ledger Entry No."; Integer)
        {
            Caption = 'In bound Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(30; "Sub Assembly Code"; Code[20])
        {
            Caption = 'Sub Assembly Code';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;
        }
        field(37; "Rework Reference No."; Code[20])
        {
            Caption = 'Rework Reference No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
        field(38; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(39; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; "Operation No."; Code[20])
        {
            Caption = 'Operation No.';
            DataClassification = CustomerContent;
        }
        field(42; "DC Inbound Ledger Entry No."; Integer)
        {
            Caption = 'DC Inbound Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(33000250; "Sub Assembly"; Code[20])
        {
            Caption = 'Sub Assembly';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;
        }
        field(50000; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Order No.", "Order Line No.", "Entry Type")
        {
            SumIndexFields = Quantity, "Remaining Quantity";
        }
        key(Key3; "Order No.", "Order Line No.", "Source Type", "Entry Type", Open)
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key4; "Item No.", "Source Type", "Order No.", "Order Line No.", "Entry Type")
        {
            SumIndexFields = Quantity, "Remaining Quantity";
        }
        key(Key5; "Operation No.", "Order No.", "Order Line No.", "Source Type", "Entry Type")
        {
            SumIndexFields = Quantity, "Remaining Quantity";
        }
        key(Key6; "Item No.", "Source No.", "Document No.", "Item Ledger Entry No.")
        {
            SumIndexFields = Quantity, "Remaining Quantity";
        }
    }

    fieldgroups
    {
    }
}


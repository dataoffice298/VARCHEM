table 33000262 "Quality Item Ledger Entry B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'Quality Item Ledger Entry';
    DataCaptionFields = "Item No.", Description;
    DrillDownPageID = "Qty Item Ledger Entries B2B";
    LookupPageID = "Qty Item Ledger Entries B2B";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            TableRelation = "Item Ledger Entry";
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
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
            DataClassification = CustomerContent;
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST(Item)) Item;
            DataClassification = CustomerContent;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(13; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(14; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(28; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            DataClassification = CustomerContent;
        }
        field(29; Open; Boolean)
        {
            Caption = 'Open';
            DataClassification = CustomerContent;
        }
        field(33; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(34; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(36; Positive; Boolean)
        {
            Caption = 'Positive';
            DataClassification = CustomerContent;
        }
        field(41; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = '" ,Customer,Vendor,Item"';
            OptionMembers = " ",Customer,Vendor,Item;
            DataClassification = CustomerContent;
        }
        field(47; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            DataClassification = CustomerContent;
        }
        field(50; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
            DataClassification = CustomerContent;
        }
        field(51; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
            DataClassification = CustomerContent;
        }
        field(52; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(59; "Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            TableRelation = "Entry/Exit Point";
            DataClassification = CustomerContent;
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(61; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(62; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
            DataClassification = CustomerContent;
        }
        field(63; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
            DataClassification = CustomerContent;
        }
        field(64; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(5401; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            DataClassification = CustomerContent;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(5408; "Derived from Blanket Order"; Boolean)
        {
            Caption = 'Derived from Blanket Order';
            DataClassification = CustomerContent;
        }
        field(5700; "Cross-Reference No."; Code[20])
        {
            Caption = 'Cross-Reference No.';
            DataClassification = CustomerContent;
        }
        field(5701; "Originally Ordered No."; Code[20])
        {
            Caption = 'Originally Ordered No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(5702; "Originally Ordered Var. Code"; Code[10])
        {
            Caption = 'Originally Ordered Var. Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Originally Ordered No."));
            DataClassification = CustomerContent;
        }
        field(5703; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            DataClassification = CustomerContent;
        }
        field(5704; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(5705; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            DataClassification = CustomerContent;
        }
        field(5706; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
            DataClassification = CustomerContent;
        }
        field(5707; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = CustomerContent;
        }
        field(5708; "Temp Accept"; Boolean)
        {
            Caption = 'Temp Accept';
            DataClassification = CustomerContent;

        }
        field(5740; "Transfer Order No."; Code[20])
        {
            Caption = 'Transfer Order No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5800; "Completely Invoiced"; Boolean)
        {
            Caption = 'Completely Invoiced';
            DataClassification = CustomerContent;
        }
        field(5801; "Last Invoice Date"; Date)
        {
            Caption = 'Last Invoice Date';
            DataClassification = CustomerContent;
        }
        field(5802; "Applied Entry to Adjust"; Boolean)
        {
            Caption = 'Applied Entry to Adjust';
            DataClassification = CustomerContent;
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
            DataClassification = CustomerContent;
        }
        field(5832; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            DataClassification = CustomerContent;
        }
        field(5833; "Prod. Order Comp. Line No."; Integer)
        {
            Caption = 'Prod. Order Comp. Line No.';
            DataClassification = CustomerContent;
        }
        field(5900; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = CustomerContent;
        }
        field(6500; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                //ItemTrackingMgt.LookupLotSerialNoInfo("Item No.", "Variant Code", ItemTrackEnum::"Serial No.", "Serial No.");//B2BJK
            end;
        }
        field(6501; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                //ItemTrackingMgt.LookupLotSerialNoInfo("Item No.", "Variant Code", ItemTrackEnum::"Lot No.", "Lot No.");//B2BJK
            end;
        }
        field(6502; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
            DataClassification = CustomerContent;
        }
        field(6503; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(6602; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
            DataClassification = CustomerContent;
        }
        field(13700; "Export Document"; Boolean)
        {
            Caption = 'Export Document';
            DataClassification = CustomerContent;
        }
        field(13701; "Import Document"; Boolean)
        {
            Caption = 'Import Document';
            DataClassification = CustomerContent;
        }
        field(13702; "Excise %"; Decimal)
        {
            Caption = 'Excise %';
            DataClassification = CustomerContent;
        }
        field(13703; "Excise Amount"; Decimal)
        {
            Caption = 'Excise Amount';
            DataClassification = CustomerContent;
        }
        field(13745; "Declared Goods"; Boolean)
        {
            Caption = 'Declared Goods';
            DataClassification = CustomerContent;
        }
        field(33000250; "Inspection Status"; Option)
        {
            Caption = 'Inspection Status';
            OptionCaption = 'Under Inspection,Rejected';
            OptionMembers = "Under Inspection",Rejected;
            DataClassification = CustomerContent;
        }
        field(33000251; "Quality Ledger Entry No."; Integer)
        {
            Caption = 'Quality Ledger Entry No.';
            TableRelation = "Quality Ledger Entry B2B";
            DataClassification = CustomerContent;
        }
        field(33000252; Accept; Boolean)
        {
            Caption = 'Accept';
            InitValue = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Accept then begin
                    Rework := false;
                    Reject := false;
                    "Accept Under Deviation" := false;
                end;
            end;
        }
        field(33000253; Rework; Boolean)
        {
            Caption = 'Rework';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Rework then begin
                    Accept := false;
                    Reject := false;
                    "Accept Under Deviation" := false;
                end;
            end;
        }
        field(33000254; Reject; Boolean)
        {
            Caption = 'Reject';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Reject then begin
                    Accept := false;
                    Rework := false;
                    "Accept Under Deviation" := false;
                end;
            end;
        }
        field(33000255; "Accept Under Deviation"; Boolean)
        {
            Caption = 'Accept Under Deviation';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Accept Under Deviation" then begin
                    Accept := false;
                    Rework := false;
                    Reject := false;
                end;
            end;
        }
        field(33000256; "Sent for Rework"; Boolean)
        {
            Caption = 'Sent for Rework';
            DataClassification = CustomerContent;
        }
        field(33000257; "Sending to Rework"; Boolean)
        {
            Caption = 'Sending to Rework';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Drop Shipment", "Location Code", "Posting Date", "Inspection Status")
        {
            SumIndexFields = "Remaining Quantity", "Invoiced Quantity";
        }
        key(Key3; "Entry Type", "Item No.", "Variant Code", "Drop Shipment", "Location Code", "Posting Date")
        {
        }
        key(Key4; "Entry Type", "Item No.", "Variant Code", "Source Type", "Source No.", "Posting Date")
        {
        }
        key(Key5; "Source Type", "Source No.", "Entry Type", "Item No.", "Variant Code", "Posting Date")
        {
            Enabled = false;
        }
        key(Key6; "Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.", "Inspection Status")
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key7; "Country Code", "Entry Type", "Posting Date")
        {
        }
        key(Key8; "Item No.", "Variant Code", "Drop Shipment", "Global Dimension 1 Code", "Global Dimension 2 Code", "Location Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Quantity, "Invoiced Quantity";
        }
        key(Key9; "Entry Type", "Item No.", "Variant Code", "Drop Shipment", "Global Dimension 1 Code", "Global Dimension 2 Code", "Location Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = "Invoiced Quantity";
        }
        key(Key10; "Prod. Order No.", "Prod. Order Line No.", "Prod. Order Comp. Line No.", "Entry Type")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity;
        }
        key(Key11; "Item No.", Positive, "Completely Invoiced", "Last Invoice Date", "Location Code", "Variant Code")
        {
        }
        key(Key12; "Applied Entry to Adjust", "Item No.", "Location Code", "Variant Code", "Posting Date")
        {
        }
        key(Key13; "Entry Type", Nonstock, "Item No.", "Posting Date")
        {
        }
        key(Key14; "Item No.", "Completely Invoiced", "Location Code", "Variant Code")
        {
        }
        key(Key15; "Item No.", "Location Code", Open, "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.")
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key16; "Document No.", "Posting Date", "Item No.")
        {
        }
        key(Key17; "Posting Date", "Item No.")
        {
        }
        key(Key18; "Sent for Rework", "Inspection Status", "Item No.", "Location Code", Accept, Rework)
        {
            SumIndexFields = "Remaining Quantity";
        }
    }

    fieldgroups
    {
    }

    var
        GLSetup: Record "General Ledger Setup";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        GLSetupRead: Boolean;
        ItemTrackEnum: Enum "Item Tracking Type";

    procedure GetCurrencyCode(): Code[10];
    begin
        if not GLSetupRead then begin
            GLSetup.GET();
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;
}


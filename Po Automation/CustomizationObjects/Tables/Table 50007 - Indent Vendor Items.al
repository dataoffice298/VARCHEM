table 50007 "Indent Vendor Items"
{
    // version PH1.0,PO1.0

    // Resource : SM-SivaMohan
    // 
    // SM  1.0  04/06/08   "Indent Req No","Indent Req Line No" Fields Added


    fields
    {
        field(1; "Item No."; Code[20])
        {
        }
        field(2; Quantity; Decimal)
        {
        }
        field(3; "Vendor No."; Code[20])
        {
        }
        field(4; "Indent No."; Code[20])
        {
        }
        field(5; "Indent Line No."; Integer)
        {
        }
        field(6; "Due Date"; Date)
        {
        }
        field(7; Check; Boolean)
        {
        }
        field(8; "Location Code"; Code[10])
        {
        }
        field(11; "Variant Code"; Code[20])
        {
        }
        field(13; "Unit Of Measure"; Code[20])
        {
        }
        field(14; "Project No."; Code[20])
        {
            TableRelation = Job;
        }
        field(15; Department; Code[20])
        {
        }
        field(16; "Material Requisition No."; Code[20])
        {
            Editable = false;
            TableRelation = Job;
        }
        field(17; Brand; Text[50])
        {
            TableRelation = Manufacturer.Code;
        }
        field(19; "No.Series"; Code[20])
        {
        }
        field(22; "Indent Req No"; Code[20])
        {
            //TableRelation = Table50067;//balu
        }
        field(23; "Indent Req Line No"; Integer)
        {
        }
        //B2BJk >>
        field(50020; "Available Inventory"; Decimal)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No.")));
            Editable = false;
        }
        field(50021; "PO Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("Item No."),Type=const(Item),"Document Type"=const(Order)));
            Editable = false;
        }
        field(50022; Make; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Make';
        }
        field(50023; Model; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Model';
        }
        field(50024; "Shortage Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortage Qty';
            Editable = false;
        }
        field(50025; "Open Quote Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("Item No."),Type=const(Item),"Document Type"=const(Quote)));
            Editable = false;
        }
        field(50026; "Shortcut Dimension 1 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(50027; "Shortcut Dimension 2 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false), "Division Code" = field("Shortcut Dimension 1 Code_B2B"));
        }
        //B2BJk <<
    }

    keys
    {
        key(Key1; "Vendor No.", "Item No.", "Indent No.", "Indent Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


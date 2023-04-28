tableextension 50005 tableextension70000007 extends "Purch. Inv. Line"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {

        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.

        field(50001; "Free Item Type"; Option)
        {
            Description = 'B2B1.0 13Dec2016';
            OptionCaption = '" ,Same Item,Different Item"';
            OptionMembers = " ","Same Item","Different Item";
        }
        field(50002; "Free Item No."; Code[20])
        {
            Description = 'B2B1.0 13Dec2016';
            TableRelation = Item;
        }
        field(50003; "Free Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Free Unit of Measure Code',
                        ENN = 'Unit of Measure Code';
            Description = 'B2B1.0 13Dec2016';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Free Item No."));
        }
        field(50004; "Free Quantity"; Decimal)
        {
            CaptionML = ENU = 'Free Quantity',
                        ENN = 'Minimum Quantity';
            Description = 'B2B1.0 13Dec2016';
            MinValue = 0;
        }
        field(50005; "Parent Line No."; Integer)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50052; Free; Boolean)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50053; "Approved Vendor"; Boolean)
        {
            Description = 'B2B1.0 05 Dec2016';
        }
        field(50054; "Agreement No."; Code[20])
        {
            Description = 'B2B1.0 06 Dec2016';
        }
        field(33002900; "Indent No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "Indent Header" WHERE("Released Status" = FILTER(Released));
        }
        field(33002901; "Indent Line No."; Integer)
        {
            Description = 'PO1.0';
        }
        field(33002902; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002904; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(33002905; "Indent Req Line No"; Integer)
        {
            Description = 'PO1.0';
            Editable = false;
        }
        
        field(50020; "Available Inventory"; Decimal)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),"Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"),"Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
            Editable = false;
        }
        field(50021; "PO Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("No."),"Shortcut Dimension 2 Code"=field("Shortcut Dimension 2 Code"),"Shortcut Dimension 1 Code"=field("Shortcut Dimension 1 Code")));
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
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("No."),Type=const(Item),"Document Type"=const(Quote),"Shortcut Dimension 2 Code"=field("Shortcut Dimension 2 Code"),"Shortcut Dimension 1 Code"=field("Shortcut Dimension 1 Code")));
            Editable = false;
        }
        
        //B2BJk <<
    }
    keys
    {
        /*//Balu
        key(Key1;"Buy-from Vendor No.","No.",Type)
        {
            SumIndexFields = Quantity;
        }*/
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}


tableextension 50010 tableextension70000016 extends "Purchase Line Archive"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {


        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.

        field(50200; "Indent No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "Indent Header" WHERE("Released Status" = FILTER(Released));
        }
        field(50201; "Indent Line No."; Integer)
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
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"), "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
            Editable = false;
        }
        field(50021; "PO Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("No."), Type = const(Item), "Document Type" = const(Order), "Shortcut Dimension 2 Code" = field("Shortcut Dimension 2 Code"), "Shortcut Dimension 1 Code" = field("Shortcut Dimension 1 Code")));
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
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("No." = field("No."), Type = const(Item), "Document Type" = const(Quote), "Shortcut Dimension 2 Code" = field("Shortcut Dimension 2 Code"), "Shortcut Dimension 1 Code" = field("Shortcut Dimension 1 Code")));
            Editable = false;
        }
        //B2BJk <<
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}


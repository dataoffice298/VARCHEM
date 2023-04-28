table 33000272 "IR Acceptance Levels B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Table

    Caption = 'IR Acceptance Levels';

    fields
    {
        field(1; "Inspection Receipt No."; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Quality Type"; Option)
        {
            Caption = 'Quality Type';
            OptionMembers = Accepted,"Accepted Under Deviation",Rework,Rejected,Hold;
            DataClassification = CustomerContent;
        }
        field(4; "Acceptance Code"; Code[20])
        {
            Caption = 'Acceptance Code';
            TableRelation = "Acceptance Level B2B".Code WHERE(Type = FIELD("Quality Type"));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                AcptLevel.GET("Acceptance Code");
                "Reason Code" := AcptLevel."Reason Code";
            end;
        }
        field(5; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Quality Reason Code B2B";
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Accepted,Accepted Under Deviation,Rework,Rejected';
            OptionMembers = Accepted,"Accepted Under Deviation",Rework,Rejected;
            DataClassification = CustomerContent;
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(9; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = "In Bound",WIP;
            DataClassification = CustomerContent;
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(11; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            TableRelation = "Production Order"."No." WHERE(Status = CONST(Released));
            DataClassification = CustomerContent;
        }
        field(12; "Rework Level"; Integer)
        {
            Caption = 'Rework Level';
            DataClassification = CustomerContent;
        }
        field(13; Status; Boolean)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(19; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;

        }

        field(20; "ILE No."; integer)
        {
            Caption = 'ILE No.';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; "Inspection Receipt No.", "Quality Type", "Line No.")
        {
        }
        key(Key2; "Quality Type", Quantity)
        {
            SumIndexFields = Quantity;
        }
        key(Key3; "Item No.", "Vendor No.", "Acceptance Code", "Quality Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        TestStatus();
        TESTFIELD(Quantity);
        TESTFIELD("Acceptance Code");
        "Item No." := InspectRcpt."Item No.";
        "Vendor No." := InspectRcpt."Vendor No.";
        "Source Type" := InspectRcpt."Source Type";
        "Production Order No." := InspectRcpt."Prod. Order No.";
        "Rework Level" := InspectRcpt."Rework Level";
    end;

    trigger OnModify();
    begin
        TestStatus();
        TESTFIELD(Quantity);
        TESTFIELD("Acceptance Code");
    end;

    var
        InspectRcpt: Record "Inspection Receipt Header B2B";
        AcptLevel: Record "Acceptance Level B2B";

    procedure TestStatus();
    begin
        InspectRcpt.GET("Inspection Receipt No.");
        InspectRcpt.TESTFIELD(Status, false);
    end;
}


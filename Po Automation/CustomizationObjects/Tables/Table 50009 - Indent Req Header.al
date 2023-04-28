table 50009 "Indent Req Header"
{
    // version PH1.0,PO1.0

    LookupPageID = 50013;

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."Indent Req No.");
                    "No.Series" := '';
                END;
            end;
        }
        field(10; "Document Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(11; "Resposibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionMembers = " ",Open,Release,"Pending Approval";
        }
        field(13; "No.Series"; Code[20])
        {
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                OnAfterLookUp(Rec);
            end;
        }
        field(14; Type; Option)
        {
            OptionMembers = Enquiry,Quote,"Order";
        }
        field(15; "Indent Type"; Option)
        {
            Caption = 'Indent Type';
            Description = 'B2BESGOn02Jun2022';
            Editable = false;
            OptionCaption = ' ,IT,Non-IT';
            OptionMembers = " ",IT,"Non-IT";
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'B2BESGOn02Jun2022';
            TableRelation = Currency;
        }
        field(17; "RFQ No."; code[20])
        {
            Caption = 'RFQ No.';
            Description = 'B2BESGOn02Jun2022';
        }
        field(50000; "Shortcut Dimension 1 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(50001; "Shortcut Dimension 2 Code_B2B"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false), "Division Code" = field("Shortcut Dimension 1 Code_B2B"));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnInsert();
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
            PurchaseSetup.TESTFIELD("Indent Req No.");
            NoSeriesMgt.InitSeries(PurchaseSetup."Indent Req No.", xRec."No.Series", 0D, "No.", "No.Series");
            "No.Series" := ''
        END;
        "Document Date" := TODAY;
    end;

    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IndentReq: Record 50009;
        OldIndentReq: Record 50009;
        Noseries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        IndentReqNoGvar: Code[20];

    procedure AssistEdit(OldIndentReq: Record 50009): Boolean;
    begin
        IndentReq := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Indent Req No.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."Indent Req No.", OldIndentReq."No.", IndentReq."No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("Indent Req No.");
            IndentReqNoGvar := IndentReq."No.";
            NoSeriesMgt.SetSeries(IndentReq."No.");
            Rec := IndentReq;
            OnAfterAssisitEditIndReq(IndentReqNoGvar, Rec);
            EXIT(TRUE);
        END;
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterAssisitEditIndReq(Var IndentNoPar: Code[20]; Var IndentReqHeaderRec: Record "Indent Req Header")
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnAfterLookUp(Var IndentReqHeaderRec: Record "Indent Req Header")
    begin
    end;
}


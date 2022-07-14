table 50001 "Indent Header"
{
    // version PH1.0,PO1.0

    LookupPageID = 50002;

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."Indent Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(7; "Due Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(8; "Delivery Location"; Code[20])
        {

            trigger OnLookup();
            begin
                IF PAGE.RUNMODAL(0, Location) = ACTION::LookupOK THEN
                    "Delivery Location" := Location.Code;
                IndentLine.SETRANGE("Document No.", "No.");
                IF IndentLine.FIND('-') THEN BEGIN
                    TestStatusOpen;
                    REPEAT
                        IndentLine."Delivery Location" := "Delivery Location";
                        IndentLine.MODIFY;
                    UNTIL IndentLine.NEXT = 0;
                END;
            end;

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(10; Department; Code[20])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
                //B2BESGOn23May2022++
                IndentLine.SETRANGE("Document No.", "No.");
                IF IndentLine.FIND('-') THEN BEGIN
                    TestStatusOpen;
                    REPEAT
                        IndentLine.Department := Department;
                        IndentLine.MODIFY;
                    UNTIL IndentLine.NEXT = 0;
                END;
                //B2BESGOn23May2022--
            end;
        }
        field(13; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; Indentor; Text[50])
        {
            Editable = false;
        }
        field(16; Comment; Boolean)
        {
        }
        field(21; "Indent Status"; Option)
        {
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Close';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Close;
        }
        field(23; "User Id"; Code[30])
        {
            Editable = false;
        }
        field(24; "Released Status"; Option)
        {
            Editable = false;
            OptionMembers = Open,Released,Cancel,Close;
        }
        field(25; "Last Modified Date"; Date)
        {
        }
        field(31; "Sent for Authorization"; Boolean)
        {
            Caption = 'Sent for Authorization';
        }
        field(32; Authorized; Boolean)
        {
            Caption = 'Authorized';
        }
        field(33; Declined; Boolean)
        {
            Caption = 'Declined';
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
        TESTFIELD("Released Status", "Released Status"::Open);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETFILTER(IndentLine."Indent Status", '<>%1', IndentLine."Indent Status"::Indent);
        IF IndentLine.FIND('-') THEN
            ERROR(Text008);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
            PurchaseSetup.TESTFIELD("Indent Nos.");
            NoSeriesMgt.InitSeries(PurchaseSetup."Indent Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User Id" := USERID;
        "Document Date" := WORKDATE;
        Indentor := USERID;
        CompSetup.GET;
        "Delivery Location" := CompSetup."Location Code";
    end;

    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PIndent: Record 50001;
        IndentLine: Record 50002;
        Item: Record 27;
        Text000: Label 'The %1 cannot be copied to itself.';
        Text002: Label 'Do you want to release the Indent?';
        Text003: Label 'Do you want to cancel the Indent?';
        Text004: Label 'Indent can not be cancel as it is in process';
        Text005: Label 'Do you want to close the Indent?';
        Text006: Label 'Do you want to reopen the Indent?';
        Text007: Label 'Do you want to open the Indent?';
        CopyDocNo: Code[20];
        Location: Record 14;
        Text008: Label '"You cannot Delete "';
        Employee: Record 5200;
        Job: Record 167;
        CompSetup: Record 79;

    procedure AssistEdit(OldIndent: Record 50001): Boolean;
    begin
        PIndent := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Indent Nos.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."Indent Nos.", OldIndent."No.", PIndent."No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("Indent Nos.");
            NoSeriesMgt.SetSeries(PIndent."No.");
            Rec := PIndent;
            EXIT(TRUE);
        END;
    end;

    procedure ReleaseIndent();
    var
        IndentLine: Record 50002;
    begin
        IF NOT CONFIRM(Text002, FALSE) THEN
            EXIT;
        TESTFIELD("Released Status", "Released Status"::Open);
        TESTFIELD(Indentor);
        LOCKTABLE;
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IF IndentLine.FINDSET THEN
            REPEAT
                IF IndentLine.Type <> IndentLine.Type::Description THEN BEGIN
                    IndentLine.TESTFIELD(IndentLine."No.");
                    IndentLine.TESTFIELD(IndentLine."Req.Quantity");
                END;
            UNTIL IndentLine.NEXT = 0;
        IF IndentLine.FINDSET THEN;
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Released);
        "Released Status" := "Released Status"::Released;
        "Last Modified Date" := WORKDATE;
    end;

    procedure CancelIndent();
    begin
        IF "Released Status" = "Released Status"::Cancel THEN BEGIN //sankar added for cancel
            MESSAGE('Status is Already in Cancel');
            EXIT;
        END;
        IF NOT ("Released Status" = "Released Status"::Open) THEN BEGIN
            MESSAGE('Status Must be Open to Cancel/Close');
            EXIT;
        END;
        IF NOT CONFIRM(Text003, FALSE) THEN
            EXIT;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETFILTER("Indent Status", '%1|%2', IndentLine."Indent Status"::Offer, IndentLine."Indent Status"::Order);
        IF IndentLine.FIND('-') THEN
            ERROR(Text004);
        LOCKTABLE;
        IndentLine.SETRANGE("Indent Status");
        IndentLine.MODIFYALL("Indent Status", IndentLine."Indent Status"::Cancel);
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Cancel);
        "Released Status" := "Released Status"::Cancel;
        "Indent Status" := "Indent Status"::Cancel;
    end;

    procedure CloseIndent();
    begin
        IF "Released Status" = "Released Status"::Close THEN BEGIN //sankar added for close
            MESSAGE('Status is Already in Closed');
            EXIT;
        END;
        IF NOT ("Released Status" = "Released Status"::Open) THEN BEGIN
            MESSAGE('Status Must be open to Cancel/Close');
            EXIT;
        END;

        IF NOT CONFIRM(Text005, FALSE) THEN
            EXIT;
        LOCKTABLE;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.MODIFYALL("Indent Status", IndentLine."Indent Status"::Closed);
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Closed);
        "Released Status" := "Released Status"::Close;
        "Indent Status" := "Indent Status"::Close;
    end;

    procedure ReopenIndent();
    var
        IndentLine: Record 50002;
        Text000: Label 'Indent Status must be ''Indent'' in the Indent Lines';
        Text007: Label 'Can not Reopen the indent if status is Cancel/Closed.';
    begin
        IF NOT CONFIRM(Text006, FALSE) THEN
            EXIT;
        IF "Released Status" <> "Released Status"::Released THEN
            ERROR(Text007);
        TESTFIELD("Indent Status", "Indent Status"::Indent);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IF IndentLine.FIND('-') THEN BEGIN
            IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Open);
            MODIFY(TRUE);
            "Released Status" := "Released Status"::Open;
            "Last Modified Date" := WORKDATE;
        END ELSE
            MESSAGE(Text000);
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD("Released Status", "Released Status"::Open);
    end;

    procedure CopyIndent();
    var
        FromIndentLine: Record 50002;
        ToIndentLine: Record 50002;
        IndentHeader: Record 50001;
        ToIndentLine1: Record 50002;
        ToIndentLine2: Record 50002;
    begin
        TESTFIELD("No.");
        TESTFIELD("Released Status", "Released Status"::Open);
        IF PAGE.RUNMODAL(0, IndentHeader) = ACTION::LookupOK THEN BEGIN
            CopyDocNo := IndentHeader."No.";
            IF CopyDocNo = "No." THEN
                ERROR(Text000, TABLECAPTION);

            FromIndentLine.SETRANGE("Document No.", CopyDocNo);
            IF FromIndentLine.FIND('-') THEN
                REPEAT
                    ToIndentLine.INIT;
                    ToIndentLine.TRANSFERFIELDS(FromIndentLine);
                    ToIndentLine2.SETRANGE(ToIndentLine2."Document No.", "No.");
                    IF ToIndentLine2.FIND('-') THEN BEGIN
                        ToIndentLine1.SETRANGE(ToIndentLine1."Document No.", "No.");
                        ToIndentLine1.FIND('+');
                        ToIndentLine."Line No." := ToIndentLine1."Line No." + 10000
                    END ELSE
                        ToIndentLine."Line No." := 10000;
                    ToIndentLine."Document No." := "No.";
                    ToIndentLine."Indent Status" := ToIndentLine."Indent Status"::Indent;
                    ToIndentLine."Release Status" := ToIndentLine."Release Status"::Open;
                    ToIndentLine."Due Date" := WORKDATE;
                    ToIndentLine."Delivery Location" := "Delivery Location";
                    ToIndentLine.INSERT;
                UNTIL FromIndentLine.NEXT = 0;
        END;
    end;
}


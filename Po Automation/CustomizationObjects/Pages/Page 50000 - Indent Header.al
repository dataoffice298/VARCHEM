page 50000 "Indent Header"
{
    // version PH1.0,PO1.0,REP1.0

    PageType = ListPlus;
    SourceTable = "Indent Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                }
                field(Department; rec.Department)
                {
                    Visible = true;
                    ApplicationArea = all;
                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
            }
            part(indentLine; 50001)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Copy BOM Lines")
                {
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        BOMLineR: Report "Quant Explo of BOM In Indent";
                    begin
                        IF rec."No." = '' then
                            rec.TestField(Rec."No.");
                        BOMLineR.GetInden(rec."No.");
                        BOMLineR.Run();
                    end;
                }
                action("Copy Indent")
                {
                    Caption = 'Copy Indent';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.CopyIndent;
                    end;
                }
                separator("Approvals")
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Document Date");
                        IndentLine.SETRANGE("Document No.", Rec."No.");
                        IF IndentLine.FIND('-') THEN
                            Rec.ReleaseIndent
                        ELSE
                            MESSAGE(Text001, Rec."No.");
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        text000: Label 'Cannot Reopen the indent if the status is Cancel/Closed.';
                    begin
                        IF NOT (Rec."Indent Status" = Rec."Indent Status"::Close) OR (Rec."Indent Status" = Rec."Indent Status"::Cancel) THEN BEGIN
                            Rec.ReopenIndent;
                            CurrPage.UPDATE;
                        END ELSE
                            MESSAGE(text000);
                    end;
                }
                action("Ca&ncel")
                {
                    Caption = 'Ca&ncel';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //IF NOT ("Indent Status" ="Indent Status"::Closed) THEN BEGIN
                        Rec.CancelIndent;
                        CurrPage.UPDATE;
                        //END;
                    end;
                }
                action("Clo&se")
                {
                    Caption = 'Clo&se';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //IF NOT ("Indent Status" ="Indent Status"::Cancel) THEN BEGIN
                        Rec.CloseIndent;
                        CurrPage.UPDATE;
                        //END;
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IndentHeader.SETRANGE(IndentHeader."No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::Indent, TRUE, TRUE, IndentHeader);
                end;
            }
        }
    }

    var
        IndentLine: Record 50002;
        IndentHeader: Record 50001;
        Text000: Label 'Do you want Convert to Quote?';
        Text001: Label 'There Is Nothing to Release for Indent %1';
        Text13002: Label 'The Order Is Authorized, You Cannot Resend For Authorization';
        Text13003: Label 'You Cannot Resend For Authorization';
        Text13004: Label 'This Order Has been Rejected. Please Create A New Order.';
        Text13700: Label 'You have %1 new Task(s).';
        Text13000: Label 'No Setup exists for this Amount.';
        Text13001: Label 'Do you want to send the order for Authorization?';
        Text13702: Label 'for your approval';
        Text13703: Label '"You have received the undermentioned document for authorisation: "';
        Text13704: Label '"Document Type: Purchase  "';
        Text13718: Label '"Not Authorised "';
        Text13719: Label '"To: "';
        Text13720: Label 'The undermentioned document has been RETURNED WITHOUT BEING AUTHORISED';
        Text13721: Label 'since the authorised signatory';
        Text13722: Label '"has not seen the document in the time specified. "';
        Text13723: Label '"You are requested to kindly resend the same for authorisation or forward it to "';
        Text13724: Label '"another authorised signatory. "';
        Text13725: Label 'No Body Is Responding to the mails.';
        Text13726: Label 'Approved';
        Text13727: Label '"The undermentioned document has been  APPROVED "';
        Text13728: Label 'You are requested to kindly proceed with subsequent processes and ensure prompt closure of this document.';
        Text13729: Label 'Rejected';
        Text13730: Label '"The undermentioned document has been REJECTED. "';
        Text13731: Label 'You are requested to kindly refer to the comments on the document to know the reason  for this document not being approved and take necessary action.';
        Text13705: Label '"Document No.: "';
        Text13706: Label 'Document Date:';
        Text13707: Label '"Vendor Name : "';
        Text13708: Label '"You are requested to verify and authorise the above document at the earliest. "';
        Text13709: Label '"Thank you, "';
        Text13710: Label '"From:  "';
        WFIndentLine: Record 50005;
        Company: Record 79;
        PurchSetup: Record 312;
        WFAmount: Decimal;
        IsValid: Boolean;
        UserSetup: Record 91;
        I: Integer;
        Link: Text[1000];
        FileName: Text[250];
        Context: Text[1000];
        File1: File;
        HideDialog: Boolean;
        ErrorNo: Integer;
        EntryNo: Integer;
        User: Record 2000000120;
        Indent: Page 50002;
        WFPurchLine: Record 39;
}


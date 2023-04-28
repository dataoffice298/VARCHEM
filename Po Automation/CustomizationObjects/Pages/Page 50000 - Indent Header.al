page 50000 "Indent Header"
{
    // version PH1.0,PO1.0,REP1.
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
                    Editable = BoolGvar;
                    trigger OnAssistEdit();
                    var
                        NoSeriesVar: Record "No. Series";
                    begin
                        IF rec.AssistEdit(xRec) THEN begin
                            //if NoSeriesVar.Get("No. Series") 
                            CurrPage.UPDATE;
                        end;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }
                field(Department; rec.Department)
                {
                    Visible = true;
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }

                field("MRS Requestor"; Rec."MRS Requestor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MRS Requestor field.';
                }
                field("MRS Department"; Rec."MRS Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MRS Department field.';
                }
                field("MRS Requested Date"; Rec."MRS Requested Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MRS Requested Date field.';
                }

                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Order No. field.';
                    Editable = BoolGvar;
                }
                /*field("Indent Status"; Rec."Indent Status")
                {
                    ApplicationArea = All;

                }*/
                field("Shortcut Dimension 1 Code_B2B"; Rec."Shortcut Dimension 1 Code_B2B")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code_B2B"; Rec."Shortcut Dimension 2 Code_B2B")
                {
                    ApplicationArea = all;
                    Editable = BoolGvar;
                }
                field("Delivery Location"; Rec."Delivery Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Location field.';
                }


            }
            part(indentLine; 50001)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                Editable = BoolGvar;
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
                       // BOMLineR: Report "Quant Explo of BOM In Indent";
                    begin
                        IF rec."No." = '' then
                            rec.TestField(Rec."No.");
                        //BOMLineR.GetInden(rec."No.");
                        //BOMLineR.Run();
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
                        Rec.TestField("Shortcut Dimension 1 Code_B2B");
                        rec.TestField(Rec."Shortcut Dimension 2 Code_B2B");
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
                    //Visible = false;
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
                    //Visible = false;
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
            
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Released Status" = Rec."Released Status"::Open then
            BoolGvar := true
        else
            BoolGvar := false;
    end;

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
        //Re : Record 36;
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
        BoolGvar: Boolean;
}


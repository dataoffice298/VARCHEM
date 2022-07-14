page 33000291 "Specification Version B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Specificatinn Version';
    PageType = ListPlus;
    SourceTable = "Specification Version B2B";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Version Code"; Rec."Version Code")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'this field the code of version';
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE();
                    end;
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'which data planning the manufacturing process start is the starting date';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = all;
                    tooltip = 'which date modified order is the last data modified';
                }
            }
            part(Control1102152012; "Specification Subform B2B")
            {
                SubPageLink = "Spec ID" = FIELD("Specification No."),
                              "Version Code" = FIELD("Version Code");
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102152013>")
            {
                Caption = 'F&unctions';
                action("Copy Specification Header")
                {
                    Caption = 'Copy Specification Header';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    tooltip = 'The user can copy an existing specification and modify it as per the requirement';
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        if not CONFIRM(Text000Qst, false) then
                            exit;

                        SpecHeader.GET(Rec."Specification No.");
                        SpecCopy.CopySpec(Rec."Specification No.", '', SpecHeader, Rec."Version Code");
                    end;
                }
                action("Copy Specification Version")
                {
                    Caption = 'Copy Specification Version';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    tooltip = 'The user can copy version an existing specification and modify it as per the requirement ';
                    trigger OnAction();
                    begin
                        SpecCopy.CopyFromVersion(Rec);
                    end;
                }
                action(Indent)
                {
                    Caption = 'Indent';
                    Image = IndentChartOfAccounts;
                    ApplicationArea = all;
                    tooltip = 'Purchase department receives the Indents item requirement list from the various departments for procurement of materials';
                    trigger OnAction();
                    begin
                        SpecIndent.IndentSpecVersion(Rec);
                    end;
                }
            }
        }
    }

    var
        SpecHeader: Record "Specification Header B2B";
        SpecIndent: Codeunit "Spec Line Indent B2B";
        SpecCopy: Codeunit "Specification-Copy B2B";
        Text000Qst: Label 'Copy from Specification?';
}


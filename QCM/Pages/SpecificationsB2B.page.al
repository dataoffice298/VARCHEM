page 33000253 "Specifications B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    AutoSplitKey = false;
    Caption = 'Specifications';
    PageType = ListPlus;
    SourceTable = "Specification Header B2B";
    UsageCategory = Administration;
    ApplicationArea = all;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Spec ID"; Rec."Spec ID")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'Specification is a group of characteristics to be inspected of an item';
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
                    ToolTip = 'Description for Identification purpose for  the user';
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    ToolTip = 'After entry of the relevant data,the status must be changed';
                    trigger OnValidate();
                    begin
                        StatusOnAfterValidate();
                    end;
                }
                field("Version Nos."; Rec."Version Nos.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Number series that you use to create a new version of the BOM';

                }
                field(ActiveVersionCodeCap; ActiveVersionCode)
                {
                    Caption = 'Active Version';
                    ToolTip = 'The active version is determined by its starting date with BOM';
                    Editable = false;
                    ApplicationArea = all;


                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        SpecVersion: Record "Specification Version B2B";
                    begin
                        SpecVersion.SETRANGE("Specification No.", Rec."Spec ID");
                        SpecVersion.SETRANGE("Version Code", ActiveVersionCode);
                        PAGE.RUNMODAL(PAGE::"Specification Version B2B", SpecVersion);
                        ActiveVersionCode := Rec.GetSpecVersion(Rec."Spec ID", WORKDATE(), true);
                    end;
                }
            }
            part(Control1000000006; "Specification Subform B2B")
            {
                ApplicationArea = All;
                SubPageLink = "Spec ID" = FIELD("Spec ID"),
                              "Version Code" = CONST('');

            }
        }
        area(factboxes)
        {
            systempart(Control1102154000; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Specifications")
            {
                Caption = '&Specifications';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    tooltip = 'comment for the decision good/bad productsgive the comment';
                    Image = ViewComments;
                    RunObject = Page "Quality Comment Sheet B2B";
                    RunPageLink = Type = CONST("Specification"),
                                  "No." = FIELD("Spec ID");
                    ApplicationArea = all;

                }
                action("&Versions")
                {
                    Caption = '&Versions';
                    ToolTip = 'create a new BOM to handle changes because this requires changes to the product structure';
                    Image = BOMVersions;
                    RunObject = Page "Specification Version B2B";
                    RunPageLink = "Specification No." = FIELD("Spec ID");
                    ApplicationArea = all;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Copy Specification")
                {
                    Caption = 'Copy Specification';
                    tooltip = 'The item is analyzed using set of characteristics codes and result is compared if it falls between minimum and maximum values';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Spec ID");
                        if PAGE.RUNMODAL(0, SpecHeader) = ACTION::LookupOK then
                            SpecCopy.CopySpec(SpecHeader."Spec ID", '', Rec, '');
                    end;
                }
                action("Copy Assay")
                {
                    Caption = 'Copy Assay';
                    tooltip = 'Assays are used to define Characters, which need to be inspected by the same inspection group copy assay,';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.CopyAssay();
                    end;
                }
                action(Indent)
                {
                    Caption = 'Indent';
                    tooltip = 'Purchase department receives the Indents from the various departments for procurement of materials';
                    Image = Indent;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Spec Line Indent B2B";
                    ApplicationArea = all;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                ToolTip = 'print generating a hardcopy to the electronic data being print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                begin
                    SpecHeader.SETRANGE("Spec ID", Rec."Spec ID");
                    REPORT.RUN(33000253, true, false, SpecHeader);
                    SpecHeader.SETRANGE("Spec ID");
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

        ActiveVersionCode := Rec.GetSpecVersion(Rec."Spec ID", WORKDATE(), true);
    end;




    local procedure StatusOnAfterValidate();
    begin
        CurrPage.UPDATE();
    end;

    var
        SpecHeader: Record "Specification Header B2B";
        SpecCopy: Codeunit "Specification-Copy B2B";
        ActiveVersionCode: Code[20];

}


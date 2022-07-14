page 33000301 "Trailing IDS Setup B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Trailing IDS Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Trailing IDS Setup B2B";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Use Work Date as Base"; Rec."Use Work Date as Base")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the mention for using the date that work date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        if not Rec.GET(USERID()) then begin
            Evaluate(Rec."User ID", USERID());
            Rec."Use Work Date as Base" := true;
            Rec.INSERT();
        end;
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("User ID", USERID());
        Rec.FILTERGROUP(0);
    end;
}


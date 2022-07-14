page 33000278 "Assay B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Assay';
    PageType = ListPlus;
    SourceTable = "Assay Header B2B";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    AssistEdit = true;
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = ' automatic numbering using generic number series';
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
                field("Sampling Plan Code"; Rec."Sampling Plan Code")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                    tooltip = 'sampling plan that is applicable to the set of characters to be inspected by the inspection group';
                }
                field("Inspection Group Code"; Rec."Inspection Group Code")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection group that is responsible for inspection of the group of characters enlisted between Begin and end';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    tooltip = 'Default is new. After entry of the relevant data, the status must be changed to Certified';
                }
            }
            part(Control1000000010; "Assay Subform B2B")
            {
                SubPageLink = "Assay No." = FIELD("No.");
                ApplicationArea = all;

            }
        }
        area(factboxes)
        {
            systempart(Control1102154003; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        OnAfterGetCurrRecordCust();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        OnAfterGetCurrRecordCust();
    end;

    local procedure OnAfterGetCurrRecordCust();
    begin
        xRec := Rec;
        Rec.SETRANGE("No.");
    end;
}


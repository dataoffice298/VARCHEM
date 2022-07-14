page 33000295 "Qty Inspector Activities B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Inspector Activities';
    PageType = CardPart;
    SourceTable = "Quality Inspector Cue B2B";

    layout
    {
        area(content)
        {
            cuegroup("For Release")
            {
                Caption = 'For Release';
                field("Inspection Datasheet - Open"; Rec."Inspection Datasheet - Open")
                {
                    DrillDownPageID = "Inspection Data Sheet List B2B";
                    ApplicationArea = all;
                    tooltip = 'system open  allow any modification in inspection data sheet ';
                }
                /*
                actions
                {
                    action("NewInspectionDatasheet")
                    {
                        Caption = 'New Inspection Data sheet';
                        RunObject = Page "Inspection Data Sheet";
                        RunPageMode = Create;
                        Visible = false;
                        ApplicationArea = all;
                    }
                    action("NewPurchaseOrder")
                    {
                        Caption = 'New Purchase Order';
                        RunObject = Page "Purchase Order";
                        RunPageMode = Create;
                        Visible = false;
                        ApplicationArea = all;
                    }
                }
                */
            }
            cuegroup("For Post")
            {
                Caption = 'For Post';
                field("Inspection Datasheet - Release"; Rec."Inspection Datasheet - Release")
                {
                    Caption = 'Inspection Datasheet - Release';
                    DrillDownPageID = "Inspection Data Sheet List B2B";
                    ApplicationArea = all;
                    tooltip = 'system does not allow any modification in inspection data sheet';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;

        Rec.SETFILTER("Date Filter", '>=%1', WORKDATE());
    end;
}


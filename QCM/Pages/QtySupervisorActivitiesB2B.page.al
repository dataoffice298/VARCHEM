page 33000296 "Qty Supervisor Activities B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Supervisor Activities';
    PageType = CardPart;
    SourceTable = "Quality Supervisor Cue B2B";

    layout
    {
        area(content)
        {
            cuegroup("For Post")
            {
                Caption = 'For Post';
                field("Inspection Receipt"; Rec."Inspection Receipt")
                {
                    DrillDownPageID = "Inspection Receipt List B2B";
                    ApplicationArea = all;
                    tooltip = 'this field user Inspection receipt through which the user actually accepts, rejects or sends for rework';
                }
                /*
                 actions
                 {
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


page 33000294 "Quality Planner Activities B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Planner Activities';
    PageType = CardPart;
    SourceTable = "Quality Planner Cue B2B";

    layout
    {
        area(content)
        {
            cuegroup(Certified)
            {
                Caption = 'Certified';
                field("Certified Specifications"; Rec."Certified Specifications")
                {
                    DrillDownPageID = "Specification List B2B";
                    ApplicationArea = all;
                    tooltip = 'Default is new, mention the specification approval to changed the status to certified';
                }
                field("Certified Sampling Plan"; Rec."Certified Sampling Plan")
                {
                    DrillDownPageID = "Sampling Plan List B2B";
                    ApplicationArea = all;
                    tooltip = 'default is new , mention sampling plan approval to changed the status to certified';
                }
                field("Sub Assembly"; Rec."Sub Assembly")
                {
                    DrillDownPageID = "Sub Assembly List B2B";
                    ApplicationArea = all;
                    tooltip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
                }
                /*
                 actions
                 {
                     action("NewSpecification")
                     {
                         Caption = 'New Specification';
                         RunObject = Page Specifications;
                         RunPageMode = Create;
                         ApplicationArea = all;
                     }
                     action("NewSamplingPlan")
                     {
                         Caption = 'New Sampling Plan';
                         RunObject = Page "Sampling Plan";
                         RunPageMode = Create;
                         ApplicationArea = all;
                     }
                     action("NewSubAssembly")
                     {
                         Caption = 'New Sub Assembly';
                         RunObject = Page "Sub Assembly Card";
                         ApplicationArea = all;
                     }
                     action(Routing)
                     {
                         Caption = 'Routing';
                         RunObject = Page "Routing List";
                         ApplicationArea = all;
                     }
                     action("Items")
                     {
                         Caption = 'Items';
                         RunObject = Page "Item List";
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


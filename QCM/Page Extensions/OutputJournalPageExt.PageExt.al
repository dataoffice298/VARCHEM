pageextension 33000303 OutPutJournalPageExtB2B extends "Output Journal"
{
    layout
    {
        addafter("No.")
        {
            field("Routing No. B2B"; Rec."Routing No.")
            {
                Caption = 'Routing No.';
                ApplicationArea = All;
                ToolTip = 'Number of the machine center or work center based on the selection the Routing no.';
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            group("QC B2B")
            {
                Caption = 'QC';
                action("Explode Rework  Routing B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'It Explodes Rework Routing';
                    Image = Indent;
                    Caption = '&Explode Rework  Routing';
                    RunObject = Codeunit 33000263;
                }
            }
        }
    }


}
pageextension 33000300 ConsumJournalPageExtB2B extends "Consumption Journal"
{
    actions
    {
        addlast("F&unctions")
        {
            group("QualityB2B")
            {

                action("Calc. Rework. Consumption B2B")
                {
                    Caption = 'Calc. &Rework. Consumption';
                    ToolTip = 'Defines callulated and Rework and Consumption Quantities';
                    Image = Calculate;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        // Start  B2BQC1.00.00 - 01

                        CalcConsumption.SetTemplateAndBatchName(Rec."Journal Template Name", Rec."Journal Batch Name");
                        CalcConsumption.RUNMODAL();

                        // Stop   B2BQC1.00.00 - 01
                    end;
                }
            }
        }
    }
    var
        CalcConsumption: Report 33000265;
}
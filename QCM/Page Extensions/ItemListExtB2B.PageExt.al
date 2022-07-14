pageextension 33000318 "ItemListExt B2B" extends "Item List"
{
    actions
    {
        addlast("E&ntries")
        {
            action("QualityLedgerentries B2B")
            {
                Caption = 'Quality Ledger entries';
                ToolTip = 'To access the quality ledger entries for that particular items';
                RunObject = page "Quality Ledger Entries B2B";
                RunPageLink = "Item No." = field("No.");
                Image = ItemLedger;
                ApplicationArea = all;
            }
        }
    }
}
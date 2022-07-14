codeunit 50002 "MyBaseSubscr"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    [EventSubscriber(ObjectType::table, 83, 'OnBeforePostingItemJnlFromProduction', '', False, False)] //PKON22M17
    local procedure OnBeforePostingItemJnlFromProduction(var ItemJournalLine: Record "Item Journal Line"; Print: Boolean; var IsHandled: Boolean)
    var
        ProOrdCom: Record "Prod. Order Component";
        ItemJourLinesGrec: Record "Item Journal Line";
    begin
        ItemJourLinesGrec.RESET;
        ItemJourLinesGrec.CopyFilters(ItemJournalLine);
        IF ItemJourLinesGrec.FINDSET then
            Repeat
                ProOrdCom.RESET;
                ProOrdCom.SetRange("Prod. Order No.", ItemJourLinesGrec."Order No.");
                ProOrdCom.SetRange("Prod. Order Line No.", ItemJourLinesGrec."Order Line No.");
                ProOrdCom.SetRange("Line No.", ItemJourLinesGrec."Prod. Order Comp. Line No.");
                IF ProOrdCom.FINDSET THEN
                    REPEAT
                        ProOrdCom.CalcFields(ProOrdCom.Inventory);
                        IF ProOrdCom.Inventory < ProOrdCom."Expected Quantity" THEN
                            Error('Inventory availability is less than expected qunatity for some items. Please check "Shortage Report_50011"');
                    Until ProOrdCom.Next = 0;
            until ItemJourLinesGrec.Next = 0;
    end;
}


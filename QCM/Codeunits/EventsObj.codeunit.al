codeunit 33000264 "Events Obj B2B"
{
    trigger OnRun()
    begin
    end;
    //Inspection Rceipt Header

    [IntegrationEvent(false, false)]
    procedure OnAfterCopyGenJnlLineFromInspRecpHeader(InspectReceptHeader: Record "Inspection Receipt Header B2B"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;


    [EventSubscriber(ObjectType::Page, Page::"Routing", 'OnBeforeValidateEvent', 'Status', true, true)]
    local procedure "Routing_OnBeforeValidateEvent_[content / General] - Status"(var Rec: Record "Routing Header")
    begin
        IF rec.Status = rec.Status::Certified THEN BEGIN
            RoutingLine.Reset();
            RoutingLine.SETRANGE("Routing No.", rec."No.");
            // IF RoutingLine.FindFirst() THEN BEGIN//PKON22M26
            IF RoutingLine.FindLast() THEN BEGIN//PKON22M26
                RoutingLine."QC Enabled B2B" := FALSE;
                RoutingLine.MODIFY();
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnAfterRefreshProdOrder', '', false, false)]//PKON22M26
    local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    var
        ProdOrdLine: Record "Prod. Order Line";
        ProdRoutLines: Record "Prod. Order Routing Line";
        Rote: Record "Routing Line";
    begin
        ProdOrdLine.reset;
        ProdOrdLine.SETRANGE("Prod. Order No.", ProductionOrder."No.");
        IF ProdOrdLine.FINDSET then
            Repeat
                ProdRoutLines.Reset();
                ProdRoutLines.SetRange("Prod. Order No.", ProdOrdLine."Prod. Order No.");
                ProdRoutLines.SetRange("Routing Reference No.", ProdOrdLine."Line No.");
                IF ProdRoutLines.FINDSET then
                    repeat
                        IF Rote.GET(ProdRoutLines."Routing No.", ProdOrdLine."Routing Version Code", ProdRoutLines."Operation No.") THEN
                            ProdRoutLines.Validate("Sub Assembly B2B", Rote."Sub Assembly B2B")
                        else
                            ProdRoutLines.Validate("Sub Assembly B2B", '');
                        ProdRoutLines.Modify();
                    until ProdRoutLines.Next = 0;
            until ProdOrdLine.Next = 0;
    end;

    var
        RoutingLine: Record "Routing Line";

}
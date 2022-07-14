codeunit 33000262 "PurchaseExt B2B"
{
    trigger OnRun();
    begin
    end;


    [EventSubscriber(ObjectType::codeunit, 90, 'OnAfterPurchRcptLineInsert', '', false, false)]
    procedure QualityCheckInspect(PurchRcptLine: Record 121; PurchaseLine: Record 39);
    var
        PurchRcptLine3: Record 121;
    begin

        //MESSAGE(FORMAT(PurchRcptLine."No."));
        IF PurchaseLine."Quality Before Receipt B2B" THEN BEGIN
            PurchaseLine.CALCFIELDS("Quantity Accepted B2B");
            IF PurchaseLine."Quantity Accepted B2B" < PurchaseLine."Qty. to Receive" + PurchaseLine."Quantity Received" THEN
                ERROR(Text33000250Err, PurchaseLine."Document No.", PurchaseLine."Line No.");

        END ELSE
            IF (PurchRcptLine.Type = PurchRcptLine.Type::Item) AND
               PurchRcptLine."QC Enabled B2B" AND (PurchRcptLine.Quantity <> 0)
   THEN BEGIN
                PurchRcpHdr.GET(PurchRcptLine."Document No.");
                IF PurchaseLine."Qty. Sending to Quality(R) B2B" = 0 THEN
                    InspectDataSheets."CreatePur.LineInspectDataSheet"(PurchRcpHdr, PurchRcptLine)
                ELSE BEGIN
                    PurchRcptLine3 := PurchRcptLine;
                    PurchRcptLine3.Quantity := PurchaseLine."Qty. Sending to Quality(R) B2B";
                    InspectDataSheets."CreatePur.LineInspectDataSheet"(PurchRcpHdr, PurchRcptLine3);
                    IF PurchRcptLine.Quantity <> PurchaseLine."Qty. Sending to Quality(R) B2B" THEN BEGIN
                        PurchRcptLine3.Quantity := PurchRcptLine.Quantity - PurchaseLine."Qty. Sending to Quality(R) B2B";
                        InspectDataSheets.CreatePurchOrderInspectDS(PurchHeader)
                    END
                END
            END;

        // Stop   B2BQC1.00.00 - 01

    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignItemValues', '', fALSE, fALSE)]
    local procedure UpdateQualityPurchLines(VAR PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchLine.UpdateQualityPurchLines(Item);
    END;

    var

        PurchHeader: Record 38;
        PurchRcpHdr: record 120;
        InspectDataSheets: Codeunit 33000251;
        Text33000250Err: Label 'You cannot receive more than Quality Accepted in Purchase Order No. %1 and Line No. %2.', comment = ' %1 Doccument No.= ; %2 = Line No.';

}
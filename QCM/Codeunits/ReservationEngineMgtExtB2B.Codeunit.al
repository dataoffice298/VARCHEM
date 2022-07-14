Codeunit 33000263 "ReservationEngineMgtExt B2B"
{
    trigger OnRun()
    begin

    end;

    PROCEDURE "---B2BQC1.00.00---"();
    BEGIN
    END;

    PROCEDURE CloseReservEntryTracking(ReservEntry: Record 337);
    VAR
        ReservEntry3: Record 337;

        ReservationEngineMgt: Codeunit "Reservation Engine Mgt.";
        LastEntryNo: Integer;
        Text33000250Err: Label 'Reservation Status should be Reservation or Tracking';
    BEGIN
        // Start  B2BQC1.00.00 - 01
        //Close the Reservation Entry Tracking.

        IF (ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation) OR
           (ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Tracking)
        THEN BEGIN
            ReservEntry3.LOCKTABLE();
            IF ReservEntry3.FIND('+') THEN
                LastEntryNo := ReservEntry3."Entry No.";
            ReservEntry3.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive);
            IF (ReservEntry3."Lot No." <> '') OR (ReservEntry3."Serial No." <> '') OR
               (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '')
            THEN
                ReservationEngineMgt.CancelReservation(ReservEntry)
            ELSE
                ERROR(Text33000250Err);

            // Stop   B2BQC1.00.00 - 01
        END;
    End;

    var

}
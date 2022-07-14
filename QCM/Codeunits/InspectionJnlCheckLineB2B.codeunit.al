codeunit 33000252 "Inspection Jnl. Check Line B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.


    trigger OnRun();
    begin
    end;

    var
        Text000Err: Label 'Total Quantity should be equal to Quantity Received.';
        Text001Err: Label 'All Inspection Data Sheets for Posted Purchase Receipt No. %1 and Line No. %2 are not posted.', Comment = '%1 = Receipt No.; %2 = Purch Line No';
        Text002Err: Label 'There is nothing to post.';
        Text003Err: Label '%1  is not equal to the quantities in the Inspection Acceptance Levels.', Comment = '%1 = Qty Rework.';


    procedure RunCheck(var InspectReceipt: Record "Inspection Receipt Header B2B");
    var
        InspectDataSheet: Record "Ins Datasheet Header B2B";
    begin
        if InspectReceipt."No." = '' then
            ERROR(Text002Err);
        InspectReceipt.TESTFIELD(Status, false);
        InspectReceipt.TESTFIELD("Posting Date");

        if InspectReceipt."Source Type" = InspectReceipt."Source Type"::"In Bound" then begin
            if InspectDataSheet."Quality Before Receipt" then
                InspectDataSheet.SETRANGE("Order No.", InspectReceipt."Order No.")
            else
                InspectDataSheet.SETRANGE("Receipt No.", InspectReceipt."Receipt No.");
            InspectDataSheet.SETRANGE("Purch. Line No", InspectReceipt."Purch Line No");
            InspectDataSheet.SETRANGE("Purchase Consignment No.", InspectReceipt."Purchase Consignment");
            InspectDataSheet.SETRANGE("Lot No.", InspectReceipt."Lot No.");
        end else begin
            InspectDataSheet.SETRANGE("Prod. Order No.", InspectReceipt."Prod. Order No.");
            InspectDataSheet.SETRANGE("Prod. Order Line", InspectReceipt."Prod. Order Line");
            InspectDataSheet.SETRANGE("Production Batch No.", InspectReceipt."Production Batch No.");
        end;
        //if InspectDataSheet.FIND('-') then
        if not InspectDataSheet.IsEmpty() then
            ERROR(Text001Err, InspectReceipt."Receipt No.", InspectReceipt."Purch Line No");
        CheckQualityAcceptanceLevels(InspectReceipt);
        if InspectReceipt.Quantity <> InspectReceipt."Qty. Accepted" + InspectReceipt."Qty. Rejected" +
                                      InspectReceipt."Qty. Rework" + InspectReceipt."Qty. Accepted Under Deviation"
        then
            ERROR(Text000Err);
        if InspectReceipt."Qty. Accepted Under Deviation" <> 0 then
            InspectReceipt.TESTFIELD(InspectReceipt."Qty. Accepted UD Reason");
    end;

    procedure CheckQualityAcceptanceLevels(InspectRcpt: Record "Inspection Receipt Header B2B");
    var
        InspectAcptLevel: Record "IR Acceptance Levels B2B";
    begin
        InspectAcptLevel.SETRANGE(InspectAcptLevel."Inspection Receipt No.", InspectRcpt."No.");
        InspectAcptLevel.SETCURRENTKEY("Quality Type", Quantity);

        InspectAcptLevel.SETRANGE("Quality Type", InspectAcptLevel."Quality Type"::Accepted);
        InspectAcptLevel.CALCSUMS(Quantity);
        if InspectRcpt."Qty. Accepted" <> InspectAcptLevel.Quantity then
            ERROR(Text003Err, InspectRcpt.FIELDCAPTION("Qty. Accepted"));

        InspectAcptLevel.SETRANGE("Quality Type", InspectAcptLevel."Quality Type"::"Accepted Under Deviation");
        InspectAcptLevel.CALCSUMS(Quantity);
        if InspectRcpt."Qty. Accepted Under Deviation" <> InspectAcptLevel.Quantity then
            ERROR(Text003Err, InspectRcpt.FIELDCAPTION("Qty. Accepted Under Deviation"));

        InspectAcptLevel.SETRANGE("Quality Type", InspectAcptLevel."Quality Type"::Rework);
        InspectAcptLevel.CALCSUMS(Quantity);
        if InspectRcpt."Qty. Rework" <> InspectAcptLevel.Quantity then
            ERROR(Text003Err, InspectRcpt.FIELDCAPTION("Qty. Rework"));

        InspectAcptLevel.SETRANGE("Quality Type", InspectAcptLevel."Quality Type"::Rejected);
        InspectAcptLevel.CALCSUMS(Quantity);
        if InspectRcpt."Qty. Rejected" <> InspectAcptLevel.Quantity then
            ERROR(Text003Err, InspectRcpt.FIELDCAPTION("Qty. Rejected"));
    end;
}


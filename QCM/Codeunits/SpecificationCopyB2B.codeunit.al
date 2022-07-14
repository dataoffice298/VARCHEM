codeunit 33000260 "Specification-Copy B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    TableNo = "Production BOM Header";

    trigger OnRun();
    begin
    end;

    var
        Text000Err: Label 'The %1 cannot be copied to itself.', comment = '%1 = TableCaption';
        Text001Err: Label '%1 on %2 %3 must not be %4', comment = '%1 = Status ;%2 = TABLECAPTION ; %3 = SpecID  ; %4 = status';
        Text002Err: Label '%1 on %2 %3 %4 must not be %5', comment = '%1 = ;%2 = ;%3 = ; %4 = ; %5 = ';

    procedure CopySpec(SpecHeaderNo: Code[20]; FromVersionCode: Code[20]; CurrentSpecHeader: Record "Specification Header B2B"; ToVersionCode: Code[20]);
    var

        ToSpecLine: Record "Specification Line B2B";
        SpecVersion: Record "Specification Version B2B";
    begin
        if (CurrentSpecHeader."Spec ID" = SpecHeaderNo) and
           (FromVersionCode = ToVersionCode)
        then
            ERROR(Text000Err, CurrentSpecHeader.TABLECAPTION());

        if ToVersionCode = '' then begin
            if CurrentSpecHeader.Status = CurrentSpecHeader.Status::Certified then
                ERROR(
                  Text001Err,
                  CurrentSpecHeader.FIELDCAPTION(Status),
                  CurrentSpecHeader.TABLECAPTION(),
                  CurrentSpecHeader."Spec ID",
                  CurrentSpecHeader.Status);
        end else begin
            SpecVersion.GET(CurrentSpecHeader."Spec ID", ToVersionCode);
            if SpecVersion.Status = SpecVersion.Status::Certified then
                ERROR(
                  Text002Err,
                  SpecVersion.FIELDCAPTION(Status),
                  SpecVersion.TABLECAPTION(),
                  SpecVersion."Specification No.",
                  SpecVersion."Version Code",
                  SpecVersion.Status);
        end;

        ToSpecLine.SETRANGE("Spec ID", CurrentSpecHeader."Spec ID");
        ToSpecLine.SETRANGE("Version Code", ToVersionCode);
        ToSpecLine.DELETEALL();

        FromSpecLine.reset();
        FromSpecLine.SETRANGE("Spec ID", SpecHeaderNo);
        FromSpecLine.SETRANGE("Version Code", FromVersionCode);

        if FromSpecLine.FIND('-') then
            repeat
                ToSpecLine := FromSpecLine;
                ToSpecLine."Spec ID" := CurrentSpecHeader."Spec ID";
                ToSpecLine."Version Code" := ToVersionCode;
                ToSpecLine.INSERT();
            until FromSpecLine.NEXT() = 0;
    end;

    procedure CopyFromVersion(var SpecVersionList2: Record "Specification Version B2B");
    var
        SpecHeader: Record "Specification Header B2B";
        OldSpecVersionList: Record "Specification Version B2B";
    begin
        OldSpecVersionList := SpecVersionList2;

        SpecHeader."Spec ID" := SpecVersionList2."Specification No.";
        if PAGE.RUNMODAL(0, SpecVersionList2) = ACTION::LookupOK then begin
            if OldSpecVersionList.Status = OldSpecVersionList.Status::Certified then
                ERROR(
                  Text002Err,
                  OldSpecVersionList.FIELDCAPTION(Status),
                  OldSpecVersionList.TABLECAPTION(),
                  OldSpecVersionList."Specification No.",
                  OldSpecVersionList."Version Code",
                  OldSpecVersionList.Status);
            CopySpec(SpecHeader."Spec ID", SpecVersionList2."Version Code", SpecHeader, OldSpecVersionList."Version Code");
        end;

        SpecVersionList2 := OldSpecVersionList;
    end;

    var
        FromSpecLine: Record "Specification Line B2B";
}


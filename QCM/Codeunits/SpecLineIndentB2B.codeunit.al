codeunit 33000255 "Spec Line Indent B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New CodeUnit.

    TableNo = "Specification Header B2B";

    trigger OnRun();
    begin
        if not AutoIndent then
            if not
              CONFIRM(
                STRSUBSTNO(
                  Text000Qst +
                  Text001Qst +
                  Text003Qst, rec."Spec ID"), true)
            then
                exit;

        SpecLine.SETRANGE("Spec ID", rec."Spec ID");
        SpecLine.SETRANGE("Version Code", '');
        Indent();
    end;

    var
        SpecLine: Record "Specification Line B2B";
        Text000Qst: Label 'This function updates the indentation of all the characters for specification %1. ', comment = '%1 = Spec Id';
        Text001Qst: Label 'All Characters between a Begin and the matching End are indented by one level.';
        Text003Qst: Label 'Do you want to indent the Characters?';
        Text004Msg: Label 'Indenting Characters @1@@@@@@@@@@@@@@@@@@';
        Text005Err: Label 'End %1 is missing a matching Begin.', comment = '%1 = Character Code';
        Window: Dialog;
        i: Integer;
        AutoIndent: Boolean;

    procedure Indent();
    var
        NoOfChars: Integer;
        Progress: Integer;
    begin
        Window.OPEN(Text004Msg);

        if NoOfChars = 0 then
            NoOfChars := 1;
        if SpecLine.FIND('-') then
            repeat
                Progress := Progress + 1;
                Window.UPDATE(1, 10000 * Progress div NoOfChars);

                if SpecLine."Character Type" = SpecLine."Character Type"::"End" then begin
                    if i < 1 then
                        ERROR(Text005Err, SpecLine."Character Code");
                    i := i - 1;
                end;

                SpecLine.Indentation := i;
                SpecLine.MODIFY();

                if SpecLine."Character Type" = SpecLine."Character Type"::"Begin" then
                    i := i + 1;
            until SpecLine.NEXT() = 0;
        Window.CLOSE();
    end;

    procedure ChangeStatus();
    begin
        AutoIndent := true;
    end;

    procedure IndentSpecVersion(SpecVersion: Record "Specification Version B2B");
    begin
        if not AutoIndent then
            if not
              CONFIRM(
                STRSUBSTNO(
                  Text000Qst +
                  Text001Qst +
                  Text003Qst, SpecVersion."Specification No."), true)
            then
                exit;

        SpecLine.SETRANGE("Spec ID", SpecVersion."Specification No.");
        SpecLine.SETRANGE("Version Code", SpecVersion."Version Code");
        Indent();
    end;
}


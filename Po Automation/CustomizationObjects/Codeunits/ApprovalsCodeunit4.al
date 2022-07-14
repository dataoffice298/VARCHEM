codeunit 50005 "Approvals MGt 4"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    Procedure OnSendQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendQuoteComparisionCusforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendQuoteComparisionCusforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnSendQuoteComparisionCusForApproval', '', true, true)]
    local procedure RunworkflowonsendQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendQuoteComparisionCusforApprovalCode(), QuoteComparisionCus);
    end;

    procedure RunworkflowOnCancelQuoteComparisionCusforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelQuoteComparisionCusForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnCancelQuoteComparisionCusForApproval', '', true, true)]

    local procedure RunworkflowonCancelQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelQuoteComparisionCusforApprovalCode(), QuoteComparisionCus);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryQuoteComparisionCus();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendQuoteComparisionCusforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionCussendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionCusrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryQuoteComparisionCus(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelQuoteComparisionCusforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
        end;
    end;

    procedure ISQuoteComparisionCusworkflowenabled(var QuoteComparisionCus: Record QuotCompHdr): Boolean
    begin
        if (QuoteComparisionCus.Status <> QuoteComparisionCus.Status::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(QuoteComparisionCus, RunworkflowOnSendQuoteComparisionCusforApprovalCode()));
    end;

    Procedure CheckQuoteComparisionCusApprovalsWorkflowEnabled(var QuoteComparisionCus: Record QuotCompHdr): Boolean
    begin
        IF not ISQuoteComparisionCusworkflowenabled(QuoteComparisionCus) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentQuoteComparisionCus(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        QuoteComparisionCus: Record QuotCompHdr;
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    ApprovalEntryArgument."Document No." := FORMAT(QuoteComparisionCus."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentQuoteComparisionCus(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::Open;
                    QuoteComparisionCus.Modify();

                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Open);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentQuoteComparisionCus(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::Released;
                    QuoteComparisionCus.Modify();
                    //QuoteComparisionCus.ModifyAll("Approval Status", QuoteComparisionCus."Approval Status"::Released);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Released);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalQuoteComparisionCus(RecRef: RecordRef; var IsHandled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::"Pending Approval";
                    QuoteComparisionCus.Modify();
                    //QuoteComparisionCus.ModifyAll("Approval Status", QuoteComparisionCus."Approval Status"::"Pending Approval");
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::"Pending Approval");
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryQuoteComparisionCus(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelQuoteComparisionCusforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryQuoteComparisionCus()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(QuoteComparisionCusCategoryTxt, 1, 20), CopyStr(QuoteComparisionCusCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsQuoteComparisionCus()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::QuotCompHdr, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateQuoteComparisionCus()
    begin
        InsertQuoteComparisionCusApprovalworkflowtemplate();
    end;



    local procedure InsertQuoteComparisionCusApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(QuoteComparisionCusDocOCRWorkflowCodeTxt, 1, 17), CopyStr(QuoteComparisionCusApprWorkflowDescTxt, 1, 100), CopyStr(QuoteComparisionCusCategoryTxt, 1, 20));
        InsertQuoteComparisionCusApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertQuoteComparisionCusApprovalworkflowDetails(var workflow: record Workflow);
    var
        QuoteComparisionCus: Record QuotCompHdr;
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildQuoteComparisionCustypecondition(QuoteComparisionCus.Status::Open), RunworkflowOnSendQuoteComparisionCusforApprovalCode(), BuildQuoteComparisionCustypecondition(QuoteComparisionCus.Status::"Pending Approval"), RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildQuoteComparisionCustypecondition(status: integer): Text
    var
        QuoteComparisionCus: Record QuotCompHdr;
    Begin
        QuoteComparisionCus.SetRange(Status, status);
        exit(StrSubstNo(QuoteComparisionCusTypeCondnTxt, workflowsetup.Encode(QuoteComparisionCus.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidQuoteComparisionCus(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidQuoteComparisionCus(RecordRef)
    end;

    local procedure GetConditionalcardPageidQuoteComparisionCus(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::QuotCompHdr:
                exit(page::"Quotation Comparision Doc");
        end;
    end;

    //Add QC QuoteComparisionCus Approval End  <<
    //b2besg  End

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        //b2besg  Start Variables for QC
        QuoteComparisionCussendforapprovaleventdescTxt: Label 'Approval of a QuoteComparisionCus Document is requested';
        QuoteComparisionCusCategoryDescTxt: Label 'QuoteComparisionCusDocuments';
        QuoteComparisionCusTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=QuoteComparisionCus>%1</DataItem></DataItems></ReportParameters>';
        QuoteComparisionCusrequestcanceleventdescTxt: Label 'Approval of a QuoteComparisionCus Document is Cancelled';
        QuoteComparisionCusCategoryTxt: Label 'QuoteComparisionCus specifications';
        QuoteComparisionCusDocOCRWorkflowCodeTxt: Label 'QC QuoteComparisionCus';
        QuoteComparisionCusApprWorkflowDescTxt: Label 'QuoteComparisionCus Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';



    //b2besg  End Variables for QC


}
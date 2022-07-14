page 33000273 "Vendor Item Qty Approval B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Vendor Item Quality Approval';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vendor Item Qty Approval B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    tooltip = 'enter the item number';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    tooltip = 'which data planning and manufacturing that is starting data';
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    tooltip = 'which data complete production that is ending data to delivery data ';
                }
                field("Certified Agency"; Rec."Certified Agency")


                {
                    ApplicationArea = all;
                    ToolTip = 'This Field Defines certified Vendors';
                }
                field("Attachment.HASVALUE"; Attachment.HASVALUE())
                {
                    AssistEdit = true;
                    Caption = 'Attachment';
                    ApplicationArea = all;
                    ToolTip = 'It allows to attach Related Documents';
                    trigger OnAssistEdit();
                    begin
                        /*
                         if Attachment.HASVALUE() then begin
                            QualityAttachmentMgt.SetVendorItemApproval(Rec);
                             QualityAttachmentMgt.OpenAttachment();
                         end;
                         */
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if Rec."Item No." <> '' then
            Rec.CALCFIELDS(Attachment);
    end;

    var
    //QualityAttachmentMgt: Codeunit QualityAttachmentManagement;
}


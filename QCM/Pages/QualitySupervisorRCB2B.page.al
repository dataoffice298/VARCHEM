page 33000299 "Quality Supervisor RC B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Supervisor RC';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1102154011)
            {
                part(Control1102154010; "Qty Supervisor Activities B2B")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154009; Outlook)
                {
                    ApplicationArea = all;
                }
            }
            group(Control1102154008)
            {
                part("<Trailing Inspection Receipts Chart>"; "Trailing IR Chart B2B")
                {
                    ApplicationArea = all;
                }
                part(Control1102154007; "My Vendors")
                {
                    ApplicationArea = all;
                }
                part(Control1102154000; "My Items")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154002; MyNotes)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&InspectionReceipts")
            {
                Caption = 'Inspection Receipts';
                RunObject = Report "Inspection Receipt B2B";
                ApplicationArea = all;
                tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
            }
            action("Inspection Data Sheet")
            {
                Caption = 'Inspection Data Sheet';
                RunObject = Report "Inspection Data Sheet B2B";
                ApplicationArea = all;
                tooltip = 'the Quality department carry out the quality activities by using the ID';
            }
        }
        area(embedding)
        {
            action("InspectionReceipts")
            {
                Caption = 'Inspection Receipts';
                RunObject = Page "Inspection Receipt List B2B";
                ApplicationArea = all;
                tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                action("<Action1102154004>")
                {
                    Caption = 'Posted Inspection Receipts';
                    RunObject = Page "Posted Ins Receipt List B2B";
                    ApplicationArea = all;
                    tooltip = ' Posted Inspection Receipts used for reporting and vendor analysis';
                }
                action("PostedInspectionDataSheets")
                {
                    Caption = 'Posted Inspection Data Sheets';
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                }
            }
        }
    }
}


page 33000298 "Quality Inspector RC B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Inspector RC';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1102154010)
            {
                part(Control1102154009; "Qty Inspector Activities B2B")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154008; Outlook)
                {
                    ApplicationArea = all;
                }
            }
            group(Control1102154007)
            {
                part("Trailing Inspection Datasheets Chart"; "Trailing IDS Chart B2B")
                {
                    ApplicationArea = all;
                }
                part(Control1102154006; "My Vendors")
                {
                    ApplicationArea = all;
                }
                part(Control1102154002; "My Items")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154000; MyNotes)
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
            action("&InspectionDataSheet")
            {
                Caption = 'Inspection Data Sheet';
                RunObject = Report "Inspection Data Sheet B2B";
                ApplicationArea = all;
                ToolTip = 'the Quality department carry out the quality activities by using the IDS';
            }
        }
        area(embedding)
        {
            action("InspectionDatasheet")
            {
                Caption = 'Inspection Datasheet';
                RunObject = Page "Inspection Data Sheet List B2B";
                ApplicationArea = all;
                tooltip = 'the Quality department carry out the quality activities by using the IDS';
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                action("<Action1102154004>")
                {
                    Caption = 'Posted Inspection Datasheet';
                    RunObject = Page "Posted Ins DataSheet List B2B";
                    ApplicationArea = all;
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                }
                /*
                separator(Separator1102154005)
                {
                    IsHeader = true;
                }
                */

            }
        }
    }
}


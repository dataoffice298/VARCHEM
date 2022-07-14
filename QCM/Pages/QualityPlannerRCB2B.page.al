page 33000297 "Quality Planner RC B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Quality Planner RC';
    PageType = RoleCenter;


    layout
    {
        area(rolecenter)
        {
            group(Control1102154001)
            {
                part(Control1102154015; "Quality Planner Activities B2B")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154010; Outlook)
                {
                    ApplicationArea = all;
                }
            }
            group(Control1102154011)
            {
                part("<Trailing Inspection Datasheets Chart>"; "Trailing IDS Chart B2B")
                {
                    ApplicationArea = all;
                }
                part(Control1102154013; "My Vendors")
                {
                    ApplicationArea = all;
                }
                part(Control1102154012; "My Items")
                {
                    ApplicationArea = all;
                }
                systempart(Control1102154014; MyNotes)
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
            action(Specifications)
            {
                Caption = 'Specifications';
                RunObject = Report "Specification B2B";
                ApplicationArea = all;
                tooltip = 'Specification is a group of characteristics to be inspected of an item';
            }
        }
        area(embedding)
        {
            action("Specification")
            {
                Caption = 'Specification';
                RunObject = Page "Specification List B2B";
                ApplicationArea = all;
                tooltip = 'Specification is a group of characteristics to be inspected of an item';
            }
            action("Sub Assembly")
            {
                Caption = 'Sub Assembly';
                RunObject = Page "Sub Assembly List B2B";
                ApplicationArea = all;
                tooltip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
            }
            action("SamplingPlan")
            {
                Caption = 'Sampling Plan';
                RunObject = Page "Sampling Plan List B2B";
                ApplicationArea = all;
                tooltip = ' sampling plan that is applicable to the set of characters to be inspected by the inspection group';
            }
            action("InspectionGroups")
            {
                Caption = 'Inspection Groups';
                RunObject = Page "Inspection Groups B2B";
                ApplicationArea = all;
                tooltip = 'Inspection Groups are different Quality Inspection Department';
            }
            action("Characterstics")
            {
                Caption = 'Characterstics';
                RunObject = Page "Characteristics B2B";
                ApplicationArea = all;
                tooltip = 'Characteristics are attributes/properties of an Item';
            }
            action("QualityReasionCodes")
            {
                Caption = 'Quality Reasion Codes';
                RunObject = Page "Quality Reason Codes B2B";
                ApplicationArea = all;
                tooltip = 'The Quality Reason Codes are normally used during the Quality Operations';
            }
            action("AcceptanceLevels")
            {
                Caption = 'Acceptance Levels';
                RunObject = Page "Acceptance Levels B2B";
                ApplicationArea = all;
                tooltip = 'The Acceptance Level for each type viz., Accepted and Rejected ';
            }
        }
        area(sections)
        {
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("&Specification")
            {
                Caption = 'Specification';
                RunObject = Page "Specifications B2B";
                ApplicationArea = all;
                tooltip = 'Specification is a group of characteristics to be inspected of an item';
            }
            action("SubAssembly")
            {
                Caption = 'Sub Assembly';
                RunObject = Page "Sub Assembly Card B2B";
                ApplicationArea = all;
                tooltip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
            }
            action("&SamplingPlan")
            {
                Caption = 'Sampling Plan';
                RunObject = Page "Sampling Plan B2B";
                ApplicationArea = all;
                tooltip = ' Sampling Plan can be attached to any number of Assays ';
            }
        }
    }
}


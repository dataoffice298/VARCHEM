page 33000305 "Quality Control RC All B2B"
{
    Caption = 'QC and PO Automation RC';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(LayoutGroup)
            {
                part(Part1; 33000296)
                {
                    ApplicationArea = all;
                }
                part(Part5; 33000295)
                {
                    ApplicationArea = all;
                }
                part(Part6; 33000294)
                {
                    ApplicationArea = all;
                }
            }
            group(Grouop2)
            {
                part(part2; 9151)
                {
                    ApplicationArea = all;
                }
                part(Part3; 9152)
                {
                    ApplicationArea = all;
                }
                systempart(part4; MyNotes)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            group("PO Automation")
            {
                action("Indents")
                {
                    ApplicationArea = All;
                    tooltip = 'all Indents see for list';
                    Image = Task;
                    RunObject = page "Indent List";
                }
                action("Indents Req. Lists")
                {
                    ApplicationArea = All;
                    tooltip = 'all Indent Req. see for list';
                    Image = Task;
                    RunObject = page 50023;
                }
                action("Purchase Enquiry")
                {
                    ApplicationArea = All;
                    tooltip = 'all Purchase Enquiries see for list';
                    Image = Task;
                    RunObject = page "Purchase Enquiry List";
                }
                action("Purchase Quotes")
                {
                    ApplicationArea = All;
                    tooltip = 'all Purchase Quotes see for list';
                    Image = Task;
                    RunObject = page "Purchase Quotes";
                }
                action("Quotation Comparision")
                {
                    ApplicationArea = All;
                    tooltip = 'Quotation comparision to commpare Quotes';
                    Image = Task;
                    RunObject = page "Quotation Comparison";
                    Visible = false;
                }
                action("Quotation Comparision New")
                {
                    ApplicationArea = All;
                    tooltip = 'Quotation comparision to commpare Quotes';
                    Image = Task;
                    Caption = 'Quotation Comparison';
                    RunObject = page "Quotation Comparisions";
                }
                action("Purchase Orders")
                {
                    ApplicationArea = All;
                    tooltip = 'all Purchase Orders see for list';
                    Image = Task;
                    RunObject = page "Purchase Order List";//PKON22M26
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = All;
                    tooltip = 'all Posted Purchase Receipts see for list';
                    Image = Task;
                    RunObject = page "Posted Purchase Receipts";
                }
            }
            group("Quality Control")
            {
                action("Specification List")
                {
                    ApplicationArea = All;
                    tooltip = 'all specification see for list';
                    Image = Task;
                    RunObject = page "Specification List B2B";
                }
                action("Sub Assembly ")
                {
                    ApplicationArea = All;
                    tooltip = 'sub Assembly is assigned to a production item for performing Quality inspection at a particular step in the manufacturing, referred to as Routing line';
                    Image = Task;
                    RunObject = page "Sub Assembly List B2B";
                }
                action("Inspection Receipt")
                {
                    ApplicationArea = All;
                    tooltip = 'Inspection receipt through which the user actually accepts, rejects or sends for rework';
                    Image = Task;
                    RunObject = page "Inspection Receipt B2B";
                }
                action("Inspection Data Sheet")
                {
                    ApplicationArea = All;
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                    Image = Task;
                    RunObject = page "Inspection Data Sheet List B2B";
                }
                /* action("Purchase Order")
                 {
                     ApplicationArea = All;
                     tooltip = 'Create a new Purchase Order. Select an item, which is QC enabled and check for the approval of vendors for that particular ite';
                     Image = Purchase;
                     RunObject = page "Purchase Orders";
                 }*///PKON22M26
            }
            group(History)
            {
                action("Posted Inspect. Receipt")
                {
                    ApplicationArea = All;
                    tooltip = 'Posted Inspection Receipts used for reporting and vendor analysis';
                    Image = Task;
                    RunObject = page "Posted Ins Receipt List B2B";
                }
                action("Posted Inspect Data Sheet List")
                {
                    ApplicationArea = All;
                    tooltip = 'posted inspection data sheet list used for reporting and vendor analysis';
                    Image = Task;
                    RunObject = page "Posted Ins DataSheet List B2B";
                }
            }
            group(Setups)
            {
                action("Quality Control Setup")
                {
                    ApplicationArea = All;
                    tooltip = 'The characteristic used for calculating Assay & Moisture need to be specified in Quality control setup';
                    Image = Task;
                    RunObject = page "Quality Control Setup B2B";
                }
                action("Inspection Groups")
                {
                    ApplicationArea = All;
                    tooltip = 'Inspection Groups are different Quality Inspection Department';
                    Image = Task;
                    RunObject = page "Inspection Groups B2B";
                }
                action("Sampling Plan List")
                {
                    ApplicationArea = All;
                    tooltip = 'Sampling Plan can be defined as the plan to draw the number of samples to inspect at each Characteristic leve';
                    Image = Task;
                    RunObject = page "Sampling Plan List B2B";
                }
                action("Characteristics")
                {
                    ApplicationArea = All;
                    tooltip = 'Characteristics in the system are attributes of an Item';
                    Image = Task;
                    RunObject = page "Characteristics B2B";
                }
                action("Quality Reason Codes")
                {
                    ApplicationArea = All;
                    tooltip = 'The Quality Reason Codes are normally used during the Quality Operations';
                    Image = Task;
                    RunObject = page "Quality Reason Codes B2B";
                }
                action("Assay List")
                {
                    ApplicationArea = All;
                    tooltip = 'Define Assay characteristic list';
                    Image = Task;
                    RunObject = page "Assay List B2B";
                }
                action("Acceptance Levels")
                {
                    ApplicationArea = All;
                    tooltip = 'The Acceptance Level for each type viz., Accepted and Rejecte';
                    Image = Task;
                    RunObject = page "Acceptance Levels B2B";
                }
            }
        }
        area(Reporting)
        {
            group("Reports & Analysis")
            {
                action("Inspection Data Sheets")
                {
                    ApplicationArea = All;
                    tooltip = 'the Quality department carry out the quality activities by using the IDS';
                    Image = Report;
                    RunObject = report "Inspection Data Sheet B2B";
                }
                action("Posted Inspection Data Sheet")
                {
                    ApplicationArea = All;
                    tooltip = 'posted inspection data sheet  used for reporting and vendor analysis';
                    Image = Report;
                    RunObject = report "Posted Ins Data Sheet B2B";
                }
                action("Specification")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                    Image = Report;
                    RunObject = report "Specification B2B";
                }
                action("Inspection Receipt Report")
                {
                    ApplicationArea = all;
                    tooltip = 'Inspection Receipts used for reporting and vendor analysis';
                    Image = Report;
                    RunObject = report "Inspection Receipt B2B";
                }
                action("Receipt - Qty Received Status")
                {
                    ApplicationArea = all;
                    tooltip = 'order to receive to mention the status';
                    Image = Report;
                    RunObject = report "Receipt-Qty Rec Status B2B";
                }
                action("Item Receipt")
                {
                    ApplicationArea = all;
                    tooltip = 'which item in and out mention the item receipt';
                    Image = Report;
                    RunObject = report "Item Receipt B2B";
                }
                action("Vendor Item Qc Analysis")
                {
                    ApplicationArea = all;
                    tooltip = 'which vendor item Qc analysis the maintain the reports';
                    Image = Report;
                    RunObject = report "Vendor Item Qc Analysis B2B";
                }
                action("Item Vendor Qc Analysis")
                {
                    ApplicationArea = all;
                    tooltip = 'which vendor item Qc analysis the maintain the reports';
                    Image = Report;
                    RunObject = report "Item Vendor Qc Analysis B2B";
                }
                action("Vendor Rating")
                {
                    ApplicationArea = all;
                    tooltip = 'Specify the rating points for Vendor according to the fields available as Vendor Rating';
                    Image = Report;
                    RunObject = report "Vendor Rating B2B";
                }
                action("Inspection Receipt List")
                {
                    ApplicationArea = all;
                    tooltip = 'inspection receipt analysis the reports';
                    Image = Report;
                    RunObject = report "Inspection Receipt List B2B";
                }
                action("Items In Quality")
                {
                    ApplicationArea = all;
                    tooltip = 'which item to quality';
                    Image = Report;
                    RunObject = report "Items In Quality B2B";
                }
                action("Daily Inspection Data Sheet")
                {
                    ApplicationArea = all;
                    tooltip = 'some item to testing the daily inspection data sheet maintain the process';
                    Image = Report;
                    RunObject = report "Daily Ins Data Sheet B2B";
                }

            }
        }

    }
}


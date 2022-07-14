page 33000255 "Specification List B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Specification List';
    CardPageID = "Specifications B2B";
    Editable = false;
    PageType = List;
    SourceTable = "Specification Header B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = all;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    tooltip = 'Description for Identification purpose for  the user';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102154004; Notes)
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Specification")
            {
                Caption = '&Specification';
                ToolTip = ' list of all the specifications defined in the system ';
                action("<Action1102154000>")
                {
                    Caption = 'Co&mments';
                    ToolTip = 'The user can add comments to a specification ';
                    Image = ViewComments;
                    RunObject = Page "Quality Comment Sheet B2B";
                    RunPageLink = Type = CONST(Specification),
                                  "No." = FIELD("Spec ID");
                    ApplicationArea = all;
                }
                action("<Action1102154001>")
                {
                    Caption = '&Specification Version';
                    ToolTip = ' list of all the specifications defined in the system change inspection specification chacteristic';
                    Image = BOMVersions;
                    RunObject = Page "Specification Version List B2B";
                    RunPageLink = "Specification No." = FIELD("Spec ID");
                    RunPageOnRec = false;
                    ApplicationArea = all;
                }
            }
        }
        area(reporting)
        {
            action("<Action1901845606>")
            {
                Caption = 'Specification';
                ToolTip = ' list of all the specifications defined in the system ';
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = "Report";
                RunObject = Report "Specification B2B";
                ApplicationArea = all;
            }
        }
    }
}


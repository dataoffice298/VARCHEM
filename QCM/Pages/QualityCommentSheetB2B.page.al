page 33000290 "Quality Comment Sheet B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    AutoSplitKey = true;
    Caption = 'Quality Comment Sheet';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Quality Comment Line B2B";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    tooltip = 'mention the date';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                    tooltip = 'The user can add comments to a Material Receipt';
                }
                field("Code"; Rec.Code)
                {
                    Visible = false;
                    ApplicationArea = all;
                    tooltip = 'enter the word,letter,numbers';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            // Caption = '<Action1102154000>';
            group("<Action1102154001>")
            {
                Caption = '&Comment';
                tooltip = 'The user can add comments to a Material Receipt';
                action("&Comment")
                {
                    Caption = 'List';
                    Image = Comment;
                    tooltip = 'total items list of the process';
                    RunObject = Page "Quality Comment List B2B";
                    RunPageLink = Type = FIELD(Type),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+L';
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.SetUpNewLine();
    end;
}


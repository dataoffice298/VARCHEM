
pageextension 33000302 "ItemcardQCExt B2B" extends "Item Card"
{
    layout
    {
        addlast(InventoryGrp)
        {

            field("Quantity Under Inspection B2B"; Rec."Quantity Under Inspection B2B")
            {
                ApplicationArea = All;
                ToolTip = 'these quantities, although included in the Inventory are not available for issues for Production';
                Caption = 'Quantity Under Inspection';
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rejected';
                tooltip = 'dissatsified quantity for the inspection data sheet that is quality rejected ';
            }
            field("Quantity Rework B2B"; Rec."Quantity Rework B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Rework';
                tooltip = 'remark  items must be sent for rework to the vendor';
            }
            field("Quantity Sent for Rework B2B"; Rec."Quantity Sent for Rework B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Sent for Rework';
                tooltip = 'how much quantity send to rework';

            }

            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
                Caption = 'Quantity Accepted';
                tooltip = 'satsified the quantity in inspection data sheet that is Quantity Accepted ';
                trigger OnDrillDown()
                var
                    ItemLedgEntry: Record 32;
                    QualityItemLedgEntry: Record 33000262;
                begin
                    // Start  B2BQC1.00.00 - 01 Open respected Item Ledger Entries
                    Rec.CALCFIELDS("Quantity Under Inspection B2B", "Quantity Rejected B2B", "Quantity Rework B2B", "Quantity Sent for Rework B2B");
                    IF (Rec."QC Enabled B2B" = TRUE) OR (Rec."WIP QC Enabled B2B" = TRUE) THEN
                        IF (Rec."Quantity Under Inspection B2B" = 0) AND (Rec."Quantity Rejected B2B" = 0) AND (Rec."Quantity Rework B2B" = 0) AND (Rec."Quantity Sent for Rework B2B" = 0) THEN BEGIN
                            ItemLedgEntry.SETRANGE("Item No.", Rec."No.");
                            ItemLedgEntry.SETRANGE(Open, TRUE);
                            PAGE.RUNMODAL(38, ItemLedgEntry);
                        END ELSE BEGIN
                            ItemLedgEntry.RESET();
                            ItemLedgEntry.SETRANGE("Item No.", Rec."No.");
                            ItemLedgEntry.SETRANGE(Open, TRUE);
                            IF ItemLedgEntry.FIND('-') THEN
                                REPEAT
                                    ItemLedgEntry.MARK(TRUE);
                                    IF QualityItemLedgEntry.GET(ItemLedgEntry."Entry No.") THEN
                                        ItemLedgEntry.MARK(FALSE);
                                UNTIL ItemLedgEntry.NEXT() = 0;
                            ItemLedgEntry.MARKEDONLY(TRUE);
                            PAGE.RUNMODAL(38, ItemLedgEntry);
                        END;
                END;

                // Stop   B2BQC1.00.00 - 01                        
            }
        }
        addafter(InventoryGrp)
        {
            group("Quality B2B")
            {
                Caption = 'Quality';
                field("Spec ID B2B"; Rec."Spec ID B2B")
                {
                    ApplicationArea = All;
                    tooltip = 'Specification is a group of characteristics to be inspected of an item';
                    Caption = 'Spec ID';

                }
                field("QC Enabled B2B"; Rec."QC Enabled B2B")
                {
                    ApplicationArea = All;
                    Caption = 'QC Enabled';
                    tooltip = 'In bound Inspection Data Sheets are created only if the item is QC Enabled';

                }
                field("Rejection Location B2B"; Rec."Rejection Location B2B")
                {
                    ApplicationArea = All;
                    Caption = 'Rejection Location';
                    tooltip = ' The quality rejected items are stored in this location';
                }
                field("WIP Spec ID B2B"; Rec."WIP Spec ID B2B")
                {
                    ApplicationArea = All;
                    Caption = 'WIP Spec ID';
                    tooltip = 'Specification is a group of characteristics to be inspected of an item WIP spec ID';

                }
                field("WIP QC Enabled B2B"; Rec."WIP QC Enabled B2B")
                {
                    ApplicationArea = All;
                    Caption = 'WIP QC Enabled';
                    tooltip = 'work in process Inspection Data Sheets are created only if the item is WIP QC Enabled';

                }
                field("Lots Accept B2B"; Rec."Lots Accept B2B")
                {
                    ApplicationArea = All;
                    Caption = 'Lots Accept';
                    ToolTip = 'Defines Accepted Lots  ';


                }

            }
        }

    }
    actions
    {

        addlast(Entries)
        {
            action("QualityLedgerentries B2B")
            {
                Caption = '&QualityLedgerentries';
                RunObject = page "Quality Ledger Entries B2B";
                RunPageLink = "Item No." = field("No.");
                Image = ItemLedger;
                ApplicationArea = all;
                ToolTip = 'When IR Posted Quality Ledger Entries created with Reclassified Quantities and Locations ';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Start  B2BQC1.00.00 - 01 Calculate Quantity accepted field

        IF (Rec."QC Enabled B2B" = TRUE) AND (Rec.Inventory >= 0) THEN
            Rec."Quantity Accepted B2B" := Rec.Inventory - (Rec."Quantity Rejected B2B" + Rec."Quantity Under Inspection B2B" + Rec."Quantity Rework B2B" +
                                                Rec."Quantity Sent for Rework B2B");
        // Stop   B2BQC1.00.00 - 01
    End;
}

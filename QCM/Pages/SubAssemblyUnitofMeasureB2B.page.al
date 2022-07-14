page 33000286 "Sub Assembly UnitofMeasure B2B"
{
    // version B2BQC1.00.00

    // *******************************************************************************
    // B2B     : B2B Software Technologies
    // Project : Quality Control Addon
    // *******************************************************************************
    // VER           SIGN       DATE         DESCRIPTION
    // *******************************************************************************
    // 1.00.00       B2BQC      06-05-15     New Page.

    Caption = 'Sub Assembly Unit of Measure';
    PageType = List;
    SourceTable = "Sub Ass Unit of Measure B2B";
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Sub Assembly No."; Rec."Sub Assembly No.")
                {
                    Caption = 'Sub Assembly No.';
                    ApplicationArea = all;
                    tooltip = 'enter the sub assembly number  selected the no.series from  quality setup numbering tab ';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    tooltip = 'enter the words, letter,number';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = all;
                    tooltip = 'Qty. per unit of measure of the items';
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = all;
                    tooltip = 'length is a measured distance point to point  the object ';
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = all;
                    tooltip = 'width is a measurement of distance by side to side ';
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = all;
                    tooltip = 'height is measure vertical distance bottom to top';
                }
                field(Cubage; Rec.Cubage)
                {
                    ApplicationArea = all;
                    tooltip = 'cubic capacity of a container,or vessel,expressed as cubic centimeter cubic meter';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = all;
                    tooltip = 'the amount of quantity of heaviness or mass,amount athing weight';
                }
            }
        }
    }

    actions
    {
    }
}


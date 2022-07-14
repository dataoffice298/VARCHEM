tableextension 33000261 "WarehouseActivityLineExt B2B" extends "Warehouse Activity Line"
{
    // version NAVW111.00.00.27667,B2BQC1.00.00

    fields
    {
        field(33000250; "Quantity Accepted B2B"; Decimal)
        {
            Caption = 'Quantity Accepted';
            DataClassification = CustomerContent;
        }
        field(33000251; "Quantity Rework B2B"; Decimal)
        {
            Caption = 'Quantity Rework';
            DataClassification = CustomerContent;
        }
        field(33000252; "Quantity Rejected B2B"; Decimal)
        {
            Caption = 'Quantity Rejected';
            DataClassification = CustomerContent;
        }
        field(33000253; "Qty. Sending to Quality B2B"; Decimal)
        {
            Caption = 'Qty. Sending to Quality';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(33000254; "Qty. Sent to Quality B2B"; Decimal)
        {
            Caption = 'Qty. Sent to Quality';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}


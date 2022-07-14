tableextension 33000253 "PostedWhseReceiptLineExt B2B" extends "Posted Whse. Receipt Line"
{
    // version NAVW111.00,B2BQC1.00.00

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
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}


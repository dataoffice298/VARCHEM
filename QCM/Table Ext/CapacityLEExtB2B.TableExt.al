tableextension 33000250 "CapacityLEExt B2B" extends "Capacity Ledger Entry"
{
    // version NAVW111.00.00.28629,B2BQC1.00.00

    fields
    {
        field(33000250; "After Inspection B2B"; Boolean)
        {
            Caption = 'After Inspection';
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}


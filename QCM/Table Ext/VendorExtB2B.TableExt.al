tableextension 33000260 "VendorExt B2B" extends Vendor
{
    // version NAVW111.00.00.27667,B2BQC1.00.00

    fields
    {
        field(33000250; "Rework Location B2B"; Code[10])
        {
            Caption = 'Rework Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}


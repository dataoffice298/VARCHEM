tableextension 33000259 "ReturnShipmentHeaderExt B2B" extends "Return Shipment Header"
{
    // version NAVW111.00.00.20783,B2BQC1.00.00

    fields
    {
        field(33000250; "Inspection Receipt No. B2B"; Code[20])
        {
            Caption = 'Inspection Receipt No.';
            TableRelation = "Inspection Receipt Header B2B"."No.";
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}


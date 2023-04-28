tableextension 50028 TrackingSpecificationExtension extends "Tracking Specification"
{
    fields
    {
        field(50000; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
    }

    var
        myInt: Integer;
}
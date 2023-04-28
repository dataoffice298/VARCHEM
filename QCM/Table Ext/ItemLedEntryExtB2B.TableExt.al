tableextension 33000263 "ItemLedEntryExt B2B" extends "Item Ledger Entry"
{
    fields
    {
        field(33000251; "QLE No. B2B"; Integer)
        {
            Caption = 'QLE No.';
            DataClassification = CustomerContent;
        }
        field(50000; "Vendor Lot No_B2B"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Lot No.';
        }
    }
    var
}
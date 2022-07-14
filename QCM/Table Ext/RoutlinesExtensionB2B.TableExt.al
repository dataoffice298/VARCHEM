tableextension 33000296 "RoutlinesExtension B2B" extends "Routing Line"
{
    fields
    {
        field(33000254; "QC Enabled B2B"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                Rec.TESTFIELD("Sub Assembly B2B");
                REc.TESTFIELD("Spec ID B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000253; "Spec ID B2B"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header b2B";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                Rec.TESTFIELD("Sub Assembly B2B");
                IF "Spec ID B2B" = '' THEN
                    "QC Enabled B2B" := FALSE;

                // Stop   B2BQC1.00.00 - 01
            end;
        }

        field(33000250; "Sub Assembly B2B"; Code[20])
        {
            Caption = 'Sub Assembly';
            TableRelation = "Sub Assembly b2b";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                IF "Sub Assembly B2B" = '' THEN BEGIN
                    "Sub Assembly UOM Code B2B" := '';
                    "Spec ID B2B" := '';
                    "QC Enabled B2B" := FALSE;
                    "Qty. Produced B2B" := 0;
                END ELSE BEGIN
                    Subassembly.GET("Sub Assembly B2B");
                    "Sub Assembly UOM Code B2B" := Subassembly."Unit of Measure Code";
                    "Spec ID B2B" := Subassembly."Spec ID";
                    "QC Enabled B2B" := Subassembly."QC Enabled";
                    "Sub Assembly Description B2B" := Subassembly.Description;
                END;

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000251; "Qty. Produced B2B"; Decimal)
        {
            Caption = 'Qty. Produced';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                Rec.TESTFIELD("Sub Assembly B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000252; "Sub Assembly UOM Code B2B"; Code[20])
        {
            Caption = 'Sub Assembly UOM Code';
            DataClassification = CustomerContent;
            TableRelation = "Sub Ass Unit of Measure B2B".Code WHERE("Sub Assembly No." = FIELD("Sub Assembly B2B"));

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                REc.TESTFIELD("Sub Assembly B2B");

                // Stop   B2BQC1.00.00 - 01
            end;
        }


        field(33000255; "Sub Assembly Description B2B"; Text[30])
        {
            Caption = 'Sub Assembly Description';
            DataClassification = CustomerContent;
        }
        field(33000256; "Hourly Sample B2B"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    var
        Subassembly: Record 33000274;
}
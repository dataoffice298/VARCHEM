tableextension 33000255 "ProdOrderRoutingLine B2B" extends "Prod. Order Routing Line"
{
    // version NAVW111.00.00.27667,B2BQC1.00.00

    fields
    {



        field(33000250; "Sub Assembly B2B"; Code[20])
        {
            Caption = 'Sub Assembly';
            TableRelation = "Sub Assembly B2B";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Get the QC related values

                if "Sub Assembly B2B" = '' then begin
                    "Spec ID B2B" := '';
                    "QC Enabled B2B" := false;
                end else begin
                    SubAssembly.GET("Sub Assembly B2B");
                    "Spec ID B2B" := SubAssembly."Spec ID";
                    if "Spec ID B2B" <> '' then
                        "Spec Version Code B2B" := GetSpecVersion();
                    "QC Enabled B2B" := SubAssembly."QC Enabled";
                    "Sub Assembly Description B2B" := SubAssembly.Description;
                end;

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000251; "Quantity B2B"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(33000252; "Spec ID B2B"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header B2B";
            DataClassification = CustomerContent;
        }
        field(33000253; "QC Enabled B2B"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        field(33000254; "Sub Assembly UOM Code B2B"; Code[20])
        {
            Caption = 'Sub Assembly UOM Code';
            TableRelation = "Sub Ass Unit of Measure B2B".Code;
            DataClassification = CustomerContent;
        }
        field(33000255; "Qty. to Produce B2B"; Decimal)
        {
            Caption = 'Qty. to Produce';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Check the Quantity to produce field

                if "Qty. to Produce B2B" < 0 then
                    ERROR(Text33000250Err);
                if "Qty. to Produce B2B" + "Quantity Produced B2B" > "Quantity B2B" then
                    MESSAGE(Text33000251Msg);

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000256; "Quantity Produced B2B"; Decimal)
        {
            Caption = 'Quantity Produced';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Caluculate the Quantity to produce value

                "Qty. to Produce B2B" := "Quantity B2B" - "Quantity Produced B2B";

                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000257; "Sub Assembly Description B2B"; Text[30])
        {
            Caption = 'Sub Assembly Description';
            DataClassification = CustomerContent;
        }
        field(33000258; "Spec Version Code B2B"; Code[20])
        {
            Caption = 'Spec Version Code';
            DataClassification = CustomerContent;
        }
        field(33000259; "Quantity Sent to Quality B2B"; Decimal)
        {
            Caption = 'Quantity Sent to Quality';
            DataClassification = CustomerContent;
        }
        field(33000260; "Quantity Accepted B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B".Quantity WHERE("Source Type" = FILTER(WIP),
                                                                     "Order No." = FIELD("Prod. Order No."),
                                                                     "Order Line No." = FIELD("Routing Reference No."),
                                                                     "Entry Type" = FILTER(Accepted),
                                                                     "Operation No." = FIELD("Operation No.")));
            Caption = 'Quantity Accepted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000261; "Quantity Rejected B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B".Quantity WHERE("Source Type" = FILTER(WIP),
                                                                     "Order No." = FIELD("Prod. Order No."),
                                                                     "Order Line No." = FIELD("Routing Reference No."),
                                                                     "Entry Type" = FILTER(Reject),
                                                                     "Operation No." = FIELD("Operation No.")));
            Caption = 'Quantity Rejected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000262; "Quantity Rework B2B"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry B2B"."Remaining Quantity" WHERE("Source Type" = FILTER(WIP),
                                                                                 "Order No." = FIELD("Prod. Order No."),
                                                                                 "Order Line No." = FIELD("Routing Reference No."),
                                                                                 "Entry Type" = FILTER(Rework),
                                                                                 "Operation No." = FIELD("Operation No.")));
            Caption = 'Quantity Rework';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000263; "Newly Added Operation B2B"; Boolean)
        {
            Caption = 'Newly Added Opearation';
            DataClassification = CustomerContent;
        }
        field(33000264; "Prev. Qty B2B"; Decimal)
        {
            Caption = 'Prev. Qty';
            DataClassification = CustomerContent;
        }
    }



    procedure GetSpecVersion(): Code[20];
    var
        SpecHeader: Record 33000253;
    begin
        // Start  B2BQC1.00.00 - 01
        //Get the specification version

        EXIT(SpecHeader.GetSpecVersion("Spec ID B2B", WORKDATE(), TRUE));

        // Stop   B2BQC1.00.00 - 01
    end;

    procedure CreateInprocInspectSheet();
    var
        InspectDataSheet: Codeunit 33000251;
    begin
        // Start  B2BQC1.00.00 - 01
        //Create Inspection Datasheets

        InspectDataSheet.CreateInprocInspectDataSheet(Rec);

        // Stop   B2BQC1.00.00 - 01
    end;


    var
        SubAssembly: Record "Sub Assembly B2B";
        Text33000250Err: Label 'Quantity To Produce should not be negative.';
        Text33000251Msg: Label 'Quantity To Produce and Quantity Produced is more than Quantity.';


}


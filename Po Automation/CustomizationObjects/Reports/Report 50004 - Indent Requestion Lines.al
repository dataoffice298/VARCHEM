report 50004 "Indent Requestion Lines"
{
    // version PO



    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1102152001; "Indent Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("Released Status" = FILTER(Released));
            //RequestFilterFields = "No.", "Delivery Location";
            dataitem(DataItem1102152000; "Indent Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE("Indent Status" = CONST(Indent),
                                          "Indent Req No" = FILTER(= ''));

                trigger OnAfterGetRecord();
                begin
                    IndentRequisitions.RESET;
                    IndentRequisitions.SETRANGE("Item No.", "No.");
                    IndentRequisitions.SETRANGE("Variant Code", "Variant Code");
                    IndentRequisitions.SETRANGE("Location Code", "Delivery Location");
                    IndentRequisitions.SETRANGE("Vendor No.", "Vendor No.");
                    IndentRequisitions.SETRANGE("Document No.", IndentReqHeader."No.");
                    IF IndentRequisitions.FIND('-') THEN BEGIN
                        IndentRequisitions.Quantity += "Quantity (Base)";
                        IndentRequisitions."Qty. To Order" += "Quantity (Base)";
                        IndentRequisitions."Remaining Quantity" += "Quantity (Base)";
                        //B2B.1.3 S
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN;
                        //IndentRequisitions."Vendor Min.Ord.Qty" := ItemVendorGvar."Vendor Min.Ord.Qty"; B2B1.1
                        IndentRequisitions.MODIFY;
                        /*if IndentReqHeader2.Get(IndentRequisitions."Document No.") then begin
                            IndentReqHeader2."Shortcut Dimension 1 Code_B2B" := DataItem1102152001."Shortcut Dimension 1 Code_B2B";
                            IndentReqHeader2."Shortcut Dimension 2 Code_B2B" := DataItem1102152001."Shortcut Dimension 2 Code_B2B";
                            IndentReqHeader2.Modify();
                            //IndentReqHeader
                        end;*/
                        //B2B.1.3 E
                    END ELSE BEGIN
                        IndentRequisitions.INIT;
                        IndentRequisitions."Document No." := IndentReqHeader."No.";
                        IndentRequisitions."Line No." := TempLineNo;
                        IndentRequisitions."Item No." := "No.";
                        IndentRequisitions.Description := Description;
                        //IF RecItem.GET(IndentRequisitions."Item No.") THEN
                        IndentRequisitions."Unit of Measure" := "Unit of Measure";
                        //  IndentRequisitions."Manufacturer Code" := "Manufacturer Code";//Divya
                        //      IndentRequisitions."Vendor Name" :=  "Indent Line"."Manufacture Name";//Divya
                        IndentRequisitions."Vendor No." := "Vendor No.";
                        IndentRequisitions."Shortcut Dimension 1 Code_B2B" := "Shortcut Dimension 1 Code_B2B";
                        IndentRequisitions."Shortcut Dimension 2 Code_B2B" := "Shortcut Dimension 2 Code_B2B";
                        //B2B.1.3 s
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN;
                        //IndentRequisitions."Vendor Min.Ord.Qty" := ItemVendorGvar."Vendor Min.Ord.Qty" ;B2B1.1
                        //B2B.1.3 E
                        IndentRequisitions.Department := Department;
                        IndentRequisitions."Variant Code" := "Variant Code";
                        IndentRequisitions."Indent No." := "Document No.";
                        IndentRequisitions."Indent Line No." := "Line No.";
                        IndentRequisitions."Indent Status" := "Indent Status";
                        IndentRequisitions.Quantity := "Req.Quantity";
                        IndentRequisitions.VALIDATE(IndentRequisitions.Quantity);//test001
                        IndentRequisitions.VALIDATE(IndentRequisitions.Quantity);
                        IndentRequisitions."Unit Cost" := "Unit Cost";  //Divya
                        //IndentRequisitions.Amount := "Indent Line".Amount;//Divya
                        IndentRequisitions."Location Code" := "Delivery Location";
                        IndentRequisitions."Indent Quantity" := "Req.Quantity";//B2B1.1
                                                                               //    IndentRequisitions."Manufacturer Ref. No." := "Manufacturer Ref. No.";
                        IndentRequisitions."Due Date" := "Due Date";
                        //    IndentRequisitions."Payment Method Code" := "Indent Line"."Payment Meathod Code";//Divya
                        IndentRequisitions."Carry out Action" := TRUE;
                        //B2BJK >>
                        IndentRequisitions.Make := Make;
                        IndentRequisitions.Model := Model;
                        IndentRequisitions."Shortage Qty" := "Shortage Qty";
                        //B2BJK <<
                        IndentRequisitions.INSERT;
                        TempLineNo += 10000;
                    END;
                    /*if IndentReqHeader2.Get(IndentRequisitions."Document No.") then begin
                        IndentReqHeader2."Shortcut Dimension 1 Code_B2B" := DataItem1102152001."Shortcut Dimension 1 Code_B2B";
                        IndentReqHeader2."Shortcut Dimension 2 Code_B2B" := DataItem1102152001."Shortcut Dimension 2 Code_B2B";
                        IndentReqHeader2.Modify();
                        //IndentReqHeader
                    end;*/
                    "Indent Req No" := IndentRequisitions."Document No.";
                    "Indent Req Line No" := IndentRequisitions."Line No.";
                    MODIFY;
                end;

                trigger OnPreDataItem();
                begin
                    IndentReqHeader.RESET;
                    IF IndentReqHeader.GET(RequestNo) THEN;

                    IndentRequisitions.RESET;
                    IndentRequisitions.SETRANGE("Document No.", IndentReqHeader."No.");
                    IF IndentRequisitions.FINDLAST THEN
                        TempLineNo := IndentRequisitions."Line No." + 10000
                    ELSE
                        TempLineNo := 10000;
                end;
            }
            trigger OnPreDataItem()
            begin
                //SetRange("Shortcut Dimension 1 Code_B2B", DimCodeGvar);
                SetRange("No.", IndentHdrNo);
            end;

        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(general)
                {
                    field(IndentHdrNo; IndentHdrNo)
                    {
                        Caption = 'Indent No.';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IndentHeaderGrec.Reset();
                            IndentHeaderGrec.SetRange("Shortcut Dimension 1 Code_B2B", DimCodeGvar);
                            IndentHeaderGrec.SetRange("Shortcut Dimension 2 Code_B2B", ProjectCodegvar);
                            IndentHeaderGrec.SetRange("Released Status", IndentHeaderGrec."Released Status"::Released);
                            if IndentHeaderGrec.FindSet() then
                                if Page.RunModal(Page::"Indent List", IndentHeaderGrec) = Action::LookupOK then
                                    IndentHdrNo := IndentHeaderGrec."No.";
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        IndentRequisitions: Record 50003;
        IndentHdrNo: Code[30];
        IndentHeaderGrec: Record "Indent Header";
        RecItem: Record 27;
        RecVendor: Record 23;
        RecLocation: Record 14;
        TempLineNo: Integer;
        QtyNotAvailable: Boolean;
        IndentReqHeader: Record 50009;
        IndentReqHeader2: Record 50009;
        RequestNo: Code[20];
        ResponsibilityCenter: Code[20];
        Count1: Integer;
        ItemVendorGvar: Record 99;
        DimCodeGvar: Code[20];
        ProjectCodegvar: Code[20];

    procedure GetValue(var HeaderNo: Code[20]; var RespCenter: Code[20]; Var DimesionCodePar: Code[20]; Var ProjectCodePar: Code[20]);
    begin
        RequestNo := HeaderNo;
        ResponsibilityCenter := RespCenter;
        DimCodeGvar := DimesionCodePar;
        ProjectCodegvar := ProjectCodePar;
    end;
}


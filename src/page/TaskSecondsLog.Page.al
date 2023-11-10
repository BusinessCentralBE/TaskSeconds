page 50101 "Task Seconds Log"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Task Seconds Log";
    SourceTableView = sorting("Codeunit ID", "Entry ID") order(descending);
    Caption = 'Task Seconds Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry ID"; Rec."Entry ID")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Logged At"; Rec."Logged At")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Logged By"; Rec."Logged By")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpr;
                }
                field("Is Error"; Rec."Is Error")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleExpr;
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleExpr;
                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = StyleExpr;
                }
            }
        }
    }

    var
        StyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        StyleExpr := 'Standard';
        if Rec."Is Error" then
            StyleExpr := 'Attention';
    end;
}
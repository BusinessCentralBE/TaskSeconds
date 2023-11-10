page 50102 "Active Sessions"
{
    ApplicationArea = All;
    caption = 'Active Sessions';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Active Session";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("User SID"; Rec."User SID")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Database Name"; Rec."Database Name")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Session Unique ID"; Rec."Session Unique ID")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StopSession)
            {
                ApplicationArea = All;
                Caption = 'Stop session';
                Image = Delete;

                trigger OnAction()
                begin
                    StopSession(Rec."Session ID", 'Manually stoppped session');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(StopSession_Promoted; StopSession)
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LineStyle := 'Standard';
        if Rec."Session ID" = SessionId() then
            LineStyle := 'Strong';
    end;

    var
        LineStyle: text;
}
table 50100 "Task Seconds Config"
{
    DataClassification = CustomerContent;
    Caption = 'Task Seconds Config';
    DataPerCompany = false;

    fields
    {
        field(1; "Codeunit ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Codeunit ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin
                CheckCanModify();
            end;
        }
        field(2; "Codeunit Name"; Text[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Codeunit), "Object ID" = field("Codeunit ID")));
        }
        field(3; "Interval Seconds"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Interval Seconds';
            MinValue = 1;
            MaxValue = 60;
            InitValue = 1;

            trigger OnValidate()
            begin
                CheckCanModify();
            end;
        }
        field(4; "Current Server Instance ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Server Instance ID';
            Editable = false;
        }
        field(5; "Current Session ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Session ID';
            Editable = false;
        }
        field(6; Active; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
        }
    }

    keys
    {
        key(PK; "Codeunit ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        CheckCanModify();
    end;

    local procedure CheckCanModify()
    var
        RunningErrorLbl: Label 'Codeunit %1 is running. First stop the session, set active off and edit.', Comment = '%1 = codeunit ID';
        ActiveErrorLbl: Label 'Codeunit %1 is not running but is active. Set active off to edit.', Comment = '%1 = codeunit ID';
    begin
        if Rec.IsTaskActive() then
            Error(RunningErrorLbl, Rec."Codeunit ID");

        if Rec.Active then
            Error(ActiveErrorLbl, Rec."Codeunit ID");
    end;

    procedure IsTaskActive(): Boolean
    var
        Session: Record "Active Session";
    begin
        Session.SetRange("Server Instance ID", Rec."Current Server Instance ID");
        Session.SetRange("Session ID", Rec."Current Session ID");
        exit(not Session.IsEmpty());
    end;

    procedure StartTask(): Boolean
    var
        Started: Boolean;
    begin
        Rec.InsertMessage('Task started.', false);
        Started := StartSession(Rec."Current Session ID", Codeunit::"Task Seconds Runner", CompanyName, Rec);
        if Started then begin
            Rec."Current Server Instance ID" := ServiceInstanceId();
            Rec.Modify(true);
            exit(true);
        end else
            Rec.InsertError('Task started failed!');

        exit(false);
    end;

    procedure StopTask(StopSession: Boolean; InsertLogMsg: Boolean)
    begin
        if StopSession and (Rec."Current Session ID" <> 0) then
            StopSession(Rec."Current Session ID", 'Stopped task seconds session.');

        Rec."Current Server Instance ID" := 0;
        Rec."Current Session ID" := 0;
        Rec.Modify(true);

        if InsertLogMsg then
            Rec.InsertMessage('Task stopped.', false);
    end;

    procedure StopTask(StopSession: Boolean)
    begin
        StopTask(StopSession, true);
    end;

    procedure InsertMessage(Message: Text; IsError: Boolean)
    var
        TaskSecondsLog: Record "Task Seconds Log";
    begin
        TaskSecondsLog.InsertLogMessage(Rec, Message, IsError);
        Commit();
    end;

    procedure InsertError(ErrorMsg: Text)
    begin
        InsertMessage(ErrorMsg, true);
    end;

}
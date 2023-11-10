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
        Started := StartSession(Rec."Current Session ID", Codeunit::"Task Seconds Runner", CompanyName, Rec);
        if Started then begin
            Rec."Current Server Instance ID" := ServiceInstanceId();
            Rec.Modify(true);
            exit(true);
        end;

        exit(false);
    end;

    procedure StopTask(StopSession: Boolean)
    begin
        if StopSession and (Rec."Current Session ID" <> 0) then
            StopSession(Rec."Current Session ID", 'Stopped task seconds session.');

        Rec."Current Server Instance ID" := 0;
        Rec."Current Session ID" := 0;
        Rec.Modify(true);
    end;

    procedure InsertMessage(Message: Text; IsError: Boolean)
    var
        TaskSecondsLog: Record "Task Seconds Log";
    begin
        TaskSecondsLog.InsertLogMessage(Rec, Message, IsError);
    end;

    procedure InsertError(ErrorMsg: Text)
    begin
        InsertMessage(ErrorMsg, true);
    end;

}
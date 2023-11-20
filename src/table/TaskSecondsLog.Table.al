table 50101 "Task Seconds Log"
{
    DataClassification = CustomerContent;
    Caption = 'Task Seconds Log';
    DataPerCompany = false;

    fields
    {
        field(1; "Codeunit ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Codeunit ID';
            TableRelation = "Task Seconds Config"."Codeunit ID";
            Editable = false;
        }
        field(2; "Entry ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry ID';
            Editable = false;
        }
        field(3; Message; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Message';
            Editable = false;
        }
        field(4; "Is Error"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Error';
            Editable = false;
        }
        field(5; "Logged At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Logged At';
            Editable = false;
        }
        field(6; "Logged By"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Logged By';
            Editable = false;
        }
        field(7; "Server Instance ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Server Instance ID';
            Editable = false;
        }
        field(8; "Session ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Session ID';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Codeunit ID", "Entry ID")
        {
            Clustered = true;
        }
        key(KEY1; "Is Error")
        {

        }
    }

    trigger OnInsert()
    begin
        if Rec."Logged At" = 0DT then
            Rec."Logged At" := CurrentDateTime();

        if Rec."Logged By" = '' then
            Rec."Logged By" := CopyStr(UserId(), 1, MaxStrLen(Rec."Logged By"));

        if Rec."Server Instance ID" = 0 then
            Rec."Server Instance ID" := ServiceInstanceId();

        if Rec."Session ID" = 0 then
            Rec."Session ID" := SessionId();
    end;

    procedure GetNextEntryID(CodeunitID: Integer) NextEntryID: Integer;
    var
        TaskSecondsLog: Record "Task Seconds Log";
    begin
        NextEntryID := 1;
        TaskSecondsLog.SetRange("Codeunit ID", CodeunitID);
        if TaskSecondsLog.FindLast() then
            NextEntryID := TaskSecondsLog."Entry ID" + 1;
    end;

    procedure InsertLogMessage(TaskSecondsConfig: Record "Task Seconds Config"; Message: Text; IsError: Boolean)
    var
        TaskSecondsLog: Record "Task Seconds Log";
    begin
        TaskSecondsLog.Init();
        TaskSecondsLog.Validate("Codeunit ID", TaskSecondsConfig."Codeunit ID");
        TaskSecondsLog.Validate("Entry ID", GetNextEntryID(TaskSecondsConfig."Codeunit ID"));
        TaskSecondsLog.Validate(Message, Message);
        TaskSecondsLog.Validate("Is Error", IsError);
        TaskSecondsLog.Insert(true);
    end;

    procedure InsertLogError(TaskSecondsConfig: Record "Task Seconds Config"; ErrorMsg: Text)
    begin
        InsertLogMessage(TaskSecondsConfig, ErrorMsg, true);
    end;

}
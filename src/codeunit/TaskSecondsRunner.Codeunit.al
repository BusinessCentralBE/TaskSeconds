codeunit 50101 "Task Seconds Runner"
{
    TableNo = "Task Seconds Config";

    trigger OnRun()
    var
        TaskSecondsLog: Record "Task Seconds Log";
        SleepTime: Integer;
        ErrorMsg: Text;
    begin
        SleepTime := Rec."Interval Seconds" * 1000;

        while true do begin
            if not Codeunit.Run(Rec."Codeunit ID", Rec) then begin
                ErrorMsg := GetLastErrorText();
                Rec.InsertError(ErrorMsg);
                Commit();
                Error(ErrorMsg);
            end;

            Commit();
            Sleep(SleepTime);
        end;
    end;
}
codeunit 50103 "Dummy Crash Every Two Minutes"
{
    TableNo = "Task Seconds Config";

    trigger OnRun()
    var
        CurrentMinute: Integer;
        CurrentSecond: Integer;
        CurrentDT: DateTime;
    begin
        CurrentDT := CurrentDateTime();
        Evaluate(CurrentMinute, Format(CurrentDT, 0, '<Minutes,2>'));
        Evaluate(CurrentSecond, Format(CurrentDT, 0, '<Seconds,2>'));

        Rec.InsertMessage('Executed at ' + Format(CurrentDT), false);

        if (CurrentMinute mod 2 = 0) and (CurrentSecond = 0) then
            Error('Two minutes CRASH!');
    end;
}
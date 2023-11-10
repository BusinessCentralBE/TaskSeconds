codeunit 50100 "Task Seconds Starter"
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        TaskSecondsConfig: Record "Task Seconds Config";
    begin
        TaskSecondsConfig.SetRange(Active, true);
        if TaskSecondsConfig.FindSet() then
            repeat
                StartTaskSecondsConfig(TaskSecondsConfig);
            until TaskSecondsConfig.Next() < 1;
    end;

    local procedure StartTaskSecondsConfig(var TaskSecondsConfig: Record "Task Seconds Config")
    begin
        if not TaskSecondsConfig.IsTaskActive() then
            TaskSecondsConfig.StartTask();
    end;

}
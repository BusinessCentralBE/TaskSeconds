codeunit 50102 "Event Handlers"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, OnAfterCompanyClose, '', false, false)]
    local procedure OnAfterCompanyClose()
    var
        TaskSecondsConfig: Record "Task Seconds Config";
    begin
        TaskSecondsConfig.SetRange("Current Server Instance ID", ServiceInstanceId());
        TaskSecondsConfig.SetRange("Current Session ID", SessionId());
        if TaskSecondsConfig.FindFirst() then
            TaskSecondsConfig.StopTask(false);
    end;
}
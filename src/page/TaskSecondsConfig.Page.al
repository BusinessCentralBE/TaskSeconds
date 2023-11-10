page 50100 "Task Seconds Config"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Task Seconds Config";
    DelayedInsert = true;
    Caption = 'Task Seconds Config';

    layout
    {
        area(Content)
        {
            field(StarterStatusTxt; StarterStatusTxt)
            {
                ShowCaption = false;
                StyleExpr = StarterStyleExpr;
                DrillDown = true;

                trigger OnDrillDown()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                    JobQueueEntryCard: Page "Job Queue Entry Card";
                    JobQueueEntries: Page "Job Queue Entries";
                begin
                    if IsStarterRunning then begin
                        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
                        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Task Seconds Starter");
                        JobQueueEntry.FindFirst();
                        JobQueueEntryCard.SetRecord(JobQueueEntry);
                        JobQueueEntryCard.Run();
                    end else begin
                        JobQueueEntries.Run();
                    end;
                end;
            }

            repeater(General)
            {
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Codeunit ID"; Rec."Codeunit ID")
                {
                    ApplicationArea = All;
                }
                field("Codeunit Name"; Rec."Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Interval Seconds"; Rec."Interval Seconds")
                {
                    ApplicationArea = All;
                }
                field("Current Server Instance ID"; Rec."Current Server Instance ID")
                {
                    ApplicationArea = All;
                }
                field("Current Session ID"; Rec."Current Session ID")
                {
                    ApplicationArea = All;
                }
            }

            part(TaskSecondsLog; "Task Seconds Log")
            {
                ApplicationArea = All;
                SubPageLink = "Codeunit ID" = field("Codeunit ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ClearCurrentSession)
            {
                ApplicationArea = All;
                Caption = 'Clear Current Session';
                Image = Restore;

                trigger OnAction()
                begin
                    Rec."Current Server Instance ID" := 0;
                    Rec."Current Session ID" := 0;
                    Rec.Modify(true);
                end;
            }
            action(StopCurrentSession)
            {
                ApplicationArea = All;
                Caption = 'Stop Current Session';
                Image = Delete;

                trigger OnAction()
                begin
                    if Rec."Current Session ID" > 0 then
                        if StopSession(Rec."Current Session ID") then begin
                            Rec."Current Server Instance ID" := 0;
                            Rec."Current Session ID" := 0;
                            Rec.Modify(true);
                        end;
                end;
            }
            action(StartStarterJob)
            {
                ApplicationArea = All;
                Caption = 'Start Starter Job';
                Image = Job;
                Enabled = not IsStarterRunning;

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
                    JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Task Seconds Starter");
                    if JobQueueEntry.IsEmpty() then begin
                        JobQueueEntry.Init();
                        JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
                        JobQueueEntry.Validate("Object ID to Run", Codeunit::"Task Seconds Starter");
                        JobQueueEntry.Validate("Run on Mondays", true);
                        JobQueueEntry.Validate("Run on Tuesdays", true);
                        JobQueueEntry.Validate("Run on Wednesdays", true);
                        JobQueueEntry.Validate("Run on Thursdays", true);
                        JobQueueEntry.Validate("Run on Fridays", true);
                        JobQueueEntry.Validate("Run on Saturdays", true);
                        JobQueueEntry.Validate("Run on Sundays", true);
                        JobQueueEntry.Validate("No. of Minutes between Runs", 1);
                        JobQueueEntry.Insert(true);
                        JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                    end else begin
                        JobQueueEntry.FindFirst();
                        if JobQueueEntry.Status <> JobQueueEntry.Status::Ready then
                            JobQueueEntry.Restart();
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ClearCurrentSession_Promoted; ClearCurrentSession)
                {

                }
                actionref(StopCurrentSession_Promoted; StopCurrentSession)
                {

                }
                actionref(StartStarterJob_Promoted; StartStarterJob)
                {

                }
            }
        }
    }

    var
        IsStarterRunning: Boolean;
        StarterStatusTxt: Text;
        StarterStyleExpr: Text;
        NotStartedLbl: Label 'Starter codeunit is not running on the job queue.';
        StartedLbl: Label 'Starter codeunit is running on the job queue.';

    trigger OnOpenPage()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Task Seconds Starter");
        if JobQueueEntry.IsEmpty() then
            IsStarterRunning := false
        else begin
            JobQueueEntry.FindFirst();
            IsStarterRunning := JobQueueEntry.Status = JobQueueEntry.Status::Ready;
        end;

        if IsStarterRunning then begin
            StarterStyleExpr := 'Favorable';
            StarterStatusTxt := StartedLbl;
        end else begin
            StarterStyleExpr := 'Unfavorable';
            StarterStatusTxt := NotStartedLbl;
        end;
    end;
}
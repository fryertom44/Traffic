//
//  TaskDetailViewController.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "LoadJobDetailCommand.h"
#import "LoadTrafficEmployeeCommand.h"
#import "LoadProjectCommand.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController
@synthesize timesheet=_timesheet;
@synthesize task=_task;
@synthesize job=_job;
@synthesize project=_project;
@synthesize client=_client;
@synthesize employee=_employee;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimesheet:(WS_TimeEntry*)newTimesheet
{
    if (_timesheet != newTimesheet) {
        _timesheet = newTimesheet;
        
        // Update the view.
        [self configureViewWithTimesheetDetails];
    }
}

- (void)setTask:(WS_JobTask *)task
{
    if (_task != task) {
        _task = task;
        
        // Update the view.
        [self configureViewWithTaskDetails];
    }
}

- (void)setJob:(WS_Job*)newJob
{
    if (_job != newJob) {
        _job = newJob;
        
        // Update the view.
        [self configureViewWithJobDetails];
    }
}

- (void)setJobDetail:(WS_JobDetail*)newJobDetail
{
    if (_jobDetail != newJobDetail) {
        _jobDetail = newJobDetail;
        
        // Update the view.
        [self configureViewWithJobDetailDetails];
        LoadProjectCommand *loadProjectCommand = [[LoadProjectCommand alloc]init];
        [loadProjectCommand executeAndUpdateComponent:self
                                            projectId:self.jobDetail.ownerProjectId];
        LoadTrafficEmployeeCommand *loadTrafficEmployeeCommand = [[LoadTrafficEmployeeCommand alloc]init];
        [loadTrafficEmployeeCommand executeAndUpdateComponent:self trafficEmployeeId:self.jobDetail.accountManagerId];
    }
}

- (void)setEmployee:(WS_TrafficEmployee*)newEmployee
{
    if (_employee != newEmployee) {
        _employee = newEmployee;
        
        // Update the view.
        [self configureViewWithEmployeeDetails];
    }
}

- (void)setProject:(WS_Project*)newProject
{
    if (_project != newProject) {
        _project = newProject;
        
        // Update the view.
        [self configureViewWithProjectDetails];
    }
}

- (void)configureView
{
    [self configureViewWithTaskDetails];
    [self configureViewWithTimesheetDetails];
    [self configureViewWithEmployeeDetails];
    [self configureViewWithJobDetailDetails];
    [self configureViewWithJobDetails];
    [self configureViewWithProjectDetails];
    [self.tableView reloadData];
}

- (void)configureViewWithTimesheetDetails
{
    if (self.timesheet!=nil) {
        //update view with timesheet infos
    }
}

- (void)configureViewWithTaskDetails
{
    if(self.task!=nil) {
        self.taskDeadlineLabel.text = [NSString stringWithFormat:@"%@",self.task.taskDeadline];
        self.taskDescriptionLabel.text = self.task.jobTaskDescription;
        self.taskNotesLabel.text = self.task.internalNote;
        self.stageLabel.text = self.task.jobStageDescription;
    }
}

- (void)configureViewWithJobDetails
{
    if(self.job!=nil) {
        self.jobNoLabel.text = self.job.jobNumber;
        self.jobDeadlineLabel.text = [NSString stringWithFormat:@"%@",self.job.jobDeadline];
    }
}

- (void)configureViewWithJobDetailDetails
{
    if(self.jobDetail!=nil) {
        self.jobNameLabel.text = [NSString stringWithFormat:@"%@",self.jobDetail.jobTitle];
    }
}

- (void)configureViewWithEmployeeDetails
{
    if (self.employee!=nil) {
        self.ownerLabel.text = [NSString stringWithFormat:@"%@ %@",self.employee.firstName,self.employee.lastName];
    }
}

- (void)configureViewWithProjectDetails
{
    if(self.project!=nil){
        self.projectLabel.text = [NSString stringWithFormat:@"%@",self.project.projectName];
    }
}

@end

//
//  TaskDetailViewController.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "LoadJobCommand.h"
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

    [self.tableView reloadData];
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
        [_timesheet saveState];
        
        // Update the view.
        [self configureViewWithTimesheetDetails];
        
        LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
        [loadJobCommand executeAndUpdateComponent:self
                                            jobId:self.timesheet.jobId];
    }
}

- (void)setTask:(WS_JobTask*)newTask
{
    if (_task != newTask) {
        _task = newTask;
        [_task saveState];
        
        // Update the view.
        [self configureViewWithTaskDetails];
    }
}

- (void)setJob:(WS_Job*)newJob
{
    if (_job != newJob) {
        _job = newJob;
//        [_job saveState];
        
        // Update the view.
        [self configureViewWithJobDetails];
        LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
        [loadJobDetailCommand executeAndUpdateComponent:self
                                             jobDetailId:self.job.jobDetailId];
    }
}

- (void)setJobDetail:(WS_JobDetail*)newJobDetail
{
    if (_jobDetail != newJobDetail) {
        _jobDetail = newJobDetail;
//        [_jobDetail saveState];
        
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
        //        [newEmployee saveState];
        
        // Update the view.
        [self configureViewWithEmployeeDetails];
    }
}

- (void)configureViewWithTimesheetDetails
{
    
    if (self.timesheet) {
        self.jobNoLabel.text = [NSString stringWithFormat:@"%@",self.timesheet.jobId.stringValue];
        [self.tableView reloadData];
    }
}

- (void)configureViewWithTaskDetails
{
    if(self.task) {
        self.taskDeadlineLabel.text = [NSString stringWithFormat:@"%d",self.task.daysUntilDeadline];
        self.taskDescriptionLabel.text = self.task.taskDescription;
        [self.tableView reloadData];
    }
}

- (void)configureViewWithJobDetails
{
    if(self.job) {
        self.jobDeadlineLabel.text = [NSString stringWithFormat:@"%@",self.job.jobDeadline];
        [self.tableView reloadData];
    }
}

- (void)configureViewWithJobDetailDetails
{
    if(self.jobDetail) {
        self.jobNameLabel.text = [NSString stringWithFormat:@"%@",self.jobDetail.jobTitle];
        [self.tableView reloadData];
    }
}

- (void) configureViewWithEmployeeDetails
{
    if (self.employee) {
        self.ownerLabel.text = [NSString stringWithFormat:@"%@ %@",self.employee.firstName,self.employee.lastName];
        [self.tableView reloadData];
    }
}

- (void) configureViewWithProjectDetails
{
    if(self.project){
        self.projectLabel.text = [NSString stringWithFormat:@"%@",self.project.projectName];
        [self.tableView reloadData];
    }
}

@end

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
#import "GlobalModel.h"
#import "ParseJobTaskFromJobData.h"
#import "LoadJobCommand.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

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
    
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobAsData" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJob" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobDetail" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedClient" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTaskAllocation" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTask" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobAsData" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedProject" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedOwner" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"timesheet" options:NSKeyValueObservingOptionNew context:NULL];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"selectedJobAsData"]) {
        self.sharedModel.selectedJobTask = [ParseJobTaskFromJobData parseData:[change objectForKey:NSKeyValueChangeNewKey] fetchJobTaskWithId:self.sharedModel.timesheet.jobTaskId];
        NSLog(@"selectedJobData has been observed!");
    }
    if ([keyPath isEqual:@"selectedJob"]) {
        [self configureViewWithJobDetails];
        LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
        [loadJobDetailCommand executeWithJobDetailId:self.sharedModel.selectedJob.jobDetailId];
        NSLog(@"selectedJob has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobDetail"]) {
        [self configureViewWithJobDetailDetails];
        LoadProjectCommand *loadProjectCommand = [[LoadProjectCommand alloc]init];
        [loadProjectCommand executeAndUpdateComponent:self projectId:self.sharedModel.selectedJobDetail.ownerProjectId];
        LoadTrafficEmployeeCommand *loadTrafficEmployeeCommand = [[LoadTrafficEmployeeCommand alloc]init];
        [loadTrafficEmployeeCommand executeWithTrafficEmployeeId:self.sharedModel.selectedJobDetail.accountManagerId];

        NSLog(@"selectedJobDetail has been observed!");
    }
    if ([keyPath isEqual:@"selectedClient"]) {
        NSLog(@"selectedClient has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTask"]) {
        [self configureViewWithTaskDetails];
        NSLog(@"selectedJobTask has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTaskAllocation"]) {
        LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
        [loadJobCommand executeWithJobId:self.sharedModel.selectedJobTaskAllocation.jobId];
        NSLog(@"selectedJobTaskAllocation has been observed!");
    }
    if ([keyPath isEqual:@"timesheet"]) {
        [self configureViewWithTimesheetDetails];
        NSLog(@"timesheet has been observed!");
    }
    if ([keyPath isEqual:@"selectedProject"]) {
        [self configureViewWithProjectDetails];
        NSLog(@"selectedProject has been observed!");
    }
    if ([keyPath isEqual:@"selectedOwner"]) {
        [self configureViewWithEmployeeDetails];
        NSLog(@"selectedOwner has been observed!");
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
    if (self.sharedModel.timesheet!=nil) {
        //update view with timesheet info
    }
}

- (void)configureViewWithTaskDetails
{
    if(self.sharedModel.selectedJobTask!=nil) {
        self.taskDeadlineLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedJobTask.taskDeadline];
        self.taskDescriptionLabel.text = self.sharedModel.selectedJobTask.jobTaskDescription;
        self.taskNotesLabel.text = self.sharedModel.selectedJobTask.internalNote;
        self.stageLabel.text = self.sharedModel.selectedJobTask.jobStageDescription;
    }
}

- (void)configureViewWithJobDetails
{
    if(self.sharedModel.selectedJob!=nil) {
        self.jobNoLabel.text = self.sharedModel.selectedJob.jobNumber;
        self.jobDeadlineLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedJob.jobDeadline];
    }
}

- (void)configureViewWithJobDetailDetails
{
    if(self.sharedModel.selectedJobDetail!=nil) {
        self.jobNameLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedJobDetail.jobTitle];
    }
}

- (void)configureViewWithEmployeeDetails
{
    if (self.sharedModel.selectedOwner!=nil) {
        self.ownerLabel.text = [NSString stringWithFormat:@"%@ %@",self.sharedModel.selectedOwner.firstName,self.sharedModel.selectedOwner.lastName];
    }
}

- (void)configureViewWithProjectDetails
{
    if(self.sharedModel.selectedProject!=nil){
        self.projectLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedProject.projectName];
    }
}

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

@end

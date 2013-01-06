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
#import "LoadClientCommand.h"
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
    
    [self configureView];
    [self loadProject];
    [self loadEmployee];
}

-(void)viewWillAppear:(BOOL)animated{
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
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobAsData"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJob"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobDetail"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedClient"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTaskAllocation"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTask"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobAsData"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedProject"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedOwner"];
    [self.sharedModel removeObserver:self forKeyPath:@"timesheet"];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProject
{
    if (self.sharedModel.selectedJobDetail) {
        LoadProjectCommand *loadProjectCommand = [[LoadProjectCommand alloc]init];
        [loadProjectCommand executeWithProjectId:self.sharedModel.selectedJobDetail.ownerProjectId];
    }
}

- (void)loadJob
{
    if (self.sharedModel.selectedJobTaskAllocation) {
        LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
        [loadJobCommand executeWithJobId:self.sharedModel.selectedJobTaskAllocation.jobId];
    }
}

- (void)loadEmployee
{
    if (self.sharedModel.selectedJobDetail!=nil) {
        LoadTrafficEmployeeCommand *loadTrafficEmployeeCommand = [[LoadTrafficEmployeeCommand alloc]init];
        [loadTrafficEmployeeCommand executeWithTrafficEmployeeId:self.sharedModel.selectedJobDetail.accountManagerId];
    }
}

- (void)loadClient
{
    if (self.sharedModel.selectedProject!=nil) {
        LoadClientCommand *loadClientCommand = [[LoadClientCommand alloc]init];
        [loadClientCommand executeWithClientCRMId:self.sharedModel.selectedProject.clientCRMEntryId];
    }
}

- (void)loadJobDetail
{
    LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
    [loadJobDetailCommand executeWithJobDetailId:self.sharedModel.selectedJob.jobDetailId];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"selectedJobAsData"]) {
        self.sharedModel.selectedJobTask = [ParseJobTaskFromJobData parseData:[change objectForKey:NSKeyValueChangeNewKey] fetchJobTaskWithId:self.sharedModel.timesheet.jobTaskId];
        NSLog(@"TaskViewDetail:selectedJobData has been observed!");
    }
    if ([keyPath isEqual:@"selectedJob"]) {
        [self configureViewWithJobDetails];
        [self loadJobDetail];
        NSLog(@"TaskViewDetail:selectedJob has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobDetail"]) {
        [self configureViewWithJobDetailDetails];
        [self loadProject];
        [self loadEmployee];

        NSLog(@"TaskViewDetail:selectedJobDetail has been observed!");
    }
    if ([keyPath isEqual:@"selectedClient"]) {
        [self configureViewWithClientDetails];
        NSLog(@"TaskViewDetail:selectedClient has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTask"]) {
        [self configureViewWithTaskDetails];
        NSLog(@"TaskViewDetail:selectedJobTask has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTaskAllocation"]) {
        [self loadJob];
        NSLog(@"TaskViewDetail:selectedJobTaskAllocation has been observed!");
    }
    if ([keyPath isEqual:@"timesheet"]) {
        [self configureViewWithTimesheetDetails];
        NSLog(@"TaskViewDetail:timesheet has been observed!");
    }
    if ([keyPath isEqual:@"selectedProject"]) {
        [self configureViewWithProjectDetails];
        [self loadClient];
        NSLog(@"TaskViewDetail:selectedProject has been observed!");
    }
    if ([keyPath isEqual:@"selectedOwner"]) {
        [self configureViewWithEmployeeDetails];
        NSLog(@"TaskViewDetail:selectedOwner has been observed!");
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
        self.taskDeadlineLabel.text = [self fullDateStringFromDate:self.sharedModel.selectedJobTask.taskDeadline];
        self.taskDescriptionLabel.text = self.sharedModel.selectedJobTask.jobTaskDescription;
        self.taskNotesLabel.text = self.sharedModel.selectedJobTask.internalNote;
        self.stageLabel.text = self.sharedModel.selectedJobTask.jobStageDescription;
    }
}

- (void)configureViewWithJobDetails
{
    if(self.sharedModel.selectedJob!=nil) {
        self.jobNoLabel.text = self.sharedModel.selectedJob.jobNumber;
        self.jobDeadlineLabel.text = [self fullDateStringFromDate:self.sharedModel.selectedJob.jobDeadline];
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

- (void)configureViewWithClientDetails
{
    if(self.sharedModel.selectedClient!=nil){
        self.clientLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedClient.clientName];
    }
}

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(NSString*)fullDateStringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm"];
    }
    return [dateFormatter stringFromDate:date];
}
@end

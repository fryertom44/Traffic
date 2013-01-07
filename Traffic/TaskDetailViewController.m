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
#import <RestKit.h>
#import "WS_JobTaskAllocation.h"

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
}

-(void)viewWillAppear:(BOOL)animated{
    [self.sharedModel addObserver:self forKeyPath:@"selectedJob" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobDetail" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedClient" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTaskAllocation" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTask" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedProject" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedOwner" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"timesheet" options:NSKeyValueObservingOptionNew context:NULL];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJob"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobDetail"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedClient"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTaskAllocation"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTask"];
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

//- (void)loadProject
//{
//    if (self.sharedModel.selectedJobDetail) {
//        LoadProjectCommand *loadProjectCommand = [[LoadProjectCommand alloc]init];
//        [loadProjectCommand executeWithProjectId:self.sharedModel.selectedJobDetail.ownerProjectId];
//    }
//}
//
//- (void)loadJob
//{
//    if (self.sharedModel.selectedJobTaskAllocation) {
//        LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
//        [loadJobCommand executeWithJobId:self.sharedModel.selectedJobTaskAllocation.jobId];
//    }
//}
//
//- (void)loadEmployee
//{
//    if (self.sharedModel.selectedJobDetail!=nil) {
//        LoadTrafficEmployeeCommand *loadTrafficEmployeeCommand = [[LoadTrafficEmployeeCommand alloc]init];
//        [loadTrafficEmployeeCommand executeWithTrafficEmployeeId:self.sharedModel.selectedJobDetail.accountManagerId];
//    }
//}
//
//- (void)loadClient
//{
//    if (self.sharedModel.selectedProject!=nil) {
//        LoadClientCommand *loadClientCommand = [[LoadClientCommand alloc]init];
//        [loadClientCommand executeWithClientCRMId:self.sharedModel.selectedProject.clientCRMEntryId];
//    }
//}
//
//- (void)loadJobDetail
//{
//    LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
//    [loadJobDetailCommand executeWithJobDetailId:self.sharedModel.selectedJob.jobDetailId];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"selectedJob"]) {
        NSLog(@"TaskViewDetail:selectedJob has changed!");
        [self displayJobDetails];
        if (self.sharedModel.selectedJob!=nil) {
            WS_JobDetail *currentJobDetail = [[WS_JobDetail alloc]init];
            currentJobDetail.jobDetailId = self.sharedModel.selectedJob.jobDetailId;
            [[RKObjectManager sharedManager]getObject:currentJobDetail path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedJobDetail = (WS_JobDetail*)[mappingResult firstObject];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    if ([keyPath isEqual:@"selectedJobDetail"]) {
        NSLog(@"TaskViewDetail:selectedJobDetail has changed!");
        [self displayJobDetailDetails];
        if (self.sharedModel.selectedJobDetail!=nil) {
            WS_Project *currentProject = [[WS_Project alloc]init];
            currentProject.projectId = self.sharedModel.selectedJobDetail.ownerProjectId;
            [[RKObjectManager sharedManager]getObject:currentProject path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedProject = (WS_Project*)[mappingResult firstObject];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
            WS_TrafficEmployee *currentOwner = [[WS_TrafficEmployee alloc]init];
            currentOwner.trafficEmployeeId = self.sharedModel.selectedJobDetail.accountManagerId;
            [[RKObjectManager sharedManager]getObject:currentOwner path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedOwner = (WS_TrafficEmployee*)[mappingResult firstObject];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    if ([keyPath isEqual:@"selectedClient"]) {
        NSLog(@"TaskViewDetail:selectedClient has changed!");
        [self displayClientDetails];
    }
    if ([keyPath isEqual:@"selectedJobTaskAllocation"]) {
        NSLog(@"TaskViewDetail:selectedJobTaskAllocation has changed!");
        [self displayTaskAllocationDetails];
        if(self.sharedModel.selectedJobTaskAllocation!=nil){
            WS_Job *currentJob = [[WS_Job alloc]init];
            currentJob.jobId = self.sharedModel.selectedJobTaskAllocation.jobId;
            [[RKObjectManager sharedManager]getObject:currentJob path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedJob = (WS_Job*)[mappingResult firstObject];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    if ([keyPath isEqual:@"timesheet"]) {
        NSLog(@"TaskViewDetail:timesheet has changed!");
    }
    if ([keyPath isEqual:@"selectedProject"]) {
        NSLog(@"TaskViewDetail:selectedProject has changed!");
        [self displayProjectDetails];
        if (self.sharedModel.selectedProject!=nil) {
            WS_Client *currentClient = [[WS_Client alloc]init];
            currentClient.clientId = self.sharedModel.selectedProject.clientCRMEntryId;
            [[RKObjectManager sharedManager]getObject:currentClient path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedClient = (WS_Client*)[mappingResult firstObject];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
            
        }
    }
    if ([keyPath isEqual:@"selectedOwner"]) {
        [self displayEmployeeDetails];
        NSLog(@"TaskViewDetail:selectedOwner has changed!");
    }
}

- (void)configureView
{
    [self displayTaskAllocationDetails];
    [self displayEmployeeDetails];
    [self displayJobDetailDetails];
    [self displayJobDetails];
    [self displayProjectDetails];
    [self.tableView reloadData];
}


- (void)displayTaskAllocationDetails
{
    if(self.sharedModel.selectedJobTaskAllocation!=nil) {
        self.taskDeadlineLabel.text = [self fullDateStringFromDate:self.sharedModel.selectedJobTaskAllocation.taskDeadline];
        self.taskDescriptionLabel.text = self.sharedModel.selectedJobTaskAllocation.taskDescription;
        self.taskNotesLabel.text = self.sharedModel.selectedJobTaskAllocation.internalNote;
        self.stageLabel.text = self.sharedModel.selectedJobTaskAllocation.jobStageDescription;
    }
}

- (void)displayJobDetails
{
    if(self.sharedModel.selectedJob!=nil) {
        self.jobNoLabel.text = self.sharedModel.selectedJob.jobNumber;
        self.jobDeadlineLabel.text = [self fullDateStringFromDate:self.sharedModel.selectedJob.jobDeadline];
    }
}

- (void)displayJobDetailDetails
{
    if(self.sharedModel.selectedJobDetail!=nil) {
        self.jobNameLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedJobDetail.jobTitle];
        
        NSString *jobBriefWithHTML = self.sharedModel.selectedJobDetail.notes;
        
        if (jobBriefWithHTML) {
            NSError *error = NULL;
            NSRegularExpression *fontRegex = [NSRegularExpression regularExpressionWithPattern:@"</?FONT[^>]*>" options:NSRegularExpressionCaseInsensitive error:&error];
            NSRegularExpression *textFormatRegex = [NSRegularExpression regularExpressionWithPattern:@"</?TEXTFORMAT[^>]*>" options:NSRegularExpressionCaseInsensitive error:&error];
            
            NSString *modifiedString = [fontRegex stringByReplacingMatchesInString:jobBriefWithHTML options:0 range:NSMakeRange(0, [jobBriefWithHTML length]) withTemplate:@""];
            modifiedString = [textFormatRegex stringByReplacingMatchesInString:modifiedString options:0 range:NSMakeRange(0, [modifiedString length]) withTemplate:@""];

            //pass the string to the webview
            [self.briefLabel loadHTMLString:[modifiedString description] baseURL:nil];
        }
    }
}

- (void)displayEmployeeDetails
{
    if (self.sharedModel.selectedOwner!=nil) {
        self.ownerLabel.text = [NSString stringWithFormat:@"%@ %@",self.sharedModel.selectedOwner.firstName,self.sharedModel.selectedOwner.lastName];
    }
}

- (void)displayProjectDetails
{
    if(self.sharedModel.selectedProject!=nil){
        self.projectLabel.text = [NSString stringWithFormat:@"%@",self.sharedModel.selectedProject.projectName];
    }
}

- (void)displayClientDetails
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

-(void)handleFailureWithOperation:(RKObjectRequestOperation*)operation error:(NSError*)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
};

@end

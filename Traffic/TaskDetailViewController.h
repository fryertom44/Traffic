//
//  TaskDetailViewController.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WS_JobTask.h"
#import "WS_TimeEntry.h"
#import "WS_Job.h"
#import "WS_JobDetail.h"
#import "WS_TrafficEmployee.h"
#import "WS_Project.h"
#import "WS_Client.h"

@interface TaskDetailViewController : UITableViewController
@property (strong,nonatomic) WS_TimeEntry *timesheet;
@property (strong,nonatomic) WS_JobTask *task;
@property (strong,nonatomic) WS_Job *job;
@property (strong,nonatomic) WS_JobDetail *jobDetail;
@property (strong,nonatomic) WS_TrafficEmployee *employee;
@property (strong,nonatomic) WS_Project *project;
@property (strong,nonatomic) WS_Client *client;

@property (weak, nonatomic) IBOutlet UILabel *jobNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskNotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@end

//
//  IXRSettingViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 05/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRSettingViewController.h"
#import <MBProgressHUD.h>

#import "IXRSelectChoiceViewController.h"
#import "IXRetailerHelper.h"
#import "IXMFreshness.h"
#import "IXRViewControllerHelper.h"


@interface IXRSettingViewController () < UITableViewDataSource, UITableViewDelegate, IXRSelectChoiceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IXRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"Settings";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingDetailCell"];
            cell.textLabel.text = @"Country";
            cell.detailTextLabel.text = [IXRetailerHelper requestCountyCode].title;
            return cell;
        }
        else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingDetailCell"];
            cell.textLabel.text = @"Freshness";
            cell.detailTextLabel.text = [IXRetailerHelper requestFreshness].value;
            return cell;
        }
        
        
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        cell.textLabel.text = @"About";
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self startSettingChoiceForCountry];
        }
        else if (indexPath.row == 1) {
            [self startSettingChoiceForFreshness];
        }
    }
    else if (indexPath.section == 1) {
        [self startSettingAboutViewController];
    }
    else if (indexPath.section == 2) {

    }
    
}

- (void)choicesController:(IXRSelectChoiceViewController *)controller didPickChoices:(NSSet *)choices {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (controller.tag == 10001) {
        NSString* chosenValue = [[choices allObjects] objectAtIndex:0];
        NSArray *countryCodes = [IXMCountryCode getAllCountryCode];
        for (IXMCountryCode *object in countryCodes) {
            if ([object.title isEqualToString:chosenValue]) {
                [IXRetailerHelper requestSaveCountyCode:object];
                [self.tableView reloadData];
                break;
            }
        }
    }
    else if (controller.tag == 10002) {
        NSString* chosenValue = [[choices allObjects] objectAtIndex:0];
        NSArray *countryCodes = [IXMFreshness getAllFreshness];
        for (IXMFreshness *object in countryCodes) {
            if ([object.value isEqualToString:chosenValue]) {
                [IXRetailerHelper requestSaveFreshness:object];
                [self.tableView reloadData];
                break;
            }
        }
    }
   
}

- (void)choicesControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

- (void)startSettingAboutViewController {
    UIViewController *aboutVC = [IXRViewControllerHelper settingAboutViewController:self.storyboard];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)startSettingChoiceForFreshness {
    UINavigationController *navControler = [IXRViewControllerHelper settingChoiceViewController:self.storyboard];
    IXRSelectChoiceViewController *destController = (IXRSelectChoiceViewController *)[navControler topViewController];
    destController.delegate = self;
    destController.isMultipleChoice = NO;
    destController.selectedChoice = [IXRetailerHelper requestFreshness].value;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *countryCodes = [IXMFreshness getAllFreshness];
    for (IXMFreshness *object in countryCodes) {
        [array addObject:object.value];
    }
    destController.choicesArray = array;
    destController.title = @"Select Freshness";
    destController.tag = 10002;
    [self presentViewController:navControler animated:YES completion:^{
        
    }];
}

- (void)startSettingChoiceForCountry {
    UINavigationController *navControler = [IXRViewControllerHelper settingChoiceViewController:self.storyboard];
    IXRSelectChoiceViewController *destController = (IXRSelectChoiceViewController *)[navControler topViewController];
    destController.delegate = self;
    destController.isMultipleChoice = NO;
    destController.selectedChoice = [IXRetailerHelper requestCountyCode].title;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *countryCodes = [IXMCountryCode getAllCountryCode];
    for (IXMCountryCode *object in countryCodes) {
        [array addObject:object.title];
    }
    destController.choicesArray = array;
    destController.title = @"Select Country";
    destController.tag = 10001;
    [self presentViewController:navControler animated:YES completion:^{
        
    }];
}

@end

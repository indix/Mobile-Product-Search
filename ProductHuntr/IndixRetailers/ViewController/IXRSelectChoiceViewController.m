//
//  IXRSelectChoiceViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 25/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRSelectChoiceViewController.h"

@interface IXRSelectChoiceViewController ()

@property (nonatomic, strong) NSMutableSet* choicesSelected;

@end

@implementation IXRSelectChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    if(self.isMultipleChoice) {
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didDone)];
        self.navigationItem.rightBarButtonItem = doneButton;
        self.choicesSelected = [NSMutableSet setWithSet:self.selectedChoices];
    }
    else {
        self.choicesSelected = [NSMutableSet set];
        [self.choicesSelected addObject:self.selectedChoice];
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancel
{
    [self.delegate performSelector:@selector(choicesControllerDidCancel)];
}

- (void)didDone
{
    [self.delegate performSelector:@selector(choicesController:didPickChoices:) withObject:self withObject:self.choicesSelected];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.choicesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *chocieText = [self.choicesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = chocieText;
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.choicesSelected containsObject:chocieText]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *chocieText = [self.choicesArray objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        [self.choicesSelected removeObject:chocieText];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }else{
        
        if (!self.isMultipleChoice) {
            [self.choicesSelected removeAllObjects];
            
            for (int i=0; i < [self.choicesArray count]; i++) {
                NSIndexPath* indexToUnselect = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexToUnselect];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        [self.choicesSelected addObject:chocieText];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    if (self.isMultipleChoice) {
        if ([self.delegate respondsToSelector:@selector(choicesController:didPickMultChoices:)]) {
            [self.delegate performSelector:@selector(choicesController:didPickMultChoices:) withObject:self withObject:self.choicesSelected];
        }
    }
    else {
        [self.delegate performSelector:@selector(choicesController:didPickChoices:) withObject:self withObject:self.choicesSelected];
    }
}
@end

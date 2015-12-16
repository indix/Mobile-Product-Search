//
//  IXRSelectChoiceViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 25/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IXRSelectChoiceViewControllerDelegate;

@interface IXRSelectChoiceViewController : UITableViewController

/**
 ViewController that can be reused, use to do some selection.
 */

@property (nonatomic, strong) NSString *selectedChoice;
@property (nonatomic, strong) NSArray *choicesArray;
@property (nonatomic, assign) BOOL isMultipleChoice;
@property (nonatomic, strong) NSSet *selectedChoices;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) id<IXRSelectChoiceViewControllerDelegate> delegate;

@end

@protocol IXRSelectChoiceViewControllerDelegate <NSObject>

@required

- (void)choicesController:(IXRSelectChoiceViewController *)controller didPickChoices:(NSSet*)choices;
- (void)choicesControllerDidCancel;

@optional
- (void) choicesController:(IXRSelectChoiceViewController *)controller didPickMultChoices:(NSSet*)choices;
@end
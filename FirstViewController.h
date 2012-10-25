//
//  FirstViewController.h
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "User.h"

@interface FirstViewController : UIViewController <LoginViewControllerDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) IBOutlet UILabel *firstName;
@property (nonatomic, strong) IBOutlet UILabel *lastName;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(void)logout;

@end

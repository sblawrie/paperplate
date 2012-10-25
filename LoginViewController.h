//
//  LoginViewController.h
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewControllerDelegate
-(void)loginViewDidFinish;
@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) UIViewController<LoginViewControllerDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;

-(IBAction)submitLogin:(id)sender;

@end

//
//  FirstViewController.m
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "FirstViewController.h"

#import "LoginViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize user=_user;
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize managedObjectContext=_managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.user = [User getUser])
    {
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logoutButton;
        self.firstName.text = self.user.first_name;
        
        NSMutableArray *comps = [Competition getAll];
        for(Competition *comp in comps)
        {
            NSLog(@"%@", comp.game);
        }
        
    }
    else
    {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showLoginView];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLoginView
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:NULL];
}

-(void)loginViewDidFinish
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)logout
{
    NSString *url = [NSString stringWithFormat:@"http://localhost/paperplate2/users/logout?handle=%@&uid=%d", [[NSUserDefaults standardUserDefaults]  stringForKey:@"handle"], self.user.id];
    //NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"uid"];
    [defaults synchronize];
    [self showLoginView];
}


@end

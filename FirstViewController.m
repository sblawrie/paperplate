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
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *uidstr = [[NSString alloc] init];
    if ((uidstr = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"])) {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = anotherButton;
        //Insert Object
         self.user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext: self.managedObjectContext];
        self.firstName.text = [self.user firstName];
        self.lastName.text = [self.user lastName];
        
         NSError *saveError=nil;
         [self.managedObjectContext save:&saveError];
         if (saveError!=nil) {
         NSLog(@"[%@ saveContext] Error saving context: Error=%@,details=%@",[self class], saveError,saveError.userInfo);
         }
         
         //Get Object
         NSEntityDescription *entityDescription = [NSEntityDescription
         entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
         NSFetchRequest *request = [[NSFetchRequest alloc] init];
         [request setEntity:entityDescription];
         
         // Set example predicate and sort orderings...
         NSPredicate *predicate = [NSPredicate predicateWithFormat:
         @"(firstName LIKE[c] 'Scot')"];
         [request setPredicate:predicate];
         
         
         NSError *error = nil;
         NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
         if (array == nil)
         {
         // Deal with error...
         }
         for (User *user in array) {
             NSString *name = [user firstName];
             NSString *last = user.lastName;
             NSLog(@"%@ %@", name, last);
             //[self.managedObjectContext deleteObject:user];
         }
         //[self.managedObjectContext save:&error];
         NSString *name = [[array objectAtIndex:0] firstName];
         NSLog(@"%@", name);
        

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
    NSString *url = [NSString stringWithFormat:@"http://localhost/paperplate/logout?handle=%@&uid=%d", [[NSUserDefaults standardUserDefaults]  stringForKey:@"handle"], self.user.uid];
    //NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"uid"];
    [defaults synchronize];
    [self showLoginView];
}


@end

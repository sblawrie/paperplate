//
//  LoginViewController.m
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate = _delegate;
@synthesize email = _email;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.email becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitLogin:(id)sender
{
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", self.email.text, self.password.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/paperplate2/users/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSError *e = nil;
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    NSString *str = [[NSString alloc] init];
    if (!jsonDict) {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else
    {
        str = [jsonDict objectForKey:@"success"];
    }
    if([str isEqualToString:@"true"])
    {
        NSString *uid = [[jsonDict objectForKey:@"session"] objectForKey:@"uid"];
        NSString *handle = [[jsonDict objectForKey:@"session"] objectForKey:@"handle"];
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:uid forKey:@"uid"];
        [defaults setObject:handle forKey:@"handle"];
        [defaults synchronize];
        [self.delegate viewDidLoad];
        [self.delegate loginViewDidFinish];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Login" message:@"Sorry, your email and password combination were incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end

//
//  DesktopprLoginViewController.m
//  Desktoppr
//
//  Created by ITR on 28/10/2012.
//  Copyright (c) 2012 jbrooksuk. All rights reserved.
//

#import "DesktopprLoginViewController.h"
#import "SBJson.h"

@class DesktopprLogin;

@implementation DesktopprLoginViewController {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@synthesize username, password, desktopprPassword, desktopprUsername, loginModel;

- (void)viewDidLoad
{
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
//    NSManagedObject *loginModel = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:AppDelegate.managedObjectContext];
}

// Let's login baby!
- (IBAction)desktopprLogin:(id)sender
{
    // Get our data!
    [self setUsername];
    [self setPassword];
    
    // Login with some JSON magic
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.desktoppr.co/1/user/whoami"]];
    
//    NSURL *aUrl = [NSURL URLWithString:@"https://api.desktoppr.co/1/user/whoami"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
//    [request setHTTPMethod:@"POST"];
//    NSString *postString = @"username=%@&password=AWESOME!";
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)setUsername
{
    self.username = [desktopprUsername text];
//    [loginModel setValue:self.username forKey:@"username"];
}

-(void)setPassword
{
    self.password = [desktopprPassword text];
//    [loginModel setValue:self.password forKey:@"password"];
}
@end

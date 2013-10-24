//
//  ViewController.m
//  FordBoschTabletApp
//
//  Created by Johan Ismael on 10/24/13.
//  Copyright (c) 2013 Johan Ismael. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface ViewController ()

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                                   delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.udpSocket bindToPort:5060
                    error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [self.udpSocket beginReceiving:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (IBAction)sendData:(id)sender
{
    NSData *data = [@"bonjour" dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data
                      toHost:@"10.34.128.149"
                        port:5060
                 withTimeout:3
                         tag:0];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end

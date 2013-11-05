//
//  PrintPlugin.m
//  Print Plugin
//
//  Created by Stas Gorodnichenko on 15/10/2011.
//  Copyright 2013 Stas Gorodnichenko. All rights reserved.
//  MIT licensed
//

#import "Print.h"

@implementation Print

@synthesize successCallback, failCallback, printHTML, dialogTopPos, dialogLeftPos, isPdf, filePath;

/*
 Is printing available. Callback returns true/false if printing is available/unavailable.
 */
- (void)isPrintingAvailable:(CDVInvokedUrlCommand *)command {
    [self callbackWithFuntion:@"Print._callback" withData:[NSString stringWithFormat:@"{available: %@}", ([self isPrintServiceAvailable] ? @"true" : @"false")]];
}
    
- (void)print:(CDVInvokedUrlCommand *)command {
    if ([command.arguments count]) {
        NSDictionary *parameters = command.arguments[0];
        [self printWithArgs:parameters];
    }
    else {
        NSLog(@"warning: missed arguments");
    }
}

- (void)printWithArgs:(NSDictionary *)arguments {
    self.isPdf = [[arguments objectForKey:@"isPdf"] boolValue];
    self.filePath = [arguments objectForKey:@"filePath"];
    if (self.isPdf) {
        [self tryPrintPdf:filePath];
        return;
    }
    self.printHTML = arguments[@"printHTML"];
    self.dialogLeftPos = [arguments[@"dialogLeftPos"] integerValue];
    self.dialogTopPos = [arguments[@"dialogTopPos"] integerValue];
    [self doPrint];    
}

- (void)doPrint{
    if (![self isPrintServiceAvailable]) {
        [self callbackWithFuntion:self.failCallback withData:@"{success: false, available: false}"];
        return;
    }
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    
    if (!controller) {
        NSLog(@"unable to print: print interaction controller is 'nil'");
        return;
    }
    
    if ([UIPrintInteractionController isPrintingAvailable]) {
        //Set the priner settings
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        controller.printInfo = printInfo;
        controller.showsPageRange = YES;
        
        //Set the base URL to be the www directory.
        NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil ];
        NSURL *baseURL = [NSURL fileURLWithPath:dbFilePath];
        
        //Load page into a webview and use its formatter to print the page
        UIWebView *webViewPrint = [[UIWebView alloc] init];
        [webViewPrint loadHTMLString:printHTML baseURL:baseURL];
        
        //Get formatter for web (note: margin not required - done in web page)
        UIViewPrintFormatter *viewFormatter = [webViewPrint viewPrintFormatter];
        controller.printFormatter = viewFormatter;
        controller.showsPageRange = YES;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed || error) {
                [self callbackWithFuntion:self.failCallback withData:
                 [NSString stringWithFormat:@"{success: false, available: true, error: \"%@\"}", error.localizedDescription]];
            }
            else {
                [self callbackWithFuntion:self.successCallback withData: @"{success: true, available: true}"];
            }
        };
        
        /*
         If iPad, and if button offsets passed, then show dilalog originating from offset
         */
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
            dialogTopPos != 0 && dialogLeftPos != 0) {
            [controller presentFromRect:CGRectMake(self.dialogLeftPos, self.dialogTopPos, 0, 0) inView:self.webView animated:YES completionHandler:completionHandler];
        }
        else {
            [controller presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (BOOL)isPrintServiceAvailable {
    
    Class myClass = NSClassFromString(@"UIPrintInteractionController");
    if (myClass) {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        return (controller != nil) && [UIPrintInteractionController isPrintingAvailable];
    }
    
    return NO;
}

- (void)tryPrintPdf:(NSString *)path
{
    NSData *myData = [NSData dataWithContentsOfFile:path];

    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if (pic && [UIPrintInteractionController canPrintData:myData]) {
        pic.delegate = self;

        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
    else {
        UIAlertView *mailNotConfiguredAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please specify the pdf file's path" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mailNotConfiguredAlert show];
    }
}

#pragma mark -
#pragma mark Return messages

- (void)callbackWithFuntion:(NSString *)function withData:(NSString *)value {
    if (!function || [@"" isEqualToString:function]){
        return;
    }
    
    NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", function, value];
    [self writeJavascript:jsCallBack];
}

@end
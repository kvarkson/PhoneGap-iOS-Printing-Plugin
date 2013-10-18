//
//  PrintPlugin.m
//  Print Plugin
//
//  Created by Stas Gorodnichenko on 15/10/2011.
//  Copyright 2013 Stas Gorodnichenko. All rights reserved.
//  MIT licensed
//

#import <Foundation/Foundation.h>


#import <Cordova/CDVPlugin.h>


@interface Print : CDVPlugin
    
@property (nonatomic, strong) NSString* successCallback;
@property (nonatomic, strong) NSString* failCallback;
@property (nonatomic, strong) NSString* printHTML;

//Print Settings
@property NSInteger dialogLeftPos;
@property NSInteger dialogTopPos;

//Print HTML
- (void)print:(CDVInvokedUrlCommand *)command;
- (void)printWithArgs:(NSDictionary*)arguments;

//Find out whether printing is supported on this platform.
- (void) isPrintingAvailable:(CDVInvokedUrlCommand *)command;
-(void) callbackWithFuntion:(NSString *)function withData:(NSString *)value;

@end
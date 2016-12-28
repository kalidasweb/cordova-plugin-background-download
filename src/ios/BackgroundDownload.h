#import <Cordova/CDV.h>

@interface BackgroundDownload : CDVPlugin <NSURLSessionDelegate>

- (void) startDownload:(CDVInvokedUrlCommand*)command;

@end
#import "BackgroundDownload.h"

@interface BackgroundDownload (){
    CDVInvokedUrlCommand * commands;
}

@end

@implementation BackgroundDownload

- (void)startDownload:(CDVInvokedUrlCommand*)command
{

     commands = command;

    NSString* downloadurl = [[command arguments] objectAtIndex:0];
    //NSString* downloadpath = [[command arguments] objectAtIndex:1];
    
    //NSLog(@"download 1 %@ && download 2 %@",downloadurl,downloadpath);

    NSLog(@"download 1 %@ ",downloadurl);


    [self downloadByURL:downloadurl]; // init download 

}

// start download method

- (void) downloadByURL: (NSString *)urlString{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlString]];
    [downloadTask resume];
}


#pragma mark - NSURLSession delegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    if (data){
        // downloaded data to save in loacal
        
        [self saveToLocal:data];
    }
    else{
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Download failed"];
        
        [self.commandDelegate sendPluginResult:result callbackId:commands.callbackId];
    }
    
    NSLog(@"downloaded");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    // calculate persentage of downloading file
    
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    NSLog(@"downloading %0.2f%%",progress*100);
}

// data to save local directory

- (void) saveToLocal: (NSData *) data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"test.m4a"];
    NSLog(@"filePath %@", documentsDirectory);

    [data writeToFile:filePath atomically:YES];
    
    NSString * files = @"file://";
    files = [files stringByAppendingString:filePath];
    
    NSData * localData = [NSData dataWithContentsOfURL:[NSURL URLWithString:files]];
    
    
    if (localData){
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects:@"Done",files                                                                              ,nil]];
        
        [self.commandDelegate sendPluginResult:result callbackId:commands.callbackId];
        
        NSLog(@"success");
    }
    else{
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Not saved"];
        
        [self.commandDelegate sendPluginResult:result callbackId:commands.callbackId];
        
        NSLog(@"not saved");
    }
}




@end
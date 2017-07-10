//
//  NSFileManager+PS.m
//  Pass
//
//  Created by Kiara Robles on 11/17/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import "NSFileManager+PS.h"

@implementation NSFileManager (PS)

- (NSArray *)listFilesAtPath:(NSString *)directory
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
}

+ (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

+ (void)moveAllFilesinDirectory
{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *documentsDirectory = [[paths lastObject] path];
    
    NSString *oldDirectory = NSTemporaryDirectory();
    NSString *newDirectory = documentsDirectory;
    
    NSArray *oldDirectoryFiles = [[NSFileManager defaultManager] listFilesAtPath:oldDirectory];
    NSLog(@"oldDirectory files: %@", oldDirectoryFiles);
    
    NSArray *newDirectoryFiles = [[NSFileManager defaultManager] listFilesAtPath:newDirectory];
    NSLog(@"newDirectory files: %@", newDirectoryFiles);
    
    // Get all the files at ~/tmp
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:oldDirectory error:nil];
    
    for (NSString *file in files) {
        [[NSFileManager defaultManager] moveItemAtPath:[oldDirectory stringByAppendingPathComponent:file]
                    toPath:[newDirectory stringByAppendingPathComponent:file]
                     error:nil];
    }
    
    [NSFileManager clearTmpDirectory];
    
    NSLog(@"oldDirectory files: %@", oldDirectoryFiles);
    NSLog(@"newDirectory files: %@", newDirectoryFiles);
}

@end

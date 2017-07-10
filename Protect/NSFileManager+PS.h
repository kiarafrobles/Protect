//
//  NSFileManager+PS.h
//  Pass
//
//  Created by Kiara Robles on 11/17/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (PS)

- (NSArray *)listFilesAtPath:(NSString *)directory;
+ (void)clearTmpDirectory;
+ (void)moveAllFilesinDirectory;

@end

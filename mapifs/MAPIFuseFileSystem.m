//
//  MAPIFuseFileSystem.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import "MAPIFuseFileSystem.h"
#import <Fuse4X/Fuse4X.h>
#import "XMLReader.h"

static NSString *helloStr = @"Hello World!\n";
static NSString *helloPath = @"/hello.txt";

@implementation MAPIFuseFileSystem

@synthesize types;

- (id)initWithTypes:(NSArray *)mapitypes {
  
  self.types = mapitypes;

  return [self init];
}

/*
 http://macfuse.googlecode.com/svn/tags/macfuse-2.0/core/sdk-objc/Documentation/GMUserFileSystem/Categories/NSObject_GMUserFileSystemOperations_/CompositePage.html#//apple_ref/doc/compositePage/occ/instm/NSObject(GMUserFileSystemOperations)
 
 and 
 
 http://macfuse.googlecode.com/svn/trunk/core/sdk-objc/GMUserFileSystem.h */

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error {
  // return [NSArray arrayWithObject:[helloPath lastPathComponent]];
  //return [self.types objectForKey:@"lastPathComponent"];
  if ([path isEqualToString:@"/"]) {
    return self.types;
  } else {
    
    for (NSString *type in self.types) {
      if ([[@"/" stringByAppendingPathComponent:type] isEqualToString:path] ) {
        
        
        // Grab some XML data from Twitter
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://spider:spider@172.16.125.214:8080/" stringByAppendingString:type]]];
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        
        // Synchronous isn't ideal, but simplifies the code for the Demo
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // Parse the XML Data into an NSDictionary
        NSDictionary *entities = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
        
        NSLog(@"%@", [[[entities objectForKey:@"Collection"] objectForKey:type] valueForKey:@"Id"]);
        
        NSMutableArray *files = [[NSMutableArray alloc] init];
        for (NSString *entityId in [[[entities objectForKey:@"Collection"] objectForKey:type] valueForKey:@"Id"]) {
          
          [files addObject:[NSString stringWithFormat:@"%@.xml", entityId]];
          
        }
        return files;
        
      }
    }
  }
  return nil;
}

- (NSData *)contentsAtPath:(NSString *)path {
  int entityId = [[[path pathComponents] lastObject] intValue];
  if (entityId > 0) {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://spider:spider@172.16.125.214:8080" stringByAppendingString:[[path componentsSeparatedByString:@"."] objectAtIndex:0]]]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    // Synchronous isn't ideal, but simplifies the code for the Demo
    NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return xmlData;
  } else {
    return nil;
  }

}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path userData:(id)userData error:(NSError **)error {
  int entityId = [[[path pathComponents] lastObject] intValue];
  if (entityId > 0) {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NSFileTypeRegular, NSFileType,
            nil];
  } else {
    return [NSDictionary dictionaryWithObjectsAndKeys:
          NSFileTypeDirectory, NSFileType,
          nil];
  }
}

#pragma optional Custom Icon

- (NSDictionary *)finderAttributesAtPath:(NSString *)path error:(NSError **)error {
  int entityId = [[[path pathComponents] lastObject] intValue];
  if (entityId > 0) {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NSFileTypeRegular, NSFileType,
            nil];
  } else {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            NSFileTypeDirectory, NSFileType,
            nil];
  }
  
  /*if ([path isEqualToString:helloPath]) {
    NSNumber* finderFlags = [NSNumber numberWithLong:kHasCustomIcon];
    return [NSDictionary dictionaryWithObject:finderFlags
                                       forKey:kGMUserFileSystemFinderFlagsKey];
  }
  return nil;*/
}

- (NSDictionary *)resourceAttributesAtPath:(NSString *)path
                                     error:(NSError **)error {
  if ([path isEqualToString:helloPath]) {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"hellodoc" ofType:@"icns"];
    return [NSDictionary dictionaryWithObject:[NSData dataWithContentsOfFile:file]
                                       forKey:kGMUserFileSystemCustomIconDataKey];
  }
  return nil;
}

@end

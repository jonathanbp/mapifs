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

@synthesize types, mapi;

- (id)initWithTypes:(NSArray *)mapitypes andMAPI:(MAPI *)theMAPI {
  
  self.types = mapitypes;
  self.mapi = theMAPI;

  return [self init];
}

/*
 http://macfuse.googlecode.com/svn/tags/macfuse-2.0/core/sdk-objc/Documentation/GMUserFileSystem/Categories/NSObject_GMUserFileSystemOperations_/CompositePage.html#//apple_ref/doc/compositePage/occ/instm/NSObject(GMUserFileSystemOperations)
 
 and 
 
 http://macfuse.googlecode.com/svn/trunk/core/sdk-objc/GMUserFileSystem.h
 https://github.com/fuse4x/framework/blob/master/GMUserFileSystem.h
 
 and
 
 http://macfuse.googlecode.com/svn-history/r686/trunk/core/sdk-objc/UserFileSystem.m
 
 
 */


// probably delete
- (NSData *)contentsAtPath:(NSString *)path {
  
  NSLog(@"contentsAtPath %@", path);
  
  int entityId = [[[path pathComponents] lastObject] intValue];
  if (entityId > 0) {
    
    return [self.mapi GET:[path stringByDeletingPathExtension]];
    
  } else {
    return nil;
  }

}



- (BOOL)removeDirectoryAtPath:(NSString *)path error:(NSError **)error {
  return NO;
}

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error {
  return NO;
}

#pragma mark Creating an Item

- (BOOL)createDirectoryAtPath:(NSString *)path 
                   attributes:(NSDictionary *)attributes
                        error:(NSError **)error {
  return NO;
}

- (BOOL)createFileAtPath:(NSString *)path 
              attributes:(NSDictionary *)attributes
                userData:(id *)userData
                   error:(NSError **)error {
  return NO;
}

#pragma mark File Contents

- (BOOL)openFileAtPath:(NSString *)path 
                  mode:(int)mode
              userData:(id *)userData
                 error:(NSError **)error {
  // whatever
  NSLog(@"open %@",path);
  return YES;
}

- (void)releaseFileAtPath:(NSString *)path userData:(id)userData {
  NSLog(@"release %@",path);
  // whatever 
}

- (int)readFileAtPath:(NSString *)path 
             userData:(id)userData
               buffer:(char *)buffer 
                 size:(size_t)size 
               offset:(off_t)offset
                error:(NSError **)error {
  return 0;
}

- (int)writeFileAtPath:(NSString *)path 
              userData:(id)userData
                buffer:(const char *)buffer
                  size:(size_t)size 
                offset:(off_t)offset
                 error:(NSError **)error {


  
  NSString* s = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
  
  NSLog(@"write %@\n%@", path, s);
  
  [self.mapi UPDATE:[path stringByDeletingPathExtension] withData:[NSData dataWithBytes:buffer length:size]];

  return (int)size;
  
}

- (BOOL)exchangeDataOfItemAtPath:(NSString *)path1
                  withItemAtPath:(NSString *)path2
                           error:(NSError **)error {
  
  NSLog(@"exchangeDataOfItem %@ %@",path1,path2); 
  
  return NO;
}

#pragma mark Directory Contents

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error {
  // return [NSArray arrayWithObject:[helloPath lastPathComponent]];
  //return [self.types objectForKey:@"lastPathComponent"];
  if ([path isEqualToString:@"/"]) {
    return self.types;
  } else {
    
    for (NSString *type in self.types) {
      if ([[@"/" stringByAppendingPathComponent:type] isEqualToString:path] ) {
        
        NSData *data = [self.mapi GET:[@"/" stringByAppendingString:type]];
        
        NSError *error;
        
        NSDictionary *entities = [[XMLReader dictionaryForXMLData:data error:&error] retain];
        
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

#pragma mark Getting and Setting Attributes

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

- (NSDictionary *)attributesOfFileSystemForPath:(NSString *)path
                                          error:(NSError **)error {
  NSLog(@"attributesOfFileSystemForPath %@",path); 
  NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
  NSNumber* defaultSize = [NSNumber numberWithLongLong:(2LL * 1024 * 1024 * 1024)];
  [attributes setObject:defaultSize forKey:NSFileSystemSize];
  [attributes setObject:defaultSize forKey:NSFileSystemFreeSize];
  [attributes setObject:defaultSize forKey:NSFileSystemNodes];
  [attributes setObject:defaultSize forKey:NSFileSystemFreeNodes];
  return attributes;
}

- (BOOL)setAttributes:(NSDictionary *)attributes ofItemAtPath:(NSString *)path userData:(id)userData error:(NSError **)error {
  
  NSLog(@"setAttributes %@",path); 
  return YES;
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

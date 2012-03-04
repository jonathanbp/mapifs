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
#import "MAPIFuseTransactionXMLSerializer.h"

static NSString *helloStr = @"Hello World!\n";
static NSString *helloPath = @"/hello.txt";

@interface MAPIFuseFileSystem()
@property (nonatomic, retain) NSArray *topLevelFolders;
@property (nonatomic, retain) id<MAPIFuseTransactionSerializerProtocol> serializer;
@end

/*typedef enum {
  
  Transactions,
  Entities
  
} TopLevelFolder;*/


@implementation MAPIFuseFileSystem

@synthesize types, mapi, transactionManager, topLevelFolders, serializer;

- (id)initWithTypes:(NSArray *)mapitypes MAPI:(MAPI *)theMAPI andTransactionManager:(MAPIFuseTransactionManager *)tm{
  
  /* structure is:
   
    /
    |- Transactions
    |  |- current.sh  
    | 
    |- Entities
       |- Organization
       |- BedPlace
       |- <etc.>
  
  */
  
  
  self.topLevelFolders = [NSArray arrayWithObjects:@"Transactions", @"Entities", nil];
  self.serializer = [[MAPIFuseTransactionXMLSerializer alloc] init];
  
  self.types = mapitypes;
  self.mapi = theMAPI;
  self.transactionManager = tm;
  
  
  // BEGIN: TEST DATA
  
  MAPIFuseTransaction *t = [tm beginTransaction:@"test"];
  [t enlist:@"Organization/youknowit" type:@"Organization" withMethod:CREATE];
    
  // END: TEST DATA

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
  
  MAPIFuseTransaction *currentTransaction = [self.transactionManager currentTransaction];
  NSString *entity = [path stringByReplacingOccurrencesOfString:@"/Entities/" withString:@""];
  if (currentTransaction != nil && [currentTransaction isEnlisted:entity]) {
    return [[self.serializer serializeTransactionalAction:[currentTransaction actionWithEntity:entity]] dataUsingEncoding:NSUTF8StringEncoding];
  }
  
  NSArray *pathComponents = [path pathComponents];
  int entityId = [[pathComponents lastObject] intValue];
  if (entityId > 0) {
    
    entity = [NSString stringWithFormat:@"%@/%@", [pathComponents objectAtIndex:pathComponents.count-2], [pathComponents lastObject]];
    
    return [self.mapi GET:entity];
    
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
  
  if (![path hasPrefix:@"/Entities"]) { 
    NSLog(@"Not allowed to created files outside /Entities");
    return NO;
  }
  
  // TODO create transactional create with key <type>-<filename>
  //      add create to current transaction
  
  MAPIFuseTransaction *t = [self.transactionManager beginTransaction:@"singleton"];
  
  NSArray *pathComponents = [[path stringByDeletingPathExtension] pathComponents];
  
  NSString *type = [pathComponents lastObject];
  NSString *name = [pathComponents objectAtIndex:pathComponents.count-2];
    
  [t enlist:[NSString stringWithFormat: @"%@/%@",type,name] type:type withMethod:CREATE];
  
  return YES;
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
    return self.topLevelFolders;
  } else {
    
    // /Transactions
    
    if ([path isEqualToString:@"/Transactions"]) {
      // look up in tm
      NSMutableArray *files = [[NSMutableArray alloc] init];
      
      MAPIFuseTransaction *t = [self.transactionManager currentTransaction];
      
      if(t != nil) {
        [files addObject:t.name];
      }
      
      return files;
    }
    
    // /Entities
    else if([path hasPrefix:@"/Entities"]) {
      
      if ([path isEqualToString:@"/Entities"]) return self.types;
      
      for (NSString *type in self.types) {
        if ([[@"/Entities/" stringByAppendingPathComponent:type] isEqualToString:path] ) {
          
          NSData *data = [self.mapi GET:[@"/" stringByAppendingString:type]];
          
          NSError *error;
          
          NSDictionary *entities = [[XMLReader dictionaryForXMLData:data error:&error] retain];
          
          NSMutableArray *files = [[NSMutableArray alloc] init];
          for (NSString *entityId in [[[entities objectForKey:@"Collection"] objectForKey:type] valueForKey:@"Id"]) {
            [files addObject:[NSString stringWithFormat:@"%@.xml", entityId]];
          }
          
          // add files which have been created as part of a transactions
          MAPIFuseTransaction *t = [self.transactionManager currentTransaction];
          
          if(t != nil) {
            NSArray *actionsOnType = [t actionsOnType:type];
            for (MAPIFuseTransactionalAction *action in actionsOnType) {
              
              NSArray *pathComponents = [action.entityId pathComponents];
              
              [files addObject:[NSString stringWithFormat:@"%@.xml", [pathComponents lastObject]] ];              
            }
          }
          
          
          return files;
          
        }
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
  
  NSLog(@"setAttributes %@ with %@", path, attributes); 
  // TODO --- YOU GOT TO HERE --- if "file" does not exist then create entry in transaction
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

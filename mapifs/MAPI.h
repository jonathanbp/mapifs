//
//  MAPI.h
//  mapifs
//
//  A MAPI is a representation of a CIS server. 
//  It has local shortterm caching.
//
//  Created by Jonathan Bunde-Pedersen on 27/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAPI : NSObject {
  
  NSURL *url;
  NSString *username;
  NSString *pasword;
  
  NSDictionary *cache;
}

@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

- (id) initWithURL:(NSURL *)address userName:(NSString *)user andPassword:(NSString *)pass;

- (NSData *) GET:(NSString *)path;
- (NSData *) CREATE:(NSString *)path withData:(NSData *)data;
- (NSData *) UPDATE:(NSString *)path withData:(NSData *)data;
- (NSData *) DELETE:(NSString *)path;


@end

//
//  MAPI.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 27/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import "MAPI.h"

@implementation MAPI


@synthesize username, password, url;

- (id) initWithURL:(NSURL *)address userName:(NSString *)user andPassword:(NSString *)pass {
  
  // init cache
  cache = [[NSDictionary alloc] init];
  
  [self setUsername:user];
  [self setPassword:pass];
  [self setUrl:address];
  
  return self;
}

- (NSData *) sendRequest:(NSString *)path withMethod:(NSString *)method andData:(NSData *)data {
  
  NSString *abspath = [NSString stringWithFormat:@"http://%@:%@@%@%@",self.username,self.password,self.url,path];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:abspath]];
  
  [request setHTTPMethod:method];
  
  if (data != nil) {
    [request setHTTPBody:data];
  }
  
  NSError *error = nil;
  NSHTTPURLResponse *response = nil;
  
  NSLog(@"%@ %@", method, abspath);
  
  return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  
}

- (NSData *) GET:(NSString *)path {
  return [self sendRequest:path withMethod:@"GET" andData:nil];
}

- (NSData *) CREATE:(NSString *)path withData:(NSData *)data {
  return [self sendRequest:path withMethod:@"POST" andData:data];
}

- (NSData *) UPDATE:(NSString *)path withData:(NSData *)data {
  return [self sendRequest:path withMethod:@"PUT" andData:data];
}

- (NSData *) DELETE:(NSString *)path {
  return [self sendRequest:path withMethod:@"DELETE" andData:nil];
}

@end

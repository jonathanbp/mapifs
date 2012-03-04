//
//  MAPIFuseTransactionXMLSerializer.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 4/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import "MAPIFuseTransactionXMLSerializer.h"

@implementation MAPIFuseTransactionXMLSerializer

- (NSString *)serializeTransaction:(MAPIFuseTransaction *)transaction {

    return @"";
  
}

- (NSString *)serializeTransactionalAction:(MAPIFuseTransactionalAction *)action {

  /*
    [indent]<TransactionalAction index="[index]">[newline]
    [indent][content w all newlines replaced w newline+indent]
    [indent]</TransactionalAction>
  */
  
  NSString *indent = @"";
  
  // generate content string with all newlines replaced by [indent]\n
  NSString *content = [action.content stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"%@\n", indent]];
  
  NSString *s = [NSString stringWithFormat: @"%@<TransactionalAction index=\"%@\">\n%@%@%@</TransactionalAction>", indent, index, indent, content, indent];
  
  return s;
}

@end

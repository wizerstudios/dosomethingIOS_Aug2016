//
//  NSString+validations.h
//  Seidensticker
//
//  Created by OCS iOS Developer on 12/10/15.
//  Copyright (c) 2015 Nandha Kumar. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (validations)
+(BOOL)isEmpty:(NSString *)string;
+(BOOL) validateEmail: (NSString *) email;
+(BOOL) validatePassword: (NSString *) password;
+(BOOL)validatePostalCode:(NSString*) postalcode;
@end

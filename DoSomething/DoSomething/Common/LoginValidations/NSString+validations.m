//
//  NSString+validations.m
//  Seidensticker
//
//  Created by OCS iOS Developer on 12/10/15.
//  Copyright (c) 2015 Nandha Kumar. All rights reserved.
//


#import "NSString+validations.h"

@implementation NSString (validations)
+(BOOL)isEmpty:(NSString *)string{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        return YES;
    else
        return NO;
}

+(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isValid = [emailTest evaluateWithObject:email];
    
    return isValid;
}

+(BOOL) validatePassword: (NSString *) password{
    // Will check for 6 characters
    // lower and upper case combination
    // atleast a numeric number
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"(?=^.{6,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$" options:0 error:nil];
    return [regex numberOfMatchesInString:password options:0 range:NSMakeRange(0, [password length])] > 0;
}


+(BOOL)validatePostalCode:(NSString*)postalcode
{
    NSString *numberRegEx = @"[0-9]{5}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:postalcode] == YES)
        return TRUE;
    else
        return FALSE;
}

+(BOOL)isNull:(NSString *)string{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:[NSNull null]])
        return YES;
    else
        return NO;
}



@end

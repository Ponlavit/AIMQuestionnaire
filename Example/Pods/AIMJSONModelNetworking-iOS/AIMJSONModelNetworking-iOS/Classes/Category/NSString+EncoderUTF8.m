//
//  NSDate+EncoderUTF8.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/29/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "NSString+EncoderUTF8.h"

@implementation NSString (EncoderUTF8)
- (NSString *) escapedUnicode
{
    NSMutableString *uniString = [ [ NSMutableString alloc ] init ];
    UniChar *uniBuffer = (UniChar *) malloc ( sizeof(UniChar) * [ self length ] );
    CFRange stringRange = CFRangeMake ( 0, [ self length ] );
    
    CFStringGetCharacters ( (CFStringRef)self, stringRange, uniBuffer );
    
    for ( int i = 0; i < [ self length ]; i++ ) {
            [ uniString appendFormat: @"\\u%04x", uniBuffer[i] ];
    }
    
    free ( uniBuffer );
    
    NSString *retString = [ NSString stringWithString: uniString ];
    
    return retString;
}
@end

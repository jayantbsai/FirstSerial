/*
 The MIT License (MIT)
 Copyright (c) 2011 Jayant Sai (@j6y6nt)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "RscMgr+IO.h"

@implementation RscMgr (IO)

#pragma mark - NSData

- (NSData *)readData:(UInt32)length {
    UInt8 *array = (UInt8 *)malloc(sizeof(UInt8) * length);
    [self read:array Length:length];
    
    NSData *data = [NSData dataWithBytes:array length:length];
    
    free(array);
    return data;
}

- (NSData *)readData {
    return [self readData:[self getReadBytesAvailable]];
}

- (int)writeData:(NSData *)data {
    UInt8 *array;
    array = CFDataGetBytePtr((__bridge CFDataRef)data);
    return [self write:array Length:[data length]];
}

#pragma mark - NSString

- (NSString *)readString:(UInt32)length {
    NSData *data = [self readData:length];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (NSString *)readString {
    return [self readString:[self getReadBytesAvailable]];
}

- (int)writeString:(NSString *)string {
    return [self writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

//
//  AllergensDataProvider.m
//  FoodSafety
//
//  Created by BoHuang on 9/6/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AllergensDataProvider.h"

@interface AllergensDataProvider ()
{
    __strong NSDictionary *_formData;
    __strong NSArray *_contentsData;
}
@end

@implementation AllergensDataProvider

- (void)startOfPrint
{
    // Form data
    NSString* formPath = [[NSBundle mainBundle] pathForResource:@"AlergensDataQRCode" ofType:@"plist"];
    _formData = [[NSDictionary alloc] initWithContentsOfFile:formPath];
    
    // Contents data
    // NSString* contentsPath = [[NSBundle mainBundle] pathForResource:[_formName stringByAppendingString:@"_CONTENTS"] ofType:@"plist"];
    //_contentsData = [[NSArray alloc] initWithContentsOfFile:contentsPath];
    
    
}

- (void)endOfPrint
{
}

- (void)startPage
{
}

- (void)endPage
{
}

- (NSInteger)numberOfPages
{
    return 1;
}
- (NSDictionary *)formDataForPage:(NSInteger)pageIndex
{
    return _formData;
}

- (id)contentData:(NSString *)contentName forPage:(NSInteger)pageIndex
{

    if([contentName isEqualToString:@"QRCODE"]) return self.qrCodeData;
    return @"";
}

@end

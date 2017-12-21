//
//  ItemDataProvider.m
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ItemDataProvider.h"

@interface ItemDataProvider ()
{
    __strong NSDictionary *_formData;
    __strong NSArray *_contentsData;
}
@end

@implementation ItemDataProvider

- (void)startOfPrint
{
    // Form data
    NSString* formPath = [[NSBundle mainBundle] pathForResource:@"FormDataQRCode" ofType:@"plist"];
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
    if([contentName isEqualToString:@"ITEM-T"]) return @"Item Name";
    if([contentName isEqualToString:@"ITEM-V"]) return self.itemName;
    if([contentName isEqualToString:@"OPERATOR-T"]) return @"Operator:";
    if([contentName isEqualToString:@"OPERATOR-V"]) return self.operatorName;
    if([contentName isEqualToString:@"CREATE-DATE-T"]) return @"Create Date:";
    if([contentName isEqualToString:@"CREATE-DATE-V"]) return self.createDate;
    if([contentName isEqualToString:@"EXPIRE-DATE-T"]) return @"Expire Date:";
    if([contentName isEqualToString:@"EXPIRE-DATE-V"]) return self.expireDate;
    if([contentName isEqualToString:@"QRCODE"]) return self.qrCodeData;
    return @"";
}

@end

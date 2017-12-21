//
//  AssignModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignModel : NSObject
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mColor;

@property (nonatomic, strong) NSString* mLocation;
@property (nonatomic, strong) NSString* mFullname;
@property (nonatomic, strong) NSString* mGroup;
@property (nonatomic, strong) NSString* mLocationKeyCode;
@property (nonatomic, strong) NSString* mItem;
@property (nonatomic, strong) NSString* mItemId;
@property (nonatomic, strong) NSString* mLocationId;

-(void) parse:(NSString*) keyCode withDict:(NSDictionary*) dict;

-(NSString*) getTaskText;
@end

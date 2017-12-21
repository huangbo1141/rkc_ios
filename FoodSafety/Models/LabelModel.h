//
//  LabelModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LabelModel : NSObject
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mDeliveryId;
@property (nonatomic, strong) NSString* mFileName;
@property (nonatomic, strong) NSString* mBigFile;
@property (nonatomic, strong) NSString* mThumbFile;
@property (nonatomic, strong) NSString* mFileSize;

@property (nonatomic, strong) NSString* mStatus;
@property (nonatomic, assign) int mProgress;
@property (nonatomic, strong) UIImage* mLocalImage;
@property (nonatomic, assign) long mIndex;
@property (nonatomic, assign) BOOL isChecked;

-(void) parse:(NSDictionary*) dict;
@end

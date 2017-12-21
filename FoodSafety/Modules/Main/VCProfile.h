//
//  VCProfile.h
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBorderImageView.h"
#import "PPSSignatureView.h"

@interface VCProfile : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblNavUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet PPSSignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UIImageView *signatureCoverImage;

@property (strong, nonatomic) NSString* mFirstName;
@property (strong, nonatomic) NSString* mLastName;
@property (strong, nonatomic) NSString* mFileName;
@property (strong, nonatomic) UIImage* mProfileImage;


@end

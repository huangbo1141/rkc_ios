//
//  VCProfile.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCProfile.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"

@interface VCProfile ()

@end

@implementation VCProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cameraAction:(id)sender {
    NSString * first = @"Take Photo";
    NSString * second= @"Choose from library";
    NSString * third= @"Cancel";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Menu"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:first style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        //picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [Global AlertMessage:self Message:@"There is no camera." Title:nil];
        }
        
        
        
    }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:second style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        //picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [Global AlertMessage:self Message:@"There is no photo library." Title:nil];
        }
        
    }]; // 3
    UIAlertAction *thirdaction = [UIAlertAction actionWithTitle:third style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
    }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdaction]; // 5
    
    
    if([alert popoverPresentationController] != nil){
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        [alert popoverPresentationController].sourceView = self.btnCamera;
        [alert popoverPresentationController].sourceRect =  self.btnCamera.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

- (IBAction)actionMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionChangeName:(id)sender {
    [self showUserNameDialog];
}
- (IBAction)clearAction:(id)sender {
    [self.signatureView erase];
    [self.signatureCoverImage setHidden:YES];
}
- (IBAction)saveAction:(id)sender {
    [self saveProfile];
}
// MARK: - image picker delegate

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* image  = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *compressedImage = [UIImage compressImage:image
                                        compressRatio:0.9f];
    self.mProfileImage = compressedImage;
    [self.imgProfile setImage:compressedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /*      */
    // upload current image
    // [Global showIndicator:self];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}


- (void) loadData {
    NSString* token = [UserInfo shared].mAccount.mToken;
    [[NetworkParser shared] serviceGetProfile:token withCompletionBlock:^(id responseObject, NSString *error) {
        UserModel* userModel = (UserModel*) responseObject;
        UserModel* account =  [UserInfo shared].mAccount;
        account.mFirstName = userModel.mFirstName;
        account.mLastName =  userModel.mLastName;
        account.mEmail = userModel.mEmail;
        account.mPhoneNumber = userModel.mPhoneNumber;
        account.mPassword = userModel.mPassword;
        account.mAvatar = userModel.mAvatar;
        self.mFirstName  = account.mFirstName;
        self.mLastName = account.mLastName;
        self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",account.mFirstName, account.mLastName];
        self.lblNavUserName.text = [NSString stringWithFormat:@"%@ %@",account.mFirstName, account.mLastName];
        self.tfEmail.text = account.mEmail;
        self.tfPhone.text = account.mPhoneNumber;
        
        if(account.mSignature != nil &&  ![account.mSignature isEqualToString:@""]) {
            account.mSignature = [account.mSignature stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.signatureCoverImage setImage:[Global decodeBase64ToImage:account.mSignature]];
            });
       
        }
        [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:account.mAvatar ]];
        
    }];
}


- (void) saveProfile {
    UserModel* account = [UserInfo shared].mAccount;
    account.mEmail = self.tfEmail.text;
    account.mPassword = self.tfPassword.text;
    account.mFirstName = self.mFirstName;
    account.mLastName = self.mLastName;
    account.mAvatar = self.mFileName;
    account.mImage = self.mProfileImage;
    account.mSignature =  [Global encodeToBase64String:[self.signatureView signatureImage]] ;
    if(account.mSignature == nil)
        account.mSignature = @"";
    NSString* header =@"data:image/png;base64,";
    account.mSignature = [header stringByAppendingString: account.mSignature];
    
    [[NetworkParser shared] serviceSaveProfile:account withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [Global AlertMessage: self Message:kLang(@"Successfully Saved!") Title:kLang(@"Profile Save")];
        }
    }];
    
}

- (void) showUserNameDialog {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Username"
                                                                              message: @"Please input your full name."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"First Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Last Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * firstName = textfields[0];
        UITextField * lastName = textfields[1];
        
        self.mFirstName = firstName.text;
        self.mLastName =lastName.text;
        self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",self.mFirstName, self.mLastName];
        self.lblNavUserName.text = [NSString stringWithFormat:@"%@ %@",self.mFirstName, self.mLastName];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    
        
    }]];
    
    if([alertController popoverPresentationController] != nil){
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        [alertController popoverPresentationController].sourceView = self.btnChangeName;
        [alertController popoverPresentationController].sourceRect =  self.btnChangeName.bounds;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

//
//  VCDeliveryLabelUpload.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryLabelUpload.h"
#import "LabelModel.h"
#import "TVCellDeliveryUpload.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "SettingModel.h"
#import "BorderButton.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"

@interface VCDeliveryLabelUpload ()

@end

@implementation VCDeliveryLabelUpload
@synthesize logModel, uploadItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    logModel = (DeliveryModel*) [UserInfo shared].captureObject;
    if(uploadItems == nil) uploadItems = [[NSMutableArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    self.tableView.delegate= self;
    self.tableView.dataSource =self;
}

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* img  = [info objectForKey:UIImagePickerControllerOriginalImage];
   // UIImage *compressedImage = [UIImage compressImage:img                                        compressRatio:0.9f];
    self.image = img;
    //[self addFile:<#(NSString *)#> withImage:<#(UIImage *)#>]
    [self addFile:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) addFile:(UIImage*) image {
    LabelModel* model = [[LabelModel alloc] init];
    model.mFileName = @"";
    model.mStatus = @"start";
    model.mProgress = 0;
    model.mIndex = uploadItems.count;
    model.mLocalImage = image;
    //NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    //NSString* bytes = [NSString stringWithFormat:@"%d kb", (long)([imgData length] /1000)];
    [uploadItems addObject:model];
    [self.tableView reloadData];
}


- (IBAction)backAction:(id)sender {
    if(self.fromVC == nil)
        [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryList"];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    if(self.fromVC == nil)
        [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryList"];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addLabel:(id)sender {
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
        [alert popoverPresentationController].sourceView = self.btnAddLabel;
        [alert popoverPresentationController].sourceRect =  self.btnAddLabel.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

- (IBAction)startAllUpload:(id)sender {
    for(int i=0; i<self.uploadItems.count; i++) {
        LabelModel* label = [uploadItems objectAtIndex:i];
        if([label.mStatus isEqualToString:@"start"]) {
            [self serviceUploadImage:label];
        }
    }
    [self.tableView reloadData];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelModel * model = [self cellModelForIndex:indexPath.row];
    TVCellDeliveryUpload* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.imgPhoto.image = model.mLocalImage;
    cell.imgPhoto.clipsToBounds = true;
    if([model.mStatus isEqualToString:@"start"]) {
        cell.btnStartUpload.hidden = false;
        cell.lblStatus.hidden = true;
    }else {
        cell.btnStartUpload.hidden = true;
        cell.lblStatus.hidden = false;
    }
    if([model.mStatus isEqualToString:@"uploaded"]){
       cell.lblStatus.text = @"Uploaded";
    }
    
    if([model.mStatus isEqualToString:@"uploading"]){
        cell.lblStatus.text = @"Uploading";
    }
    if([model.mStatus isEqualToString:@"upload_fail"]){
        cell.lblStatus.text = @"Upload Faild";
    }
    [cell.btnStartUpload addTarget:self action:@selector(startUpload:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnStartUpload.tag = indexPath.row;
    
    [cell.btnDelete addTarget:self action:@selector(deleteLabel:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelModel * model = [self cellModelForIndex:indexPath.row];
    
}

- (void) startUpload:(UIButton *) sender {

    long row =  sender.tag;
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:row inSection:0] ;
    LabelModel* model = [self cellModelForIndex:row];
    model.mStatus = @"uploading";
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[myIP] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self serviceUploadImage:model];
    
    
}

- (void) deleteLabel:(UIButton *) sender {
    
    long row =  sender.tag;
    [Global ConfirmWithCompletionBlock:self Message:kLang(@"delete_confirm") Title:kLang(@"alert") withCompletion:^(NSString *result) {
        [self deleteItem:row];
        
    }];
}
- (void) deleteItem:(int) position {
    if(position >= uploadItems.count)
        return;
    else {
        [uploadItems removeObjectAtIndex:position];
        for(int i=position; i<uploadItems.count; i++) {
            LabelModel* model = uploadItems[i];
            model.mIndex -= 1;
        }
        [self.tableView reloadData];
    }
}

- (void) serviceUploadImage:(LabelModel*) model {
    
    if(logModel != nil && logModel.mKeyCode != nil) {
        model.mStatus = @"uploading";
        [[NetworkParser shared] serviceDeliveryUploadLabel:model.mLocalImage withKeyCode:logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                model.mStatus = @"uploaded";
                
            }else {
                 model.mStatus = @"upload_fail";
            }
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:model.mIndex inSection:0] ;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[myIP] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
        }];
    }else {
        model.mStatus = @"upload_fail";
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:model.mIndex inSection:0] ;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[myIP] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



//MARK: - Helpers

- (long) rowCount{
    return uploadItems.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * uploadItems.count;
}

- (int) cellHeight{
    return 100;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellDeliveryUpload";
}

- (LabelModel*) cellModelForIndex: (NSInteger) index{
    if( self.uploadItems.count > index) {
        return [self.uploadItems objectAtIndex:index];
    }else
        return nil;
}

- (void) setTableViewHeight :(double) height {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.tableView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    heightConstraint.constant = height;
    
}


@end

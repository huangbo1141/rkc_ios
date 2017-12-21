//
//  VCPrint.m
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCPrint.h"
#import "TVCellPrintDiscover.h"
#import "LWPrint.h"
#import "LWPrintDataProvider.h"
#import "AllergensDataProvider.h"
#import "ItemDataProvider.h"
#import "DeliveryMenuModel.h"
#import "ItemModel.h"
#import "UserInfo.h"
static LWPrint *_lwPrint = nil;

@interface VCPrint () {
    __strong NSDictionary *_printerInfo;
    __strong NSDictionary *_printSettngs;
    __strong NSDictionary *_lwStatus;
    __strong ItemDataProvider *_itemDataProvider;
    __strong AllergensDataProvider *_alergensDataProvider;
}
@end

@implementation VCPrint

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TVCellPrintDiscover" bundle:nil] forCellReuseIdentifier:@"TVCellPrintDiscover"];
    if(self.printers == nil) {
        self.printers = [[NSMutableArray alloc] init];
    }

    
    if(self.discover == nil) {
        self.discover = [[LWPrintDiscoverPrinter alloc] initWithModels:nil connectionType:ConnectionTypeAll];
        _discover.delegate = self;
    }

    [self.discover startDiscover];
    [self initializePrinter];
    
    
    // Do any additional setup after loading the view.
}

- (void) initializePrinter {
    _printerInfo = nil;
    if(_alergensDataProvider == nil)
        _alergensDataProvider = [[AllergensDataProvider alloc] init];
    if(_itemDataProvider == nil)
        _itemDataProvider = [[ItemDataProvider alloc] init];
    _printSettngs = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInteger:1],                @"Copies",
                     [NSNumber numberWithInteger:TapeCutEachLabel], @"Tape Cut",
                     [NSNumber numberWithBool:YES],                 @"Half Cut",
                     [NSNumber numberWithBool:NO],                  @"Low Speed",
                     [NSNumber numberWithInteger:0],                @"Density",
                     nil];
    
    _progressView.progress = 0.0;
    _processing = NO;
    [self loadData];
}

- (void) loadData {
    if(_printType != nil && [_printType isEqualToString:@"print_menu_alergens"]) {
        DeliveryMenuModel* model= (DeliveryMenuModel*) [UserInfo shared].selectedObject;
        NSString* code = [model getAllergensString];
        if([code isEqualToString:@""])
            _alergensDataProvider.qrCodeData = code;
    }else {
    
        ItemModel* item = (ItemModel*) [UserInfo shared].selectedObject;
        if(item.mName != nil) _itemDataProvider.itemName = item.mName;
        if(item.mCreator != nil) _itemDataProvider.operatorName = item.mCreator;
        if(item.mCreateDate != nil) _itemDataProvider.createDate = [item getCreateDate];
        if(item.mExpireDate != nil) _itemDataProvider.expireDate = [item getExpireDate];
        if(item.mKeyCode != nil) _itemDataProvider.qrCodeData = item.mKeyCode;
        if(item.mAlergenString != nil) _alergensDataProvider.qrCodeData = item.mAlergenString;
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_printers count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TVCellPrintDiscover";
    
    TVCellPrintDiscover *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *printer = [_printers objectAtIndex:indexPath.row];
 
    cell.lblTitle.text = [printer objectForKey:LWPrintPrinterInfoBonjourName];
    cell.lblSubTitle.text = printer[LWPrintPrinterInfoMFG];
    NSString* mac = printer[@"Serial Number"];
    [cell setChecked:NO];
    if(mac != nil && _printerInfo != nil) {
        NSString* selectedMac = _printerInfo[@"Serial Number"];
        if(selectedMac != nil && [mac isEqualToString:selectedMac]) {
            [cell setChecked:YES];
        }
    }
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *printerInfo = [_printers objectAtIndex:indexPath.row];
    _printerInfo = printerInfo;
    [self.tableView reloadData];
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LWPrintDiscoverPrinterDelegate

- (void)discoverPrinter:(LWPrintDiscoverPrinter *)discoverPrinter didFindPrinter:(NSDictionary *)printerInformation;
{
    [_printers addObject:printerInformation];
    [self.tableView reloadData];
}

// DiscoverPrinter Delegate
- (void)discoverPrinter:(LWPrintDiscoverPrinter *)discoverPrinter didRemovePrinter:(NSDictionary *)printerInformation;
{
    [_printers removeObject:printerInformation];
    [self.tableView reloadData];
}

#pragma mark -IBActions
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)printAction:(id)sender {
    _processing = YES;
    [self performPrint];
}
+ (LWPrint *)sharedLWPrint
{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _lwPrint = [[LWPrint alloc] init];
    });
    return _lwPrint;
    
}
- (void)performPrint
{
    if(_printerInfo == nil) return;
    
    LWPrint *lwPrint = [VCPrint sharedLWPrint];
    [_statusIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [lwPrint setPrinterInformation:_printerInfo];
        if(_lwStatus == nil) {
            _lwStatus = [lwPrint fetchPrinterStatus];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_statusIndicator stopAnimating];
            
            LWPrintStatusError deviceError = [lwPrint deviceErrorFromStatus:_lwStatus];
           // _lwStatusLabel.text = [NSString stringWithFormat:@"%0X", deviceError];
            LWPrintTapeWidth tapeWidth = [lwPrint tapeWidthFromStatus:_lwStatus];
            //_tapeLabel.text = [self tapeWidthStringFromTapeWidhCode:tapeWidth];
       
            lwPrint.delegate = self;
            
            NSDictionary *printParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [_printSettngs objectForKey:@"Copies"],    LWPrintParameterKeyCopies,
                                            [_printSettngs objectForKey:@"Tape Cut"],  LWPrintParameterKeyTapeCut,
                                            [_printSettngs objectForKey:@"Half Cut"],  LWPrintParameterKeyHalfCut,
                                            [_printSettngs objectForKey:@"Low Speed"], LWPrintParameterKeyPrintSpeed,
                                            [_printSettngs objectForKey:@"Density"],   LWPrintParameterKeyDensity,
                                            [NSNumber numberWithInteger:tapeWidth],    LWPrintParameterKeyTapeWidth,
                                            nil];
            if(_printType != nil && ([_printType isEqualToString:@"print_alergens"] || [_printType isEqualToString:@"print_menu_alergens"])) {
                [lwPrint doPrint:_alergensDataProvider printParameter:printParameter];
            }else {
                [lwPrint doPrint:_itemDataProvider printParameter:printParameter];
            }
                
           
            
        });
    });
    
}


@end

//
//  Stress LevelViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "Stress LevelViewController.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "SVProgressHUD.h"
#import "SessionManager.h"
@interface Stress_LevelViewController ()
{
    BOOL isOpendCombobox1;
    NSArray *comboString1;
    BOOL isOpendCombobox2;
    NSArray *comboString2;
    BOOL isOpendCombobox3;
    NSArray *comboString3;
    BOOL isOpendCombobox4;
    NSArray *comboString4;
    BOOL isOpendCombobox5;
    NSArray *comboString5;
    BOOL isOpendCombobox6;
    NSArray *comboString6;
    BOOL isOpendCombobox7;
    NSArray *comboString7;
    BOOL isOpendCombobox8;
    NSArray *comboString8;
    BOOL isOpendCombobox9;
    NSArray *comboString9;
    BOOL isOpendCombobox10;
    NSArray *comboString10;
    IBOutlet UIButton *badgeButton;

    BOOL isUpdated;
    NSString  *combo1String, *combo2String, *combo3String, *combo4String, *combo5String, *combo6String, *combo7String, *combo8String, *combo9String, *combo10String;
    int compleationrate;
}

@end

@implementation Stress_LevelViewController
@synthesize saveButton;
@synthesize stressLevel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpdated = NO;
    self.title = @"HEALTH ASSESSMENT";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]init];
    barButton.title = @"";
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _contentWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
//    self.scrollView.contentSize= CGSizeMake(320, 2600);
    
    [self initBadgeButton];
    [self loadData];
    [self combobox1Init];
    [self combobox2Init];
    [self combobox3Init];
    [self combobox4Init];
    [self combobox5Init];
    [self combobox6Init];
    [self combobox7Init];
    [self combobox8Init];
    [self combobox9Init];
    [self combobox10Init];
    saveButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    saveButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    [saveButton setCornerRadius:5.0f];
    // Do any additional setup after loading the view from its nib.
}


-(void)loadData
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/stressLevel" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.stressLevel = (NSDictionary *)responseObject;
        if([self.stressLevel count]>0)
        {
            [self showInfor];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
         message:[error localizedDescription]
         delegate:nil
         cancelButtonTitle:@"Ok"
         otherButtonTitles:nil];
         [alertView show];
         [SVProgressHUD dismiss];
        
    }];
}


-(void)showInfor
{
    self.combo1Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo1"]];
    self.combo2Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo2"]];
    self.combo3Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo3"]];
    self.combo4Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo4"]];
    self.combo5Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo5"]];
    self.combo6Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo6"]];
    self.combo7Txt.text =[self setSelectedValue:[self.stressLevel valueForKey:@"combo7"]];
    self.combo8Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo8"]];
    self.combo9Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo9"]];
    self.combo10Txt.text = [self setSelectedValue:[self.stressLevel valueForKey:@"combo10"]];
    [badgeButton setTitle:[NSString stringWithFormat:@"%@%%", [self.stressLevel valueForKey:@"completionPercentage"]] forState:UIControlStateNormal];
}

- (void) initBadgeButton
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
    [badgeButton setTitle:@"0%" forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

-(void)combobox1Init
{
    comboString1 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox1 = NO;
    self.combo1Txt.enabled = NO;
    [self.combo1Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString1 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString1[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo1Txt.text=cell.lb.text;
        [self.combo1Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo1Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo1Table.layer setBorderWidth:2];
    
}
-(void)combobox2Init
{
    comboString2 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox2 = NO;
    self.combo2Txt.enabled = NO;
    [self.combo2Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString2 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString2[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo2Txt.text=cell.lb.text;
        [self.combo2Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo2Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo2Table.layer setBorderWidth:2];
    
}
-(void)combobox3Init
{
    comboString3 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox3 = NO;
    self.combo3Txt.enabled = NO;
    [self.combo3Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString3 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString3[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo3Txt.text=cell.lb.text;
        [self.combo3Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo3Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo3Table.layer setBorderWidth:2];
    
    
}
-(void)combobox4Init
{
    comboString4 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox4 = NO;
    self.combo4Txt.enabled = NO;
    [self.combo4Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString4 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString4[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo4Txt.text=cell.lb.text;
        [self.combo4Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo4Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo4Table.layer setBorderWidth:2];
    
    
}
-(void)combobox5Init
{
    comboString5 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox5 = NO;
    self.combo5Txt.enabled = NO;
    [self.combo5Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString5 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString5[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo5Txt.text=cell.lb.text;
        [self.combo5Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo5Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo5Table.layer setBorderWidth:2];
    
    
}
-(void)combobox6Init
{
    comboString6 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox6 = NO;
    self.combo6Txt.enabled = NO;
    [self.combo6Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString6 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString6[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo6Txt.text=cell.lb.text;
        [self.combo6Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo6Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo6Table.layer setBorderWidth:2];
    
    
}
-(void)combobox7Init
{
    comboString7 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox7 = NO;
    self.combo7Txt.enabled = NO;
    [self.combo7Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString7 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString7[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo7Txt.text=cell.lb.text;
        [self.combo7Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo7Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo7Table.layer setBorderWidth:2];
    
    
}
-(void)combobox8Init
{
    comboString8 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox8 = NO;
    self.combo8Txt.enabled = NO;
    [self.combo8Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString8 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString8[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo8Txt.text=cell.lb.text;
        [self.combo8Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo8Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo8Table.layer setBorderWidth:2];
    
    
}
-(void)combobox9Init
{
    comboString9 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox9 = NO;
    self.combo9Txt.enabled = NO;
    [self.combo9Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString9 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString9[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo9Txt.text=cell.lb.text;
        [self.combo9Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo9Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo9Table.layer setBorderWidth:2];
    
    
}
-(void)combobox10Init
{
    comboString10 = [NSArray arrayWithObjects:@"never",@"almost never",@"sometimes",@"fairly often",@"very often", nil];
    isOpendCombobox10 = NO;
    self.combo10Txt.enabled = NO;
    [self.combo10Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString10 count];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString10[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo10Txt.text=cell.lb.text;
        [self.combo10Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo10Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo10Table.layer setBorderWidth:2];
    
    
}
////////
- (IBAction)clickCombo1Btn:(id)sender {
    if (isOpendCombobox1) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo1Table.frame;
            
            frame.size.height=0;
            
            [self.combo1Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox1=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo1Table.frame;
            
            frame.size.height=150;
            
            [self.combo1Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox1=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo2Btn:(id)sender {
    if (isOpendCombobox2) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo2Table.frame;
            
            frame.size.height=0;
            
            [self.combo2Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox2=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo2Table.frame;
            
            frame.size.height=150;
            
            [self.combo2Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox2=YES;
        }];
        
        
    }
    
    
}
- (IBAction)clickCombo3Btn:(id)sender {
    if (isOpendCombobox3) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo3Table.frame;
            
            frame.size.height=0;
            
            [self.combo3Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox3=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo3Table.frame;
            
            frame.size.height=150;
            
            [self.combo3Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox3=YES;
        }];
        
        
    }
    
    
    
}
- (IBAction)clickCombo4Btn:(id)sender {
    if (isOpendCombobox4) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo4Table.frame;
            
            frame.size.height=0;
            
            [self.combo4Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox4=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo4Table.frame;
            
            frame.size.height=150;
            
            [self.combo4Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox4=YES;
        }];
        
        
    }
    
    
    
}
- (IBAction)clickCombo5Btn:(id)sender {
    if (isOpendCombobox5) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo5Table.frame;
            
            frame.size.height=0;
            
            [self.combo5Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox5=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo5Table.frame;
            
            frame.size.height=150;
            
            [self.combo5Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox5=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo6Btn:(id)sender {
    if (isOpendCombobox6) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo6Table.frame;
            
            frame.size.height=0;
            
            [self.combo6Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox6=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo6Table.frame;
            
            frame.size.height=150;
            
            [self.combo6Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox6=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo7Btn:(id)sender {
    if (isOpendCombobox7) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo7Table.frame;
            
            frame.size.height=0;
            
            [self.combo7Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox7=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo7Table.frame;
            
            frame.size.height=150;
            
            [self.combo7Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox7=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo8Btn:(id)sender {
    if (isOpendCombobox8) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo8Table.frame;
            
            frame.size.height=0;
            
            [self.combo8Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox8=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo8Table.frame;
            
            frame.size.height=150;
            
            [self.combo8Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox8=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo9Btn:(id)sender {
    if (isOpendCombobox9) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo9Table.frame;
            
            frame.size.height=0;
            
            [self.combo9Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox9=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo9Table.frame;
            
            frame.size.height=150;
            
            [self.combo9Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox9=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo10Btn:(id)sender {
    if (isOpendCombobox10) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo10Table.frame;
            
            frame.size.height=0;
            
            [self.combo10Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox10=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo10Table.frame;
            
            frame.size.height=150;
            
            [self.combo10Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox10=YES;
        }];
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//just for test
- (IBAction)testButtonTapped:(UIButton *)sender
{
    self.combo1Txt.text = @"sometimes";
    self.combo2Txt.text = @"sometimes";
    self.combo3Txt.text = @"sometimes";
    self.combo4Txt.text = @"sometimes";
    self.combo5Txt.text = @"sometimes";
    self.combo6Txt.text = @"sometimes";
    self.combo7Txt.text = @"sometimes";
    self.combo8Txt.text = @"sometimes";
    self.combo9Txt.text = @"sometimes";
    self.combo10Txt.text = @"sometimes";
}


- (IBAction)clickedSaveBtn:(id)sender {
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    combo1String=[self getSelectedValue:self.combo1Txt.text];
    combo2String=[self getSelectedValue:self.combo2Txt.text];
    combo3String=[self getSelectedValue:self.combo3Txt.text];
    combo4String=[self getSelectedValue:self.combo4Txt.text];
    combo5String=[self getSelectedValue:self.combo5Txt.text];
    combo6String=[self getSelectedValue:self.combo6Txt.text];
    combo7String=[self getSelectedValue:self.combo7Txt.text];
    combo8String=[self getSelectedValue:self.combo8Txt.text];
    combo9String=[self getSelectedValue:self.combo9Txt.text];
    combo10String=[self getSelectedValue:self.combo10Txt.text];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"combo1":combo1String,@"combo2":combo2String,@"combo3":combo3String,@"combo4":combo4String,@"combo5":combo5String,@"combo6":combo6String,@"combo7":combo7String,@"combo8":combo8String,@"combo9":combo9String,@"combo10":combo10String};
    
    [manager POST:@"v1/stressLevel" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD popActivity];
        
        [badgeButton setTitle:[NSString stringWithFormat:@"%d%%",[self getcompletionRate]] forState:UIControlStateNormal];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];


}
-(int)getcompletionRate
{
    compleationrate = 0;
    if (![self.combo1Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo2Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo3Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo4Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo5Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo6Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo7Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo8Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo9Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
    if (![self.combo10Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+10;
    }
        return compleationrate;
}

-(NSString*) getSelectedValue:(NSString*) value
{
    if ([value isEqualToString:@"never"]) {
        return @"NEVER";
    }else if([value isEqualToString:@"almost never"]){
        return @"ALMOST_NEVER";
    }else if([value isEqualToString:@"sometimes"]){
        return @"SOMETIMES";
    }else if([value isEqualToString:@"fairly often"]){
        return @"FAIRLY_OFTEN";
    }else if([value isEqualToString:@"very often"]){
        return @"VERY_OFTEN";
    }
    
    return  @"";
}


-(NSString*)setSelectedValue:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"NEVER"]) {
        return @"never";
        
    }else if([value isEqualToString:@"ALMOST_NEVER"]){
        return @"almost never";
    }else if([value isEqualToString:@"SOMETIMES"]){
        return @"sometimes";
    }else if([value isEqualToString:@"FAIRLY_OFTEN"]){
        return @"fairly often";
    }else if([value isEqualToString:@"VERY_OFTEN"]){
        return @"very often";
    }
    
    return  @"";
}


@end

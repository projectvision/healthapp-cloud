//
//  DietViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "DietViewController.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "SVProgressHUD.h"
#import "SessionManager.h"
@interface DietViewController ()
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
    BOOL isOpendCombobox11;
    NSArray *comboString11;
    BOOL isOpendCombobox12;
    NSArray *comboString12;
    BOOL isOpendCombobox13;
    NSArray *comboString13;
   IBOutlet UIButton *badgeButton;
    PFObject *obj;
    BOOL isUpdated;
    int habit,grain,fruits,calcium,meats,saturatedfat,sugar;
    NSString  *combo1String, *combo2String, *combo3String, *combo4String, *combo5String, *combo6String, *combo7String, *combo8String, *combo9String, *combo10String,*combo11String,*combo12String,*combo13String;
    int compleationrate;
}


@end

@implementation DietViewController
@synthesize saveButton;
@synthesize diet;
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
    
//    self.scrollView.contentSize= CGSizeMake(320, 2800);
    _contentWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    
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
    [self combobox11Init];
    [self combobox12Init];
    [self combobox13Init];
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
    
    [manager GET:@"v1/diet" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.diet = (NSDictionary *)responseObject;
        if([self.diet count]>0)
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
    self.combo1Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo1"]];
    self.combo2Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo2"]];
    self.combo3Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo3"]];
    self.combo4Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo4"]];
    self.combo5Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo5"]];
    self.combo6Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo6"]];
    self.combo7Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo7"]];
    self.combo8Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo8"]];
    self.combo9Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo9"]];
    self.combo10Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo10"]];
    self.combo11Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo11"]];
    self.combo12Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo12"]];
    self.combo13Txt.text = [self setSelectedValue:[self.diet valueForKey:@"combo13"]];
    [badgeButton setTitle:[NSString stringWithFormat:@"%@%%", [self.diet valueForKey:@"completionPercentage"]] forState:UIControlStateNormal];
}
- (void) initBadgeButton
{
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
     [badgeButton setTitle:[NSString stringWithFormat:@"%d%%", 0] forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 15, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

-(void)combobox1Init
{
    comboString1 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];
    isOpendCombobox1 = NO;
    self.combo1Txt.enabled = NO;
    [self.combo1Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString1 count];
//        CGRect frame=self.combo1Table.frame;
//        frame.size.height=1;
//        [self.combo1Table setFrame:frame];
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
    comboString2 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];
    isOpendCombobox2 = NO;
    self.combo2Txt.enabled = NO;
    [self.combo2Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString2 count];
//        CGRect frame=self.combo2Table.frame;
//        
//        frame.size.height=1;
//        [self.combo2Table setFrame:frame];
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
    comboString3 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox3 = NO;
    self.combo3Txt.enabled = NO;
    [self.combo3Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString3 count];
//        CGRect frame=self.combo3Table.frame;
//        
//        frame.size.height=1;
//        [self.combo3Table setFrame:frame];
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
    comboString4 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox4 = NO;
    self.combo4Txt.enabled = NO;
    [self.combo4Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString4 count];
//        CGRect frame=self.combo4Table.frame;
//        
//        frame.size.height=1;
//        [self.combo4Table setFrame:frame];
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
    comboString5 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox5 = NO;
    self.combo5Txt.enabled = NO;
    [self.combo5Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString5 count];
//        CGRect frame=self.combo5Table.frame;
//        
//        frame.size.height=1;
//        [self.combo5Table setFrame:frame];
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
    comboString6 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox6 = NO;
    self.combo6Txt.enabled = NO;
    [self.combo6Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString6 count];
//        CGRect frame=self.combo6Table.frame;
//        
//        frame.size.height=1;
//        [self.combo6Table setFrame:frame];
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
    comboString7 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox7 = NO;
    self.combo7Txt.enabled = NO;
    [self.combo7Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString7 count];
//        CGRect frame=self.combo7Table.frame;
//        
//        frame.size.height=1;
//        [self.combo7Table setFrame:frame];
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
    comboString8 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox8 = NO;
    self.combo8Txt.enabled = NO;
    [self.combo8Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString8 count];
//        CGRect frame=self.combo8Table.frame;
//        
//        frame.size.height=1;
//        [self.combo8Table setFrame:frame];
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
    comboString9 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox9 = NO;
    self.combo9Txt.enabled = NO;
    [self.combo9Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString9 count];
//        CGRect frame=self.combo9Table.frame;
//        
//        frame.size.height=1;
//        [self.combo9Table setFrame:frame];
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
    comboString10 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox10 = NO;
    self.combo10Txt.enabled = NO;
    [self.combo10Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString10 count];
//        CGRect frame=self.combo10Table.frame;
//        
//        frame.size.height=1;
//        [self.combo10Table setFrame:frame];
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
-(void)combobox11Init
{
    comboString11 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox11 = NO;
    self.combo11Txt.enabled = NO;
    [self.combo11Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString11 count];
//        CGRect frame=self.combo11Table.frame;
//        
//        frame.size.height=1;
//        [self.combo11Table setFrame:frame];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString11[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo11Txt.text=cell.lb.text;
        [self.combo11Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo11Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo11Table.layer setBorderWidth:2];

    
}
-(void)combobox12Init
{
    comboString12 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox12 = NO;
    self.combo12Txt.enabled = NO;
    [self.combo12Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString12 count];
//        CGRect frame=self.combo12Table.frame;
//        
//        frame.size.height=1;
//        [self.combo12Table setFrame:frame];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString12[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo12Txt.text=cell.lb.text;
        [self.combo12Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo12Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo12Table.layer setBorderWidth:2];

    
}
-(void)combobox13Init
{
    comboString13 = [NSArray arrayWithObjects:@"Usually/Often",@"Sometimes",@"Rarely/Never", nil];    isOpendCombobox13 = NO;
    self.combo13Txt.enabled = NO;
    [self.combo13Table initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        NSInteger n=[comboString13 count];
//        CGRect frame=self.combo13Table.frame;
//        
//        frame.size.height=1;
//        [self.combo13Table setFrame:frame];
        return n;
        
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:comboString13[indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.combo13Txt.text=cell.lb.text;
        [self.combo13Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.combo13Table.layer setBorderColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0].CGColor];
    [self.combo13Table.layer setBorderWidth:2];

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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
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
            
            frame.size.height=90;
            
            [self.combo10Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox10=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo11Btn:(id)sender {
    if (isOpendCombobox11) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo11Table.frame;
            
            frame.size.height=0;
            
            [self.combo11Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox11=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo11Table.frame;
            
            frame.size.height=90;
            
            [self.combo11Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox11=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo12Btn:(id)sender {
    if (isOpendCombobox12) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo12Table.frame;
            
            frame.size.height=0;
            
            [self.combo12Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox12=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo12Table.frame;
            
            frame.size.height=90;
            
            [self.combo12Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox12=YES;
        }];
        
        
    }
    
}
- (IBAction)clickCombo13Btn:(id)sender {
    if (isOpendCombobox13) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo13Table.frame;
            
            frame.size.height=0;
            
            [self.combo13Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox13=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo13Table.frame;
            
            frame.size.height=90;
            
            [self.combo13Table setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpendCombobox13=YES;
        }];
        
        
    }
    
}

//jsut for test
- (IBAction)testButtonTapped:(UIButton *)sender
{
    self.combo1Txt.text = @"Sometimes";
    self.combo2Txt.text = @"Sometimes";
    self.combo3Txt.text = @"Sometimes";
    self.combo4Txt.text = @"Sometimes";
    self.combo5Txt.text = @"Sometimes";
    self.combo6Txt.text = @"Sometimes";
    self.combo7Txt.text = @"Sometimes";
    self.combo8Txt.text = @"Sometimes";
    self.combo9Txt.text = @"Sometimes";
    self.combo10Txt.text = @"Sometimes";
    self.combo11Txt.text = @"Sometimes";
    self.combo12Txt.text = @"Sometimes";
    self.combo13Txt.text = @"Sometimes";
}


- (IBAction)clickedSaveButton:(id)sender
{
    if ([self.combo1Txt.text isEqualToString:@"Usually/Often"]) {
        habit=habit+3;
        
    }else if([self.combo1Txt.text isEqualToString:@"Sometimes"]){
        habit=habit+2;
        
    }else if([self.combo1Txt.text isEqualToString:@"Rarely/Never"]){
        habit=habit+1;
        
    }else{
        habit=habit+0;
       
    }
    //
    if ([self.combo2Txt.text isEqualToString:@"Usually/Often"]) {
        habit=habit+3;
        
    }else if([self.combo2Txt.text isEqualToString:@"Sometimes"]){
        habit=habit+2;
        
    }else if([self.combo2Txt.text isEqualToString:@"Rarely/Never"]){
        habit=habit+1;
        
    }else{
        habit=habit+0;
        
    }
    //
    if ([self.combo3Txt.text isEqualToString:@"Usually/Often"]) {
        grain=grain+3;
        
    }else if([self.combo3Txt.text isEqualToString:@"Sometimes"]){
        grain=grain+2;
        
    }else if([self.combo3Txt.text isEqualToString:@"Rarely/Never"]){
        grain=grain+1;
        
    }else{
        grain=grain+0;
        
    }
    if ([self.combo4Txt.text isEqualToString:@"Usually/Often"]) {
        fruits=fruits+3;
        
    }else if([self.combo4Txt.text isEqualToString:@"Sometimes"]){
        fruits=fruits+2;
        
    }else if([self.combo4Txt.text isEqualToString:@"Rarely/Never"]){
        fruits=fruits+1;
        
    }else{
        fruits=fruits+0;
        
    }
    if ([self.combo5Txt.text isEqualToString:@"Usually/Often"]) {
        fruits=fruits+3;
        
    }else if([self.combo5Txt.text isEqualToString:@"Sometimes"]){
        fruits=fruits+2;
        
    }else if([self.combo5Txt.text isEqualToString:@"Rarely/Never"]){
        fruits=fruits+1;
        
    }else{
        fruits=fruits+0;
        
    }
    //
    if ([self.combo6Txt.text isEqualToString:@"Usually/Often"]) {
        calcium=calcium+3;
        
    }else if([self.combo6Txt.text isEqualToString:@"Sometimes"]){
        calcium=calcium+2;
        
    }else if([self.combo6Txt.text isEqualToString:@"Rarely/Never"]){
        calcium=calcium+1;
        
    }else{
        calcium=calcium+0;
        
    }
    if ([self.combo7Txt.text isEqualToString:@"Usually/Often"]) {
        meats=meats+3;
        
    }else if([self.combo7Txt.text isEqualToString:@"Sometimes"]){
        meats=meats+2;
        
    }else if([self.combo7Txt.text isEqualToString:@"Rarely/Never"]){
        meats=meats+1;
        
    }else{
        meats=meats+0;
        
    }
    if ([self.combo8Txt.text isEqualToString:@"Usually/Often"]) {
        meats=meats+3;
        
    }else if([self.combo8Txt.text isEqualToString:@"Sometimes"]){
        meats=meats+2;
        
    }else if([self.combo8Txt.text isEqualToString:@"Rarely/Never"]){
        meats=meats+1;
        
    }else{
        meats=meats+0;
        
    }
    if ([self.combo9Txt.text isEqualToString:@"Usually/Often"]) {
        saturatedfat=saturatedfat+3;
        
    }else if([self.combo9Txt.text isEqualToString:@"Sometimes"]){
        saturatedfat=saturatedfat+2;
        
    }else if([self.combo9Txt.text isEqualToString:@"Rarely/Never"]){
        saturatedfat=saturatedfat+1;
        
    }else{
        saturatedfat=saturatedfat+0;
        
    }
    if ([self.combo10Txt.text isEqualToString:@"Usually/Often"]) {
        saturatedfat=saturatedfat+3;
        
    }else if([self.combo10Txt.text isEqualToString:@"Sometimes"]){
        saturatedfat=saturatedfat+2;
        
    }else if([self.combo10Txt.text isEqualToString:@"Rarely/Never"]){
        saturatedfat=saturatedfat+1;
        
    }else{
        saturatedfat=saturatedfat+0;
        
    }
    if ([self.combo11Txt.text isEqualToString:@"Usually/Often"]) {
        saturatedfat=saturatedfat+3;
        
    }else if([self.combo11Txt.text isEqualToString:@"Sometimes"]){
        saturatedfat=saturatedfat+2;
        
    }else if([self.combo11Txt.text isEqualToString:@"Rarely/Never"]){
        saturatedfat=saturatedfat+1;
        
    }else{
        saturatedfat=saturatedfat+0;
        
    }
    if ([self.combo12Txt.text isEqualToString:@"Usually/Often"]) {
        sugar=sugar+3;
        
    }else if([self.combo12Txt.text isEqualToString:@"Sometimes"]){
        sugar=sugar+2;
        
    }else if([self.combo12Txt.text isEqualToString:@"Rarely/Never"]){
        sugar=sugar+1;
        
    }else{
        sugar=sugar+0;
        
    }
    if ([self.combo13Txt.text isEqualToString:@"Usually/Often"]) {
        sugar=sugar+3;
        
    }else if([self.combo13Txt.text isEqualToString:@"Sometimes"]){
        sugar=sugar+2;
        
    }else if([self.combo13Txt.text isEqualToString:@"Rarely/Never"]){
        sugar=sugar+1;
        
    }else{
        sugar=sugar+0;
        
    }
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
    combo11String=[self getSelectedValue:self.combo11Txt.text];
    combo12String=[self getSelectedValue:self.combo12Txt.text];
    combo13String=[self getSelectedValue:self.combo13Txt.text];
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"combo1":combo1String,@"combo2":combo2String,@"combo3":combo3String,@"combo4":combo4String,@"combo5":combo5String,@"combo6":combo6String,@"combo7":combo7String,@"combo8":combo8String,@"combo9":combo9String,@"combo10":combo10String,@"combo11":combo11String,@"combo12":combo12String,@"combo13":combo13String};
    
    [manager POST:@"v1/diet" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
    

    ///
   /* obj[@"HABITS"]=[NSNumber numberWithInt:habit];
    obj[@"GRAIN"]=[NSNumber numberWithInt:grain];
    obj[@"FRUITS_VEG"]=[NSNumber numberWithInt:fruits];
    obj[@"CALCIUM"]=[NSNumber numberWithInt:calcium];
    obj[@"SAT_FAT"]=[NSNumber numberWithInt:saturatedfat];
    obj[@"SUGAR"]=[NSNumber numberWithInt:sugar];
    obj[@"MEATS"]=[NSNumber numberWithInt:meats];
    obj[@"COMPLETIONRATE"]=[NSString stringWithFormat:@"%d",[self getcompletionRate]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Lifestyle"];
    [query whereKey:@"username" equalTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            if ([objects lastObject][@"ActivityLevel"])
            {
                obj[@"ACTIVITY_LEVEL"]=[objects lastObject][@"ActivityLevel"];
                [self nextFunction];
            }
            else
            {
                obj[@"ACTIVITY_LEVEL"]=[NSNumber numberWithInt:0];
            }
        }
    }];*/
}

-(int)getcompletionRate
{
    compleationrate = 0;
    if (![self.combo1Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo2Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo3Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo4Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo5Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo6Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo7Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo8Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo9Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo10Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo11Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo12Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (![self.combo13Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+7;
    }
    if (compleationrate==91) {
        compleationrate = 100;
    }
    return compleationrate;
}

-(void)nextFunction
{
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD popActivity];
            [badgeButton setTitle:[NSString stringWithFormat:@"%d%%",[self getcompletionRate]] forState:UIControlStateNormal];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)setSelectedValue:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"USUALLY_OR_OFTEN"]) {
        return @"Usually/Often";
        
    }else if([value isEqualToString:@"SOMETIMES"]){
        return @"Sometimes";
    }else if([value isEqualToString:@"RARELY_OR_NEVER"]){
        return @"Rarely/Never";
    }
    return  @"";
}


-(NSString*) getSelectedValue:(NSString*) value
{
    if ([value isEqualToString:@"Usually/Often"]) {
        return @"USUALLY_OR_OFTEN";
    }else if([value isEqualToString:@"Sometimes"]){
        return @"SOMETIMES";
    }else if([value isEqualToString:@"Rarely/Never"]){
        return @"RARELY_OR_NEVER";
    }
    return  @"";
}



@end

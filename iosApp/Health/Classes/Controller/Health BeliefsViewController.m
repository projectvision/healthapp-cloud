//
//  Health BeliefsViewController.m
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "Health BeliefsViewController.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "SVProgressHUD.h"
#import "SessionManager.h"


@interface Health_BeliefsViewController ()
{
    BOOL isOpendCombobox1;
    NSArray *comboString1;
    BOOL isOpendCombobox2;
    NSArray *comboString2;
    BOOL isOpendCombobox3;
    NSArray *comboString3;
    BOOL isOpendCombobox4;
    NSArray *comboString4;
    IBOutlet UIButton *badgeButton;
   
    NSString  *susceptibility,*severity,*barriers,*benefits;
    BOOL isUpdated;
    
     int compleationrate;
   
}
 @property(strong) NSDictionary *healthBelief;

@end

@implementation Health_BeliefsViewController
@synthesize saveButton;
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
    
    [self initBadgeButton];
    [self loadData];
    [self combobox1Init];
    [self combobox2Init];
    [self combobox3Init];
    [self combobox4Init];
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
    
    [manager GET:@"v1/healthBelief" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
     
        [badgeButton setTitle:[NSString stringWithFormat:@"%d%%",[self getcompletionRate]] forState:UIControlStateNormal];
        
         self.healthBelief = (NSDictionary *)responseObject;
         if([self.healthBelief count]>0)
         {
          [self showInfor];
          [SVProgressHUD dismiss];
         }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
  

      /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];*/
        
    }];
    

    
    
    
    
}
-(void)showInfor
{
    self.combo1Txt.text = [self setSelectedValue:[self.healthBelief valueForKey:@"susceptibility"]];
    self.combo2Txt.text = [self setSelectedValue:[self.healthBelief valueForKey:@"severity"]];
    self.combo3Txt.text = [self setSelectedValue:[self.healthBelief valueForKey:@"barriers"]];
    self.combo4Txt.text = [self setSelectedValue:[self.healthBelief valueForKey:@"benefits"]];
   
    [badgeButton setTitle:[NSString stringWithFormat:@"%@%%", [self.healthBelief valueForKey:@"completionPercentage"]] forState:UIControlStateNormal];
    
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
    comboString1 = [NSArray arrayWithObjects:@"Strongly Disagree",@"Disagree",@"Neutral",@"Agree",@"Strongly Agree", nil];
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
    comboString2 = [NSArray arrayWithObjects:@"Strongly Disagree",@"Disagree",@"Neutral",@"Agree",@"Strongly Agree", nil];
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
    comboString3 = [NSArray arrayWithObjects:@"Strongly Disagree",@"Disagree",@"Neutral",@"Agree",@"Strongly Agree", nil];    isOpendCombobox3 = NO;
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
    comboString4 = [NSArray arrayWithObjects:@"Strongly Disagree",@"Disagree",@"Neutral",@"Agree",@"Strongly Agree", nil];    isOpendCombobox4 = NO;
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
////////
- (IBAction)clickCombo1Btn:(id)sender
{
    if(isOpendCombobox4||isOpendCombobox2 || isOpendCombobox3)
    {
        return;
    }
    
    if (isOpendCombobox1)
    {
       
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo1Table.frame;
            
            frame.size.height=0;
            
            [self.combo1Table setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpendCombobox1=NO;
        }];
    }
    else
    {
       
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
    if(isOpendCombobox4||isOpendCombobox1 || isOpendCombobox3)
    {
        return;
    }
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
    if(isOpendCombobox4||isOpendCombobox1 || isOpendCombobox2)
    {
        return;
    }
    [self.combo3Table setHidden:NO];
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
    if(isOpendCombobox3||isOpendCombobox1 || isOpendCombobox2)
    {
        return;
    }

        if (isOpendCombobox4) {
        isOpendCombobox4=NO;

        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo4Table.frame;
            
            frame.size.height=0;
            frame.origin.y=frame.origin.y+150;
            
            [self.combo4Table setFrame:frame];
            
        } completion:^(BOOL finished){
            [self.combo3Table setHidden:NO];
            [self.combo1Table setHidden:NO];
           
            
            
        }];
    }else{
        [self.combo3Table setHidden:YES];
        

        isOpendCombobox4=YES;
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame=self.combo4Table.frame;
            
            frame.size.height=150;
            frame.origin.y=frame.origin.y-150;
            
            [self.combo4Table setFrame:frame];
        } completion:^(BOOL finished){
           [self.combo3Table setHidden:YES];
            
        }];
        
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testButtonTapped:(UIButton *)sender
{
    self.combo1Txt.text = @"Neutral";
    self.combo2Txt.text = @"Neutral";
    self.combo3Txt.text = @"Neutral";
    self.combo4Txt.text = @"Neutral";
}


- (IBAction)clickedSaveBtn:(id)sender
{
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    susceptibility=[self getSelectedValue:self.combo1Txt.text];
    severity=[self getSelectedValue:self.combo2Txt.text];
    barriers=[self getSelectedValue:self.combo3Txt.text];
    benefits=[self getSelectedValue:self.combo4Txt.text];
   
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"susceptibility":susceptibility,@"severity":severity,@"barriers":barriers,@"benefits":benefits};
    
    [manager POST:@"v1/healthBelief" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
        compleationrate=compleationrate+25;
    }
    if (![self.combo2Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+25;
    }
    if (![self.combo3Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+25;
    }
    if (![self.combo4Txt.text isEqualToString:@""]) {
        compleationrate=compleationrate+25;
    }
        return compleationrate;
}
-(NSString*) getSelectedValue:(NSString*) value
{
    if ([value isEqualToString:@"Strongly Disagree"]) {
      return @"STRONGLY_DISAGREE";
    }else if([value isEqualToString:@"Disagree"]){
       return @"DISAGREE";
    }else if([value isEqualToString:@"Neutral"]){
        return @"NEUTRAL";
    }else if([value isEqualToString:@"Agree"]){
       return @"AGREE";
    }else if([value isEqualToString:@"Strongly Agree"]){
       return @"STRONGLY_AGREE";
    }

       return  @"";
}
-(NSString*)setSelectedValue:(NSString*) value
{
    if(value == (id)[NSNull null])
    {
        return @"";
    }
    
    if ([value isEqualToString:@"STRONGLY_DISAGREE"]) {
        return @"Strongly Disagree";
      
    }else if([value isEqualToString:@"DISAGREE"]){
        return @"Disagree";
    }else if([value isEqualToString:@"NEUTRAL"]){
        return @"Neutral";
    }else if([value isEqualToString:@"AGREE"]){
        return @"Agree";
    }else if([value isEqualToString:@"STRONGLY_AGREE"]){
        return @"Strongly Agree";
    }
    return  @"";
}

@end

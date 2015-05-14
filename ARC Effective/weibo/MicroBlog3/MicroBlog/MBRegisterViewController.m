//
//  MBRegisterViewController.m
//  MicroBlog
//
//  Created by Reese on 13-4-27.
//  Copyright (c) 2013年 北风网www.ibeifeng.com. All rights reserved.
//

#import "MBRegisterViewController.h"
#import "UserEntity.h"
#import "MBDBManager.h"
@interface MBRegisterViewController ()

@end

@implementation MBRegisterViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc]initWithCustomView:_navBackButton]autorelease]];
    [_mainScroller setContentSize:CGSizeMake(320, 748)];
    [self.navigationItem setTitleView:_titleView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userEmail release];
    [_userPassword release];
    [_userNickname release];
    [_userDescription release];
    [_navBackButton release];
    [_mainScroller release];
    [_titleView release];
    [_userHead release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}



//开始注册


- (IBAction)startRegister:(id)sender {
    if ([[MBDBManager defaultManager]checkIsRegisterd:_userEmail.text]) {
        
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Email已经存在" message:@"注册失败" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [av show];
        [av release];
        
        return;
    }
    ;
    
    UserEntity *thisUser=[[[UserEntity alloc]init]autorelease];
    [thisUser setUserEmail:_userEmail.text];
    [thisUser setUserPassword:_userPassword.text];
    [thisUser setUserNickname:_userNickname.text];
    [thisUser setUserDescription:_userDescription.text];

    [thisUser setUserHead:[self saveUserHead]];
    
    
    
    long long int index=[[MBDBManager defaultManager]insertNewUser:thisUser];
    if (index!=0) {
        NSLog(@"我们把这个用户插入到了userTable中的第%lld行",index);
        
    }else{
        return;
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Email已经存在" message:@"注册失败" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }
    
    
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"注册成功" message:@"成功注册" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [av show];
    [av release];
    [self startLogin];
    
    
    
}


-(NSString *)saveUserHead{
    NSString *path=pathInDocumentDirectory([NSString stringWithFormat:@"IMAGE-%u",[[[NSDate date]description]hash]]);
    UIImage *headImage=_userHead.imageView.image;
    NSData *imageData=UIImageJPEGRepresentation(headImage, 0.5);
    [imageData writeToFile:path atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"myUserHead"];
    return path;
}

- (IBAction)pushBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseUserHead:(id)sender {
     UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择一张图片作为头像" delegate:self  cancelButtonTitle:@"取消" destructiveButtonTitle:@"立即拍照上传" otherButtonTitles:@"从手机相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
    
    
}

- (IBAction)tapTouch:(id)sender {
    for (UIView *view in _mainScroller.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
        
    }
}


#pragma mark UIActionSheet协议
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
if (buttonIndex ==0)
        {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setAllowsEditing:YES];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.navigationController presentModalViewController:imgPicker animated:YES];
            
        }
        if (buttonIndex ==1) {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setAllowsEditing:YES];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self.navigationController presentModalViewController:imgPicker animated:YES];
            
        }
        else return;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [_userHead setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}


//登陆
- (void)startLogin
{
    UserEntity *thisUser=[[MBDBManager defaultManager]getUserAllInfoByEmail:_userEmail.text];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:thisUser.userId forKey:MY_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:_userEmail.text forKey:MY_USER_EMAIL];
    [[NSUserDefaults standardUserDefaults] setObject:_userPassword.text forKey:MY_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] setObject:_userNickname.text forKey:MY_USER_NICKNAME];
    [[NSUserDefaults standardUserDefaults] setObject:_userDescription.text forKey:MY_USER_DESCRIPTION];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popViewControllerAnimated:NO];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in _mainScroller.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
        
    }
}
@end

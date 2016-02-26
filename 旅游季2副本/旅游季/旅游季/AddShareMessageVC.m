//
//  AddShareMessageVC.m
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "AddShareMessageVC.h"

#import "ShareModel.h"
#import "Bmob+BmobDataModelTool.h"
#import "EditImageMangerVC.h"

#import "MBProgressHUD+MJ.h"

#define Screen_W  [UIScreen mainScreen].bounds.size.width
#define margin 10
#define  button_w 45
#define button_h button_w
@interface AddShareMessageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditImageActionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextfield;
@property (strong, nonatomic)  UIImageView *displayImageView;

@property( strong, nonatomic) NSMutableArray *imageItemArrM;
@property (weak, nonatomic) IBOutlet UIButton *addShareMessageButton;
@property (weak, nonatomic) IBOutlet UILabel *accessoryTextV;

@end

@implementation AddShareMessageVC{
    
    UIButton *_currentButton;
    
}

-(NSMutableArray *)imageItemArrM{
    
    if (_imageItemArrM == nil) {
        _imageItemArrM = [[NSMutableArray alloc]init];
    }
    return _imageItemArrM;
}

-(void)viewDidLoad{
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testFiledChange) name:UITextViewTextDidBeginEditingNotification object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testFiledChange) name:UITextViewTextDidEndEditingNotification object:nil];
    
    [self initDisplayImageV];
    [self loadImageButton];
    [self reloadDisplayImageView];
    
    self.addShareMessageButton.layer.cornerRadius = 8;
    self.addShareMessageButton.clipsToBounds = YES;
   
}

- (void)initDisplayImageV{
    
    CGFloat textFiled_maxY = CGRectGetMaxY(self.accessoryTextV.frame);
    CGFloat addButton_minY = CGRectGetMinY(self.addShareMessageButton.frame);
    CGFloat v_margin = 35;
    
    _displayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(v_margin,textFiled_maxY+(addButton_minY -textFiled_maxY)/2-25,Screen_W-v_margin*2 , 55)];
    
    _displayImageView.userInteractionEnabled = YES;
    UIImage *sourceImage =[UIImage imageNamed:@"backImage"];
    UIImage *image =[sourceImage resizableImageWithCapInsets:UIEdgeInsetsMake(sourceImage.size.height/2-1, sourceImage.size.width/2-1, sourceImage.size.height/2, sourceImage.size.width/2)];
    [_displayImageView setImage:image];
    [self.view addSubview:_displayImageView];
    
    
}

-(void)loadImageButton{
    
    NSArray *imageName = @[@"jia",@"crame"];
    
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        button.tag = 101+i;
        [button addTarget:self action:@selector(imageLibraryFetch:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageItemArrM addObject:button];
    }
    

}

-(void)reloadDisplayImageView{
    CGFloat h_margin = (self.displayImageView.bounds.size.height - button_h)/2;
    for (int i = 0;i<self.imageItemArrM.count;i++) {
        UIView *itemView = self.imageItemArrM[i];
        [itemView setFrame:CGRectMake(margin+(button_w+margin)*i, h_margin, button_w, button_h)];
        [self.displayImageView addSubview:itemView];
    }
}

- (void)imageLibraryFetch:(UIButton *)sender {
    
    if (self.imageItemArrM.count>=3) {
     
            UIAlertController *alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"最大照片数为一张" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
     

    }
    
    UIImagePickerController *pickVC =[[UIImagePickerController alloc]init];
    pickVC.delegate = self;
    if ([sender tag]==101) {
        
        pickVC.sourceType = 0;
        
    }else{
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertController *alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持拍照功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        pickVC.sourceType = 1;
    }
    
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{

    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    
   
    UIImage *tempImage = [UIImage imageWithData:data];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:tempImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchDown];
    
    [self.imageItemArrM insertObject:button atIndex:0];
    [self reloadDisplayImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
     NSLog(@"取消");
}

- (IBAction)cancelAction:(id)sender {
    self.navigationController.navigationBar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma  mark 点击图片切换到处理界面
-(void)selectImage:(UIButton *)touchedButton{
    
    _currentButton = touchedButton;
    EditImageMangerVC *editImageManage = [[EditImageMangerVC alloc]init];
    editImageManage.sourceImage = _currentButton.currentImage;

    editImageManage.changeImagedelegate = self;
    [self.navigationController pushViewController:editImageManage animated:YES];
}

#pragma mark EditImageActionDelegate
- (void)compeletChangeImage:(UIImage *)resultImage{
    
    [_currentButton setImage:resultImage forState:UIControlStateNormal];
}


- (IBAction)sendShareAction:(id)sender {
    
    NSMutableArray *imageArrM = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<_imageItemArrM.count-2; i++) {

            UIButton *tempbutton = _imageItemArrM[i];
            UIImage *tempImage = tempbutton.imageView.image;
            [imageArrM addObject:tempImage];
    }
    if (_imageItemArrM.count-2<=0) {
        UIImage *tempImage = [UIImage imageNamed:@"5"];
        [imageArrM addObject:tempImage];
    }
    
    ShareModel *shareMessage = [[ShareModel alloc]initShareModelWithContent:_contentTextfield.text andImages:[imageArrM copy]];
    
    [MBProgressHUD showMessage:@"正在发送动态"];
    [Bmob inseterShareInfo:shareMessage andInsterAction:^(id result) {
        NSNumber *sendResult =(NSNumber *)result;
        if ([sendResult intValue]==1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"动态发送成功"];
        }else{
            [MBProgressHUD showError:@"动态发送失败"];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)even{
    
    [self.view endEditing:YES];
    
}


- (void)testFiledChange{
    
    if ([[_contentTextfield.text stringByReplacingOccurrencesOfString:@"" withString:@" "] isEqualToString:@""]) {
        _contentTextfield.text = @"在这里写下你的旅游心情吧...";
    }else if ([_contentTextfield.text isEqualToString:@"在这里写下你的旅游心情吧..."]) {
        _contentTextfield.text = nil;
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end

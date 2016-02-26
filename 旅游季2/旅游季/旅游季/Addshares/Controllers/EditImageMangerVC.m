//
//  EditImageMangerVC.m
//  旅游季
//
//  Created by niit on 16/1/21.
//  Copyright © 2016年 niit. All rights reserved.
//

typedef enum ScrollViewSizeType{
    
    ScrollViewSizeTypeLong=0,
    ScrollViewSizeTypeHeight
    
}ScrollViewSizeType;

#import "EditImageMangerVC.h"
#import "UIImage+Resize.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "AdjustSliderNib.h"
#import "FilterModel.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H  [UIScreen mainScreen].bounds.size.height
#define topButton_W 35
#define toorBar_H 49

#define contast_H  (667.0/ScreenH)
#define contast_W (375.0/ScreenW)



@interface EditImageMangerVC ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *showImageSV;
@property (strong, nonatomic) UIImageView *sourceImageV;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) UIScrollView *statusScrollV;
@property (strong, nonatomic) UIScrollView *adjustScrollV;

@property (strong, nonatomic) UISlider *adjustSlider;

@end

@implementation EditImageMangerVC{
    
    CGFloat imageScale;
    BOOL statusScrollVSelected;
  
    UIImage *currentImage;
    ImageUtil *unit;
    
    CIContext *_context;
    FilterModel *_filterModel;
    AdjustSliderNib *sliderV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:5/255.0 green:30
                                   
                                   /255.0 blue:35/255.0 alpha:1]];
    self.navigationController.navigationBar.hidden = YES;
    unit = [[ImageUtil alloc]init];
    currentImage = _sourceImage;
    [self initShowImageSV];
    [self initSourceImageV];
    [self initTopButtonV];
    [self initToolBar];
    [self initPerStatusScrollV];
    [self initAdjustScrollV];

    [self loadSliderV];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initShowImageSV{
    
    _showImageSV = [[UIScrollView alloc]init];
    _showImageSV.showsHorizontalScrollIndicator = NO;
    _showImageSV.showsVerticalScrollIndicator = NO;
    _showImageSV.minimumZoomScale = 1;
    _showImageSV.maximumZoomScale = 2.0;
    _showImageSV.delegate = self;
}

- (void)initSourceImageV{
    
    imageScale = self.sourceImage.size.width/self.sourceImage.size.height;
    
    if (imageScale>=1) {
        [_showImageSV setFrame:[self resertScrollViewFrameWithType:ScrollViewSizeTypeLong]];
    }else{
        [_showImageSV setFrame:[self resertScrollViewFrameWithType:ScrollViewSizeTypeHeight]];
    }
    
    CGSize newSize = CGSizeMake(_showImageSV.frame.size.width,
                                _showImageSV.frame.size.width/imageScale);
    UIImage *newImage = [self.sourceImage resizedImage:newSize interpolationQuality:kCGInterpolationNone];
    
    _sourceImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
    [_sourceImageV setImage:newImage];
    _showImageSV.contentSize = CGSizeMake(newSize.width, _sourceImageV.frame.size.height);
    
    [_showImageSV addSubview:_sourceImageV];
    [self.view addSubview:_showImageSV];
}


- (void)initTopButtonV{
    
    UIView *topBarV = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_W, 35)];
    NSArray *arr = @[@"返回",@"16:9",@"3:4",@"确定"];
    for (int i =0; i<4; i++) {
        
        UIButton *topBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBarButton setTitle:arr[i] forState:UIControlStateNormal];
        [topBarButton addTarget:self action:@selector(topBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [topBarButton setFrame:CGRectMake((Screen_W-topButton_W*4)/3*i+topButton_W*i, 0, topButton_W, topButton_W)];
        topBarButton.titleLabel.textColor = [UIColor whiteColor];
        topBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        topBarButton.tag = 100+i;
        [topBarV addSubview:topBarButton];
    }
    
    
    [topBarV setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:topBarV];
}


- (void)initToolBar{
   
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, Screen_H-toorBar_H, Screen_W, toorBar_H)];
    [_toolBar setBackgroundColor:[UIColor blackColor]];
    [_toolBar setBarTintColor:[UIColor blackColor]];
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSArray *titleArr = @[@"预设",@"调整"];
    for (int i =0; i<2; i++) {
        UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBarButton setFrame:CGRectMake(0, 0,45, 30)];
        toolBarButton.titleLabel.font = ListFont;
        toolBarButton.titleLabel.textColor = [UIColor whiteColor];
        [toolBarButton addTarget:self action:@selector(adjustImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBarButton setTitle:titleArr[i] forState:UIControlStateNormal];
        toolBarButton.tag = 110+i;
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:toolBarButton];
        
        [arrM addObject:item];
    }
    
    _toolBar.items = [arrM copy];
    [self.view addSubview:_toolBar];
}



- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _sourceImageV;
    
}

- (void)adjustImageAction:(UIButton *)toolbarButton{
     [self hiddenOtherPerStatusScrollV];
    
    if(sliderV.isShow){
        [sliderV didHidden];
    }
    if ([toolbarButton tag]==110) {
        if (!statusScrollVSelected) {
             [self showPerStatusScrollV:_statusScrollV];
        }else{
             [self hiddenPerStatusScrollV:_statusScrollV];
        }
    }
    
    if ([toolbarButton tag]==111) {
        if (!statusScrollVSelected) {
            
            [self showPerStatusScrollV:_adjustScrollV];
        }else{
            [self hiddenPerStatusScrollV:_adjustScrollV];
        }
    }
    statusScrollVSelected =  !statusScrollVSelected;
}
- (void)showPerStatusScrollV:(UIScrollView *)tempScrollV{
    [UIView animateWithDuration:0.2 animations:^{
        tempScrollV.frame = CGRectMake(0, Screen_H-toorBar_H-80, Screen_W, 80);
    }];
}
- (void)hiddenPerStatusScrollV:(UIScrollView *)tempScrollV{
    [UIView animateWithDuration:0.2 animations:^{
        tempScrollV.frame = CGRectMake(0, Screen_H, Screen_W, 80);
    }];
}
- (void)hiddenOtherPerStatusScrollV{
    for (UIView *v in [self.view subviews]) {
        if (v == _statusScrollV ||
            v==_adjustScrollV) {
            [self hiddenPerStatusScrollV:(UIScrollView *)v];
        }
    }
}


- (void)topBarButtonAction:(UIButton *)topBarBut{
    
    if ([topBarBut tag]==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([topBarBut tag]==101) {
        [self changShowImageSVTypetoLong];
    }
    if ([topBarBut tag]==102) {
        [self changShowImageSVTypetoHeight];
    }
    if ([topBarBut tag]==103) {
        [self enterChangeImage];
    }
}

- (void)changShowImageSVTypetoHeight{
     [_showImageSV setFrame:[self resertScrollViewFrameWithType:ScrollViewSizeTypeHeight]];
    CGSize newSize = CGSizeMake(_showImageSV.frame.size.width,
                                _showImageSV.frame.size.width/imageScale);
    _showImageSV.contentSize = newSize;
    [_sourceImageV setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];

}

- (void)changShowImageSVTypetoLong{
    [_showImageSV setFrame:[self resertScrollViewFrameWithType:ScrollViewSizeTypeLong]];
    CGSize newSize = CGSizeMake(_showImageSV.frame.size.width,
                                _showImageSV.frame.size.width/imageScale);

    [_sourceImageV setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];

}

- (void)enterChangeImage{
    
    CGRect currentRect ;
    if (  _sourceImageV.frame.size.height>=_showImageSV.frame.size.height) {
        currentRect =_showImageSV.frame;
    }else{
        currentRect =_sourceImageV.frame;
    }
    
    
    CGSize sourceImageSize = _sourceImageV.image.size;
    CGPoint sourceImageVOrgain =_sourceImageV.frame.origin;
    CGRect resultRect =CGRectMake(
                                 (_showImageSV.contentOffset.x-sourceImageVOrgain.x)*sourceImageSize.width/_sourceImageV.frame.size.width
                                  ,(_showImageSV.contentOffset.y- sourceImageVOrgain.y)*sourceImageSize.height/_sourceImageV.frame.size.height
                                  , currentRect.size.width*sourceImageSize.width/_sourceImageV.frame.size.width
                                  ,currentRect.size.height*sourceImageSize.height/_sourceImageV.frame.size.height);

    CGImageRef cgRef = _sourceImageV.image.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef,resultRect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (self.changeImagedelegate && [self.changeImagedelegate respondsToSelector:@selector(compeletChangeImage:)]) {
        [self.changeImagedelegate compeletChangeImage:thumbScale];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initPerStatusScrollV{
   _statusScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, 80)];
    _statusScrollV.bounces = NO;
    _statusScrollV.showsHorizontalScrollIndicator = NO;
    _statusScrollV.showsVerticalScrollIndicator  = NO;
    statusScrollVSelected = NO;
    _statusScrollV.backgroundColor = [UIColor blackColor];
    _statusScrollV.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色",nil];
   
     UIImage *semplyImage = [currentImage resizedImage:CGSizeMake(40*2, 43*2) interpolationQuality:kCGInterpolationNone];
    
    float x = 0.0 ;
    for (int i = 0; i<14; i++) {
    
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        
        x = 20 + 51*i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, 40, 23)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[arr objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setUserInteractionEnabled:YES];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 40, 43)];
        [bgImageView setUserInteractionEnabled:YES];
      
        UIImage *bgImage = [self changeImage:i imageView:nil sourceImage:semplyImage andIndex:1000+i];
        bgImageView.image = bgImage;
        
        UIView *sortV = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 40, 80)];
        [sortV addSubview:label];
        [sortV addSubview:bgImageView];
      
        sortV.tag = 100+i;
        [sortV addGestureRecognizer:recognizer];
        
        [_statusScrollV addSubview:sortV];
    }
    
    _statusScrollV.userInteractionEnabled = YES;
    _statusScrollV.contentSize = CGSizeMake(x, 0);
    [self.view insertSubview:_statusScrollV belowSubview:_toolBar];

}

- (void)initAdjustScrollV{
    
    _adjustScrollV =[[UIScrollView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, 80)];
    _adjustScrollV.bounces = NO;
    _adjustScrollV.showsHorizontalScrollIndicator = NO;
    _adjustScrollV.showsVerticalScrollIndicator  = NO;
    statusScrollVSelected = NO;
    _adjustScrollV.backgroundColor = [UIColor blackColor];
    _adjustScrollV.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    NSArray *arr = [NSArray arrayWithObjects:@"亮度",@"对比度",@"饱和度",@"色彩",@"曝光", nil];
   NSArray *imageName = [NSArray arrayWithObjects:@"iconfont-liangdu",@"iconfont-duibidu-2",@"iconfont-baohedu-2",@"iconfont-secai",@"iconfont-navbaoguang", nil];
    float x = 0.0 ;
    for (int i = 0; i<arr.count; i++) {
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageAdjust:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        
        UIImageView *sortImageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [sortImageV setImage:[UIImage imageNamed:imageName[i]]];
        
        x = 20 + 51*i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, 40, 23)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[arr objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setUserInteractionEnabled:YES];

        UIView *sortV = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 40, 80)];
        [sortV addSubview:label];
        [sortV addSubview:sortImageV];

        sortV.tag = 100+i;
        [sortV addGestureRecognizer:recognizer];
        
        [_adjustScrollV addSubview:sortV];
    }
    
    _adjustScrollV.userInteractionEnabled = YES;
    _adjustScrollV.contentSize = CGSizeMake(x, 0);
    [self.view insertSubview:_adjustScrollV belowSubview:_toolBar];
    
}

- (void)loadSliderV{
    
    sliderV = [[NSBundle mainBundle]loadNibNamed:@"AdjustSliderNib" owner:nil options:nil].lastObject;
}

- (void)setImageStyle:(UITapGestureRecognizer *)sender{
  
   
    [_sourceImageV removeFromSuperview];
    UIImage *image = [self changeImage:(int)sender.view.tag-100 imageView:nil sourceImage:currentImage andIndex:10024];
    [_sourceImageV setFrame:CGRectMake(0, 0, _sourceImageV.bounds.size.width, _sourceImageV.bounds.size.height)];
    _sourceImageV.image = image;
  
    [_showImageSV addSubview:_sourceImageV];
    
 }

- (void)setSliderImage{
    
    [_adjustSlider setThumbImage:[UIImage imageNamed:@"Thum"] forState:UIControlStateNormal];
    [_adjustSlider setMinimumTrackImage:[UIImage imageNamed:@"SilderNormalImage"] forState:UIControlStateNormal];
    [_adjustSlider setMaximumTrackImage:[UIImage imageNamed:@"SliderHelght"] forState:UIControlStateNormal];
    
}

- (void)setImageAdjust:(UITapGestureRecognizer *)sender{
    

    [self.view insertSubview:sliderV belowSubview:self.statusScrollV];
    [sliderV setFrame:CGRectMake(0,Screen_H, Screen_W, 50)];
    if (sliderV.isShow) {
        [sliderV didHidden];
    }else{
        [sliderV didShow];
    }
 
    _adjustSlider =  sliderV.slider;
    [self setSliderImage];
   

    _adjustSlider.tag = sender.view.tag;
    [_adjustSlider addTarget:self action:@selector(silderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    NSInteger tag = sender.view.tag-100;
    [self setSliderV:tag];
    
    _filterModel = [[FilterModel alloc]init];
    [_filterModel setFilterWithTag:tag];
    _context = [CIContext contextWithOptions:nil];
    CIImage *_image = [CIImage imageWithCGImage:_sourceImageV.image.CGImage];
    [_filterModel.filter setValue:_image forKey:@"inputImage"];
    
    
}
- (void)setSliderV:(NSInteger )tag{
    if (tag==0) {
          [self didSetSliderVWtihMaxValue:0.5 andMinValue:-0.5];
    }
    if (tag==1) {
        [self didSetSliderVWtihMaxValue:2.0 andMinValue:0.0];
    }
    if (tag==2) {
        [self didSetSliderVWtihMaxValue:2.0 andMinValue:0.0];
    }
    if (tag==3) {
         [self didSetSliderVWtihMaxValue:1.0 andMinValue:-1.0];
    }

    if (tag==4) {
        [self didSetSliderVWtihMaxValue:1.0 andMinValue:-1.0];
    }
    
}

-  (void)didSetSliderVWtihMaxValue:(float)maxV
                       andMinValue:(float)minV{
    _adjustSlider.maximumValue =maxV;
    _adjustSlider.minimumValue = minV;
    _adjustSlider.value = (maxV+minV)/2.0;
    sliderV.maxLabel.text = [NSString stringWithFormat:@"%.1f",maxV];
    sliderV.minLabel.text= [NSString stringWithFormat:@"%.1f",minV];
}

- (void)silderValueChange:(UISlider *)tempSilder{
    
    [_filterModel.filter setValue:[NSNumber numberWithFloat:tempSilder.value] forKey:_filterModel.filterAttributeName];
    
    [self setImage];
}


- (void)setImage{
    
    CIImage *outputImage = [_filterModel.filter outputImage];
    CGImageRef temp = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *image =[UIImage imageWithCGImage:temp];
    [_sourceImageV setImage:image];
    CGImageRelease(temp);
}

-(UIImage *)changeImage:(int)index imageView:(UIImageView *)imageView sourceImage:(UIImage *)sourceImage andIndex:(int)tag;
{
    UIImage *image;

    switch (index) {
        case 0:
        {
            return sourceImage;
        }
            break;
        case 1:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_lomo andIndex:tag];
        }
            break;
        case 2:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_heibai andIndex:tag];
        }
            break;
        case 3:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_huajiu andIndex:tag];
        }
            break;
        case 4:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_gete andIndex:tag];
        }
            break;
        case 5:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_ruise andIndex:tag];
        }
            break;
        case 6:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_danya andIndex:tag];
        }
            break;
        case 7:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_jiuhong andIndex:tag];
        }
            break;
        case 8:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_qingning andIndex:tag] ;
        }
            break;
        case 9:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_langman andIndex:tag];
        }
            break;
        case 10:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_guangyun andIndex:tag];
        }
            break;
        case 11:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_landiao andIndex:tag];
            
        }
            break;
        case 12:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_menghuan andIndex:tag];
            
        }
            break;
        case 13:
        {
            image = [unit imageWithImage:sourceImage withColorMatrix:colormatrix_yese andIndex:tag] ;
            
        }
    }
    return image;
}

- (CGRect)resertScrollViewFrameWithType:(ScrollViewSizeType)type{
    
    CGRect rect;
    
    switch (type) {
        case ScrollViewSizeTypeLong:
            rect=CGRectMake(0, 90, Screen_W, Screen_W/16*9);
            break;
        case ScrollViewSizeTypeHeight:
            rect=CGRectMake(30, 40, Screen_W-60, (Screen_W-60)/3*4);
            break;
        default:
            break;
    }
    return rect;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

@end

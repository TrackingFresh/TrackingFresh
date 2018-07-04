

import Foundation
import UIKit
import AAPopUp


/* Device Size Constants */

struct DeviceSizeConstants {
    
    static let IOS_VERSION = Int(UIDevice.current.systemVersion)
    static let IS_IPHONE = (UIDevice.current.model == "iPhone" ) || (UIDevice.current.model == "iPhone Simulator" )
    static let IS_IPAD = (UIDevice.current.model == "iPad" ) || (UIDevice.current.model == "iPad Simulator" )
    static let IS_IPHONE4 = (fabs(Double (UIScreen.main.bounds.size.height) - Double(480)) < Double.ulpOfOne)
    static let IS_IPHONE5 = (fabs(Double (UIScreen.main.bounds.size.height) - Double(568)) < Double.ulpOfOne)
    static let IS_IPHONE6 = (fabs(Double (UIScreen.main.bounds.size.height) - Double(667)) < Double.ulpOfOne)
    static let IS_IPHONE6PLUS = (fabs(Double (UIScreen.main.bounds.size.height) - Double(736)) < Double.ulpOfOne)
    static let IS_IPHONE7 = (fabs(Double (UIScreen.main.bounds.size.height) - Double(667)) < Double.ulpOfOne)
    static let IS_IPHONE7PLUS = (fabs(Double (UIScreen.main.bounds.size.height) - Double(736)) < Double.ulpOfOne)
    static let IS_IPHONEX = (fabs(Double (UIScreen.main.bounds.size.height) - Double(812)) < Double.ulpOfOne)
    
    static let rupee = "\u{20B9}"
    
}

struct StoryBoard {
//    static let MainstoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    static let TutorialBoard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
//    static let FeaturedBoard: UIStoryboard = UIStoryboard(name: "Features", bundle: nil)
}


extension AAPopUp {
    static let demo1 = AAPopUps<String? ,String>(identifier: "EditProfileViewController")
    static let demo2 = AAPopUps<String? ,String>("Main" ,identifier: "EditProfileViewController")

}


//if Constant.checkReachability() == false {
//    Alertviewclass.showAlertMethod("Watslive", strBody:"Please check your internet connection !" as NSString, delegate: nil)
//}else{





//Images hud

//#pragma mark ShowhudMethod
//
//-(void)showhud{
//    if (backgroundView) {
//        [backgroundView.layer removeAllAnimations];
//        [backgroundView removeFromSuperview];
//        backgroundView=nil;
//    }
//
//    CGRect  screenRect = [[UIScreen mainScreen] bounds];
//    backgroundView=[[UIView alloc]init];
//    backgroundView.frame=screenRect;
//    backgroundView.backgroundColor= [UIColor colorWithRed:(0.0/255.0f) green:(0.0/255.0f) blue:(0.0/255.0f) alpha:0.5];
//
//    UIImageView *ima=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indicator_logo"]];
//    ima.frame=CGRectMake(0, 0, 40, 40);
//    UIView *vi=[[UIView alloc]initWithFrame:CGRectMake((screenRect.size.width/2)-20, screenRect.size.height/2, 40, 40)];
//    vi.backgroundColor=[UIColor clearColor];
//    [vi addSubview:ima];
//
//    //  hudbackground
//    // backgroundView.backgroundColor=[UIColor blackColor];
//    backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"hudbackground"]];
//    [backgroundView addSubview:vi];
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ *4 * 60.0 ];
//    rotationAnimation.duration = 60.0;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 3;
//    [vi.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
//}
//#pragma mark HidehudMethod
//
//-(void)hidehud{
//    [backgroundView.layer removeAllAnimations];
//    [backgroundView removeFromSuperview];
//}





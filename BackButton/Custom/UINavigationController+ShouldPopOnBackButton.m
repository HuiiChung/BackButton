//
//  UINavigationController+ShouldPopOnBackButton.m
//  DoSmile
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 庄 春辉. All rights reserved.
//

#import "UINavigationController+ShouldPopOnBackButton.h"
#import "UIViewController+BackButtonHandler.h"
#import <objc/runtime.h>

static void *CurrentVC = &CurrentVC;

@implementation UINavigationController (ShouldPopOnBackButton)

-(void)setCurrentVC:(UIViewController *)currentVC
{
    objc_setAssociatedObject(self, &CurrentVC, currentVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)currentVC
{
    return objc_getAssociatedObject(self, &CurrentVC);
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
{
    UIViewController *vc = self.topViewController;
    self.currentVC = vc;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item
{
    BOOL shouldPop = YES;
    UIViewController *vc = self.topViewController;
    if([self.currentVC respondsToSelector:@selector(navigationShouldPopOnBackButton)]){
        if([vc hash]==[self.currentVC hash]){
            shouldPop = [self.currentVC navigationShouldPopOnBackButton];
            if(shouldPop){
                [self popViewControllerAnimated:YES];
            }else{
                for(UIView *subview in [navigationBar subviews]) {
                    if(subview.alpha < 1.) {
                        [UIView animateWithDuration:.25 animations:^{
                            subview.alpha = 1.;
                        }];
                    }
                }
            }
            return shouldPop;
        }else{
            return shouldPop;
        }
    }else{
        [self popViewControllerAnimated:YES];
    }
    return shouldPop;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    UIViewController *vc = self.topViewController;
    self.currentVC = vc;
}

@end

//
//  SampleViewController.h
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKViewController.h"

@interface SampleViewController : AGLKViewController
{
    GLuint _vertexBufferID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@end

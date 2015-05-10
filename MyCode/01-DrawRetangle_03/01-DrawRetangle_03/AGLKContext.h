//
//  AGLKContext.h
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext

@property (nonatomic,assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;

@end

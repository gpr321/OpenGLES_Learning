//
//  AGLKContext.m
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)setClearColor:(GLKVector4)clearColor{
    _clearColor = clearColor;
    NSAssert(self == [[self class] currentContext], @"context is not curr context");
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLbitfield)mask{
    NSAssert(self == [[self class] currentContext], @"context is not curr context");
    glClear(mask);
}

@end

//
//  AGLKTextureLoader.h
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/17.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKTextureInfo : NSObject{
    GLuint _name;
    GLenum _target;
    GLuint _width;
    GLuint _height;
}
@property (nonatomic,assign,readonly) GLuint name;
@property (nonatomic,assign,readonly) GLuint target;
@property (nonatomic,assign,readonly) GLuint width;
@property (nonatomic,assign,readonly) GLuint height;

- (instancetype)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height;

@end

@interface AGLKTextureLoader : NSObject

+ (AGLKTextureInfo *)targetWithCGImage:(CGImageRef )img options:(NSDictionary *)options error:(NSError **)error;

@end

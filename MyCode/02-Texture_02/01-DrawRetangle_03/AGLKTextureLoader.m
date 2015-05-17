//
//  AGLKTextureLoader.m
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/17.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKTextureLoader.h"

typedef enum
{
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
}
AGLKPowerOf2;

static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef img, size_t *widthPtr, size_t *heightPtr);

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(GLuint dimension);

@implementation AGLKTextureInfo

- (instancetype)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height{
    if ( self = [super init] ) {
        _name = name;
        _target = target;
        _width = width;
        _height = height;
    }
    return self;
}

@end


@implementation AGLKTextureLoader

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(GLuint dimension) {
    AGLKPowerOf2  result = AGLK1;
    
    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    
    return result;
}

static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef img, size_t *widthPtr, size_t *heightPtr){
    NSCParameterAssert(img != NULL);
    NSCParameterAssert(widthPtr != NULL);
    NSCParameterAssert(heightPtr != NULL);
    
    GLuint originalWidth = (GLuint)CGImageGetWidth(img);
    GLuint originalHeight = (GLuint)CGImageGetHeight(img);
    
    NSCAssert(originalWidth > 0, @"Invalid img width");
    NSCAssert(originalHeight > 0, @"Invalid img height");
    
    GLuint width = AGLKCalculatePowerOf2ForDimension(originalWidth);
    GLuint height = AGLKCalculatePowerOf2ForDimension(originalHeight);
    
    NSMutableData *imgData = [NSMutableData dataWithLength:width * height * 4];
    
    NSCAssert(imgData != nil, @"Unable to allocate img storage");
    
    // initial the image
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate([imgData mutableBytes], width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), img);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    *widthPtr = width;
    *heightPtr = height;
    
    return imgData;
}

+ (AGLKTextureInfo *)targetWithCGImage:(CGImageRef )img options:(NSDictionary *)options error:(NSError *__autoreleasing *)error{
    // 由于gl只接受图片尺寸为 2 的次幂的尺寸，如果图片宽高不符合要求会影响图片的质量
    size_t width;
    size_t height;
    
    NSData *imageData = AGLKDataWithResizedCGImageBytes(img, &width, &height);
    
    GLuint textureBufferID;
    // 创建缓存
    glGenTextures(1, &textureBufferID);
    // 绑定
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    // 初始化缓存
    glTexImage2D(GL_TEXTURE_2D,     // 参数名 2D 纹理
                 0,                 // MIP贴图的级别,如果没有使用MIP贴图为0
                 GL_RGBA,           // 指定为个纹理需要保存的信息量
                 (GLsizei)width,    // 图像的宽，必须是2的次幂
                 (GLsizei)height,   // 图像的高，必须是2的次幂
                 0,                 // 指定围绕纹理的边界大小，在 es 中总是为0
                 GL_RGBA,           // 缓存中所使用图像数据中每个像素所保存的信息
                 GL_UNSIGNED_BYTE,  // 缓存数据中纹理数据所使用的位编码类型
                 [imageData bytes]);
    
    // 设置纹理缓存的取样和循环模式，如果没有使用MIP贴图要一下设置
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    /**
        GL_UNSIGNED_BYTE : 会提供最佳色彩质量，但是它每个纹素中每个颜色元素的保存需要一个字节存储空间，结果每次取样一个RGB类型的纹素需要读取3字节，对于RGBA需要读取4个字节。其它纹素格式使用多种编码方式来把每个纹素的所有颜色信息保存到2个字节中
        GL_UNSIGNED_SHORT_5_6_5 : 5位用于红色，6位用于绿色，5位用于蓝色
        GL_UNSIGNED_SHORT_4_4_4_4 : 平均每个纹素的颜色使用4位
        GL_UNSIGNED_SHORT_5_5_5_1 : 格式为红绿蓝各使用5位，透明度使用1位，它会使每个纹素要么全透明要么全部不透明
     */
    
    AGLKTextureInfo *textureInfo = [[AGLKTextureInfo alloc] initWithName:textureBufferID target:GL_TEXTURE_2D width:(GLuint)width height:(GLuint)height];
    return textureInfo;
}

@end

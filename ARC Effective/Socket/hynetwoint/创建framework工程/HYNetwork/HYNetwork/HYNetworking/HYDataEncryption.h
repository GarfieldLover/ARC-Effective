//
//  HYDataEncryption.h
//  HYNetworking
//
//  Created by zhangke on 13-4-9.
//  Copyright (c) 2013年 张科. All rights reserved.
//


/*!
 该类为加密工具组件类
 */

#import <Foundation/Foundation.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#import "HYNetworkConfig.h"

//RSA密钥类型
typedef enum {
    KeyTypePublic,
    KeyTypePrivate
}KeyType;

//RSA填补类型
typedef enum {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

@interface HYDataEncryption : NSObject{
    //rsa
    RSA *_rsa;
    
    //des
    NSString* _des;
}

/*!
 @method 初始化单例类
 @param
 @return  HYNetworkEngine单例对象
 */
+ (HYDataEncryption*)shareInstance;

/*!
 @method 用开源RSA算法加密字符串
 @param 1.RSA密钥类型  2.加密字符串
 @return  加密后的字符串
 */
- (NSString *)encryptRSAKeyWithType:(KeyType)keyType plainText:(NSString*)text;

/*!
 @method 用开源RSA算法解密字符串
 @param 1.RSA密钥类型  2.解密字符串
 @return  解密后的字符串
 */
- (NSString *)decryptRSAKeyWithType:(KeyType)keyType plainText:(NSString*)text;

/*!
 @method 用ios自带RSA算法加密字符串
 @param 1.加密字符串
 @return  加密后的字符串
 */
- (NSString *)iosRSAEncrypt:(NSString *)plainText;

/*!
 @method 用ios自带RSA算法解密字符串，***该方法暂时不能用***
 @param
 @return
 */
- (NSString *)iosRSADecrypt:(NSString *)plainText;

/*!
 @method 用DES算法加密字符串
 @param 1.加密字符串
 @return  加密后的字符串
 */
-(NSString *)encryptStringUseDES:(NSString *)clearText;

/*!
 @method 用DES算法解密字符串
 @param 1.解密字符串
 @return  解密后的字符串
 */
-(NSString *)decryptStringUseDES:(NSString*)cipherText;

/*!
 @method 用DES算法加密二进制数据
 @param 1.加密数据
 @return  加密后的数据
 */
-(NSData *)encryptDataUseDES:(NSData *)data;

/*!
 @method 用DES算法解密二进制数据
 @param 1.解密数据
 @return  解密后的数据
 */
-(NSData *)decryptDataUseDES:(NSData*)data;

@end


/*!
 补充NSString方法
 */
@interface NSString(MD5)

/*!
 @method URL编码
 @param
 @return  编码后字符串
 */
- (NSString *)URLEncodedString;

/*!
 @method URL解码
 @param
 @return  解码后的字符串
 */
- (NSString*)URLDecodedString;

/*!
 @method md5加密
 @param
 @return  加密后的字符串
 */
- (NSString*)MD5String;

@end

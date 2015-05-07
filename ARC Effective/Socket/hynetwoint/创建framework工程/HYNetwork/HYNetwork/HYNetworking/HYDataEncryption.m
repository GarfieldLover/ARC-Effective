//
//  HYDataEncryption.m
//  HYNetworking
//
//  Created by zhangke on 13-4-9.
//  Copyright (c) 2013年 张科. All rights reserved.
//


#define DocumentsDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define EncryptionKeyDir [DocumentsDir stringByAppendingPathComponent:@"encryption"]
#define IOSPublicKeyFile [EncryptionKeyDir stringByAppendingPathComponent:@"ios_public_key.der"]
#define IOSPrivateKeyFile [EncryptionKeyDir stringByAppendingPathComponent:@"ios_private_key.pem"]
#define RSAPublicKeyFile [EncryptionKeyDir stringByAppendingPathComponent:@"open_publicKey.pem"]
#define RSAPrivateKeyFile [EncryptionKeyDir stringByAppendingPathComponent:@"open_privateKey.pem"]
#define DESKeyFile [EncryptionKeyDir stringByAppendingPathComponent:@"des.pem"]

#import "HYDataEncryption.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation HYDataEncryption

+ (HYDataEncryption*)shareInstance{
    static HYDataEncryption *_opensslWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _opensslWrapper = [[self alloc] init];
    });
    return _opensslWrapper;
}

#define _DEBUG_ 0
- (id)init{
    if (self = [super init]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:EncryptionKeyDir]) {
            [fm createDirectoryAtPath:EncryptionKeyDir withIntermediateDirectories:YES attributes:nil error:nil];
            if(_DEBUG_){
                [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"ios_public_key" ofType:@"der"] toPath:IOSPublicKeyFile error:nil];
                [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"ios_private_key" ofType:@"pem"] toPath:IOSPrivateKeyFile error:nil];
                [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"rsakey0-pub" ofType:@"pem"] toPath:RSAPublicKeyFile error:nil];
                [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"rsakey0" ofType:@"pem"] toPath:RSAPrivateKeyFile error:nil];
                [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"des" ofType:@"pem"] toPath:DESKeyFile error:nil];
            }else{
                NSString* bundlePath=[[NSBundle mainBundle] pathForResource:@"HYNetworkResources" ofType:@"bundle"];
                [fm copyItemAtPath:[NSBundle pathForResource:@"ios_public_key" ofType:@"der" inDirectory:bundlePath] toPath:IOSPublicKeyFile error:nil];
                [fm copyItemAtPath:[NSBundle pathForResource:@"rsakey0-pub" ofType:@"pem" inDirectory:bundlePath] toPath:RSAPublicKeyFile error:nil];
                [fm copyItemAtPath:[NSBundle pathForResource:@"des" ofType:@"pem" inDirectory:bundlePath] toPath:DESKeyFile error:nil];
            }
        }
    }return self;
}

-(SecKeyRef)getIOSKeyWith:(KeyType)type{
    NSData *certificateData=nil;
    switch (type) {
        case KeyTypePublic:
            certificateData= [[NSData alloc] initWithContentsOfFile:IOSPublicKeyFile];
            break;
        case KeyTypePrivate:
            certificateData= [[NSData alloc] initWithContentsOfFile:IOSPrivateKeyFile];
            break;
        default:
            break;
    }
    SecCertificateRef myCertificate  = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        SecTrustEvaluate(myTrust, &trustResult);
    }
    [certificateData release];
    return SecTrustCopyPublicKey(myTrust);
}

- (NSString *)iosRSAEncrypt:(NSString *)plainText
{
    SecKeyRef key=[self getIOSKeyWith:KeyTypePublic];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    
    uint8_t *cipherBuffer = NULL;
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize-11;
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            [encryptedBytes release];
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    NSString* returnString=[GTMBase64 stringByEncodingData:encryptedData];
    [encryptedData release];
    return returnString;
}

- (NSString *)iosRSADecrypt:(NSString *)plainText
{
    //算法不成功
    NSData* cipherData = [GTMBase64 decodeString:plainText];

    SecKeyRef key=[self getIOSKeyWith:KeyTypePrivate];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    
    uint8_t *cipherBuffer = NULL;
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    int blockSize = cipherBufferSize-11;
    int numBlock = (int)ceil([cipherData length] / (double)blockSize);
    
    NSMutableData *decryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[cipherData length] - i * blockSize);
        NSData *buffer = [cipherData subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
       OSStatus status = SecKeyDecrypt(key,
                                       kSecPaddingPKCS1,
                                       (const uint8_t *)[buffer bytes],
                                       [buffer length],
                                       cipherBuffer,
                                       &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc]
                                      initWithBytes:(const void *)cipherBuffer
                                      length:cipherBufferSize];
            [decryptedData appendData:encryptedBytes];
            [encryptedBytes release];
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    NSString* text = [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] autorelease];
    [decryptedData release];
    return text;
}

//根据key导入密钥
- (BOOL)importRSAKeyWithType:(KeyType)type{
    FILE *file;
    if (type == KeyTypePublic) {
        file = fopen([RSAPublicKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"rb");
    }else{
        file = fopen([RSAPrivateKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"rb");
    }
    if (NULL != _rsa) {
        RSA_free(_rsa);
        _rsa = NULL;
    }
    
    if (NULL != file) {
        if (type == KeyTypePublic) {
            _rsa = PEM_read_RSA_PUBKEY(file,NULL, NULL, NULL);
            LOG(@"  执行导入rsa加密公钥");
        }else{
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
        }
        fclose(file);
        return (_rsa != NULL)?YES:NO;
    }
    return NO;
}

//根据填补类型，确定加密长度
- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type keyType:(KeyType)keyType{
    int len = RSA_size(_rsa);
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    return len;
}

//非对称加密，一般公钥加密，私钥解密
- (NSString*)encryptRSAKeyWithType:(KeyType)keyType plainText:(NSString*)text{
    
    if (text && [text length] && [self importRSAKeyWithType:keyType]) {
        LOG(@"  执行RSA加密");

        int length = [text length];
        unsigned char input[length+1];
        bzero(input, length+1);
        
        int i;
        for (i=0;i<length; i++) {
            input[i] = [text characterAtIndex:i];
        }
        input[i] = '\0';//end of the string
        
        NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:RSA_NO_PADDING keyType:keyType];
        char *encData =  (char *)malloc(flen);
        bzero(encData, flen);
        
        switch (keyType) {
            case KeyTypePublic:
                RSA_public_encrypt(flen, (unsigned char*)input, (unsigned char*)encData, _rsa,  RSA_NO_PADDING);
                break;
            case KeyTypePrivate:
                RSA_private_encrypt(flen, (unsigned char*)input, (unsigned char*)encData, _rsa,  RSA_NO_PADDING);
                break;
            default:
                break;
        }
        
        NSData *returnData = [NSData dataWithBytes:encData length:flen];
        NSString* returnString=[GTMBase64 stringByEncodingData:returnData];
        return returnString;
        free(encData);
    }
    return nil;
}

- (NSString*)decryptRSAKeyWithType:(KeyType)keyType plainText:(NSString*)text{
    
    NSData* data=[GTMBase64 decodeString:text];
    
    if (data && [data length] && [self importRSAKeyWithType:keyType]) {
        
        NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:RSA_NO_PADDING keyType:keyType];
        char *decData =  (char *)malloc(flen);
        bzero(decData, flen);
        
        switch (keyType) {
            case KeyTypePublic:
                RSA_public_decrypt(flen, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa,  RSA_NO_PADDING);                
                break;
            case KeyTypePrivate:
                RSA_private_decrypt(flen, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa,  RSA_NO_PADDING);
                break;
            default:
                break;
        }
        
        NSString *decryptString = [[NSString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return [decryptString autorelease];
        
        free(decData);
        decData = NULL;
    }
    return nil;
}

//导入deskey
- (BOOL)importDESKey
{
    NSString* desFile=[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"encryption"] stringByAppendingPathComponent:@"des.pem"];
    _des=[NSString stringWithContentsOfFile:desFile encoding:NSUTF8StringEncoding error:nil];
    if(_des){
        return YES;
    }
    return NO;
}

-(NSString *)encryptStringUseDES:(NSString *)clearText
{
    if(clearText && [clearText length] && [self importDESKey]){
        NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        unsigned char buffer[1024000];
        memset(buffer, 0, sizeof(char));
        size_t numBytesEncrypted = 0;
        
        //C函数
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              [_des UTF8String],
                                              kCCKeySizeDES,
                                              nil,
                                              [data bytes],
                                              [data length],
                                              buffer,
                                              1024000,
                                              &numBytesEncrypted);
        
        NSString* plainText = nil;
        if (cryptStatus == kCCSuccess) {
            NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
            plainText = [GTMBase64 stringByEncodingData:dataTemp];
        }else{
            LOG(@"DES加密失败");
        }
        return plainText;
    }
    return nil;
}

-(NSString*)decryptStringUseDES:(NSString*)cipherText
{
    if(cipherText && [cipherText length] && [self importDESKey]){

        // 利用 GTMBase64 解碼 Base64 字串
        NSData* cipherData = [GTMBase64 decodeString:cipherText];
        unsigned char buffer[1024000];
        memset(buffer, 0, sizeof(char));
        size_t numBytesDecrypted = 0;
        
        // IV 偏移量不需使用
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              [_des UTF8String],
                                              kCCKeySizeDES,
                                              nil,
                                              [cipherData bytes],
                                              [cipherData length],
                                              buffer,
                                              1024000,
                                              &numBytesDecrypted);
        NSString* plainText = nil;
        if (cryptStatus == kCCSuccess) {
            NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
            plainText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        }else{
            LOG(@"DES解密失败");
        }
        return plainText;
    }
    return nil;
}

-(NSData *)encryptDataUseDES:(NSData *)data
{
    if(data && [data length] && [self importDESKey]){
        unsigned char buffer[1024000];
        memset(buffer, 0, sizeof(char));
        size_t numBytesEncrypted = 0;
        
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              [_des UTF8String],
                                              kCCKeySizeDES,
                                              nil,
                                              [data bytes],
                                              [data length],
                                              buffer,
                                              1024000,
                                              &numBytesEncrypted);
        
        NSData *dataTemp=nil;
        if (cryptStatus == kCCSuccess) {
            dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
            dataTemp=[GTMBase64 encodeData:dataTemp];
        }else{
            LOG(@"DES加密失败");
        }
        return dataTemp;
    }
    return nil;
}

-(NSData*)decryptDataUseDES:(NSData*)data
{
    if(data && [data length] && [self importDESKey]){
        
        // 利用 GTMBase64 解碼 Base64 
        NSData* cipherData = [GTMBase64 decodeData:data];
        unsigned char buffer[1024];
        memset(buffer, 0, sizeof(char));
        size_t numBytesDecrypted = 0;
        
        // IV 偏移量不需使用 C函数
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              [_des UTF8String],
                                              kCCKeySizeDES,
                                              nil,
                                              [cipherData bytes],
                                              [cipherData length],
                                              buffer,
                                              1024,
                                              &numBytesDecrypted);
        NSData* plainData = nil;
        if (cryptStatus == kCCSuccess) {
            plainData = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        }
        return plainData;
    }
    return nil;
}

@end




//补充NSString方法
@implementation NSString(MD5)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	return [result autorelease];
}

- (NSString*)URLDecodedString {
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
	return [result autorelease];
}

- (NSString *) MD5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    
    char md5string[CC_MD5_DIGEST_LENGTH*2];
    
    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        sprintf(md5string+i*2, "%02X", digest[i]);
    }
    
    return [NSString stringWithCString:md5string encoding:NSASCIIStringEncoding];
}

@end


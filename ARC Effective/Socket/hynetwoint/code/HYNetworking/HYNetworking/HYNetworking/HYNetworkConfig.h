//
//  HYNetworkConfig.h
//  HYNetworking
//
//  Created by zhangke on 13-4-22.
//  Copyright (c) 2013年 张科. All rights reserved.
//

#ifdef DEBUG
#  define LOG(fmt, ...) NSLog((@"%@(%d)" fmt), NSStringFromClass([self class]) , __LINE__, ##__VA_ARGS__);
#  define LOG_METHOD NSLog(@"%s", __func__)
#  define LOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define COUNT(p) NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
#  define LOG_TRACE(x) do {printf x; putchar('\n'); fflush(stdout);} while (0)
#else
#  define LOG(...)
#  define LOG_METHOD
#  define LOG_CMETHOD
#  define COUNT(p)
#  define LOG_TRACE(x)
#endif


#ifndef DEBUGOUT
#define DEBUGOUT  1
#endif

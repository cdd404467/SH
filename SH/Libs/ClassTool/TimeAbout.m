//
//  TimeAbout.m
//  QCY
//
//  Created by i7colors on 2018/10/12.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TimeAbout.h"

@implementation TimeAbout

//获取当前时间戳  （以毫秒为单位）
+ (NSString *)getNowTimeTimestamp_HM {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
    
    return timeSp;
}

//获取当前时间戳(以秒为单位)
+ (NSString *)getNowTimeTimestamp_M {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

//时间戳转字符串,只有年月日
+ (NSString *)timestampToString:(long long)time isSecondMin:(BOOL)isSecMin {
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)time];
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (isSecMin == YES) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timestampToString:(long long)time ofType:(NSString *)ofType {
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)time];
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:ofType];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//时间戳转字符串,年月日，十分秒
+ (NSString *)timestampToString:(long long)time {
    return [self timestampToString:time isSecondMin:YES];
}

+ (NSString *)timestampToStringAsOfMin:(long long)time {
    return [self timestampToString:time ofType:@"yyyy-MM-dd HH:mm"];
}

//今天开始往前后推时间
+ (NSDate *)getNDay:(NSInteger)nDay {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    if(nDay!= 0){
        //initWithTimeIntervalSinceNow是从现在往前后推的秒数
        NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay * nDay ];
    } else
        theDate = nowDate;
    
    return theDate;
}

//nsdate转string
+ (NSString*)stringFromDate:(NSDate*)date {
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

//string转nsdata
+ (NSDate *)stringToDate:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";
    // NSString * -> NSDate *
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    
    return date;
}

+ (NSDate *)stringToDateSec:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // NSString * -> NSDate *
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    return date;
}

//判断今天、昨天
+ (NSString *)checkTheDate:(long long)timeStamp {
    
    NSString *string = [self timestampToString:timeStamp isSecondMin:NO];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    NSString *strDiff = nil;
    
    if(isToday) {
        strDiff= [NSString stringWithFormat:@"今天"];
    } else if (isYesterday) {
        strDiff= [NSString stringWithFormat:@"昨天"];
    } else {
        strDiff = string;
    }
    
    return strDiff;
}

//时间戳转NSDate
+ (NSDate *)dateWithLongLong:(long long)longlongValue {
    long long value = 0;
    if (@(longlongValue).stringValue.length > 10) {
        value = longlongValue / 1000;
    }
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

//比较两个时间戳之间的时间差，输出天，时，分，秒
+ (void)timeDiffWithStartTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock {
    NSDate *startDate  = [self dateWithLongLong:starTimeStamp];
    NSDate *finishDate = [self dateWithLongLong:finishTimeStamp];
    NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate];
    //时间差
    int timeout = timeInterval;
    if (timeout <= 0) { //倒计时结束，关闭
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(0,0,0,0);
        });
    } else {
        int days = (int)(timeout / (3600 * 24));
        int hours = (int)((timeout-days * 24 * 3600) / 3600);
        int minute = (int)(timeout-days * 24 * 3600 - hours * 3600) / 60;
        int second = timeout - days * 24 * 3600 - hours * 3600 - minute * 60;
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(days,hours,minute,second);
        });
    }
}

//数组形式返回
+ (NSArray *)timeDiffWithStartTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp {
    NSDate *startDate  = [self dateWithLongLong:starTimeStamp];
    NSDate *finishDate = [self dateWithLongLong:finishTimeStamp];
    NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate];
    //时间差
    int timeout = timeInterval;
    NSArray *timeArray = [NSArray array];
    if (timeout <= 0) { //倒计时结束，关闭
        timeArray = @[@0,@0,@0,@0];
    } else {
        int days = (int)(timeout / (3600 * 24));
        int hours = (int)((timeout-days * 24 * 3600) / 3600);
        int minute = (int)(timeout-days * 24 * 3600 - hours * 3600) / 60;
        int second = timeout - days * 24 * 3600 - hours * 3600 - minute * 60;
        timeArray = @[@(days),@(hours),@(minute),@(second)];
    }
    
    return timeArray;
}

@end

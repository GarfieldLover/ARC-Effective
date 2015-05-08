//
//  CoreTextPoint.h
//  ARC Effective
//
//  Created by zhangke on 15/5/8.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//


//CoreText能够对文本格式和文本布局进行精细控制的文本引擎。


//UIKit 的 UILabel 允许你通过在 IB 中简单的拖曳添加文本，但你不能改变文本的颜色和其中的单词。
//Core Graphics/Quartz几乎允许你做任何系统允许的事情，但你需要为每个字形计算位置，并画在屏幕上。
//Core Text 正结合了这两者！你可以完全控制位置、布局、类似文本大小和颜色这样的属性，而 Core Text 将帮你完善其它的东西——类似文本换行、字体呈现等等。
//位置，大小，颜色，通过计算可以实现点击效果




0.传入自定义 style ，name，font，color，undline，


//FTCoreTextStyle *bulletStyle = [FTCoreTextStyle new];
//bulletStyle.name = @"_FTBulletStyle";
//bulletStyle.font = newNode.style.bulletFont;
//bulletStyle.color = newNode.style.bulletColor;
//bulletStyle.applyParagraphStyling = NO;
//bulletStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 0, newNode.style.paragraphInset.left);



1.创建context


//CGContextRef context = UIGraphicsGetCurrentContext();
//[self.backgroundColor setFill];
//CGContextFillRect(context, rect);


2.	生成 framesetter（管理文本引用和绘制），－》createWithAttributedString，－》getattributedString （对文本应用格式化属性）－》processText 处理文本，

//_URLs ，_images，
//rootNode.style，regEx = @"<(/){0,1}.*?( /){0,1}>" 正则表达式，处理标示为< >，</ >, < />类xml文本，取得open fulltag tagName <title>，title，根据tagName获取之前传入的style，字符串的range存在TextNode里，标签<title>被替换为空，
//如果是isLink，[_URLs setObject:url forKey:NSStringFromRange(urlDescriptionRange)];  urls存给Description  的range，同时村node里，如果是image，用\n代替，同时存 range到node，标记为image，imagename。
//bullet 单独处理了，
//  \n也有attributed，处理完后 所有的标签就没了，只剩下要显示的字符串，换行，bullet，返回string，生成NSAttributedString
// 每一段string 都有attributed，主要CTForegroundColor，FTCoreTextDataName，NSFont，NSUnderline，都是key


/*
所有解析后得到多种node节点类型，字符串string已经变成了正常显示的值

<FTCoreTextNode: 0x7f9612c30ac0>	-	_FTTopSpacingStyle_title - 	{0, 1},
<FTCoreTextNode: 0x7f9612c30a20>	-	title - 	{1, 7},
<FTCoreTextNode: 0x7f9612d048c0>	-	_image - 	{9, 1},
<FTCoreTextNode: 0x7f9612e06900>	-	firstLetter - 	{11, 1},
<FTCoreTextNode: 0x7f96150958c0>	-	_link - 	{62, 18},
<FTCoreTextNode: 0x7f9612c39870>	-	_link - 	{190, 17},
<FTCoreTextNode: 0x7f9612c15c30>	-	_FTTopSpacingStyle_subtitle - 	{332, 1},
<FTCoreTextNode: 0x7f9612d71f50>	-	subtitle - 	{333, 10},
<FTCoreTextNode: 0x7f9612c18950>	-	_link - 	{409, 17},
<FTCoreTextNode: 0x7f9612d72c80>	-	bold - 	{445, 4},
<FTCoreTextNode: 0x7f961503be70>	-	colored - 	{451, 5},
<FTCoreTextNode: 0x7f9612f33de0>	-	italic - 	{461, 7},
<FTCoreTextNode: 0x7f9612f2d0d0>	-	_bullet - 	{677, 168},
<FTCoreTextNode: 0x7f9612f2b4e0>	-	_bullet - 	{846, 18},
<FTCoreTextNode: 0x7f9612f26ad0>	-	_bullet - 	{865, 18},
<FTCoreTextNode: 0x7f9612f34540>	-	_bullet - 	{884, 18},
<FTCoreTextNode: 0x7f9612c248b0>	-	_bullet - 	{903, 18},
<FTCoreTextNode: 0x7f9612f0c130>	-	_bullet - 	{922, 21},
<FTCoreTextNode: 0x7f9612c3a9f0>	-	_bullet - 	{944, 19},
<FTCoreTextNode: 0x7f9615095a00>	-	_bullet - 	{964, 15},
<FTCoreTextNode: 0x7f9612f1dd40>	-	_bullet - 	{980, 20},
<FTCoreTextNode: 0x7f9612f2f290>	-	_FTTopSpacingStyle_subtitle - 	{1001, 1},
<FTCoreTextNode: 0x7f9612f328a0>	-	subtitle - 	{1002, 8},
<FTCoreTextNode: 0x7f9612c1f2a0>	-	_link - 	{1069, 17},
<FTCoreTextNode: 0x7f9615095e80>	-	_link - 	{1289, 17}
*/


//[self updateFramesetterIfNeeded];
//_framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);


3. - (void)drawRect:(CGRect)rect  在drawRect内，通过 self.bounds 使用整个视图矩形区域创建 CGPath 引用。
用_framesetter，mainPath 创建 CTFrameRef


//CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
//CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);

/*
 CTFrame，多行 CTLine， 第2行是 画字符，总共有2个CTRun，包含attributes，

 
 CTFrame，总共48行，
 
 <CTFrame: 0x7ffe2c25ead0>{visible string range = (0, 1306), path = <CGPath 0x7ffe2c0a3660>, attributes = (null), lines = <CFArray 0x7ffe2c25e360 [0x10c802eb0]>{type = mutable-small, count = 48, values = (
 
 CTLine， 第2行是 画字符，总共有2个CTRun，
 
 1 : <CTLine: 0x7ffe2c267e90>{run count = 2, string range = (1, 8), width = 118.746, A/D/L = 35.6445/8.65234/1.69922, glyph count = 8, runs = (
 
 CTRun，第1个run内是 由attributes分割的， 属性内有foregroundColor，nsfont, NSUnderline=1，单下划线
 
 <CTRun: 0x7ffe2c268fa0>{string range = (1, 7), string = "Giraffe",
 attributes = {
 CTForegroundColor = "<CGColor 0x7ffe2c3112a0> [<CGColorSpace 0x7ffe2c311280> (kCGColorSpaceDeviceGray)] ( 0 1 )";
 FTCoreTextDataName = title;
 NSFont = "<UICTFont: 0x7ffe2c23c280> font-family: \"Times New Roman\"; font-weight: normal; font-style: normal; font-size: 40.00pt";
 
 
 CTFrameRef   通过Framesetter 创建CreateFrame 自动生成，内含各种line，run
 */

4.draw到context

//转换CTM

//CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//CGContextTranslateCTM(context, 0, self.bounds.size.height);
//CGContextScaleCTM(context, 1.0, -1.0);

// draw text 画在context上
//CTFrameDraw(drawFrame, context);



//drawimage，
[self drawImages];

//取得每行CTLine，取得line的字符range，如果字符的location大于imagenode的location，取得line的y，得到image的frame，drawinrect，下一个
//取得ctframe 和 ctline
CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
NSArray *lines = (__bridge NSArray *)CTFrameGetLines(ctframe);

for (int i = 0; i < lineCount; i++) {
    CGPoint baselineOrigin = origins[i];
    //the view is inverted, the y origin of the baseline is upside down
    
    //原来是反着的，减去后得到y
    baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
    
    //取得每行的字符location
    CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
    CFRange cfrange = CTLineGetStringRange(line);
    if (cfrange.location > imageNode.styleRange.location) {
        
        [img drawInRect:CGRectIntegral(frame)];
        //下一个imagenode
        imageNode = [_images objectAtIndex:imageNodeIndex + 1];
        
        

5.释放所有使用的对象

//if (drawFrame) CFRelease(drawFrame);
//CGPathRelease(mainPath);
        

6.点击 ，url 和 image

//获得当前的point
CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
        //取数据
 NSDictionary *data = [self dataForPoint:point activeRects:&activeRects];

        //取frame
        CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
        
        NSArray *lines = (__bridge NSArray *)CTFrameGetLines(ctframe);

        //图片，取字符loction－－－－－－－
        CFRange cfrange = CTLineGetStringRange(line);
        //如果在imageNode的起始和结束范围内，就是image的代替符，
        if (cfrange.location >= imageNode.styleRange.location && cfrange.location<imageNode.styleRange.location+imageNode.styleRange.length) {
            //再通过line 取得image的farme，如果能拿到图片
            CGRect frame = CGRectMake(x, lineFrame.origin.y, img.size.width, img.size.height);
            if(CGRectContainsPoint(frame, point)){
                [returnedDict setObject:@"image" forKey:@"type"];

                
       //URL，先判断行，－－－－－－
                if (CGRectContainsPoint(lineFrame, point)) {
                    //根据点 取得 点击的字符位置 102
                    CFIndex index = CTLineGetStringIndexForPosition(line, point);
                    //根据index判断是哪个URL
                    if (index >= range.location && index < range.location + range.length) {
                        //取得url 开始结束location
                        NSInteger startIndex = range.location;
                        NSInteger endIndex = range.location + range.length;
                        
                        //如果是开始，就是getoffsetforstring
                        if (range.location >= startIndex) {
                               actualRect.origin.x = CTLineGetOffsetForStringIndex(line, startIndex, NULL);
                        }
                        //如果是结束，就是width＝getoffsetforstring
                        if (lineRangEnd <= endIndex) {
                            CGFloat position = CTLineGetOffsetForStringIndex(line, endIndex, NULL);
                            actualRect.size.width = position - CGRectGetMinX(actualRect);
                        }
                        //跨行
                        //一行的开始小于结束位置，开始＋长度大于结束位置
                        range.location <= endIndex && range.location + range.length >
                        
                        <__NSArrayM 0x7fcd71f47330>(
                        {{215.921875, 367.7421875}, {65.078125, 17.71875}},
                        {{-1, 385.7421875}, {57.09375, 17.71875}}
                                                    )
                        
                        //        //加了个灰色view
                        //        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
                        //        [self addSubview:view];
                        //        [selectedViews addObject:view];
                        
                        
                        
                        
CTFrame 作为一个整体的画布(Canvas)，其中由行(CTLine)组成，而每行可以分为一个或多个小方块（CTRun）。
注意：你不需要自己创建CTRun，Core Text将根据NSAttributedString的属性来自动创建CTRun。每个CTRun对象对应不同的属性，正因此，你可以自由的控制字体、颜色、字间距等等信息。

1.使用core text就是先有一个要显示的string，然后定义这个string每个部分的样式－>attributedString －> 生成 CTFramesetter -> 得到CTFrame -> 绘制（CTFrameDraw）
其中可以更详细的设置换行方式，对齐方式，绘制区域的大小等。
2.绘制只是显示，点击事件就需要一个判断了。


#import "SKMRUtils.h"

@implementation SKMRUtils

+ (SKColor *)convertHexStringToSKColor:(NSString *)hexValue
{
    NSScanner *hexScanner = [NSScanner scannerWithString:hexValue];
    
    static NSMutableCharacterSet *hexCharacterSet = nil;
    if(hexCharacterSet == nil)
    {
        hexCharacterSet = [[NSMutableCharacterSet alloc] init];
        [hexCharacterSet addCharactersInString:@"0123456789abcdefABCDEF"];
        [hexCharacterSet invert];
    }
    
    [hexScanner setCharactersToBeSkipped:hexCharacterSet];
    
    unsigned long long hexNumeric;
    [hexScanner scanHexLongLong:&hexNumeric];

    if(hexValue.length == 6 || hexValue.length == 7)
    {
        return [SKColor colorWithRed:((hexNumeric & 0xFF0000) >> 16) / 255.0f
                               green:((hexNumeric & 0x00FF00) >> 8) / 255.0f
                                blue:(hexNumeric & 0x0000FF) / 255.0f
                               alpha:1.0];
    }
    else
    {
        return [SKColor colorWithRed:((hexNumeric & 0xFF000000) >> 32) / 255.0f
                               green:((hexNumeric & 0x00FF0000) >> 16) / 255.0f
                                blue:((hexNumeric & 0x0000FF00) >> 8) / 255.0f
                               alpha:(hexNumeric & 0x000000FF) / 255.0f];
    }
}

@end

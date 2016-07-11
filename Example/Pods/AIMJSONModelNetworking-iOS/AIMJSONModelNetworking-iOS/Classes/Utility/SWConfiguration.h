//
//  SWConfiguration.h
//  SaleWorkFlow
//
//  Created by Saranrat Janpichai on 3/9/15.
//  Copyright (c) 2015 com.arsoft. All rights reserved.
//

#ifndef SaleWorkFlow_SWConfiguration_h
#define SaleWorkFlow_SWConfiguration_h


#define TAG(obj) [obj hash]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.00]
#define Prop_MArray(ofClass,varName) \
_Pragma("clang diagnostic push"); \
_Pragma("clang diagnostic ignored \"-Wobjc-protocol-qualifiers\""); \
@property(nonatomic,strong) NSMutableArray<ofClass> *varName; \
_Pragma("clang diagnostic pop")


#define MArray(ofClass,varName,value) \
_Pragma("clang diagnostic push"); \
_Pragma("clang diagnostic ignored \"-Wobjc-protocol-qualifiers\""); \
NSMutableArray<ofClass> *varName; \
_Pragma("clang diagnostic pop");\
varName = value


#define GEN_CODE(prefix,number) [NSString stringWithFormat:@"%@%03d",prefix, number]
#define GEN_CODE_2_DIGIT(prefix,number) [NSString stringWithFormat:@"%@%02d",prefix, number]

#define CELL_CODE(number) GEN_CODE(@"C",number)
#define ICON_STATUS_CODE(number) GEN_CODE(@"ACI",number)

#define EMPTY_STRING @""
#define CATEGORY_PROPERTY_GET(type, property) - (type) property { return objc_getAssociatedObject(self, @selector(property)); }
#define CATEGORY_PROPERTY_SET(type, property, setter) - (void) setter (type) property { objc_setAssociatedObject(self, @selector(property), property, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
#define CATEGORY_PROPERTY_GET_SET(type, property, setter) CATEGORY_PROPERTY_GET(type, property) CATEGORY_PROPERTY_SET(type, property, setter)
#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]
#define notYetImplemented() mustOverride()

#define CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(type, property, valueSelector) - (type) property { return [objc_getAssociatedObject(self, @selector(property)) valueSelector]; }
#define CATEGORY_PROPERTY_SET_NSNUMBER_PRIMITIVE(type, property, setter, numberSelector) - (void) setter (type) property { objc_setAssociatedObject(self, @selector(property), [NSNumber numberSelector: property], OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

#define CATEGORY_PROPERTY_GET_UINT(property) CATEGORY_PROPERTY_GET_NSNUMBER_PRIMITIVE(unsigned int, property, unsignedIntValue)
#define CATEGORY_PROPERTY_SET_UINT(property, setter) CATEGORY_PROPERTY_SET_NSNUMBER_PRIMITIVE(unsigned int, property, setter, numberWithUnsignedInt)
#define CATEGORY_PROPERTY_GET_SET_UINT(property, setter) CATEGORY_PROPERTY_GET_UINT(property) CATEGORY_PROPERTY_SET_UINT(property, setter)
#define URL_TEL @"tel://"


#define isPhone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isPad  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SECOND_PER_MINIUTE 60
#define MINIUTE_PER_HOUR 60
#define HOUR_PER_DAY 24
#define DAY SECOND_PER_MINIUTE*MINIUTE_PER_HOUR*HOUR_PER_DAY
#define WEEK DAY*7
#define OpenService(serviceName) OpenServiceWithInfo(serviceName,nil)
#define OpenServiceWithInfo(serviceName,info) [[NSNotificationCenter defaultCenter] postNotificationName:serviceName object:info]

#define deg2rad(deg) (deg * M_PI / 180.0)
#define rad2deg(rad) (rad * 180.0 / M_PI)

/////////////////////////////////////////////////////////////////////////////




#define KEY_PARAM_JSON_HTTP_REQUEST @"json"
#define KEY_PARAM_TOKEN_HTTP_REQUEST @"token"
#define KEY_RESPONSE_STATUS @"status"
#define KEY_RESPONSE_MESSAGE @"message"
#define KEY_RESPONSE_ENTITIES @"entities"

#define LoginServiceURL @"http://swfspvid.ar.co.th/USE001/MSignin"
#define NotificationServiceURL @"swfspvid.ar.co.th/PHP"

#define NOTIFICATION_NAME_MENU_PRESSED @"NOTIFICATION_NAME_MENU_PRESSED"
#define NOTIFICATION_DASHBOARD_PRESSED @"NOTIFICATION_DASHBOARD_PRESSED"

#define NOTIFICATION_APPLICATION_MODULE_START_LOADING_MASTER(module) [NSString stringWithFormat:@"%@%@",module,@"NOTISTARTLOADINGMASTER"]
#define NOTIFICATION_APPLICATION_MODULE_STOP_LOADING_MASTER(module) [NSString stringWithFormat:@"%@%@",module,@"NOTISTOPLOADINGMASTER"]

#define NOTIFICATION_APPLICATION_MODULE_START_LOADING_MODULE @"NOTISTARTLOADINGMODULE"
#define NOTIFICATION_APPLICATION_MODULE_DONE_LOADING_MODULE @"NOTIDONELOADINGMODULE"
#define NOTIFICATION_APPLICATION_WIDGET_DISMISS @"MODISMWIDGET"


#define MOCK_DATA YES
#define IS_TEST NO

#define UPDATE_LOCATION_BACKGROUND_INTERVAL (60*30)
#define UPDATE_LOCATION_TRACK_INTERVAL (60*1)
#define LOCAL_NOTIFICATION_TIME 30

#endif

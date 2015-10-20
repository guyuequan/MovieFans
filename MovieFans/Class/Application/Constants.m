//
//  Constants.m
//  MovieFans
//
//  Created by Leo Gao on 2/22/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

//缓存时间key
NSString *const KEY_CACHE_DATE = @"key_cache_date";

NSString *const KEY_PASTEBOARD_SWITCH = @"key_pasteboard_switch";

NSString *const KEY_IF_SHOW_ALL_TAG = @"key_if_show_all_tag";

//收藏夹数据表名
NSString *const DB_NAME = @"movies.db";
NSString *const TABLE_MOVIE = @"tb_movie";
NSString *const TABLE_REVIEW = @"tb_review";
NSString *const TABLE_CELEBRITY = @"tb_celebrity";

NSString *const KEY_SEARCH_HISTORY = @"searchHistory";


//更改收藏数据通知
NSString *const NOTICE_COLLECTION_DATA_CHANGED = @"notice_collection_data_changed";

NSString *const NOTICE_COLLECTION_DATA_BEGIN_EDIT = @"notice_collection_data_begin_edit";
NSString *const NOTICE_COLLECTION_DATA_END_EDIT = @"notice_collection_data_end_edit";
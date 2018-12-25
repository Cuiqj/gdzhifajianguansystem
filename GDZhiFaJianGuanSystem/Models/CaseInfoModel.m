//
//  CaseInfoModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CaseInfoModel.h"


@implementation CaseInfoModel

@dynamic anjuan_no;
@dynamic badcar_sum;
@dynamic badcar_type;
@dynamic badwound_sum;
@dynamic baomi_type;
@dynamic beikao_remark;
@dynamic case_address;
@dynamic case_code;
@dynamic case_from;
@dynamic case_from_department;
@dynamic case_from_detail;
@dynamic case_from_inform;
@dynamic case_from_inspection;
@dynamic case_from_other;
@dynamic case_from_party;
@dynamic case_mode;
@dynamic case_no;
@dynamic case_reality;
@dynamic case_reason;
@dynamic case_reason_decide;
@dynamic case_style;
@dynamic case_type;
@dynamic case_type_id;
@dynamic case_yearno;
@dynamic caseqingkuang;
@dynamic casereason;
@dynamic casetype;
@dynamic cbren_opinion_date;
@dynamic chengbandate;
@dynamic chengbanyijiang;
@dynamic citizen_name;
@dynamic clerk;
@dynamic clerk1;
@dynamic clerk1_code;
@dynamic clerk2;
@dynamic clerk2_code;
@dynamic clerk3;
@dynamic clerk3_code;
@dynamic clerk4;
@dynamic clerk4_code;
@dynamic clerk5;
@dynamic clerk5_code;
@dynamic cover_page;
@dynamic cover_sum;
@dynamic damageplace;
@dynamic danganshi_no;
@dynamic date_caseend;
@dynamic date_casereg;
@dynamic date_underwrite;
@dynamic death_sum;
@dynamic endcase_flag;
@dynamic execute_circs;
@dynamic fact_pay_sum;
@dynamic fleshwound_sum;
@dynamic fuzheyijian;
@dynamic fuzheyijian_date;
@dynamic fz_opinion;
@dynamic fz_opinion_date;
@dynamic fz_opinion_man;
@dynamic happen_date;
@dynamic identifier;
@dynamic idea_police;
@dynamic importent;
@dynamic is_from_civilaction;
@dynamic latefee_sum;
@dynamic leader_name;
@dynamic limit;
@dynamic linkaddress;
@dynamic linkman;
@dynamic linktel;
@dynamic organization_id;
@dynamic outwardstatus;
@dynamic overrunname;
@dynamic pagenum;
@dynamic pay_sum;
@dynamic peccancy_type;
@dynamic place;
@dynamic project_id;
@dynamic punish_sum;
@dynamic quanzong_no;
@dynamic recorderName;
@dynamic remark;
@dynamic roadsegment_id;
@dynamic side;
@dynamic station_end;
@dynamic station_start;
@dynamic title;
@dynamic transact_decision;
@dynamic weater;
@dynamic zfjg_opinion;
@dynamic zfjg_opinion_date;
@dynamic zfjg_opinion_man;


+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    CaseInfoModel *caseInfo = nil;
    
    [MYAPPDELEGATE saveContext];
    return caseInfo;
}

@end

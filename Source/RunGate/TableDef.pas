unit TableDef;

interface

uses
  Windows, Messages, SysUtils;

type
  TMagDelayList = array[0..112] of Integer;

var
  MAIGIC_DELAY_ARRAY        : array[0..112] of BOOL = (True,
    True, True, True, True, True, True, False, True, True, True, True, False, //1~12
    True, True, True, True, True, True, True, True, True, True, True, True, //13~24
    False, False, False, True, True, True, True, True, True, True, False, True, //25~36
    True, True, True, False, False, False, False, True, True, True, True, True, //37~48
    True, True, True, True, True, True, False, False, True, True, False, False, //49~60
    False, False, False, False, False, False, True, True, True, True, True, True, //61~72
    True, True, True, True, True, True, True, True, True, True, True, True, //73~84
    True, True, True, True, True, True, True, True, True, True, True, True, //85~96
    True, True, True,                   //97~99
    True, True, True, True, True, True, True, True, True, True, True, True, //100..111
    True); //112~119

  MAIGIC_ATTACK_ARRAY       : array[0..112] of BOOL = (
    False,
    True,                               //小火球
    False,                              //治愈术
    False,                              //基本剑术
    False,                              //精神力战法
    True,                               //大火球
    True,                               //施毒术
    False, False,
    True,                               //地狱火焰
    True,                               //疾电雷光
    True,                               //雷电术
    False,                              //12
    True,                               //灵魂道府
    False, False, False, False, False, False, False, False,
    True,                               //火墙
    True,                               //爆裂火焰
    True,                               //地狱雷光
    False, False, False, False, False, False, False,
    True,                               //圣言术
    True,                               //冰咆哮
    False, False,
    True,                               //火焰冰
    True,                               //狮子吼 - 群体雷电术
    True,                               //群体施毒术
    True,                               //彻地钉
    False,                              //40
    True,                               //狮子吼
    False,
    False,
    True,                               //寒冰掌
    True,                               //灭天火
    False,
    True,                               //火龙烈焰
    False,                              //37~48
    False,                              //净化术
    False,                              //无极真气
    True,                               //51
    True,                               //52
    True,                               //53
    True,                               //54
    False,                              //55
    False,                              //逐日剑法
    True,                               //噬血术
    True,                               //流星火雨
    False,                              //59
    False,                              //60
    False,                              //61
    False,                              //62
    False,                              //63
    False,                              //64
    False,                              //65
    False,                              //66
    False,                              //67
    False,
    False,
    False,
    True,                               //71擒龙手
    True, True, True, True, True, True, True, True, True, True, True, True,
    True, True, True, True, True, True, True, True, True, True, True, True, //84~95
    True, True, True, True,             //96..99
    True, True, True, True, True, True, True, True, True, True, True, True, //100~111
    True); //112

  //魔法的延迟表
  MAIGIC_DELAY_TIME_LIST_DEF: TMagDelayList;
  MAIGIC_DELAY_TIME_LIST    : TMagDelayList = (
    60000,
    {1}1300,                          //火焰掌
    {2}1100,                          //回复术
    {3}700,                           //外修剑法
    {4}700,                           //逸光剑法
    {5}1300,                          //金刚火焰掌
    {6}1100,                          //暗烟术
    {7}700,                           //锐刀剑法
    {8}1000,                          //火焰风
    {9}1300,                          //焰沙掌
    {10}1700,                         //雷刃掌
    {11}1700,                         //强击
    {12}700,                          //御剑术
    {13}1300,                         //爆杀界
    {14}1100,                         //抗魔真法
    {15}1100,                         //大地援护
    {16}1200,                         //结界
    {17}1200,                         //骷髅召唤术
    {18}1200,                         //隐身术
    {19}1200,                         //大隐身术
    {20}1300,                         //雷魂击
    {21}1200,                         //亚空行法
    {22}1900,                         //地焰术
    {23}1300,                         //爆焰波
    {24}1300,                         //雷雪花
    {25}700,                          //半月剑法
    {26}700,                          //焰火诀
    {27}700,                          //武跆步
    {28}1100,                         //探气波眼
    {29}1100,                         //大回复术
    {30}1900,                         //神兽召唤
    {31}700,                          //咒术衣幕
    {32}1900,                         //死字轮回
    {33}1300,                         //冰雪风
    {34}700,                          //狂风斩
    {35}1900,                         //灭天火
    {36}1100,                         //无极真气
    {37}1000,                         //气功波
    {38}700,                          //双龙斩
    {39}1900,                         //结冰掌
    {40}1300,                         //净化术
    {41}1200,                         //精魂召唤术
    {42}1200,                         //分身术
    {43}1200,                         //狮子吼
    {44}1200,                         //空破闪
    {45}1900,                         //火龙气焰
    {46}1300,                         //诅咒术
    {47}2900,                         //捕绳剑
    {48}1900,                         //吸血术
    {49}2900,                         //迷魂术
    {50}1100,                         //剑气暴
    {51}1100,                         //护身气幕
    {52}1100,                         //天霜冰环
    {53}1100,                         //天上落焰
    {54}1100,                         //苏生术
    {55}1100,                         //毒雾
    {56}1100,                         //日闪
    {57}1100,                         //冰焰术
    {58}1100,                         //先天气功
    {59}700,                          //绝命剑法
    {60}700,                          //风剑术
    {61}700,                          //体迅风
    {62}900,                          //拔刀术
    {63}800,                          //千里剑
    {64}1000,                         //烈风击
    {65}1200,                         //捕缚术
    {66}900,                          //月影术
    {67}700,                          //吸气
    {68}1100,                         //轻身步
    {69}900,                          //风身术
    {70}700,                          //猛毒剑气
    {71}900,                          //烈火身
    {72}700,                          //月华乱舞
    {73}700,                          //天务
    {74}700,                          //深延术
    {75}700,                          //瘟疫
    {76}700,                          //血风击
    {77}700,                          //血龙剑法
    {78}700,                          //天上秘术
    {79}700,                          //血龙水
    {80}700,                          //猫舌兰
    {81}700,                          //金刚不坏
    {82}700,                          //雷仙风
    {83}700,                          //阴阳五行阵
    {84}700,                          //月影雾
    {85}700,                          //金刚不坏-秘笈
    {86}700,                          //雷仙风-秘笈
    {87}700,                          //阴阳五行阵-秘笈
    {88}700,                          //月影雾-秘笈
    {89}700,                          //必中闪
    {90}900,                          //天日闪
    {91}1100,                         //无我闪
    {92}1700,                         //爆阱
    {93}900,                          //爆闪
    {94}700,                          //气功术
    {95}1100,                         //万斤闪
    {96}1200,                         //风弹步
    {97}900,                          //气流术
    {98}1200,                         //地柱钉
    {99}1100,                         //金刚术
    {100}1200,                        //吸血地精
    {101}900,                         //吸血地闪
    {102}1200,                        //痹魔阱
    {103}700,                         //毒魔闪
    {104}900,                         //邪爆闪
    {105}1100,                        //蛇柱阱
    {106}700,                         //血龙闪
    {107}700,                         //血龙闪-秘笈
    {108}700,                         //捕绳剑-秘笈
    {109}700,                         //金刚火焰掌-秘笈
    {110}700,                         //回复术-秘笈
    {111}700,                         //拔刀术-秘笈
    {112}700                          //爆闪-秘笈
   );

  MAIGIC_NAME_LIST          : array[0..112] of string = (
    '',
    '火焰掌',
    '回复术',
    '外修剑法',
    '逸光剑法',
    '金刚火焰掌',
    '暗烟术',
    '锐刀剑法',
    '火焰风',
    '焰沙掌',
    '雷刃掌',
    '强击',
    '御剑术',
    '爆杀界',
    '抗魔真法',
    '大地援护',
    '结界',
    '骷髅召唤术',
    '隐身术',
    '大隐身术',
    '雷魂击',
    '亚空行法',
    '地焰术',
    '爆焰波',
    '雷雪花',
    '半月剑法',
    '焰火诀',
    '武跆步',
    '探气波眼',
    '大回复术',
    '神兽召唤',
    '咒术衣幕',
    '死字轮回',
    '冰雪风',
    '狂风斩',
    '灭天火',
    '无极真气',
    '气功波',
    '双龙斩',
    '结冰掌',
    '净化术',
    '精魂召唤术',
    '分身术',
    '狮子吼',
    '空破闪',
    '火龙气焰',
    '诅咒术',
    '捕绳剑',
    '吸血术',
    '迷魂术',
    '剑气暴',
    '护身气幕',
    '天霜冰环',
    '天上落焰',
    '苏生术',
    '毒雾',
    '日闪',
    '冰焰术',
    '先天气功',
    '绝命剑法',
    '风剑术',
    '体迅风',
    '拔刀术',
    '千里剑',
    '烈风击',
    '捕缚术',
    '月影术',
    '吸气',
    '轻身步',
    '风身术',
    '猛毒剑气',
    '烈火身',
    '月华乱舞',
    '天务',
    '深延术',
    '瘟疫',
    '血风击',
    '血龙剑法',
    '天上秘术',
    '血龙水',
    '猫舌兰',
    '金刚不坏',
    '雷仙风',
    '阴阳五行阵',
    '月影雾',
    '金刚不坏-秘笈',
    '雷仙风-秘笈',
    '阴阳五行阵-秘笈',
    '月影雾-秘笈',
    '必中闪',
    '天日闪',
    '无我闪',
    '爆阱',
    '爆闪',
    '气功术',
    '万斤闪',
    '风弹步',
    '气流术',
    '地柱钉',
    '金刚术',
    '吸血地精',
    '吸血地闪',
    '痹魔阱',
    '毒魔闪',
    '邪爆闪',
    '蛇柱阱',
    '血龙闪',
    '血龙闪-秘笈',
    '捕绳剑-秘笈',
    '金刚火焰掌-秘笈',
    '回复术-秘笈',
    '拔刀术-秘笈',
    '爆闪-秘笈');

implementation

initialization
  MAIGIC_DELAY_TIME_LIST_DEF := MAIGIC_DELAY_TIME_LIST;

finalization

end.


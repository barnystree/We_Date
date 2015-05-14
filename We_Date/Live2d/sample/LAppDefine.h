
#pragma once

//C++ std
//#include <string>
//#include <vector>


static const float VIEW_MAX_SCALE = 2.0f;
static const float VIEW_MIN_SCALE = 0.8f;

static const float VIEW_LOGICAL_LEFT = -1;
static const float VIEW_LOGICAL_RIGHT = 1;

static const float VIEW_LOGICAL_MAX_LEFT = -2;
static const float VIEW_LOGICAL_MAX_RIGHT = 2;
static const float VIEW_LOGICAL_MAX_BOTTOM = -2;
static const float VIEW_LOGICAL_MAX_TOP = 2;




static const char BACK_IMAGE_NAME[] = "back_class_normal.png" ;



static const char MODEL_HARU[]		= "live2d/LuHanBH/LuHanBH.model.json";
static const char MODEL_HARU_A[]		= "live2d/haru/haru_01.model.json";
static const char MODEL_HARU_B[]		= "live2d/haru/haru_02.model.json";
static const char MODEL_SHIZUKU[]		= "live2d/shizuku/shizuku.model.json";
static const char MODEL_WANKO[]       = "live2d/wanko/wanko.model.json";

static const char MOTION_GROUP_SCRIPT_EXPRESSION[]		="script_expressions";
static const char MOTION_GROUP_SCRIPT_MOTION[]		="script_motion";

static const char MOTION_GROUP_IDLE[]			="idle";
static const char MOTION_GROUP_TAP_BODY[]		="tap_body";
static const char MOTION_GROUP_FLICK_HEAD[]	="flick_head";
static const char MOTION_GROUP_PINCH_IN[]		="pinch_in";
static const char MOTION_GROUP_PINCH_OUT[]		="pinch_out";
static const char MOTION_GROUP_SHAKE[]			="shake";


static const char HIT_AREA_HEAD[]		="head";
static const char HIT_AREA_BODY[]		="body";


static const int PRIORITY_NONE  = 0;
static const int PRIORITY_IDLE  = 1;
static const int PRIORITY_NORMAL= 2;
static const int PRIORITY_FORCE = 3;


class LAppDefine {
public:
    static const bool DEBUG_LOG=false;
    static const bool DEBUG_TOUCH_LOG=false;
	static const bool DEBUG_DRAW_HIT_AREA=false;
};

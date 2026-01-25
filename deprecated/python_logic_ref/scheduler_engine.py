import datetime
from dataclasses import dataclass
from typing import List, Optional

# --- 1. 数据模型 ---

@dataclass
class UserProfile:
    name: str
    body_type: str  # 'ectomorph'(外胚), 'mesomorph'(中胚), 'endomorph'(内胚)
    goal: str       # 'muscle_gain', 'fat_loss'

@dataclass
class WorkoutBlock:
    id: str
    name: str
    duration_min: int
    intensity: str  # 'high', 'medium', 'low'
    tags: List[str] # ['gym', 'home', 'office', 'no-sweat']
    calories: int

@dataclass
class ScheduleEvent:
    start_hour: float
    end_hour: float
    title: str
    is_busy: bool

# --- 2. 知识库 (模拟数据库) ---

# 完整训练库
FULL_WORKOUTS = {
    "chest_day": [
        WorkoutBlock("bench_press", "杠铃卧推", 15, "high", ["gym"], 100),
        WorkoutBlock("incline_press", "上斜哑铃推", 15, "high", ["gym"], 90),
        WorkoutBlock("fly", "绳索夹胸", 15, "medium", ["gym"], 70),
        WorkoutBlock("pushup_finish", "俯卧撑力竭组", 10, "medium", ["home", "gym"], 50)
    ]
}

# 碎片训练库 (用于拆解/替换)
MICRO_WORKOUTS = [
    WorkoutBlock("office_pushup", "办公桌俯卧撑", 5, "medium", ["office", "no-sweat"], 20),
    WorkoutBlock("stair_climb", "楼梯冲刺", 10, "high", ["office", "home"], 80),
    WorkoutBlock("chair_dips", "椅子臂屈伸", 5, "medium", ["office", "no-sweat"], 15),
    WorkoutBlock("backpack_row", "背包划船", 10, "medium", ["home", "office"], 40)
]

# --- 3. 核心算法引擎 ---

class AIScheduler:
    def __init__(self, user: UserProfile):
        self.user = user

    def check_conflicts(self, plan: List[WorkoutBlock], schedule: List[ScheduleEvent], plan_start_hour: float) -> bool:
        """检查预定的训练计划是否与日程冲突"""
        plan_duration = sum(w.duration_min for w in plan) / 60.0
        plan_end_hour = plan_start_hour + plan_duration
        
        for event in schedule:
            if not event.is_busy: continue
            # 简单的重叠检测
            if max(plan_start_hour, event.start_hour) < min(plan_end_hour, event.end_hour):
                return True # 冲突
        return False

    def suggest_alternatives(self, original_plan: List[WorkoutBlock], available_slots: List[float]):
        """
        核心逻辑：当发生冲突时，根据用户体质和剩余时间生成替代方案
        """
        print(f"\n🤖 AI 正在分析用户 [{self.user.name} ({self.user.body_type})] 的替代方案...")
        
        suggestions = []

        # 策略 A: 碎片化拆解 (适合中/内胚，需要维持代谢)
        # 尝试找到总时长匹配的碎片动作
        needed_calories = sum(w.calories for w in original_plan)
        micro_plan = []
        current_cals = 0
        
        # 贪心算法选择微运动
        for _ in range(3): # 假设只能插3次
            for micro in MICRO_WORKOUTS:
                if "office" in micro.tags: # 假设场景是办公室
                    micro_plan.append(micro)
                    current_cals += micro.calories
            if current_cals >= needed_calories * 0.6: # 达到60%容量即可接受
                break
        
        suggestions.append({
            "type": "fragmentation",
            "title": "碎片化拆解 (保持代谢)",
            "description": f"将训练打散到工间休息，预计完成原计划 {int(current_cals/needed_calories*100)}% 的消耗。",
            "blocks": micro_plan
        })

        # 策略 B: 强度压缩 (适合外胚，减少消耗，保留刺激)
        if self.user.body_type == "ectomorph":
            suggestions.append({
                "type": "compression",
                "title": "保留核心 (防止掉肌肉)",
                "description": "只做最重要的复合动作，砍掉孤立动作。",
                "blocks": [original_plan[0], original_plan[1]] # 只保留前两个大项
            })
        
        # 策略 C: 转移 (适合所有人)
        suggestions.append({
            "type": "reschedule",
            "title": "推迟到明日 (加量)",
            "description": "今日彻底休息，明日训练量增加 20%。",
            "blocks": [] 
        })

        return suggestions

# --- 4. 模拟运行 ---

def run_simulation():
    # 1. 创建用户：小明，外胚型（瘦子），想增肌
    user = UserProfile("小明", "ectomorph", "muscle_gain")
    engine = AIScheduler(user)

    # 2. 原定计划：今晚 19:00 练胸
    original_plan = FULL_WORKOUTS["chest_day"]
    plan_start = 19.0 # 19:00

    # 3. 日程表：突然插入了一个加班
    schedule = [
        ScheduleEvent(9.0, 18.0, "工作", True),
        ScheduleEvent(19.0, 21.0, "🔥 突发加班会议", True) # 冲突！
    ]

    print(f"📅 原定计划: 胸肌训练 (约 {sum(w.duration_min for w in original_plan)} 分钟)")
    print(f"⚠️ 检测日程: 19:00 - 21:00 有 [🔥 突发加班会议]")

    # 4. 检测冲突
    if engine.check_conflicts(original_plan, schedule, plan_start):
        print("\n🚨 发现时间冲突！启动智能编排...")
        
        # 5. 生成建议
        options = engine.suggest_alternatives(original_plan, [12.0, 22.0]) # 假设中午和深夜有空
        
        for i, opt in enumerate(options):
            print(f"\n[方案 {i+1}] {opt['title']}")
            print(f"   📝 {opt['description']}")
            if opt['blocks']:
                print(f"   👉 内容: {', '.join([b.name for b in opt['blocks']])}")

if __name__ == "__main__":
    run_simulation()

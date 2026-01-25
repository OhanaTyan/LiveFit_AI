import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart'; // Import all AppColors
import '../../domain/models/schedule_event.dart';
import '../../../voice_schedule/presentation/screens/voice_schedule_screen.dart';

class ManualSchedulePage extends StatefulWidget {
  final Function(ScheduleEvent) onSave;
  final DateTime? initialDate;

  const ManualSchedulePage({super.key, required this.onSave, this.initialDate});

  @override
  State<ManualSchedulePage> createState() => _ManualSchedulePageState();
}

class _ManualSchedulePageState extends State<ManualSchedulePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay _startTime = TimeOfDay.now();
  late TimeOfDay _endTime;
  EventType _selectedType = EventType.workout;

  @override
  void initState() {
    super.initState();
    // Use the initial date passed from the widget, or current date if null
    _selectedDate = widget.initialDate ?? DateTime.now();
    final now = TimeOfDay.now();
    int endHour = now.hour + 1;
    if (endHour > 23) endHour = 0;
    _endTime = now.replacing(hour: endHour);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Color _getTypeColor(EventType type) {
    switch (type) {
      case EventType.workout:
        return AppColors.success; // 绿色 - 健身
      case EventType.work:
        return AppColors.primary; // 蓝色 - 工作
      case EventType.life:
        return AppColors.secondary; // 珊瑚粉 - 生活
      case EventType.rest:
        return AppColors.warning; // 橙色 - 休息
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ), // Allow selecting dates up to 1 year in the past
      lastDate: DateTime.now().add(
        const Duration(days: 730),
      ), // Allow selecting dates up to 2 years in the future
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;

    // 确保初始分钟数是5的倍数
    int minute = initialTime.minute;
    minute = (minute ~/ 5) * 5;

    final initialDateTime = DateTime(0, 0, 0, initialTime.hour, minute);

    await showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDateTime = initialDateTime;
        return AlertDialog(
          title: Text(isStart ? '选择开始时间' : '选择结束时间'),
          content: SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: initialDateTime,
              onDateTimeChanged: (dateTime) {
                selectedDateTime = dateTime;
              },
              use24hFormat: true,
              minuteInterval: 5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final pickedTime = TimeOfDay.fromDateTime(selectedDateTime);
                setState(() {
                  if (isStart) {
                    _startTime = pickedTime;
                  } else {
                    _endTime = pickedTime;
                  }
                });
                Navigator.pop(context);
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('添加日程'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VoiceScheduleScreen()),
            ),
            icon: const Icon(Icons.mic, color: AppColors.primary),
            tooltip: '语音添加',
          ),
        ],
      ),
      body: GestureDetector(
        // Add swipe left/right gesture detection
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              // Swipe right - previous day
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            } else if (details.primaryVelocity! < 0) {
              // Swipe left - next day
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. Basic Info Card
              _buildSectionCard(
                context,
                children: [
                  TextField(
                    controller: _titleController,
                    style: theme.textTheme.titleMedium,
                    decoration: InputDecoration(
                      hintText: '请输入事件标题',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(
                        color: AppColors.textDisabled.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '添加备注（可选）',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(
                        color: AppColors.textDisabled.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Type Selection (Horizontal)
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: EventType.values.map((type) {
                    final isSelected = _selectedType == type;
                    final chipColor = _getTypeColor(type);
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(_getTypeName(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedType = type);
                        },
                        selectedColor: chipColor,
                        backgroundColor: isDark
                            ? AppColors.surfaceDark
                            : Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : (isDark
                                    ? Colors.white
                                    : AppColors.textSecondaryLight),
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : AppColors.textDisabled.withAlpha(
                                    (0.2 * 255).toInt(),
                                  ),
                          ),
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: chipColor.withAlpha((0.3 * 255).toInt()),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Time Settings
              _buildSectionCard(
                context,
                children: [
                  _buildListRow(
                    context,
                    icon: Icons.calendar_today,
                    label: '日期',
                    value: DateFormat('yyyy年MM月dd日').format(_selectedDate),
                    onTap: _pickDate,
                  ),
                  const Divider(height: 1),
                  _buildListRow(
                    context,
                    icon: Icons.access_time,
                    label: '开始时间',
                    value: _startTime.format(context),
                    onTap: () => _pickTime(true),
                  ),
                  const Divider(height: 1),
                  _buildListRow(
                    context,
                    icon: Icons.access_time_filled,
                    label: '结束时间',
                    value: _endTime.format(context),
                    onTap: () => _pickTime(false),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 4. Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. 检查标题是否为空
                    if (_titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('请输入事件标题'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final now = DateTime.now();
                    final startDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _startTime.hour,
                      _startTime.minute,
                    );
                    final endDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _endTime.hour,
                      _endTime.minute,
                    );

                    // 2. 检查基本时间合理性：结束时间 >= 开始时间
                    if (endDateTime.isBefore(startDateTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('结束时间不能早于开始时间'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final newEvent = ScheduleEvent(
                      id: '${now.millisecondsSinceEpoch}',
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      startTime: startDateTime,
                      endTime: endDateTime,
                      type: _selectedType,
                      color: _getTypeColor(_selectedType),
                    );

                    widget.onSave(newEvent);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withAlpha(
                      (0.4 * 255).toInt(),
                    ),
                  ),
                  child: Text(
                    '保存日程',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildListRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.secondary),
            const SizedBox(width: 12),
            Text(label, style: theme.textTheme.bodyMedium),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeName(EventType type) {
    switch (type) {
      case EventType.workout:
        return '健身';
      case EventType.work:
        return '工作';
      case EventType.life:
        return '生活';
      case EventType.rest:
        return '休息';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';
import 'package:life_fit/src/core/theme/app_colors.dart';

class ScheduleEditPage extends StatefulWidget {
  final ScheduleEvent? initialEvent;
  final Function(ScheduleEvent) onSave;
  final Function() onCancel;

  const ScheduleEditPage({
    Key? key,
    this.initialEvent,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ScheduleEditPage> createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _startTime;
  late DateTime _endTime;
  late EventType _eventType;
  late EventPriority _priority;
  late Color _eventColor;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initialEvent = widget.initialEvent;
    
    _titleController = TextEditingController(
      text: initialEvent?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: initialEvent?.description ?? '',
    );
    _locationController = TextEditingController(
      text: initialEvent?.location ?? '',
    );
    _startTime = initialEvent?.startTime ?? now;
    _endTime = initialEvent?.endTime ?? now.add(const Duration(hours: 1));
    _eventType = initialEvent?.type ?? EventType.work;
    _priority = initialEvent?.priority ?? EventPriority.medium;
    _eventColor = initialEvent?.color ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialEvent != null ? '编辑日程' : '创建日程'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.initialEvent != null ? _showDeleteDialog : null,
            color: AppColors.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildTimeFields(),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 16),
            _buildEventTypeField(),
            const SizedBox(height: 16),
            _buildPriorityField(),
            const SizedBox(height: 16),
            _buildColorPicker(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: '事件标题',
        border: const OutlineInputBorder(),
        hintText: '请输入事件标题',
      ),
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: '描述',
        border: const OutlineInputBorder(),
        hintText: '请输入事件描述',
      ),
      maxLines: 3,
    );
  }

  Widget _buildTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('时间'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDateTime(context, true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_startTime.year}-${_startTime.month.toString().padLeft(2, '0')}-${_startTime.day.toString().padLeft(2, '0')} ${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectDateTime(context, false),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: '地点',
        border: const OutlineInputBorder(),
        hintText: '请输入地点',
        prefixIcon: const Icon(Icons.location_on),
      ),
    );
  }

  Widget _buildEventTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('事件类型'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: EventType.values.map((type) {
            return ChoiceChip(
              label: Text(_getEventTypeLabel(type)),
              selected: _eventType == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _eventType = type;
                    // 根据事件类型自动设置颜色
                    _eventColor = _getColorForEventType(type);
                  });
                }
              },
              selectedColor: _getColorForEventType(type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('优先级'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: EventPriority.values.map((priority) {
            return ChoiceChip(
              label: Text(_getPriorityLabel(priority)),
              selected: _priority == priority,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _priority = priority;
                  });
                }
              },
              selectedColor: _getColorForPriority(priority),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('事件颜色'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _eventColor = color;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: _eventColor == color
                      ? Border.all(width: 3, color: Colors.black)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onCancel,
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('保存'),
          ),
        ),
      ],
    );
  }

  void _selectDateTime(BuildContext context, bool isStartTime) async {
    final initialDateTime = isStartTime ? _startTime : _endTime;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (timePicked != null) {
        final newDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );

        setState(() {
          if (isStartTime) {
            _startTime = newDateTime;
            // 确保结束时间在开始时间之后
            if (_endTime.isBefore(_startTime)) {
              _endTime = _startTime.add(const Duration(hours: 1));
            }
          } else {
            _endTime = newDateTime;
            // 确保开始时间在结束时间之前
            if (_startTime.isAfter(_endTime)) {
              _startTime = _endTime.subtract(const Duration(hours: 1));
            }
          }
        });
      }
    }
  }

  void _saveEvent() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入事件标题')),
      );
      return;
    }

    final event = ScheduleEvent(
      id: widget.initialEvent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      type: _eventType,
      color: _eventColor,
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      priority: _priority,
      isCompleted: widget.initialEvent?.isCompleted ?? false,
    );

    widget.onSave(event);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('您确定要删除这个日程吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // 返回删除结果
              Navigator.pop(context);
              widget.onCancel(); // 使用cancel回调通知删除
            },
            child: const Text('删除', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _getEventTypeLabel(EventType type) {
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

  String _getPriorityLabel(EventPriority priority) {
    switch (priority) {
      case EventPriority.low:
        return '低';
      case EventPriority.medium:
        return '中';
      case EventPriority.high:
        return '高';
      case EventPriority.urgent:
        return '紧急';
    }
  }

  Color _getColorForEventType(EventType type) {
    switch (type) {
      case EventType.workout:
        return Colors.green;
      case EventType.work:
        return Colors.blue;
      case EventType.life:
        return Colors.purple;
      case EventType.rest:
        return Colors.yellow;
    }
  }

  Color _getColorForPriority(EventPriority priority) {
    switch (priority) {
      case EventPriority.low:
        return Colors.green;
      case EventPriority.medium:
        return Colors.blue;
      case EventPriority.high:
        return Colors.orange;
      case EventPriority.urgent:
        return Colors.red;
    }
  }
}

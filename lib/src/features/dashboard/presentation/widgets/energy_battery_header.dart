import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/gradient_utils.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';

class EnergyBatteryHeader extends StatefulWidget {
  final double energyLevel; // 0.0 to 1.0

  const EnergyBatteryHeader({
    super.key,
    this.energyLevel = 0.8,
  });

  @override
  State<EnergyBatteryHeader> createState() => _EnergyBatteryHeaderState();
}

class _EnergyBatteryHeaderState extends State<EnergyBatteryHeader> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  
  // Time service integration
  late TimeService _timeService;
  late StreamSubscription<DateTime> _timeSubscription;
  DateTime _currentTime = DateTime.now();
  String _formattedTime = '';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.energyLevel).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
    
    // Initialize time service
    _timeService = TimeService();
    _formattedTime = _timeService.formatTime(_currentTime);
    
    // Subscribe to time updates
    _timeSubscription = _timeService.timeStream.listen((time) {
      setState(() {
        _currentTime = time;
        _formattedTime = _timeService.formatTime(time);
      });
    });
  }

  @override
  void didUpdateWidget(EnergyBatteryHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.energyLevel != widget.energyLevel) {
      _progressAnimation = Tween<double>(begin: oldWidget.energyLevel, end: widget.energyLevel).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      _animController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _timeSubscription.cancel();
    super.dispose();
  }

  String _getGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = _currentTime.hour;
    if (hour >= 0 && hour < 6) {
      return l10n.greetingNight;
    } else if (hour >= 6 && hour < 12) {
      return l10n.greetingMorning;
    } else if (hour >= 12 && hour < 17) {
      return l10n.greetingAfternoon;
    } else {
      return l10n.greetingEvening;
    }
  }

  Future<void> _showStarredEvents(BuildContext context) async {
    final storageService = StorageService();
    final allEvents = await storageService.loadActiveEvents();
    
    // 过滤今天的重要标星事件
    final today = DateTime.now();
    final todayEvents = allEvents?.where((event) {
      // 检查是否是今天的事件
      final isToday = event.startTime.year == today.year &&
                     event.startTime.month == today.month &&
                     event.startTime.day == today.day;
      
      // 检查是否是标星事件，显示所有标星事件
      return isToday && event.isStarred;
    }).toList() ?? [];
    
    // 按时间排序
    todayEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // 显示事件列表
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(context)!;
        
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Text(
                l10n.todayStarredEvents,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 20),
              
              // 事件列表
              if (todayEvents.isEmpty) ...[
                Center(
                  child: Text(
                    l10n.noStarredEventsToday,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ] else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayEvents.length,
                  itemBuilder: (context, index) {
                    final event = todayEvents[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 时间
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: event.color,
                                ),
                              ),
                              Text(
                                '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          
                          // 事件信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      event.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                if (event.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    event.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: event.color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event.priority.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: event.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<UserProfileProvider>(
                    builder: (context, provider, child) {
                      final userName = provider.userProfile.nickname.isNotEmpty 
                          ? provider.userProfile.nickname 
                          : 'Alex';
                      return Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24, // 减小字体大小
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis, // 添加溢出处理
                      );
                    },
                  ),
                  // Time display
                  const SizedBox(height: 4),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      fontSize: 14, // 减小字体大小
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis, // 添加溢出处理
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showStarredEvents(context),
                child: CircleAvatar(
                  backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  radius: 28,
                  child: Icon(Icons.notifications_outlined, 
                    size: 24,
                    color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Vitality Ring
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Circle
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 12,
                  color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
                  strokeCap: StrokeCap.round,
                ),
                // Gradient Progress Circle
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _GradientCircularProgressPainter(
                        progress: _progressAnimation.value,
                        strokeWidth: 12,
                        gradient: GradientUtils.createLinearGradient(
                          colors: GradientColors.primary,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
                // Inner Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => GradientUtils.createLinearGradient(
                        colors: GradientColors.primary,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Text(
                          '${(_progressAnimation.value * 1240).toInt()}',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            foreground: Paint()
                              ..shader = GradientUtils.createLinearGradient(
                                colors: GradientColors.primary,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(const Rect.fromLTWH(0, 0, 150, 60)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.calories,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for gradient circular progress
class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create gradient paint
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    final angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.gradient != gradient;
  }
}

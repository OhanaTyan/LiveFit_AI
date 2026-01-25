import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';

class StatsSettingsPage extends StatelessWidget {
  const StatsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final userProfile = provider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('统计设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, '目标设定'),
          _buildSettingCard(
            context,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department, color: Colors.orange),
                ),
                title: const Text('每日卡路里目标'),
                subtitle: Text('${userProfile.dailyCalorieGoal ?? 2000} kcal'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCalorieEditDialog(context, provider);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer, color: AppColors.primary),
                ),
                title: const Text('每日运动时长'),
                subtitle: const Text('60 分钟 (默认)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showDurationEditDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, '显示偏好'),
          _buildSettingCard(
            context,
            children: [
              SwitchListTile(
                title: const Text('显示周末高亮'),
                secondary: const Icon(Icons.weekend),
                value: true,
                onChanged: (val) {},
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('显示详细数据标签'),
                secondary: const Icon(Icons.label_outline),
                value: false,
                onChanged: (val) {},
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, '数据管理'),
          _buildSettingCard(
            context,
            children: [
              ListTile(
                leading: const Icon(Icons.file_download_outlined),
                title: const Text('导出本周报表 (CSV)'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('正在导出...')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined, color: Colors.red),
                title: const Text('重置统计缓存', style: TextStyle(color: Colors.red)),
                onTap: () {
                  _clearCache(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  void _showCalorieEditDialog(BuildContext context, UserProfileProvider provider) {
    final controller = TextEditingController(
      text: (provider.userProfile.dailyCalorieGoal ?? 2000).toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改卡路里目标'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '每日目标 (kcal)',
            border: OutlineInputBorder(),
            suffixText: 'kcal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                provider.updateUserProfile(
                  provider.userProfile.copyWith(dailyCalorieGoal: val),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDurationEditDialog(BuildContext context) {
    final controller = TextEditingController(text: '60');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改运动时长目标'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '每日目标 (分钟)',
            border: OutlineInputBorder(),
            suffixText: '分钟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                // TODO: Save duration goal to user profile
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('目标已更新')),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置统计缓存'),
        content: const Text('此操作将清除所有统计缓存数据，确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: Implement cache clearing logic
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已重置')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

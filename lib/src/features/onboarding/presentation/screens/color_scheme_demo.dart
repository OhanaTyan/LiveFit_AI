import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ColorSchemeDemo extends StatelessWidget {
  const ColorSchemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('配色方案演示'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // 主题1: 现代科技蓝
          _buildThemeCard(
            context,
            title: '主题1: 现代科技蓝',
            description: '设计理念：采用更柔和的蓝色调，营造科技感与专业感，同时提升视觉舒适度\n适用场景：全功能健身应用，适合科技爱好者和追求专业感的用户',
            colorScheme: AppColors.modernBlue,
            backgroundColor: AppColors.backgroundLightModern,
          ),
          const SizedBox(height: 24),
          
          // 主题2: 清新薄荷绿
          _buildThemeCard(
            context,
            title: '主题2: 清新薄荷绿',
            description: '设计理念：采用清新的薄荷绿调，营造自然、健康、活力的氛围，适合健身和健康应用\n适用场景：瑜伽、冥想、健康养生类功能，适合追求自然生活方式的用户',
            colorScheme: AppColors.freshMint,
            backgroundColor: AppColors.backgroundLightMint,
          ),
          const SizedBox(height: 24),
          
          // 主题3: 温暖奶油色
          _buildThemeCard(
            context,
            title: '主题3: 温暖奶油色',
            description: '设计理念：采用温暖的奶油色调，营造舒适、亲切、激励的氛围，适合健身激励和日常使用\n适用场景：健身计划、进度追踪、日常记录，适合需要温暖激励的用户',
            colorScheme: AppColors.warmCream,
            backgroundColor: AppColors.backgroundLightCream,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    {
      required String title,
      required String description,
      required ColorScheme colorScheme,
      required Color backgroundColor,
    }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 颜色预览
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColorPreview(color: colorScheme.primary, label: '主色'),
                _buildColorPreview(color: colorScheme.secondary, label: '辅助色'),
                _buildColorPreview(color: colorScheme.surface, label: '背景色'),
                _buildColorPreview(color: colorScheme.surface, label: '卡片色'),
              ],
            ),
            const SizedBox(height: 20),
            
            // 示例组件
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '示例组件',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: const Text('主要按钮'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                        ),
                        child: const Text('次要按钮'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '输入框示例',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPreview({required Color color, required String label}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

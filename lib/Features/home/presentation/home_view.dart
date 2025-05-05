import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/core/utils/app_router.dart';

class Homeview extends StatelessWidget {
  const Homeview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔢 ملخص سريع
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("👥 عدد المرضى: 120", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text("🕒 آخر زيارة: 2 مايو 2025",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ➕ زرار تسجيل مريض جديد
            ElevatedButton.icon(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kRegisterpatient);
              },
              icon: const Icon(Icons.person_add),
              label:
                  const Text("تسجيل مريض جديد", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // 🔍 زرار البحث عن مريض
            ElevatedButton.icon(
              onPressed: () {
                // TODO: navigate to search screen
              },
              icon: const Icon(Icons.search),
              label:
                  const Text("البحث عن مريض", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // 📝 آخر الزيارات
            const Text("📋 آخر الزيارات:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text("أحمد محمد"),
                    subtitle: Text("زيارة بتاريخ 1 مايو 2025"),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text("سارة علي"),
                    subtitle: Text("زيارة بتاريخ 30 إبريل 2025"),
                  ),
                  // أضف زيارات أخرى حسب الحاجة
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

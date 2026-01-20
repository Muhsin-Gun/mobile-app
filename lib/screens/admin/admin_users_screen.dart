import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';

class AdminUsersScreen extends StatefulWidget {
  static const routName = "/AdminUsersScreen";

  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(IconlyLight.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AdminProvider>(
                builder: (context, adminProvider, child) {
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: adminProvider.fetchAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                IconlyLight.user,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              SubtitleTextWidget(label: 'No users found'),
                            ],
                          ),
                        );
                      }
                      List<Map<String, dynamic>> users = snapshot.data!;
                      if (_searchController.text.isNotEmpty) {
                        users = users
                            .where(
                              (user) =>
                                  (user['username'] ?? '')
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                        _searchController.text.toLowerCase(),
                                      ) ||
                                  (user['email'] ?? '')
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                        _searchController.text.toLowerCase(),
                                      ),
                            )
                            .toList();
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserCard(user: user);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (user['userImage'] ?? '').isNotEmpty
              ? NetworkImage(user['userImage'] as String)
              : null,
          child: (user['userImage'] ?? '').isEmpty
              ? const Icon(IconlyLight.user)
              : null,
        ),
        title: TitlesTextWidget(
          label: user['username'] ?? 'Unknown',
          fontSize: 16,
        ),
        subtitle: SubtitleTextWidget(
          label: user['email'] ?? 'No email',
          fontSize: 12,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (user['role'] ?? 'user') == 'admin'
                ? Colors.red.withOpacity(0.2)
                : Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SubtitleTextWidget(
            label: user['role'] ?? 'user',
            fontSize: 11,
            color: (user['role'] ?? 'user') == 'admin'
                ? Colors.red
                : Colors.blue,
          ),
        ),
      ),
    );
  }
}


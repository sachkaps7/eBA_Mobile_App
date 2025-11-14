import 'package:eyvo_v3/core/widgets/NotificationProvider.dart';

import 'package:eyvo_v3/presentation/Notification_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationDashboard extends StatelessWidget {
  NotificationDashboard({Key? key, this.notificationData}) : super(key: key);

  final Map<String, String>? notificationData;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final data = notificationData ?? notificationProvider.notificationData;

    final notifications = data != null ? [data] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        actions: [
          // Example action button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic here
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notification data available'))
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationDetailScreen(
                            notificationData: notification),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification image if available
                          if (notification['imageUrl'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Image.network(
                                notification['imageUrl']!,
                                cacheWidth: 500,
                                cacheHeight: 300,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          Text(
                            notification['title'] ?? 'No title',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            notification['body'] ?? 'No content',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          // Notification time if available
                          if (notification['time'] != null)
                            Text(
                              'Received: ${notification['time']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

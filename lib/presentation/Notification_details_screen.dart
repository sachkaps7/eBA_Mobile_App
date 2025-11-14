import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, String> notificationData;

  const NotificationDetailScreen({Key? key, required this.notificationData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = notificationData['title'] ?? 'No Title';
    final body = notificationData['body'] ?? 'No Content';
    final imageUrl = notificationData['imageUrl'];
    final time = notificationData['time'];

    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(fontSize: 18),
            ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Received: $time',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Accept'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    // TODO: Handle Accept action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request Accepted')),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    // TODO: Handle Reject action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request Rejected')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

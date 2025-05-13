import 'package:flutter/material.dart';
import '../theme.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail-chat', arguments: name);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Cyan50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Cyan.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child:
                  name.toLowerCase().contains('toko')
                      ? ClipOval(
                        child: Image.asset(
                          'assets/icon_shoplogo.jpg',
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                        size: 28,
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: primaryTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: secondaryTextStyle.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              (time.toLowerCase() == 'now' || time.toLowerCase() == 'baru saja')
                  ? 'Now'
                  : time,
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

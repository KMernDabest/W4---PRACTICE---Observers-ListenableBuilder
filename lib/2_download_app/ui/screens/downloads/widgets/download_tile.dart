import 'package:flutter/material.dart';
 
import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  Widget _buildTrailing(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.notDownloaded:
        return IconButton(
          icon: const Icon(Icons.download),
          onPressed: controller.startDownload,
        );
      case DownloadStatus.downloading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case DownloadStatus.downloaded:
        return const Icon(Icons.folder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final status = controller.status;
        final progress = controller.progress;
        final resource = controller.ressource;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (status != DownloadStatus.notDownloaded)
                      Text(
                        '${(progress * 100).toStringAsFixed(1)} % completed - '
                        '${(progress * resource.size).toStringAsFixed(1)} of ${resource.size} MB',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              _buildTrailing(status),
            ],
          ),
        );
      },
    );
  }
}

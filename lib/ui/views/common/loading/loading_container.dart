import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: [
          Row(
            children: [
              const SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.circle,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 6,
                      maxLength: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SkeletonParagraph(
            style: SkeletonParagraphStyle(
              spacing: 6,
              lineStyle: SkeletonLineStyle(
                randomLength: true,
                height: 10,
                borderRadius: BorderRadius.circular(8),
                minLength: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              minHeight: MediaQuery.of(context).size.height / 8,
              maxHeight: MediaQuery.of(context).size.height / 3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(width: 20, height: 20),
                  ),
                  SizedBox(width: 8),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(width: 20, height: 20),
                  ),
                  SizedBox(width: 8),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(width: 20, height: 20),
                  ),
                ],
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: 64,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

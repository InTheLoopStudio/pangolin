import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/themes.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tappedAccent,
        ),
        width: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.work,
                size: 50,
              ),
              Text(
                service.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                service.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '\$${(service.rate / 100).toStringAsFixed(2)}${service.rateType == RateType.hourly ? '/hr' : ''}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

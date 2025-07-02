

import 'package:demo/Model/employee.dart';
import 'package:flutter/material.dart';


class EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final bool isLastOpened;
  final VoidCallback onTap;

  const EmployeeListItem({
    Key? key,
    required this.employee,
    required this.isLastOpened,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: isLastOpened ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isLastOpened 
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isLastOpened
                ? LinearGradient(
                    colors: [
                      Colors.blue.shade50,
                      Colors.blue.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Avatar with photo or initials
              ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isLastOpened 
                        ? Colors.blue.shade600 
                        : Colors.grey.shade300,
                  ),
                  child: 
                       Image.network(
                        
                          employee.photo,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                employee.name.isNotEmpty 
                                    ? employee.name[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isLastOpened ? Colors.white : Colors.grey.shade600,
                                ),
                              ),
                            );
                          },
                        )
                     
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Employee details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLastOpened 
                            ? Colors.blue.shade800 
                            : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.company.isNotEmpty ? employee.company : employee.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: isLastOpened 
                            ? Colors.blue.shade600 
                            : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${employee.username}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLastOpened 
                            ? Colors.blue.shade500 
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow and badge
              Column(
                children: [
                  if (isLastOpened)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'RECENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isLastOpened 
                        ? Colors.blue.shade600 
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
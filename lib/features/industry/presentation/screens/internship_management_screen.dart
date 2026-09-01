
import 'package:flutter/material.dart';

import '../../data/models/industry_internship_model.dart';
import '../../data/services/industry_service.dart';

class InternshipManagementScreen extends StatefulWidget {
  const InternshipManagementScreen({super.key});

  @override
  State<InternshipManagementScreen> createState() =>
      _InternshipManagementScreenState();
}

class _InternshipManagementScreenState
    extends State<InternshipManagementScreen> {
  final IndustryService _industryService = IndustryService();

  late Future<List<IndustryInternshipModel>> _internshipsFuture;

  @override
  void initState() {
    super.initState();
    _internshipsFuture = _industryService.getIndustryInternships();
  }

  Future<void> _refreshInternships() async {
    setState(() {
      _internshipsFuture = _industryService.getIndustryInternships();
    });

    await _internshipsFuture;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
      case 'approved':
      case 'verified':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'submitted':
        return Colors.indigo;

      case 'under_review':
      case 'in_progress':
        return Colors.orange;

      case 'pending':
      case 'draft':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    return status.replaceAll('_', ' ').toUpperCase();
  }

  Widget _statusRow(
    String label,
    String status,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Chip(
          label: Text(
            _formatStatus(status),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          backgroundColor: _getStatusColor(status),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Management'),
      ),
      body: FutureBuilder<List<IndustryInternshipModel>>(
        future: _internshipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final internships = snapshot.data ?? [];

          if (internships.isEmpty) {
            return const Center(
              child: Text('No internships available'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshInternships,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: internships.length,
              itemBuilder: (context, index) {
                final internship = internships[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                internship.studentName[0],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                internship.studentName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          internship.internshipTitle,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 16),

                        LinearProgressIndicator(
                          value: internship.progress / 100,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Internship Progress: '
                          '${internship.progress.toStringAsFixed(0)}%',
                        ),

                        const SizedBox(height: 12),

                        _statusRow(
                          'Internship',
                          internship.status,
                        ),

                        _statusRow(
                          'ITR',
                          internship.itrStatus,
                        ),

                        _statusRow(
                          'Evaluation',
                          internship.evaluationStatus,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


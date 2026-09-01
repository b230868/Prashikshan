
import 'package:flutter/material.dart';

import '../../data/models/industry_internship_model.dart';
import '../../data/services/industry_service.dart';
import 'internship_management_screen.dart';
import '../../../itr/presentation/screens/itr_screen.dart';

class IndustryDashboardScreen extends StatefulWidget {
  const IndustryDashboardScreen({super.key});

  @override
  State<IndustryDashboardScreen> createState() =>
      _IndustryDashboardScreenState();
}

class _IndustryDashboardScreenState extends State<IndustryDashboardScreen> {
  final IndustryService _industryService = IndustryService();

  late Future<List<IndustryInternshipModel>> _internshipsFuture;

  @override
  void initState() {
    super.initState();
    _internshipsFuture = _industryService.getIndustryInternships();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _internshipsFuture = _industryService.getIndustryInternships();
    });

    await _internshipsFuture;
  }

  int _countByStatus(
    List<IndustryInternshipModel> internships,
    String status,
  ) {
    return internships.where((item) => item.status == status).length;
  }

  int _countItrStatus(
    List<IndustryInternshipModel> internships,
    List<String> statuses,
  ) {
    return internships
        .where((item) => statuses.contains(item.itrStatus))
        .length;
  }

  int _countEvaluationStatus(
    List<IndustryInternshipModel> internships,
    List<String> statuses,
  ) {
    return internships
        .where((item) => statuses.contains(item.evaluationStatus))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Industry Dashboard'),
        centerTitle: true,
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
              child: Text(
                'Unable to load dashboard: ${snapshot.error}',
              ),
            );
          }

          final internships = snapshot.data ?? [];

          if (internships.isEmpty) {
            return const Center(
              child: Text('No industry internship data available'),
            );
          }

          final activeInterns =
              _countByStatus(internships, 'active');

          final pendingItr = _countItrStatus(
            internships,
            ['draft', 'submitted', 'under_review'],
          );

          final pendingEvaluation = _countEvaluationStatus(
            internships,
            ['pending', 'in_progress'],
          );

          final completedInternships =
              _countByStatus(internships, 'completed');

          return RefreshIndicator(
            onRefresh: _refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _DashboardCard(
                          title: 'Active Interns',
                          value: activeInterns.toString(),
                          icon: Icons.people,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DashboardCard(
                          title: 'ITR Pending',
                          value: pendingItr.toString(),
                          icon: Icons.description,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _DashboardCard(
                          title: 'Evaluations Pending',
                          value: pendingEvaluation.toString(),
                          icon: Icons.assignment_turned_in,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DashboardCard(
                          title: 'Completed',
                          value: completedInternships.toString(),
                          icon: Icons.check_circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListTile(
                    leading: const Icon(Icons.business_center),
                    title: const Text('Manage Internships'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InternshipManagementScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('ITR Management'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItrListScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text('Evaluation & Verification'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Evaluation screen navigation will be added here.
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Reports & Analytics'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Reports screen navigation will be added here.
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


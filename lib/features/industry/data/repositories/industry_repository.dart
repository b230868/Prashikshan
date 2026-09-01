import '../models/industry_internship_model.dart';

class IndustryRepository {
  Future<List<IndustryInternshipModel>> getIndustryInternships() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      IndustryInternshipModel(
        id: '1',
        studentName: 'Rahul Sharma',
        internshipTitle: 'Software Development Intern',
        status: 'active',
        progress: 65,
        itrStatus: 'submitted',
        evaluationStatus: 'pending',
      ),
      IndustryInternshipModel(
        id: '2',
        studentName: 'Priya Singh',
        internshipTitle: 'Data Analytics Intern',
        status: 'active',
        progress: 80,
        itrStatus: 'under_review',
        evaluationStatus: 'in_progress',
      ),
      IndustryInternshipModel(
        id: '3',
        studentName: 'Aman Verma',
        internshipTitle: 'Flutter Development Intern',
        status: 'completed',
        progress: 100,
        itrStatus: 'approved',
        evaluationStatus: 'verified',
      ),
    ];
  }
}
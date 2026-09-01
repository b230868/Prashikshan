import '../models/industry_internship_model.dart';
import '../repositories/industry_repository.dart';

class IndustryService {
  final IndustryRepository _repository;

  IndustryService({
    IndustryRepository? repository,
  }) : _repository = repository ?? IndustryRepository();

  Future<List<IndustryInternshipModel>> getIndustryInternships() async {
    return _repository.getIndustryInternships();
  }
}
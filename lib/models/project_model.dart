class ProjectModel {
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String imageUrl;
  final List<String> features;

  ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    required this.imageUrl,
    required this.features,
  });
}
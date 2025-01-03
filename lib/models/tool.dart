class Tool {
  const Tool(
      {required this.image, required this.title, required this.description});

  final String image;
  final String title;
  final String description;
}

const List<Tool> toolArray = [
  Tool(
      image: "assets/icons/icon.jpg",
      title: "Garden AI",
      description: "Garden AI can answer your gardening questions"),
  Tool(
      image: "assets/icons/identify_icon.jpg",
      title: "Plant Identification",
      description: "Identify unknown plants by image"),
  Tool(
      image: "assets/icons/health_assessment_icon.jpg",
      title: "Health Assessment",
      description: "Assess your plant's health by image"),
];

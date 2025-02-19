import 'dart:convert';

class HealthAssessmentResponse {
    String name;
    String scientificName;
    int healthScorePercentage;
    String issueDescription;
    String solution;
    String prevention;

    HealthAssessmentResponse({
        required this.name,
        required this.scientificName,
        required this.healthScorePercentage,
        required this.issueDescription,
        required this.solution,
        required this.prevention,
    });

    factory HealthAssessmentResponse.fromRawJson(String str) => HealthAssessmentResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HealthAssessmentResponse.fromJson(Map<String, dynamic> json) => HealthAssessmentResponse(
        name: json["name"],
        scientificName: json["scientific_name"],
        healthScorePercentage: json["health_score_percentage"],
        issueDescription: json["issue_description"],
        solution: json["solution"],
        prevention: json["prevention"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "scientific_name": scientificName,
        "health_score_percentage": healthScorePercentage,
        "issue_description": issueDescription,
        "solution": solution,
        "prevention": prevention,
    };
}
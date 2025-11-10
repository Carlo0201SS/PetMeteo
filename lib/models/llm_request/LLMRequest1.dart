class LLMRequest1 {
  final List<LLMMessage1>? messages;
  final int? maxTokens;
  final double? temperature;
  final double? topP;
  final String? model;

  LLMRequest1({
    this.messages,
    this.model,
    this.maxTokens,
    this.temperature,
    this.topP,
  });

  ///  Questo serve per la POST (trasforma in JSON)
  Map<String, dynamic> toJson() {
    return {
      if (model != null) 'model': model,
      'messages': messages?.map((e) => e.toJson()).toList(),
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
    };
  }

  ///  Questo serve per la lettura (response)
  factory LLMRequest1.fromJson(Map<String, dynamic> json) {
    return LLMRequest1(
      messages: (json['messages'] as List?)
          ?.map((e) => LLMMessage1.fromJson(e))
          .toList(),
      model: json['model'],
      maxTokens: json['max_tokens'],
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['top_p'] as num?)?.toDouble(),
    );
  }
}

class LLMMessage1 {
  final String? role;
  final String? content;

  LLMMessage1({this.role, this.content});

  ///  Questo serve per la POST
  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }

  ///  Questo serve per la lettura (response)
  factory LLMMessage1.fromJson(Map<String, dynamic> json) {
    return LLMMessage1(role: json['role'], content: json['content']);
  }
}















































































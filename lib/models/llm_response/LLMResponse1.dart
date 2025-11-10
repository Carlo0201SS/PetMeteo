class LLMResponse1 {
  final List<LLMChoices>? choices;
  final String? model;
  final String? object;
  final Usage? usage;

  LLMResponse1({this.choices, this.model, this.object, this.usage});

  factory LLMResponse1.fromJson(Map<String, dynamic> json) {
    return LLMResponse1(
      choices: (json['choices'] as List?)
          ?.map((e) => LLMChoices.fromJson(e))
          .toList(),
      model: json['model'],
      object: json['object'],
      usage: json['usage'] != null ? Usage.fromJson(json['usage']) : null,
    );
  }
}

class LLMChoices {
  final Message? message;

  LLMChoices({this.message});

  factory LLMChoices.fromJson(Map<String, dynamic> json) {
    return LLMChoices(
      message: json['message'] != null
          ? Message.fromJson(json['message'])
          : null,
    );
  }
}

class Message {
  final String? content;
  final String? role;

  Message({this.content, this.role});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(content: json['content'], role: json['role']);
  }
}

class Usage {
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;

  Usage({this.promptTokens, this.completionTokens, this.totalTokens});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}




































































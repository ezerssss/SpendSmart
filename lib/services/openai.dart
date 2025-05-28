import 'package:dart_openai/dart_openai.dart';
import 'package:spendsmart/constants/ai.dart';

class OpenAIService {
  Future<void> ha() async {
    print("HERE");
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(systemPrompt),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    final imageUrlRequestMap = {
      "type": "image_url",
      "text": "Analyze this receipt.",
      "image_url": {
        "url":
            "https://upload.wikimedia.org/wikipedia/commons/0/0b/ReceiptSwiss.jpg",
        "detail": "high",
      },
    };

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.fromMap(
          imageUrlRequestMap,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [systemMessage, userMessage];

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat
        .create(
          model: "gpt-4o-mini-2024-07-18",
          messages: requestMessages,
          responseFormat: {"type": "json_object"},
        );

    print(chatCompletion.choices.first.message);
  }
}

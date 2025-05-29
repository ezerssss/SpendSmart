import 'dart:convert';

import 'package:openai_dart/openai_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/constants/ai.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/errors/network.dart';
import 'package:spendsmart/models/receipt.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/utils/network.dart';

class OpenAIService {
  static final _apiKey = dotenv.env['OPEN_AI_API_KEY'] ?? "";
  static final _client = OpenAIClient(apiKey: _apiKey);

  static Future<Receipt> analyzeReceipt(String imageUrl) async {
    final hasConnection = await hasNetwork();

    if (!hasConnection) {
      throw NoNetwork();
    }

    final user = AppState().currentUser.value;

    if (user.isEmpty) {
      throw NoUser();
    }

    final res = await _client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(aiModel),
        messages: [
          ChatCompletionMessage.system(content: receiptAnalyzerSystemPrompt),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.parts([
              ChatCompletionMessageContentPart.image(
                imageUrl: ChatCompletionMessageImageUrl(url: imageUrl),
              ),
            ]),
          ),
        ],
        temperature: 0,
        responseFormat: ResponseFormat.jsonObject(),
      ),
    );

    final jsonObject = jsonDecode(
      res.choices.first.message.content ?? '{"isValid": false}',
    );
    final Receipt receipt = Receipt.fromOpenAIResponse(jsonObject, imageUrl);

    return receipt;
  }

  static Future<String> generateTip(String prompt) async {
    final hasConnection = await hasNetwork();

    if (!hasConnection) {
      throw NoNetwork();
    }

    final user = AppState().currentUser.value;

    if (user.isEmpty) {
      throw NoUser();
    }

    int budgetGoal = user["monthlyBudget"];
    String budgetGoalString = "\nMy MONTHLY budget goal: PHP$budgetGoal\n";

    List<Receipt> recentReceipts = await FirestoreService.getReceipts(
      user["uid"],
      maxLimit: 15,
    );
    String recentReceiptsString = "My recent spending data:\n";

    for (final Receipt receipt in recentReceipts) {
      final mapReceipt = Receipt.toMap(receipt);
      mapReceipt.remove("imageUrl");
      recentReceiptsString += "${json.encode(mapReceipt).trim()}\n";
    }

    String finalUserPrompt = prompt + budgetGoalString;

    if (recentReceipts.isNotEmpty) {
      finalUserPrompt += recentReceiptsString;
    }

    final res = await _client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(aiModel),
        messages: [
          ChatCompletionMessage.system(content: personalizedTipsSystemPrompt),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              finalUserPrompt.trim(),
            ),
          ),
        ],
        responseFormat: ResponseFormat.text(),
      ),
    );

    return res.choices.first.message.content!;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpCenterPage extends StatelessWidget {
  final List<FAQCategory> faqCategories = [
    FAQCategory(
      title: 'Account',
      questions: [
        FAQItem(
          question: 'How do I reset my password?',
          answer: 'Go to Settings > Account > Reset Password.',
        ),
        FAQItem(
          question: 'How do I delete my account?',
          answer: 'Please contact support to request account deletion.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Notifications',
      questions: [
        FAQItem(
          question: 'How do I turn off notifications?',
          answer: 'Go to Settings > Notifications and disable what you need.',
        ),
        FAQItem(
          question: 'Why am I not receiving alerts?',
          answer: 'Ensure app notifications are enabled in your phone settings.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Privacy',
      questions: [
        FAQItem(
          question: 'Is my data secure?',
          answer:
          'Yes, we use industry-standard encryption to keep your data safe.',
        ),
        FAQItem(
          question: 'Can I make my profile private?',
          answer: 'Yes, go to Settings > Privacy and enable Private Mode.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView.builder(
        itemCount: faqCategories.length,
        itemBuilder: (context, index) {
          final category = faqCategories[index];
          return ExpansionTile(
            title: Text(category.title, style: TextStyle(fontWeight: FontWeight.bold)),
            children: category.questions.map((faq) {
              return ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 24.0),
                title: Text(faq.question),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Text(faq.answer),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class FAQCategory {
  final String title;
  final List<FAQItem> questions;

  FAQCategory({required this.title, required this.questions});
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
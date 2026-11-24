import 'package:flutter/material.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  final List<Map<String, String>> _readingPassages = const [
    {
      'title': 'A Day in the Life of Lisa',
      'level': 'Beginner (A1)',
      'content': 'Lisa is 22 years old. She lives in Chicago, USA. She is a student at university. Every morning, she wakes up at 7:00 AM, drinks a cup of coffee, and walks to her classes. She loves learning new languages and meeting friends.',
      'translation': 'လစ်ဆာသည် အသက် ၂၂ နှစ်ရှိပြီ ဖြစ်သည်။ သူမသည် အမေရိကန်နိုင်ငံ၊ ရှီကာโกမြို့တွင် နေထိုင်သည်။ သူမသည် တက္ကသိုလ်ကျောင်းသူတစ်ဦး ဖြစ်သည်။ နံနက်တိုင်း သူမသည် နံနက် ၇ နာရီတွင် ထပြီး ကော်ဖီတစ်ခွက်သောက်ကာ အတန်းများသို့ လမ်းလျှောက်သွားသည်။ သူမသည် ဘာသာစကားအသစ်များသင်ယူရန်နှင့် သူငယ်ချင်းများနှင့်တွေ့ဆုံရသည်ကို နှစ်သက်သည်။'
    },
    {
      'title': 'Traveling the World',
      'level': 'Elementary (A2)',
      'content': 'Traveling is one of the best ways to understand different cultures. When you visit new places, you taste new food, hear new languages, and see beautiful historic landmarks. It opens your mind and builds lifelong memories.',
      'translation': 'ခရီးသွားခြင်းသည် မတူကွဲပြားသော ယဉ်ကျေးမှုများကို နားလည်ရန် အကောင်းဆုံးနည်းလမ်းများထဲမှ တစ်ခုဖြစ်သည်။ နေရာအသစ်များသို့ သွားရောက်လည်ပတ်သည့်အခါ အစားအစာအသစ်များကို မြည်းစမ်းရသည်၊ ဘာသာစကားအသစ်များကို ကြားရသည်၊ သမိုင်းဝင် အထင်ကရနေရာလှလှများကို မြင်တွေ့ရသည်။ ၎င်းက သင်၏စိတ်ကို ဖွင့်ပေးပြီး တစ်သက်တာ အမှတ်တရများကို ဖန်တီးပေးသည်။'
    },
    {
      'title': 'The Benefits of Reading Books',
      'level': 'Intermediate (B1)',
      'content': 'Reading books regularly improves vocabulary, enhances focus, and reduces stress. Whether fiction or non-fiction, books transport readers to different worlds and expand knowledge across diverse topics.',
      'translation': 'စာအုပ်များကို ပုံမှန်ဖတ်ရှုခြင်းသည် ဝေါဟာရကြွယ်ဝစေခြင်း၊ အာရုံစူးစိုက်မှုကို တိုးတက်စေခြင်းနှင့် စိတ်ဖိစီးမှုကို လျော့ပါးစေခြင်းတို့ကို ဖြစ်စေသည်။ ဝတ္ထုဖြစ်စေ၊ သုတစာပေဖြစ်စေ စာအုပ်များသည် စာဖတ်သူများကို ကမ္ဘာသစ်များသို့ ပို့ဆောင်ပေးပြီး ခေါင်းစဉ်အမျိုးမျိုးအပေါ် ဗဟုသုတများကို ကျယ်ပြန့်စေသည်။'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _readingPassages.length,
        itemBuilder: (context, index) {
          final passage = _readingPassages[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          passage['title']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Chip(
                        label: Text(passage['level']!),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    passage['content']!,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Myanmar Translation · မြန်မာဘာသာပြန်', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          passage['translation']!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

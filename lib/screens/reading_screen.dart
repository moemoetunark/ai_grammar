import 'package:flutter/material.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  final List<Map<String, String>> _readingPassages = const [
    {
      'title': 'A Day in the Life of Lisa',
      'level': 'Beginner (A1)',
      'gradient': '0xFF6366F1',
      'content':
          'Lisa is 22 years old. She lives in Chicago, USA. She is a student at university. Every morning, she wakes up at 7:00 AM, drinks a cup of coffee, and walks to her classes. She loves learning new languages and meeting friends.',
      'translation':
          'လစ်ဆာသည် အသက် ၂၂ နှစ်ရှိပြီ ဖြစ်သည်။ သူမသည် အမေရိကန်နိုင်ငံ၊ ရှီကာဂိုမြို့တွင် နေထိုင်သည်။ သူမသည် တက္ကသိုလ်ကျောင်းသူတစ်ဦး ဖြစ်သည်။ နံနက်တိုင်း သူမသည် နံနက် ၇ နာရီတွင် ထပြီး ကော်ဖီတစ်ခွက်သောက်ကာ အတန်းများသို့ လမ်းလျှောက်သွားသည်။ သူမသည် ဘာသာစကားအသစ်များသင်ယူရန်နှင့် သူငယ်ချင်းများနှင့်တွေ့ဆုံရသည်ကို နှစ်သက်သည်။'
    },
    {
      'title': 'Traveling the World',
      'level': 'Elementary (A2)',
      'gradient': '0xFF0EA5E9',
      'content':
          'Traveling is one of the best ways to understand different cultures. When you visit new places, you taste new food, hear new languages, and see beautiful historic landmarks. It opens your mind and builds lifelong memories.',
      'translation':
          'ခရီးသွားခြင်းသည် မတူကွဲပြားသော ယဉ်ကျေးမှုများကို နားလည်ရန် အကောင်းဆုံးနည်းလမ်းများထဲမှ တစ်ခုဖြစ်သည်။ နေရာအသစ်များသို့ သွားရောက်လည်ပတ်သည့်အခါ အစားအစာအသစ်များကို မြည်းစမ်းရသည်၊ ဘာသာစကားအသစ်များကို ကြားရသည်၊ သမိုင်းဝင် အထင်ကရနေရာလှလှများကို မြင်တွေ့ရသည်။ ၎င်းက သင်၏စိတ်ကို ဖွင့်ပေးပြီး တစ်သက်တာ အမှတ်တရများကို ဖန်တီးပေးသည်။'
    },
    {
      'title': 'The Benefits of Reading Books',
      'level': 'Intermediate (B1)',
      'gradient': '0xFFF59E0B',
      'content':
          'Reading books regularly improves vocabulary, enhances focus, and reduces stress. Whether fiction or non-fiction, books transport readers to different worlds and expand knowledge across diverse topics.',
      'translation':
          'စာအုပ်များကို ပုံမှန်ဖတ်ရှုခြင်းသည် ဝေါဟာရကြွယ်ဝစေခြင်း၊ အာရုံစူးစိုက်မှုကို တိုးတက်စေခြင်းနှင့် စိတ်ဖိစီးမှုကို လျော့ပါးစေခြင်းတို့ကို ဖြစ်စေသည်။ ဝတ္ထုဖြစ်စေ၊ သုတစာပေဖြစ်စေ စာအုပ်များသည် စာဖတ်သူများကို ကမ္ဘာသစ်များသို့ ပို့ဆောင်ပေးပြီး ခေါင်းစဉ်အမျိုးမျိုးအပေါ် ဗဟုသုတများကို ကျယ်ပြန့်စေသည်။'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _readingPassages.length,
        itemBuilder: (context, index) {
          final passage = _readingPassages[index];
          final colorVal = int.parse(passage['gradient']!);
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          passage['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(colorVal).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          passage['level']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(colorVal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    passage['content']!,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.black.withValues(alpha: 0.04)),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Myanmar Translation · မြန်မာဘာသာပြန်',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF475569),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            passage['translation']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
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

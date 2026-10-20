import 'package:flutter/material.dart';

class Phrase {
  final String text;
  final IconData icon;
  const Phrase(this.text, this.icon);
}

class Category {
  final String name;
  final IconData icon;
  final Color color;
  final List<Phrase> phrases;
  const Category(this.name, this.icon, this.color, this.phrases);
}

const categories = <Category>[
  Category('أساسيات', Icons.chat_bubble, Color(0xFF00796B), [
    Phrase('نعم', Icons.check_circle),
    Phrase('لا', Icons.cancel),
    Phrase('شكرًا لك', Icons.favorite),
    Phrase('من فضلك', Icons.volunteer_activism),
    Phrase('لم أفهم', Icons.help_outline),
    Phrase('أعد من فضلك', Icons.replay),
    Phrase('تحدث ببطء', Icons.slow_motion_video),
    Phrase('أنا أصم ولا أسمعك، اكتب لي من فضلك', Icons.hearing_disabled),
    Phrase('أنا لا أستطيع الكلام', Icons.voice_over_off),
    Phrase('انتظر قليلًا', Icons.hourglass_top),
  ]),
  Category('طوارئ', Icons.sos, Color(0xFFC62828), [
    Phrase('أحتاج مساعدة عاجلة', Icons.sos),
    Phrase('اتصل بالإسعاف', Icons.emergency),
    Phrase('اتصل بالشرطة', Icons.local_police),
    Phrase('أحتاج طبيبًا', Icons.local_hospital),
    Phrase('أشعر بألم شديد', Icons.sentiment_very_dissatisfied),
    Phrase('أنا تائه', Icons.wrong_location),
    Phrase('هناك حريق', Icons.local_fire_department),
  ]),
  Category('صحة', Icons.medical_services, Color(0xFF1565C0), [
    Phrase('أين أقرب صيدلية؟', Icons.local_pharmacy),
    Phrase('أحتاج دواءً', Icons.medication),
    Phrase('عندي حساسية', Icons.warning_amber),
    Phrase('رأسي يؤلمني', Icons.psychology_alt),
    Phrase('بطني يؤلمني', Icons.sick),
    Phrase('أحتاج إلى مترجم لغة إشارة', Icons.sign_language),
  ]),
  Category('طعام', Icons.restaurant, Color(0xFFEF6C00), [
    Phrase('أريد ماءً', Icons.water_drop),
    Phrase('أنا جائع', Icons.restaurant),
    Phrase('أريد قهوة أو شايًا', Icons.coffee),
    Phrase('الحساب من فضلك', Icons.receipt_long),
    Phrase('أين دورة المياه؟', Icons.wc),
  ]),
  Category('تنقل وتسوق', Icons.directions_bus, Color(0xFF6A1B9A), [
    Phrase('أين المحطة؟', Icons.directions_bus),
    Phrase('أريد سيارة أجرة', Icons.local_taxi),
    Phrase('كم السعر؟', Icons.price_check),
    Phrase('أريد الدفع بالبطاقة', Icons.credit_card),
    Phrase('أين المخرج؟', Icons.exit_to_app),
    Phrase('هل يمكنك مساعدتي؟', Icons.support_agent),
  ]),
];

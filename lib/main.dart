import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'phrases.dart';
import 'speaker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Speaker.init();
  runApp(const TawasalApp());
}

class TawasalApp extends StatelessWidget {
  const TawasalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'تواصل معي',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
            useMaterial3: true, colorSchemeSeed: const Color(0xFF00796B)),
        home: const Home(),
      );
}

/// ينطق النص، وإن لم يتوفر الصوت يعرضه بخط كبير ليقرأه الطرف الآخر.
Future<void> say(BuildContext context, String text) async {
  final ok = await Speaker.speak(text);
  if (!ok && context.mounted) showFull(context, text);
}

void showFull(BuildContext context, String text) => Navigator.push(
    context, MaterialPageRoute(builder: (_) => FullText(text)));

class FullText extends StatelessWidget {
  final String text;
  const FullText(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: SafeArea(
            child: Column(children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            height: 1.4,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('المس الشاشة للإغلاق',
                    style: TextStyle(color: Colors.white54)),
              ),
            ]),
          ),
        ),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تواصل معي'), centerTitle: true),
        body: IndexedStack(
            index: i, children: const [PhrasesTab(), TypeTab(), EmergencyTab()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.grid_view), label: 'عبارات'),
            NavigationDestination(icon: Icon(Icons.keyboard), label: 'اكتب'),
            NavigationDestination(icon: Icon(Icons.sos), label: 'طوارئ'),
          ],
        ),
      );
}

class PhrasesTab extends StatefulWidget {
  const PhrasesTab({super.key});
  @override
  State<PhrasesTab> createState() => _PhrasesTabState();
}

class _PhrasesTabState extends State<PhrasesTab> {
  int sel = 0;
  @override
  Widget build(BuildContext context) {
    final cat = categories[sel];
    return Column(children: [
      SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(10),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, k) => ChoiceChip(
            avatar: Icon(categories[k].icon, size: 18),
            label: Text(categories[k].name),
            selected: sel == k,
            onSelected: (_) => setState(() => sel = k),
          ),
        ),
      ),
      Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(12),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
          children: [
            for (final p in cat.phrases)
              Material(
                color: cat.color.withAlpha(32),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => say(context, p.text),
                  onLongPress: () => showFull(context, p.text),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(p.icon, size: 52, color: cat.color),
                          const SizedBox(height: 8),
                          Text(p.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                        ]),
                  ),
                ),
              ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 6),
        child: Text('اضغط للنطق • اضغط مطولًا للعرض بالشاشة الكاملة',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    ]);
  }
}

class TypeTab extends StatefulWidget {
  const TypeTab({super.key});
  @override
  State<TypeTab> createState() => _TypeTabState();
}

class _TypeTabState extends State<TypeTab> {
  final ctrl = TextEditingController();
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
        (p) => setState(() => history = p.getStringList('history') ?? []));
  }

  Future<void> remember(String t) async {
    history
      ..remove(t)
      ..insert(0, t);
    if (history.length > 20) history.removeLast();
    final p = await SharedPreferences.getInstance();
    await p.setStringList('history', history);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = ctrl.text.trim();
    return ListView(padding: const EdgeInsets.all(16), children: [
      TextField(
        controller: ctrl,
        minLines: 3,
        maxLines: 6,
        style: const TextStyle(fontSize: 22),
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
            hintText: 'اكتب ما تريد قوله...', border: OutlineInputBorder()),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: t.isEmpty
                ? null
                : () {
                    remember(t);
                    say(context, t);
                  },
            icon: const Icon(Icons.volume_up),
            label: const Text('تحدث'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: t.isEmpty
                ? null
                : () {
                    remember(t);
                    showFull(context, t);
                  },
            icon: const Icon(Icons.fullscreen),
            label: const Text('عرض'),
          ),
        ),
      ]),
      if (history.isNotEmpty) ...[
        const SizedBox(height: 20),
        const Text('الأخيرة', style: TextStyle(fontWeight: FontWeight.bold)),
        for (final h in history)
          ListTile(
            title: Text(h),
            leading: const Icon(Icons.history),
            onTap: () => setState(() => ctrl.text = h),
          ),
      ],
    ]);
  }
}

class EmergencyTab extends StatefulWidget {
  const EmergencyTab({super.key});
  @override
  State<EmergencyTab> createState() => _EmergencyTabState();
}

class _EmergencyTabState extends State<EmergencyTab> {
  final name = TextEditingController();
  final medical = TextEditingController();
  final contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      name.text = p.getString('name') ?? '';
      medical.text = p.getString('medical') ?? '';
      contact.text = p.getString('contact') ?? '';
    });
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('name', name.text);
    await p.setString('medical', medical.text);
    await p.setString('contact', contact.text);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم الحفظ على الجهاز')));
    }
  }

  String card() {
    final parts = <String>[
      if (name.text.trim().isNotEmpty) 'اسمي ${name.text.trim()}.',
      'أنا أصم ولا أستطيع الكلام.',
      if (medical.text.trim().isNotEmpty) '${medical.text.trim()}.',
      if (contact.text.trim().isNotEmpty)
        'للتواصل مع قريبي: ${contact.text.trim()}.',
    ];
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(16), children: [
        SizedBox(
          height: 90,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => showFull(context, 'أحتاج مساعدة عاجلة'),
            icon: const Icon(Icons.sos, size: 36),
            label: const Text('أحتاج مساعدة عاجلة',
                style: TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 20),
        const Text('بطاقتي الطبية والتعريفية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
            controller: name,
            decoration: const InputDecoration(
                labelText: 'الاسم', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(
            controller: medical,
            maxLines: 2,
            decoration: const InputDecoration(
                labelText: 'ملاحظات طبية (حساسية، أدوية...)',
                border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(
            controller: contact,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                labelText: 'رقم قريب للتواصل',
                border: OutlineInputBorder())),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: FilledButton(onPressed: save, child: const Text('حفظ'))),
          const SizedBox(width: 8),
          Expanded(
              child: OutlinedButton(
                  onPressed: () => showFull(context, card()),
                  child: const Text('عرض البطاقة'))),
          const SizedBox(width: 8),
          Expanded(
              child: OutlinedButton(
                  onPressed: () => say(context, card()),
                  child: const Text('نطق'))),
        ]),
      ]);
}
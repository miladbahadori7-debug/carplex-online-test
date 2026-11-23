import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

const systems = [
  'ماکس فاز صفر', 'مالتی‌پلکس فرانسه', 'مالتی‌پلکس سازه پویش',
  'مالتی‌پلکس اکوماکس کروز', 'مالتی‌پلکس SMS', 'تک‌نود کروز',
  'تک‌نود سازه پویش', 'سیستم هوشمند CEC', 'مالتی‌پلکس سایپا',
];
const titles = ['معرفی', 'عیب‌یابی', 'نقشه‌ها', 'عیوب شایع', 'تعمیر نود'];
const icons = [Icons.info_outline, Icons.search, Icons.map_outlined,
  Icons.warning_amber, Icons.build_outlined];
const gold = Color(0xFFFFCD65);
const frenchDiagnostics = [
  'استارت', 'برف‌پاک‌کن عقب', 'چراغ ترمز', 'چراغ دنده عقب (گیربکس دستی)',
  'نور پایین', 'نور بالا', 'گرم‌کن شیشه عقب',
  'شیشه‌بالابر عقب', 'قفل مرکزی', 'کولر', 'راهنما و فلاشر',
  'شیشه‌بالابر جلو', 'چراغ کوچک', 'مه‌شکن عقب',
  'فن خنک‌کننده J34 و J35', 'مه‌شکن جلو',
  'فن خنک‌کننده S2000 و Bosch ME744', 'برف‌پاک‌کن جلو', 'شیشه‌شور', 'بوق',
  'شناور داخل باک',
];

void main() => runApp(MaterialApp(
  locale: const Locale('fa'), supportedLocales: const [Locale('fa')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  title: 'کارپلکس', debugShowCheckedModeBanner: false,
  theme: ThemeData(fontFamily: 'BTitr', colorScheme: ColorScheme.fromSeed(seedColor: gold,
    brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xFF111318)),
  builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
  home: const Home(),
));

class Home extends StatelessWidget {
  const Home({super.key});
  void openSystem(BuildContext context, String system) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => Details(system: system),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF6F7FA),
    appBar: AppBar(title: const Text('خانه'), centerTitle: true,
      backgroundColor: const Color(0xFFFFD32A), foregroundColor: const Color(0xFF292000)),
    drawer: Drawer(child: SafeArea(child: ListView(children: [
      const ListTile(leading: Icon(Icons.bolt, color: gold), title: Text('کارپلکس')),
      for (final system in systems) ListTile(title: Text(system), onTap: () {
        Navigator.of(context).pop();
        openSystem(context, system);
      }),
    ]))),
    body: CustomScrollView(slivers: [
      const SliverToBoxAdapter(child: HomeSlides()),
      SliverPadding(padding: const EdgeInsets.all(14), sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 142),
        itemCount: systems.length,
        itemBuilder: (context, i) => Card(color: Colors.white, surfaceTintColor: Colors.transparent,
          elevation: 2, margin: EdgeInsets.zero, clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(onTap: () => openSystem(context, systems[i]),
            child: Padding(padding: const EdgeInsets.all(8), child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(radius: 25, backgroundColor: const Color(0xFF103B67),
                  foregroundColor: const Color(0xFF82DCFF), child: Icon([
                    Icons.directions_car, Icons.electric_car, Icons.memory,
                    Icons.bolt, Icons.hub, Icons.speed, Icons.developer_board,
                    Icons.settings, Icons.directions_car_filled,
                  ][i])),
                const SizedBox(height: 8),
                Flexible(child: Text(systems[i], textAlign: TextAlign.center,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF8A5C00), fontWeight: FontWeight.bold))),
              ],
            )),
          ),
        ),
      )),
    ]),
  );
}

class Details extends StatelessWidget {
  const Details({required this.system, super.key});
  final String system;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF6F7FA),
    appBar: AppBar(title: Text(system), centerTitle: true,
      backgroundColor: const Color(0xFFFFD32A), foregroundColor: const Color(0xFF292000)),
    body: SafeArea(child: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: titles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => Card(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          minTileHeight: 72,
          leading: CircleAvatar(backgroundColor: const Color(0xFF103B67),
            foregroundColor: Colors.white, child: Icon(icons[i])),
          title: Text(titles[i], style: const TextStyle(
            color: Color(0xFF292000), fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_left, color: Color(0xFF8A5C00)),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => SectionPage(system: system, title: titles[i]),
          )),
        ),
      ),
    )),
  );
}

class SectionPage extends StatefulWidget {
  const SectionPage({required this.system, required this.title, super.key});
  final String system;
  final String title;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late Future<Map<String, dynamic>> content;

  @override
  void initState() {
    super.initState();
    content = load();
  }

  Future<Map<String, dynamic>> load() async {
    const base = String.fromEnvironment('CARPLEX_API');
    if (base.isEmpty) throw StateError('Missing CARPLEX_API');
    final root = Uri.parse(base.endsWith('/') ? base : '$base/');
    final system = systems.indexOf(widget.system);
    final section = titles.indexOf(widget.title);
    final staticSite = root.host.endsWith('.github.io');
    final uri = staticSite
      ? root.resolve('content/$system/$section.json')
      : root.resolve('/api/content').replace(queryParameters: {
          'system': '$system', 'section': '$section',
        });
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      final result = await request.close().timeout(const Duration(seconds: 12));
      if (staticSite && result.statusCode == 404) return {};
      if (result.statusCode != 200) throw HttpException('Request failed');
      final text = await result.transform(utf8.decoder).join().timeout(const Duration(seconds: 15));
      return jsonDecode(text) as Map<String, dynamic>;
    } finally {
      client.close(force: true);
    }
  }

  void refresh() => setState(() => content = load());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title), actions: [
      IconButton(onPressed: refresh, icon: const Icon(Icons.refresh), tooltip: 'دریافت دوباره'),
    ]),
    body: FutureBuilder<Map<String, dynamic>>(
      future: content,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(
            const String.fromEnvironment('CARPLEX_API') == ''
              ? 'آدرس سرور در تنظیمات ساخت APK وارد نشده است.'
              : 'ارتباط با سایت برقرار نشد. اینترنت گوشی را بررسی کن و دوباره بزن.',
            textAlign: TextAlign.center,
          )));
        }
        final data = snapshot.data!;
        if (widget.system == systems[1] && widget.title == titles[1]) {
          final published = data['articles'] is List
            ? (data['articles'] as List).whereType<Map<String, dynamic>>().toList()
            : <Map<String, dynamic>>[if (data.isNotEmpty) data];
          final byTitle = {for (final row in published) (row['title'] as String).trim(): row};
          final rows = <Map<String, dynamic>>[
            for (final title in frenchDiagnostics) byTitle[title] ?? {'title': title},
            for (final entry in byTitle.entries)
              if (!frenchDiagnostics.contains(entry.key)) entry.value,
          ];
          if (rows.isEmpty) return const Center(child: Text('هنوز مطلبی منتشر نشده است.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16), itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => Card(child: ListTile(
              title: Text(rows[i]['title'] as String),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => Scaffold(appBar: AppBar(title: Text(rows[i]['title'] as String)),
                  body: rows[i]['body'] is String
                    ? ArticleView(data: rows[i], system: widget.system)
                    : const Center(child: Text('هنوز مطلبی منتشر نشده است.'))),
              )),
            )),
          );
        }
        if (data.isEmpty) return const Center(child: Text('هنوز مطلبی منتشر نشده است.'));
        return ArticleView(data: data, system: widget.system);
      },
    ),
  );
}

class ArticleView extends StatelessWidget {
  const ArticleView({required this.data, required this.system});
  final Map<String, dynamic> data;
  final String system;
  @override
  Widget build(BuildContext context) {
    final image = data['image'] as String? ?? '';
    return ListView(padding: const EdgeInsets.all(16), children: [
          Text(system),
          const SizedBox(height: 12),
          if ((data['title'] as String).isNotEmpty)
            Text(data['title'] as String, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final block in (data['body'] as String).split(RegExp(r'\n\s*\n')))
            if (block.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  block.trim().startsWith('## ') ? block.trim().substring(3) : block.trim(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                  style: block.trim().startsWith('## ')
                    ? const TextStyle(fontSize: 22, color: Color(0xFF82DCFF), height: 1.5)
                    : const TextStyle(fontSize: 16, height: 1.8),
                ),
              ),
          if (image.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 16),
            child: InteractiveViewer(child: Image.memory(base64Decode(image),
              errorBuilder: (_, __, ___) => const Text('عکس قابل نمایش نیست.')))),
        ]);
  }
}

class HomeSlides extends StatefulWidget {
  const HomeSlides({super.key});
  @override
  State<HomeSlides> createState() => _HomeSlidesState();
}

class _HomeSlidesState extends State<HomeSlides> {
  int index = 0;
  late final Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) setState(() => index = (index + 1) % 3);
    });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 9,
    child: ColoredBox(color: const Color(0xFF103B67), child: Column(children: [
      Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 450),
        child: Image.asset('assets/slide$index.webp', key: ValueKey(index),
          fit: BoxFit.contain))),
      const Text('کارپلکس', style: TextStyle(color: Colors.white, fontSize: 22)),
      const SizedBox(height: 6),
    ])),
  );
}

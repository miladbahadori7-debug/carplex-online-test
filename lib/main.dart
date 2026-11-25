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

const diagnosticIcons = <IconData>[
  Icons.bolt, Icons.wash, Icons.stop_circle_outlined, Icons.keyboard_return,
  Icons.south_east, Icons.east, Icons.waves, Icons.arrow_upward,
  Icons.lock_outline, Icons.ac_unit, Icons.swap_horiz, Icons.swap_vert,
  Icons.lightbulb_outline, Icons.blur_on, Icons.air, Icons.foggy,
  Icons.toys, Icons.cleaning_services, Icons.water_drop_outlined,
  Icons.campaign_outlined, Icons.local_gas_station_outlined,
];

class PartSketch extends CustomPainter {
  const PartSketch(this.index, this.color);
  final int index;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);
    final p = Paint()..color = color..style = PaintingStyle.stroke
      ..strokeWidth = 1.8..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    void line(double x, double y, double a, double b) =>
      canvas.drawLine(Offset(x, y), Offset(a, b), p);
    void box(double x, double y, double w, double h) => canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), const Radius.circular(2)), p);
    if (index == 0) {
      box(3, 14, 17, 11); box(7, 8, 12, 6); box(20, 16, 5, 7);
      line(25, 19.5, 29, 19.5); line(29, 17, 29, 22);
      line(7, 8, 7, 5); line(6, 24, 6, 15);
    } else if (index == 1 || index == 17) {
      final windshield = Path()..moveTo(3, 24)..lineTo(6, 10)
        ..quadraticBezierTo(16, 5, 26, 10)..lineTo(29, 24)..close();
      canvas.drawPath(windshield, p);
      line(16, 24, index == 1 ? 12 : 20, 16);
      line(9, 18, 23, 14);
      if (index == 17) line(9, 23, 12, 19);
    } else if (index == 2 || index == 3) {
      box(4, 11, 24, 11);
      line(16, 11, 16, 22);
      if (index == 2) {
        line(8, 15, 12, 15); line(8, 18, 12, 18);
        line(20, 15, 24, 15); line(20, 18, 24, 18);
      } else {
        line(10, 16, 23, 16); line(10, 16, 13, 13); line(10, 16, 13, 19);
      }
    }
  }
  @override
  bool shouldRepaint(covariant PartSketch oldDelegate) =>
    index != oldDelegate.index || color != oldDelegate.color;
}

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
    appBar: AppBar(title: const Text('Carplex', style: TextStyle(
      fontFamily: 'Roboto', fontWeight: FontWeight.w800, letterSpacing: 1.2)), centerTitle: true,
      backgroundColor: const Color(0xFFFFD32A), foregroundColor: const Color(0xFF292000)),
    drawer: Drawer(
      backgroundColor: const Color(0xFFF0F6FC),
      surfaceTintColor: Colors.transparent,
      child: SafeArea(child: ListView(padding: const EdgeInsets.all(12), children: [
        Card(color: const Color(0xFF103B67), child: ListTile(
          leading: const Icon(Icons.bolt, color: gold),
          title: const Text('کارپلکس', style: TextStyle(color: Colors.white)),
        )),
        const SizedBox(height: 8),
        for (final system in systems) Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: ListTile(
            tileColor: Colors.white,
            textColor: const Color(0xFF182D44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(system), onTap: () {
              Navigator.of(context).pop();
              openSystem(context, system);
            },
          ),
        ),
      ])),
    ),
    body: SafeArea(top: false, child: CustomScrollView(slivers: [
      const SliverToBoxAdapter(child: HomeSlides()),
      SliverPadding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 28), sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
          mainAxisExtent: 122.0 + MediaQuery.textScalerOf(context).scale(40)),
        itemCount: systems.length,
        itemBuilder: (context, i) => SystemCard(index: i,
          onTap: () => openSystem(context, systems[i])),
      )),
    ])),
  );
}

class SystemCard extends StatelessWidget {
  const SystemCard({required this.index, required this.onTap});
  final int index;
  final VoidCallback onTap;

  static const marks = <(String, IconData, Color)>[
    ('MUX 0', Icons.directions_car_outlined, Color(0xFF264E88)),
    ('FR', Icons.electric_car, Color(0xFF275F91)),
    ('SP', Icons.memory, Color(0xFF11665C)),
    ('ECOMAX', Icons.bolt, Color(0xFF8B4B14)),
    ('SMS', Icons.hub, Color(0xFF674198)),
    ('CRUISE', Icons.speed, Color(0xFF973C59)),
    ('SP 1', Icons.developer_board, Color(0xFF32643C)),
    ('CEC', Icons.settings_input_component, Color(0xFF3D4D91)),
    ('SAIPA', Icons.directions_car_filled, Color(0xFF9C442E)),
  ];

  @override
  Widget build(BuildContext context) {
    final (mark, icon, accent) = marks[index];
    return Card(
      color: Colors.white, surfaceTintColor: Colors.transparent,
      elevation: 1, shadowColor: accent.withAlpha(55), margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21),
        side: BorderSide(color: accent.withAlpha(46))),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [accent.withAlpha(22), Colors.white])),
        child: InkWell(onTap: onTap, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ExcludeSemantics(child: Container(
              width: 72, height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                gradient: LinearGradient(begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, Color.lerp(accent, Colors.black, .32)!]),
                border: Border.all(color: Colors.white.withAlpha(165)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icon, size: 28, color: Colors.white),
                const SizedBox(height: 3),
                SizedBox(width: 63, height: 15, child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(mark, textDirection: TextDirection.ltr,
                    style: const TextStyle(fontFamily: 'Roboto', fontSize: 10,
                      letterSpacing: 1, fontWeight: FontWeight.w800, color: Colors.white)),
                )),
              ]),
            )),
            const SizedBox(height: 9),
            Flexible(child: Text(systems[index], textAlign: TextAlign.center,
              maxLines: 3, overflow: TextOverflow.ellipsis,
              style: TextStyle(inherit: false, fontFamily: 'sans-serif',
                fontSize: 15, height: 1.35, fontWeight: FontWeight.w700,
                color: Color.lerp(accent, const Color(0xFF172438), .55)))),
          ]),
        )),
      ),
    );
  }
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

  bool get isFrenchDiagnostics => widget.system == systems[1] && widget.title == titles[1];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: isFrenchDiagnostics ? const Color(0xFFF0F6FC) : null,
    appBar: AppBar(title: Text(widget.title),
      backgroundColor: isFrenchDiagnostics ? const Color(0xFFFFDA55) : null,
      foregroundColor: isFrenchDiagnostics ? const Color(0xFF182D44) : null,
      actions: [
      IconButton(onPressed: refresh, icon: const Icon(Icons.refresh), tooltip: 'دریافت دوباره'),
    ]),
    body: SafeArea(top: false, child: FutureBuilder<Map<String, dynamic>>(
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
        if (isFrenchDiagnostics) {
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final title = rows[i]['title'] as String;
              final index = frenchDiagnostics.indexOf(title);
              const accents = [Color(0xFF125CA8), Color(0xFF006D65),
                Color(0xFF9D3744), Color(0xFF67419A), Color(0xFF805200)];
              final accent = accents[i % accents.length];
              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFD8E6F4))),
                child: ListTile(
                  minTileHeight: 68,
                  leading: Container(
                    width: 46, height: 46, alignment: Alignment.center,
                    decoration: BoxDecoration(color: accent.withAlpha(24),
                      borderRadius: BorderRadius.circular(12)),
                    child: index == 0 || index == 1 || index == 2 || index == 3 || index == 17
                      ? CustomPaint(size: const Size.square(30), painter: PartSketch(index, accent))
                      : Icon(index < 0 ? Icons.build_outlined : diagnosticIcons[index], color: accent),
                  ),
                  title: Text(title, style: const TextStyle(color: Color(0xFF182D44),
                    fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.chevron_left, color: accent),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => Scaffold(appBar: AppBar(title: Text(title)),
                      body: SafeArea(top: false, child: rows[i]['body'] is String
                        ? ArticleView(data: rows[i], system: widget.system, section: widget.title)
                        : const Center(child: Text('هنوز مطلبی منتشر نشده است.')))),
                  )),
                ),
              );
            },
          );
        }
        if (data.isEmpty) return const Center(child: Text('هنوز مطلبی منتشر نشده است.'));
        return ArticleView(data: data, system: widget.system, section: widget.title);
      },
    )),
  );
}

class ArticleView extends StatelessWidget {
  const ArticleView({required this.data, required this.system, required this.section});
  final Map<String, dynamic> data;
  final String system;
  final String section;
  @override
  Widget build(BuildContext context) {
    final image = data['image'] as String? ?? '';
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final palette = dark
        ? const [Color(0xFFF3CE82), Color(0xFF87DEC8), Color(0xFFCDBAF9)]
        : const [Color(0xFF765000), Color(0xFF006452), Color(0xFF614097)];
    final index = titles.indexOf(section);
    final accent = palette[(index < 0 ? 0 : index) % palette.length];
    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: accent.withAlpha(22),
              border: Border.all(color: accent.withAlpha(65)),
              borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(system, style: theme.textTheme.labelLarge?.copyWith(color: accent)),
              if ((data['title'] as String).isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(data['title'] as String, style: theme.textTheme.titleLarge?.copyWith(height: 1.4)),
              ],
            ]),
          ),
          const SizedBox(height: 18),
          for (final block in (data['body'] as String).split(RegExp(r'\n\s*\n')))
            if (block.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: block.trim().startsWith('## ')
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: accent.withAlpha(16),
                        border: Border(right: BorderSide(color: accent, width: 3))),
                      child: Text(block.trim().substring(3), textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, color: accent, height: 1.5)),
                    )
                  : Text(block.trim(), textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, height: 1.85, color: theme.colorScheme.onSurface)),
              ),
          if (image.isNotEmpty) Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE3F4FF), gold]),
                borderRadius: BorderRadius.circular(17),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(child: _articleImage(image)),
              ),
            ),
          ),
        ]);
  }
}

Widget _articleImage(String source) {
  const fallback = ColoredBox(
    color: Colors.white,
    child: Text('عکس قابل نمایش نیست.',
      style: TextStyle(color: Color(0xFF182D44))),
  );
  final value = source.trim();
  final uri = Uri.tryParse(value);
  if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty) {
    return Image.network(value, width: double.infinity, fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback);
  }
  try {
    return Image.memory(base64Decode(value), width: double.infinity, fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback);
  } on FormatException {
    return fallback;
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
    child: ClipRect(child: ColoredBox(
      color: const Color(0xFF103B67),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        layoutBuilder: (current, previous) => Stack(fit: StackFit.expand, children: [
          ...previous,
          if (current != null) current,
        ]),
        child: Image.asset('assets/slide$index.webp', key: ValueKey(index),
          fit: BoxFit.cover),
      ),
    )),
  );
}

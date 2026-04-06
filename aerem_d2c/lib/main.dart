// Aerem Solar D2C App — Complete Flutter Conversion
// Single-file format for FlutLab.io
// Run with: flutter run

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

// ─────────────────────────────────────────────
// MAIN ENTRY
// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AeremApp());
}

class AeremApp extends StatelessWidget {
  const AeremApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerem Solar D2C',
      debugShowCheckedModeBanner: false,
      theme: AeremTheme.data,
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// THEME & COLORS
// ─────────────────────────────────────────────
class C {
  static const orange = Color(0xFFF97316);
  static const orangeLt = Color(0xFFFFF7ED);
  static const orangeDk = Color(0xFFEA580C);
  static const black = Color(0xFF1A1A1A);
  static const white = Color(0xFFFFFFFF);
  static const g50 = Color(0xFFFAFAFA);
  static const g100 = Color(0xFFF5F5F5);
  static const g200 = Color(0xFFE5E5E5);
  static const g300 = Color(0xFFD4D4D4);
  static const g500 = Color(0xFF737373);
  static const g900 = Color(0xFF171717);
  static const green = Color(0xFF22C55E);
  static const greenLt = Color(0xFFD1FAE5);
  static const amber = Color(0xFFF59E0B);
  static const amberLt = Color(0xFFFEF3C7);
  static const red = Color(0xFFEF4444);
  static const redLt = Color(0xFFFEE2E2);
}

class AeremTheme {
  static ThemeData get data => ThemeData(
        fontFamily: '.SF Pro Text',
        scaffoldBackgroundColor: C.white,
        colorScheme: ColorScheme.light(
          primary: C.orange,
          secondary: C.orangeDk,
          surface: C.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: C.white,
          foregroundColor: C.black,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.orange, fontFamily: '.SF Pro Text'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: C.orange,
            foregroundColor: C.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: C.orange,
            side: const BorderSide(color: C.orange, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: C.orange),
        ),
      );
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────
String fmt(num n) => '₹${n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(\d)(?!\d))'), (m) => '${m[1]},')}';

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [const Icon(Icons.check_circle, color: C.white, size: 16), const SizedBox(width: 8), Flexible(child: Text(msg))]),
    backgroundColor: C.g900,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    margin: const EdgeInsets.only(bottom: 20, left: 32, right: 32),
    duration: const Duration(seconds: 2),
  ));
}

Widget starsRow(double r, {double size = 11}) {
  return Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) {
    if (i < r.floor()) return Icon(Icons.star, size: size, color: C.amber);
    if (i < r) return Icon(Icons.star_half, size: size, color: C.amber);
    return Icon(Icons.star_border, size: size, color: C.g300);
  }));
}

Widget sectionHeader(String title, {IconData? icon, String? action, VoidCallback? onAction}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      if (icon != null) ...[Icon(icon, size: 18, color: C.orange), const SizedBox(width: 6)],
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      const Spacer(),
      if (action != null) GestureDetector(onTap: onAction, child: Text(action, style: const TextStyle(fontSize: 12, color: C.orange, fontWeight: FontWeight.w600))),
    ]),
  );
}

Widget cardWidget({required Widget child, Color? color, Color? borderColor, EdgeInsets? padding, double? borderLeft}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color ?? C.white,
      borderRadius: BorderRadius.circular(12),
      border: borderLeft != null
          ? Border(left: BorderSide(color: borderColor ?? C.green, width: borderLeft))
          : Border.all(color: borderColor ?? C.g200),
    ),
    child: child,
  );
}

Widget badge(String text, {Color bg = C.greenLt, Color fg = const Color(0xFF065F46), IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, size: 10, color: fg), const SizedBox(width: 4)],
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    ]),
  );
}

Widget progressBar(double pct, {Color? color, double height = 8}) {
  return Container(
    height: height,
    decoration: BoxDecoration(color: C.g200, borderRadius: BorderRadius.circular(999)),
    child: FractionallySizedBox(
      widthFactor: pct.clamp(0, 1),
      alignment: Alignment.centerLeft,
      child: Container(decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color ?? C.orange, color?.withOpacity(0.8) ?? C.orangeDk]),
        borderRadius: BorderRadius.circular(999),
      )),
    ),
  );
}

Widget btnPrimary(String label, {IconData? icon, VoidCallback? onTap, bool small = false, bool disabled = false}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: disabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? C.g300 : C.orange,
        padding: EdgeInsets.symmetric(vertical: small ? 8 : 12, horizontal: small ? 16 : 20),
        textStyle: TextStyle(fontSize: small ? 12 : 14, fontWeight: FontWeight.w600),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: small ? 14 : 18), const SizedBox(width: 8)],
        Text(label),
      ]),
    ),
  );
}

Widget btnSecondary(String label, {IconData? icon, VoidCallback? onTap, bool small = false}) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: C.black,
        side: const BorderSide(color: C.g300, width: 1.5),
        padding: EdgeInsets.symmetric(vertical: small ? 8 : 12, horizontal: small ? 16 : 20),
        textStyle: TextStyle(fontSize: small ? 12 : 14, fontWeight: FontWeight.w600),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: small ? 14 : 18), const SizedBox(width: 8)],
        Text(label),
      ]),
    ),
  );
}

Widget btnGhost(String label, {IconData? icon, VoidCallback? onTap, bool small = false}) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: C.orange,
        side: const BorderSide(color: C.orange, width: 1.5),
        padding: EdgeInsets.symmetric(vertical: small ? 8 : 12, horizontal: small ? 16 : 20),
        textStyle: TextStyle(fontSize: small ? 12 : 14, fontWeight: FontWeight.w600),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: small ? 14 : 18), const SizedBox(width: 8)],
        Text(label),
      ]),
    ),
  );
}

Widget statBox(String value, String unit, String label) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.orange)),
        Text(unit, style: const TextStyle(fontSize: 10, color: C.g500)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: C.g500)),
      ]),
    ),
  );
}

Widget chipRow(List<String> items, String selected, Function(String) onTap) {
  return SizedBox(
    height: 36,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final on = items[i] == selected;
        return GestureDetector(
          onTap: () => onTap(items[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: on ? C.orange : C.white,
              border: Border.all(color: on ? C.orange : C.g300, width: 1.5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(items[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: on ? C.white : C.g500)),
          ),
        );
      },
    ),
  );
}

Widget contentListItem({required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: C.orangeLt, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: C.orange),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: C.g500)),
        ])),
        const Icon(Icons.chevron_right, size: 16, color: C.g300),
      ]),
    ),
  );
}

Widget infoRow(String label, String value, {Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: C.g500)),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? C.black)),
    ]),
  );
}

// ─────────────────────────────────────────────
// STORE (MOCK DATA)
// ─────────────────────────────────────────────
class Store extends ChangeNotifier {
  static final Store _i = Store._();
  factory Store() => _i;
  Store._();

  // USER
  Map<String, dynamic> user = {
    'name': 'Krishna', 'phone': '9876543210', 'email': 'krishna.vishwakarma@aerem.co',
    'pin': '411001', 'city': 'Pune', 'address': '42, Koregaon Park, Pune 411001',
    'referralCode': 'KRISH2026', 'loggedIn': false,
    'settings': {'push': true, 'email': true, 'sms': false},
  };

  // PRODUCTS
  final List<Map<String, dynamic>> products = [
    {'id': 1, 'name': 'Aerem PowerMax 3kW', 'brand': 'Aerem Solar', 'cat': 'Systems', 'kw': 3.0, 'mrp': 195000, 'price': 165000, 'rating': 4.5, 'reviews': 128, 'eff': '21.5%', 'warranty': '25 yrs', 'subsidy': 78000, 'img': 'system1', 'stock': true, 'desc': 'Complete 3kW rooftop solar system with monocrystalline panels, string inverter, and mounting structure.'},
    {'id': 2, 'name': 'Aerem PowerMax 5kW', 'brand': 'Aerem Solar', 'cat': 'Systems', 'kw': 5.0, 'mrp': 310000, 'price': 275000, 'rating': 4.7, 'reviews': 89, 'eff': '21.5%', 'warranty': '25 yrs', 'subsidy': 78000, 'img': 'system2', 'stock': true, 'desc': 'Premium 5kW system for larger homes with high energy consumption.'},
    {'id': 3, 'name': 'Waaree Bifacial 545W', 'brand': 'Waaree', 'cat': 'Panels', 'kw': 0.545, 'mrp': 18500, 'price': 15800, 'rating': 4.3, 'reviews': 256, 'eff': '22.1%', 'warranty': '25 yrs', 'subsidy': 0, 'img': 'panel', 'stock': true, 'desc': 'High-efficiency bifacial panel with enhanced energy yield.'},
    {'id': 4, 'name': 'Fronius Primo 5.0', 'brand': 'Fronius', 'cat': 'Inverters', 'kw': 5.0, 'mrp': 85000, 'price': 72000, 'rating': 4.6, 'reviews': 67, 'eff': '98.1%', 'warranty': '10 yrs', 'subsidy': 0, 'img': 'inverter', 'stock': true, 'desc': 'Premium single-phase inverter with WiFi monitoring.'},
    {'id': 5, 'name': 'Growatt MIN 3000TL-X', 'brand': 'Growatt', 'cat': 'Inverters', 'kw': 3.0, 'mrp': 42000, 'price': 35000, 'rating': 4.2, 'reviews': 145, 'eff': '97.6%', 'warranty': '10 yrs', 'subsidy': 0, 'img': 'inverter', 'stock': true, 'desc': 'Value-for-money inverter with built-in monitoring.'},
    {'id': 6, 'name': 'Luminous 5kWh Battery', 'brand': 'Luminous', 'cat': 'Batteries', 'kw': 5.0, 'mrp': 225000, 'price': 198000, 'rating': 4.4, 'reviews': 34, 'eff': '95%', 'warranty': '8 yrs', 'subsidy': 0, 'img': 'battery', 'stock': false, 'desc': 'Lithium-ion battery for energy storage and backup.'},
    {'id': 7, 'name': 'DC Cable 4mm² (50m)', 'brand': 'Polycab', 'cat': 'Accessories', 'kw': 0.0, 'mrp': 3500, 'price': 2800, 'rating': 4.1, 'reviews': 62, 'eff': '—', 'warranty': '5 yrs', 'subsidy': 0, 'img': 'panel', 'stock': true, 'desc': 'UV-resistant 4mm² DC solar cable.'},
    {'id': 8, 'name': 'MC4 Connector Set (10 pairs)', 'brand': 'Staubli', 'cat': 'Accessories', 'kw': 0.0, 'mrp': 1800, 'price': 1450, 'rating': 4.3, 'reviews': 89, 'eff': '—', 'warranty': '10 yrs', 'subsidy': 0, 'img': 'panel', 'stock': true, 'desc': 'IP67 waterproof MC4 connectors.'},
  ];

  // CART
  List<Map<String, dynamic>> cart = [];
  List<int> compare = [];

  void addCart(int id) {
    final p = products.firstWhere((x) => x['id'] == id, orElse: () => {});
    if (p.isNotEmpty && !cart.any((x) => x['id'] == id)) {
      cart.add({...p, 'qty': 1});
      notifyListeners();
    }
  }

  void removeCart(int id) { cart.removeWhere((x) => x['id'] == id); notifyListeners(); }
  void updateQty(int id, int delta) {
    final item = cart.firstWhere((x) => x['id'] == id, orElse: () => {});
    if (item.isNotEmpty) { item['qty'] = max(1, (item['qty'] as int) + delta); notifyListeners(); }
  }
  int cartTotal() => cart.fold(0, (s, x) => s + (x['price'] as int) * (x['qty'] as int));
  int cartCount() => cart.fold(0, (s, x) => s + (x['qty'] as int));

  void toggleCompare(int id) {
    if (compare.contains(id)) { compare.remove(id); }
    else if (compare.length < 3) { compare.add(id); }
    notifyListeners();
  }

  // PROJECT
  final Map<String, dynamic> project = {
    'id': 'PRJ-2026-0142', 'name': "Krishna's 3kW Rooftop", 'size': '3 kW',
    'epc': {'name': 'SunPower Solutions', 'rating': 4.6, 'phone': '9823456789'},
    'cost': 165000, 'subsidy': 78000, 'net': 87000,
    'payments': [
      {'stage': '20% Advance', 'amt': 17400, 'status': 'paid', 'date': '01 Mar 2026'},
      {'stage': '70% Pre-Install', 'amt': 60900, 'status': 'due', 'date': null},
      {'stage': '10% Post-Commission', 'amt': 8700, 'status': 'upcoming', 'date': null},
    ],
    'milestones': [
      {'name': 'Order Confirmed', 'status': 'done', 'exp': '01 Mar', 'act': '01 Mar', 'who': 'Aerem Ops', 'desc': 'Order placed and advance payment received.'},
      {'name': 'Site Survey', 'status': 'done', 'exp': '05 Mar', 'act': '04 Mar', 'who': 'SunPower', 'desc': 'Roof area: 300 sqft. Shadow analysis completed.'},
      {'name': 'Design Approved', 'status': 'done', 'exp': '08 Mar', 'act': '09 Mar', 'who': 'Aerem Eng.', 'desc': '6 panels, south-facing layout finalized.'},
      {'name': 'Procurement', 'status': 'active', 'exp': '15 Mar', 'act': null, 'who': 'Sunstore', 'desc': 'Panels and inverter dispatched. In transit.'},
      {'name': 'Installation', 'status': 'pending', 'exp': '22 Mar', 'act': null, 'who': 'SunPower', 'desc': 'Structure mounting and panel installation.'},
      {'name': 'Electrical', 'status': 'pending', 'exp': '25 Mar', 'act': null, 'who': 'SunPower', 'desc': 'Wiring, earthing, inverter connection.'},
      {'name': 'Inspection', 'status': 'pending', 'exp': '28 Mar', 'act': null, 'who': 'Aerem Eng.', 'desc': 'Quality check and safety inspection.'},
      {'name': 'Net Meter', 'status': 'pending', 'exp': '05 Apr', 'act': null, 'who': 'MSEDCL', 'desc': 'Net meter installation by DISCOM.'},
      {'name': 'Commissioning', 'status': 'pending', 'exp': '10 Apr', 'act': null, 'who': 'MSEDCL', 'desc': 'System activated and grid-connected.'},
      {'name': 'Subsidy Filed', 'status': 'pending', 'exp': '15 Apr', 'act': null, 'who': 'Aerem Ops', 'desc': 'MNRE subsidy application submitted.'},
    ],
    'days': 33, 'pct': 35,
  };

  // MONITOR
  final Map<String, dynamic> monitor = {
    'kw': 2.4, 'todayKwh': 11.2, 'self': 7.8, 'grid': 3.4,
    'savToday': 89, 'savMonth': 2340, 'savSinceInstall': 6660,
    'co2': 156, 'trees': 7, 'waterSaved': 2340,
    'weekly': [8.5, 12.1, 11.8, 9.2, 13.5, 12.8, 11.2],
    'battery': {'pct': 72, 'status': 'Charging', 'health': 'Good'},
    'alerts': <String>[],
    'monthly': [
      {'mon': 'Jan', 'gen': 280, 'consumed': 185, 'exported': 95, 'savings': 2100, 'cumulative': 2100},
      {'mon': 'Feb', 'gen': 310, 'consumed': 200, 'exported': 110, 'savings': 2340, 'cumulative': 4440},
      {'mon': 'Mar', 'gen': 295, 'consumed': 193, 'exported': 102, 'savings': 2220, 'cumulative': 6660},
    ],
    'roi': {'invested': 87000, 'saved': 6660, 'paybackYears': 5.2, 'projectedDate': 'Oct 2030'},
    'system': {'brand': 'Luminous', 'capacity': '3 kW', 'panels': '8 x 375W Mono PERC', 'inverter': 'Luminous 3kW Hybrid', 'installedDate': '15 Jan 2026', 'warranty': '25 yrs panels / 5 yrs inverter'},
  };

  // AMC
  final Map<String, dynamic> amc = {
    'active': true, 'plan': 'Comprehensive', 'coverage': 'Panels, Inverter, Wiring, Structure',
    'start': '15 Jan 2026', 'expiry': '14 Jan 2027', 'visits': 4, 'usedVisits': 1, 'remaining': 3, 'price': 4500,
    'history': [
      {'date': '10 Mar 2026', 'type': 'Scheduled', 'tech': 'Rajesh K.', 'summary': 'Panel cleaning, inverter check, wiring inspection. All OK.', 'status': 'Completed'},
      {'date': '15 Jun 2026', 'type': 'Scheduled', 'tech': null, 'summary': 'Upcoming quarterly maintenance', 'status': 'Upcoming'},
    ],
  };

  // SUBSIDY
  final Map<String, dynamic> subsidy = {
    'id': 'PMSG-MH-2026-08421',
    'steps': [
      {'name': 'Application Submitted', 'status': 'done', 'date': '20 Mar 2026'},
      {'name': 'Document Verification', 'status': 'active', 'date': null},
      {'name': 'DISCOM Approval', 'status': 'pending', 'date': null},
      {'name': 'Subsidy Sanctioned', 'status': 'pending', 'date': null},
      {'name': 'Amount Credited', 'status': 'pending', 'date': null},
    ],
  };

  // NOTIFICATIONS
  final List<Map<String, dynamic>> notifs = [
    {'id': 1, 'icon': Icons.local_shipping, 'title': 'Material Dispatched', 'desc': 'Solar panels shipped from Sunstore warehouse.', 'time': '2h ago', 'read': false, 'cat': 'Project'},
    {'id': 2, 'icon': Icons.account_balance_wallet, 'title': 'Payment Reminder', 'desc': '70% pre-installation payment of ₹60,900 is due.', 'time': '1d ago', 'read': false, 'cat': 'Payment'},
    {'id': 3, 'icon': Icons.wb_sunny, 'title': 'Summer Solar Sale!', 'desc': 'Get 5% off on all 5kW+ systems this month.', 'time': '2d ago', 'read': true, 'cat': 'Offers'},
    {'id': 4, 'icon': Icons.check_circle, 'title': 'Design Approved', 'desc': 'Your 3kW system layout has been approved.', 'time': '5d ago', 'read': true, 'cat': 'Project'},
    {'id': 5, 'icon': Icons.description, 'title': 'Subsidy Filed', 'desc': 'PM Surya Ghar application under review.', 'time': '2w ago', 'read': true, 'cat': 'Project'},
  ];

  // REVIEWS
  final List<Map<String, dynamic>> reviews = [
    {'name': 'Rajesh M.', 'rating': 5, 'text': 'Excellent service! 3kW system installed in 25 days.', 'loc': 'Kothrud, Pune'},
    {'name': 'Priya S.', 'rating': 4, 'text': 'Good experience. App tracking was very helpful.', 'loc': 'Wakad, Pune'},
    {'name': 'Amit K.', 'rating': 5, 'text': 'Aerem made it hassle-free. Subsidy filing was a breeze!', 'loc': 'Baner, Pune'},
  ];

  // CONTENT
  final List<Map<String, dynamic>> content = [
    {'id': 1, 'title': 'How PM Surya Ghar Subsidy Works', 'type': 'Article', 'time': '5 min', 'icon': Icons.description},
    {'id': 2, 'title': 'Mono vs Poly: Which Panel?', 'type': 'Video', 'time': '8 min', 'icon': Icons.play_circle},
    {'id': 3, 'title': 'Solar ROI: Is It Worth It?', 'type': 'Article', 'time': '4 min', 'icon': Icons.trending_up},
  ];

  // REFERRALS
  final List<Map<String, dynamic>> referrals = [
    {'name': 'Amit Sharma', 'status': 'installed', 'reward': 5000},
    {'name': 'Neha Patel', 'status': 'pending', 'reward': 0},
  ];

  bool amcToggle = false;
  String? lastOrderId;
}

// ─────────────────────────────────────────────
// SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C), Color(0xFFC2410C)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          ScaleTransition(scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
            child: const Icon(Icons.wb_sunny, size: 64, color: C.white)),
          const SizedBox(height: 16),
          const Text('Aerem', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: C.white, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Power Your Future with Solar', style: TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 24),
          const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: C.white)),
        ])),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ONBOARDING
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  int _page = 0;
  final _slides = [
    {'icon': Icons.wb_sunny, 'title': 'Go Solar with Aerem', 'desc': 'Complete rooftop solar solutions for your home'},
    {'icon': Icons.trending_up, 'title': 'Save ₹2,000+/month', 'desc': 'Reduce your electricity bill from day one'},
    {'icon': Icons.speed, 'title': 'Track Everything', 'desc': 'Monitor generation, savings & project progress live'},
  ];

  void _next() {
    if (_page < 2) { setState(() => _page++); }
    else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(alignment: Alignment.topRight, child: TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            child: const Text('Skip', style: TextStyle(color: C.g500, fontWeight: FontWeight.w600)),
          )),
          Expanded(child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Column(key: ValueKey(_page), mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.orangeLt, width: 4), color: C.orangeLt),
                child: Icon(_slides[_page]['icon'] as IconData, size: 80, color: C.orange),
              ),
              const SizedBox(height: 28),
              Text(_slides[_page]['title'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(_slides[_page]['desc'] as String, style: const TextStyle(fontSize: 14, color: C.g500), textAlign: TextAlign.center)),
            ]),
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == _page ? 24 : 8, height: 8,
            decoration: BoxDecoration(color: i == _page ? C.orange : C.g300, borderRadius: BorderRadius.circular(4)),
          ))),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.all(32), child: btnPrimary(_page < 2 ? 'Next' : 'Get Started', icon: Icons.arrow_forward, onTap: _next)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOGIN
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  bool _otpSent = false;
  final List<TextEditingController> _otpCtrls = List.generate(4, (_) => TextEditingController());

  void _submit() {
    if (!_otpSent) {
      if (_phoneCtrl.text.length != 10 || !RegExp(r'^[6-9]').hasMatch(_phoneCtrl.text)) {
        showToast(context, 'Enter valid 10-digit mobile number');
        return;
      }
      setState(() => _otpSent = true);
    } else {
      final otp = _otpCtrls.map((c) => c.text).join();
      if (otp.length != 4) { showToast(context, 'Enter 4-digit OTP'); return; }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PincodeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 32),
          Row(children: [const Icon(Icons.wb_sunny, color: C.orange, size: 28), const SizedBox(width: 8), const Text('Aerem', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.orange))]),
          const SizedBox(height: 24),
          const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Enter your mobile number to continue', style: TextStyle(fontSize: 14, color: C.g500)),
          const SizedBox(height: 32),
          const Text('MOBILE NUMBER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: C.g100, border: Border.all(color: C.g300), borderRadius: const BorderRadius.horizontal(left: Radius.circular(8))),
              child: const Text('+91', style: TextStyle(fontSize: 14, color: C.g500, fontWeight: FontWeight.w600))),
            Expanded(child: TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, maxLength: 10,
              decoration: InputDecoration(counterText: '', hintText: '9876543210', hintStyle: const TextStyle(color: C.g300),
                border: OutlineInputBorder(borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)), borderSide: const BorderSide(color: C.g300)),
                focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)), borderSide: const BorderSide(color: C.orange)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
          ]),
          if (_otpSent) ...[
            const SizedBox(height: 24),
            const Text('ENTER OTP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) => Container(
              width: 48, margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(controller: _otpCtrls[i], maxLength: 1, textAlign: TextAlign.center, keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.g300, width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.orange, width: 2))),
                onChanged: (v) { if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus(); }),
            ))),
          ],
          const Spacer(),
          btnPrimary(_otpSent ? 'Verify & Continue' : 'Send OTP', icon: _otpSent ? Icons.shield : Icons.send, onTap: _submit),
          const SizedBox(height: 16),
          Center(child: Text('By continuing, you agree to our Terms & Privacy Policy', style: const TextStyle(fontSize: 11, color: C.g500), textAlign: TextAlign.center)),
        ])),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PINCODE
// ─────────────────────────────────────────────
class PincodeScreen extends StatelessWidget {
  const PincodeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 32),
          const Text('Your Location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Enter PIN code for localized pricing & availability', style: TextStyle(fontSize: 14, color: C.g500)),
          const SizedBox(height: 32),
          const Text('PIN CODE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          TextField(controller: ctrl, keyboardType: TextInputType.number, maxLength: 6,
            decoration: InputDecoration(counterText: '', hintText: '411001', prefixIcon: const Icon(Icons.location_on, color: C.orange),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.g300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.orange)))),
          const Spacer(),
          btnPrimary('Continue', icon: Icons.arrow_forward, onTap: () {
            if (ctrl.text.length != 6) { showToast(context, 'Enter valid 6-digit PIN code'); return; }
            Store().user['loggedIn'] = true;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
          }),
        ])),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SHELL (Bottom Nav)
// ─────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  final _pages = const [HomeScreen(), ShopScreen(), ProjectListScreen(), MonitorScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final s = Store();
    final unread = s.notifs.any((n) => !(n['read'] as bool));
    final cc = s.cartCount();
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [const Icon(Icons.wb_sunny, size: 20, color: C.orange), const SizedBox(width: 6), const Text('Aerem')]),
        actions: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: C.orangeLt, borderRadius: BorderRadius.circular(999)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on, size: 12, color: C.orangeDk), const SizedBox(width: 4),
              Text(s.user['city'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.orangeDk))])),
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_cart_outlined, size: 20, color: C.g500),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
            if (cc > 0) Positioned(top: 6, right: 6, child: Container(width: 7, height: 7, decoration: BoxDecoration(color: C.orange, shape: BoxShape.circle, border: Border.all(color: C.white, width: 1.5)))),
          ]),
          Stack(children: [
            IconButton(icon: const Icon(Icons.notifications_outlined, size: 20, color: C.g500),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotifsScreen()))),
            if (unread) Positioned(top: 6, right: 6, child: Container(width: 7, height: 7, decoration: BoxDecoration(color: C.red, shape: BoxShape.circle, border: Border.all(color: C.white, width: 1.5)))),
          ]),
        ],
      ),
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.g200))),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: C.orange,
          unselectedItemColor: C.g500,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Shop'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Project'),
            BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_outlined), activeIcon: Icon(Icons.monitor_heart), label: 'Monitor'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    final topPicks = s.products.where((p) => p['stock'] == true).take(4).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      // BANNER
      Container(
        height: 140, margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [C.orange, C.orangeDk])),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubsidyEligScreen())),
          child: Stack(children: [
            Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black38])))),
            Positioned(bottom: 16, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PM Surya Ghar: Get ₹78,000 Subsidy', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: C.white)),
              const SizedBox(height: 4),
              Text('Apply now and save on your solar installation', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
            ])),
          ]),
        ),
      ),

      // QUICK ACTIONS
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.orange, C.orangeDk]), borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorScreen())),
          child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.calculate, size: 18, color: C.white)),
            const SizedBox(width: 12),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Solar Calculator', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.white)),
              Text('See how much you save', style: TextStyle(fontSize: 10, color: Colors.white70)),
            ])),
            Icon(Icons.arrow_forward, size: 16, color: Colors.white70),
          ]),
        ),
      ),

      // BENTO GRID
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
        children: [
          _bentoItem(Icons.account_balance_wallet, 'EMI Plans', '0% interest', C.orangeLt, C.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancingScreen()))),
          _bentoItem(Icons.task_alt, 'Subsidy', 'Up to ₹78K', C.greenLt, C.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubsidyEligScreen()))),
          _bentoItem(Icons.bar_chart, 'My Plant', 'Live monitor', const Color(0xFFEDE9FE), const Color(0xFF7C3AED), () {}),
          _bentoItem(Icons.help_outline, 'Support', 'Get help', C.amberLt, C.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()))),
        ],
      ),
      const SizedBox(height: 20),

      // TOP PICKS
      sectionHeader('Top Picks for You', action: 'See All'),
      SizedBox(height: 220, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: topPicks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => ProductCard(product: topPicks[i], width: 156))),
      const SizedBox(height: 20),

      // REVIEWS
      sectionHeader('Customer Reviews'),
      SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: s.reviews.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final r = s.reviews[i];
          return Container(width: 200, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: C.g50, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              starsRow(r['rating'].toDouble(), size: 11),
              const SizedBox(height: 4),
              Text(r['text'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: C.g500)),
            ]));
        })),
      const SizedBox(height: 20),

      // LEARN
      sectionHeader('Learn about Solar'),
      ...s.content.map((c) => contentListItem(icon: c['icon'], title: c['title'], subtitle: '${c['type']} • ${c['time']}', onTap: () => showToast(context, 'Opening ${c['title']}'))),
      const SizedBox(height: 20),

      // REFERRAL
      Container(
        padding: const EdgeInsets.all(16), decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [C.orangeLt, Color(0xFFFED7AA)]),
          border: Border.all(color: C.orange.withOpacity(0.2), width: 1.5), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.card_giftcard, size: 18, color: C.orange), const SizedBox(width: 6),
            const Text('Refer & Earn ₹5,000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 4),
          const Text('Share solar with friends and earn rewards', style: TextStyle(fontSize: 12, color: C.g500)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(color: C.white, border: Border.all(color: C.orange, width: 1.5, strokeAlign: BorderSide.strokeAlignCenter), borderRadius: BorderRadius.circular(8)),
            child: Text(s.user['referralCode'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.orange, letterSpacing: 1))),
          const SizedBox(height: 10),
          btnPrimary('Invite Friends', icon: Icons.share, small: true, onTap: () => showToast(context, 'Shared!')),
        ]),
      ),
    ]);
  }

  Widget _bentoItem(IconData icon, String title, String sub, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: fg)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          Text(sub, style: const TextStyle(fontSize: 10, color: C.g500)),
        ]),
      ]),
    ));
  }
}

// ─────────────────────────────────────────────
// PRODUCT CARD WIDGET (reusable)
// ─────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final double? width;
  const ProductCard({super.key, required this.product, this.width});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: p['id']))),
      child: Container(
        width: width ?? 156,
        decoration: BoxDecoration(border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12), color: C.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 110, decoration: BoxDecoration(color: C.g100, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            child: Stack(children: [
              Center(child: Icon(Icons.solar_power, size: 48, color: C.g300)),
              if ((p['subsidy'] ?? 0) > 0) Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: C.green, borderRadius: BorderRadius.circular(4)),
                child: const Text('Subsidy', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: C.white)))),
            ])),
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3)),
            const SizedBox(height: 4),
            Text('${p['brand']}${p['kw'] > 0 ? ' • ${p['kw']}kW' : ''}', style: const TextStyle(fontSize: 11, color: C.g500)),
            const SizedBox(height: 4),
            Row(children: [
              Text(fmt(p['price']), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.orange)),
              const SizedBox(width: 6),
              Text(fmt(p['mrp']), style: const TextStyle(fontSize: 10, color: C.g500, decoration: TextDecoration.lineThrough)),
            ]),
            const SizedBox(height: 4),
            Row(children: [starsRow(p['rating'].toDouble()), const SizedBox(width: 4),
              Text('(${p['reviews']})', style: const TextStyle(fontSize: 10, color: C.g500))]),
          ])),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHOP SCREEN
// ─────────────────────────────────────────────
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override State<ShopScreen> createState() => _ShopState();
}

class _ShopState extends State<ShopScreen> {
  String _cat = 'All';
  String _query = '';
  String _sort = 'default';
  bool _subOnly = false;
  bool _filterOpen = false;
  final _cats = ['All', 'Systems', 'Panels', 'Inverters', 'Batteries', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    final s = Store();
    var filtered = s.products.where((p) {
      if (_cat != 'All' && p['cat'] != _cat) return false;
      if (_subOnly && (p['subsidy'] ?? 0) == 0) return false;
      if (_query.isNotEmpty && !(p['name'] as String).toLowerCase().contains(_query.toLowerCase())) return false;
      return true;
    }).toList();

    if (_sort == 'low') filtered.sort((a, b) => (a['price'] as int).compareTo(b['price']));
    if (_sort == 'high') filtered.sort((a, b) => (b['price'] as int).compareTo(a['price']));
    if (_sort == 'rating') filtered.sort((a, b) => (b['rating'] as num).compareTo(a['rating']));

    return Column(children: [
      // SEARCH + FILTER
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: Row(children: [
        Expanded(child: TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search solar products...', prefixIcon: const Icon(Icons.search, size: 16, color: C.g500),
            filled: true, fillColor: C.g50, isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.g200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.g200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.orange)),
          ),
        )),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _filterOpen = !_filterOpen),
          child: Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _filterOpen ? C.orangeLt : C.white, border: Border.all(color: _filterOpen ? C.orange : C.g300, width: 1.5), borderRadius: BorderRadius.circular(999)),
            child: Icon(Icons.tune, size: 16, color: _filterOpen ? C.orange : C.g500)),
        ),
      ])),

      // FILTER DRAWER
      if (_filterOpen) Container(
        margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.white, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('SORT BY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500)),
            DropdownButton<String>(value: _sort, underline: const SizedBox(), isDense: true, style: const TextStyle(fontSize: 12, color: C.black),
              items: const [DropdownMenuItem(value: 'default', child: Text('Default')), DropdownMenuItem(value: 'low', child: Text('Price: Low→High')),
                DropdownMenuItem(value: 'high', child: Text('Price: High→Low')), DropdownMenuItem(value: 'rating', child: Text('Top Rated'))],
              onChanged: (v) => setState(() => _sort = v!)),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('SUBSIDY ELIGIBLE ONLY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500)),
            Switch(value: _subOnly, onChanged: (v) => setState(() => _subOnly = v), activeColor: C.orange),
          ]),
        ]),
      ),

      // CHIPS
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
        child: chipRow(_cats, _cat, (v) => setState(() => _cat = v))),

      // COUNT
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(alignment: Alignment.centerLeft, child: Text('${filtered.length} products', style: const TextStyle(fontSize: 11, color: C.g500)))),
      const SizedBox(height: 8),

      // GRID
      Expanded(child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.58),
        itemCount: filtered.length,
        itemBuilder: (_, i) => ProductCard(product: filtered[i], width: double.infinity),
      )),
    ]);
  }
}

// ─────────────────────────────────────────────
// PRODUCT DETAIL
// ─────────────────────────────────────────────
class ProductDetailScreen extends StatelessWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final s = Store();
    final prod = s.products.firstWhere((p) => p['id'] == productId);
    final disc = (((prod['mrp'] - prod['price']) / prod['mrp']) * 100).round();
    final related = s.products.where((p) => p['cat'] == prod['cat'] && p['id'] != prod['id']).take(3).toList();

    return Scaffold(
      body: SafeArea(child: Column(children: [
        Expanded(child: ListView(children: [
          // IMAGE
          Container(height: 220, color: C.g100,
            child: Stack(children: [
              const Center(child: Icon(Icons.solar_power, size: 80, color: C.g300)),
              Positioned(top: 12, left: 12, child: _circleBtn(Icons.arrow_back, () => Navigator.pop(context))),
              Positioned(top: 12, right: 12, child: _circleBtn(Icons.share, () => showToast(context, 'Shared!'))),
              if (disc > 0) Positioned(top: 12, right: 56, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: C.red, borderRadius: BorderRadius.circular(4)),
                child: Text('-$disc%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: C.white)))),
            ])),

          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // PIN
            Row(children: [const Icon(Icons.location_on, size: 12, color: C.g500), const SizedBox(width: 4),
              Text('PIN: ${s.user['pin']}', style: const TextStyle(fontSize: 11, color: C.g500)),
              const SizedBox(width: 8),
              GestureDetector(onTap: () => showToast(context, 'Change PIN'), child: const Text('Change', style: TextStyle(fontSize: 11, color: C.orange, fontWeight: FontWeight.w600)))]),
            const SizedBox(height: 8),

            // NAME & BRAND
            Text(prod['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.verified, size: 12, color: C.g500), const SizedBox(width: 4),
              Text(prod['brand'], style: const TextStyle(fontSize: 12, color: C.g500))]),
            const SizedBox(height: 8),

            // PRICE
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              Text(fmt(prod['price']), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.orange)),
              const SizedBox(width: 8),
              Text(fmt(prod['mrp']), style: const TextStyle(fontSize: 13, color: C.g500, decoration: TextDecoration.lineThrough)),
            ]),
            const SizedBox(height: 4),
            if (prod['stock']) const Text('3 systems available near you', style: TextStyle(fontSize: 11, color: C.green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            // RATING
            Row(children: [
              Text('${prod['rating']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              starsRow(prod['rating'].toDouble(), size: 16),
              const SizedBox(width: 8),
              Text('(${prod['reviews']} reviews)', style: const TextStyle(fontSize: 12, color: C.g500)),
            ]),
            const SizedBox(height: 16),

            // SUBSIDY
            if ((prod['subsidy'] ?? 0) > 0) cardWidget(color: C.greenLt, borderColor: C.green.withOpacity(0.15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.currency_rupee, size: 12, color: C.green), const SizedBox(width: 4), const Text('PM Surya Ghar Subsidy', style: TextStyle(fontSize: 11, color: C.green))]),
                Text(fmt(prod['subsidy']), style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
              ]),
              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubsidyEligScreen())),
                child: const Text('Check Eligibility →', style: TextStyle(fontSize: 11, color: C.orange, fontWeight: FontWeight.w600))),
            ])),

            // SPECS
            sectionHeader('Key Specs', icon: Icons.settings),
            GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.5,
              children: [
                _specItem(Icons.bolt, '${prod['kw']} kW', 'Capacity'),
                _specItem(Icons.speed, prod['eff'], 'Efficiency'),
                _specItem(Icons.shield, prod['warranty'], 'Warranty'),
                _specItem(Icons.star, '${prod['rating']}', 'Rating'),
              ]),
            const SizedBox(height: 16),

            // DESCRIPTION
            Text(prod['desc'], style: const TextStyle(fontSize: 13, color: C.g500, height: 1.5)),
            const SizedBox(height: 16),

            // EMI
            cardWidget(color: C.orangeLt, borderColor: C.orange.withOpacity(0.15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('EMI starting from', style: TextStyle(fontSize: 11, color: C.g500)),
                Text('${fmt((prod['price'] / 36).round())}/mo', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.orange)),
                const Text('for 36 months @ 9.5%', style: TextStyle(fontSize: 11, color: C.g500)),
              ]),
              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancingScreen())),
                child: const Text('View Plans →', style: TextStyle(fontSize: 13, color: C.orange, fontWeight: FontWeight.w600))),
            ])),

            // CONFIGURE
            if (prod['cat'] == 'Systems') GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorScreen())),
              child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: C.orange, width: 1.5, strokeAlign: BorderSide.strokeAlignCenter), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.settings, size: 18, color: C.orange), const SizedBox(width: 8),
                  Column(children: [const Text('Configure System?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const Text('Customize panels, inverter & battery', style: TextStyle(fontSize: 11, color: C.g500))]),
                ]))),

            // RELATED
            if (related.isNotEmpty) ...[
              sectionHeader('Suggested Products', action: 'See All'),
              SizedBox(height: 200, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => ProductCard(product: related[i], width: 156))),
            ],
          ])),
        ])),

        // BOTTOM BAR
        Container(
          padding: const EdgeInsets.all(12), decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.g200))),
          child: prod['stock'] ? Row(children: [
            Expanded(child: btnSecondary('Cart', icon: Icons.shopping_cart, onTap: () { s.addCart(prod['id']); showToast(context, 'Added to cart'); })),
            const SizedBox(width: 8),
            Expanded(child: btnPrimary('Buy Now', icon: Icons.bolt, onTap: () {
              s.cart.clear(); s.addCart(prod['id']);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutSummaryScreen()));
            })),
          ]) : btnPrimary('Out of Stock', icon: Icons.block, disabled: true),
        ),
      ])),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(width: 32, height: 32,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: C.black)));
  }

  Widget _specItem(IconData icon, String value, String label) {
    return Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(8)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 16, color: C.orange),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(fontSize: 10, color: C.g500)),
      ]));
  }
}

// ─────────────────────────────────────────────
// CALCULATOR
// ─────────────────────────────────────────────
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override State<CalculatorScreen> createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorScreen> {
  double _bill = 2000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Solar Calculator')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Monthly Electricity Bill', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: C.g50, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.g200)),
          child: Column(children: [
            Text(fmt(_bill.round()), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: C.orange)),
            const Text('per month', style: TextStyle(fontSize: 12, color: C.g500)),
          ])),
        const SizedBox(height: 16),
        Slider(value: _bill, min: 500, max: 15000, divisions: 29, activeColor: C.orange,
          label: fmt(_bill.round()), onChanged: (v) => setState(() => _bill = v)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(fmt(500), style: const TextStyle(fontSize: 11, color: C.g500)),
          Text(fmt(15000), style: const TextStyle(fontSize: 11, color: C.g500)),
        ]),
        const Spacer(),
        btnPrimary('Calculate My Savings', icon: Icons.calculate, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CalcResultsScreen(bill: _bill)));
        }),
      ])));
  }
}

class CalcResultsScreen extends StatelessWidget {
  final double bill;
  const CalcResultsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final kw = (bill / 1200).clamp(1, 10).round();
    final cost = kw * 55000;
    final subsidy = kw <= 3 ? 78000 : (kw <= 5 ? 78000 : 78000);
    final net = cost - subsidy;
    final monthly = (kw * 120 * 7.5).round();
    final annual = monthly * 12;
    final payback = (net / annual).toStringAsFixed(1);

    return Scaffold(appBar: AppBar(title: const Text('Your Solar Estimate')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.orange, C.orangeDk]), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text('$kw kW', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: C.white)),
            const Text('Recommended System', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ])),
        const SizedBox(height: 16),
        Row(children: [
          statBox(fmt(monthly), '/mo', 'Savings'),
          const SizedBox(width: 8),
          statBox(fmt(annual), '/yr', 'Annual'),
          const SizedBox(width: 8),
          statBox('$payback yr', '', 'Payback'),
        ]),
        const SizedBox(height: 16),
        cardWidget(child: Column(children: [
          infoRow('System Cost', fmt(cost)),
          infoRow('Subsidy', '-${fmt(subsidy)}', valueColor: C.green),
          const Divider(),
          infoRow('Net Investment', fmt(net), valueColor: C.orange),
        ])),
        const SizedBox(height: 16),
        btnPrimary('Browse ${kw}kW Systems', icon: Icons.shopping_bag, onTap: () => Navigator.pop(context)),
        const SizedBox(height: 8),
        btnGhost('Share Estimate', icon: Icons.share, onTap: () => showToast(context, 'Shared!')),
      ]));
  }
}

// ─────────────────────────────────────────────
// SUBSIDY SCREENS
// ─────────────────────────────────────────────
class SubsidyEligScreen extends StatelessWidget {
  const SubsidyEligScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('PM Surya Ghar')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.green, Color(0xFF16A34A)]), borderRadius: BorderRadius.circular(12)),
          child: const Column(children: [
            Text('Up to ₹78,000', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: C.white)),
            SizedBox(height: 4),
            Text('Government subsidy for rooftop solar', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ])),
        const SizedBox(height: 16),
        sectionHeader('Subsidy Slabs', icon: Icons.grid_view),
        ...[['Up to 2 kW', '₹30,000/kW'], ['2-3 kW', '₹18,000/kW (for 3rd kW)'], ['3-10 kW', '₹9,000/kW (above 3kW)']].map((r) =>
          cardWidget(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(r[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), Text(r[1], style: const TextStyle(fontSize: 13, color: C.orange, fontWeight: FontWeight.w600))]))),
        const SizedBox(height: 8),
        sectionHeader('Eligibility', icon: Icons.check_circle),
        ...['Indian citizen with residential electricity connection', 'Rooftop area: min 100 sqft for 1kW', 'No previous solar subsidy availed'].map((e) =>
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [const Icon(Icons.check, size: 14, color: C.green), const SizedBox(width: 8),
            Expanded(child: Text(e, style: const TextStyle(fontSize: 12, color: C.g500)))]))),
        const SizedBox(height: 16),
        btnPrimary('Apply Now', icon: Icons.description, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubsidyAppScreen()))),
      ]));
  }
}

class SubsidyAppScreen extends StatelessWidget {
  const SubsidyAppScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Subsidy Application')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('ELECTRICITY ACCOUNT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(decoration: InputDecoration(hintText: 'Consumer Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 16),
        const Text('DISCOM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        DropdownButtonFormField(items: ['MSEDCL', 'BEST', 'Tata Power'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {}, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 16),
        const Text('SYSTEM SIZE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(decoration: InputDecoration(hintText: '3', suffixText: 'kW', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 16),
        const Text('ID PROOF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        DropdownButtonFormField(items: ['Aadhaar Card', 'PAN Card', 'Voter ID'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {}, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 24),
        btnPrimary('Submit Application', icon: Icons.send, onTap: () {
          showToast(context, 'Application submitted!');
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubsidyTrackerScreen()));
        }),
      ]));
  }
}

class SubsidyTrackerScreen extends StatelessWidget {
  const SubsidyTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    return Scaffold(appBar: AppBar(title: const Text('Subsidy Tracker')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        cardWidget(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Application ID', style: TextStyle(fontSize: 11, color: C.g500)),
            Text(s.subsidy['id'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ]),
          badge('In Progress', bg: C.amberLt, fg: const Color(0xFF92400E)),
        ])),
        const SizedBox(height: 8),
        ...(s.subsidy['steps'] as List).map((step) => _timelineItem(step)),
      ]));
  }

  Widget _timelineItem(Map<String, dynamic> step) {
    final done = step['status'] == 'done';
    final active = step['status'] == 'active';
    return Container(
      padding: const EdgeInsets.only(left: 28, bottom: 24),
      decoration: BoxDecoration(border: Border(left: BorderSide(color: done ? C.green : (active ? C.orange : C.g200), width: 2))),
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(left: -37, top: 0, child: Container(width: 16, height: 16,
          decoration: BoxDecoration(shape: BoxShape.circle, color: done ? C.green : (active ? C.orange : C.white),
            border: Border.all(color: done ? C.green : (active ? C.orange : C.g300), width: 2)),
          child: done ? const Icon(Icons.check, size: 10, color: C.white) : null)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(step['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: done ? const Color(0xFF065F46) : (active ? C.orangeDk : C.black))),
          if (step['date'] != null) Text(step['date'], style: const TextStyle(fontSize: 11, color: C.g500)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// FINANCING
// ─────────────────────────────────────────────
class FinancingScreen extends StatelessWidget {
  const FinancingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Financing Options')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.g900, Color(0xFF262626)]), borderRadius: BorderRadius.circular(12)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NetZero Green Loan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.white)),
            SizedBox(height: 4),
            Text('0% interest for 12 months', style: TextStyle(fontSize: 12, color: Colors.white70)),
            SizedBox(height: 12),
            Row(children: [
              Column(children: [Text('₹2,417', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: C.orange)), Text('/month', style: TextStyle(fontSize: 10, color: Colors.white70))]),
              SizedBox(width: 24),
              Column(children: [Text('36 mo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: C.white)), Text('tenure', style: TextStyle(fontSize: 10, color: Colors.white70))]),
            ]),
          ])),
        const SizedBox(height: 16),
        sectionHeader('Other Lenders'),
        ...[['Tata Capital', '9.5%', '60 mo'], ['SBI Green', '8.5%', '48 mo'], ['HDFC', '10.5%', '36 mo']].map((l) =>
          cardWidget(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${l[1]} • ${l[2]}', style: const TextStyle(fontSize: 11, color: C.g500))]),
            const Text('Apply →', style: TextStyle(fontSize: 12, color: C.orange, fontWeight: FontWeight.w600)),
          ]))),
        const SizedBox(height: 16),
        btnPrimary('Proceed with NetZero', icon: Icons.arrow_forward, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutSummaryScreen()))),
      ]));
  }
}

// ─────────────────────────────────────────────
// CHECKOUT SCREENS
// ─────────────────────────────────────────────
class CheckoutSummaryScreen extends StatefulWidget {
  const CheckoutSummaryScreen({super.key});
  @override State<CheckoutSummaryScreen> createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final s = Store();
    if (s.cart.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Order Summary')),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.shopping_cart, size: 48, color: C.g300),
          const SizedBox(height: 12),
          const Text('Your cart is empty', style: TextStyle(color: C.g500)),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 48), child: btnPrimary('Browse Products', icon: Icons.shopping_bag, onTap: () => Navigator.pop(context))),
        ])));
    }
    final gst = (s.cartTotal() * 0.05).round();
    final sub = s.cart.fold<int>(0, (sum, x) => sum + ((x['subsidy'] ?? 0) as int));
    final amcPrice = (s.cart.first['price'] * 0.03).round();
    final addAmc = s.amcToggle;
    final total = s.cartTotal() + gst - sub + (addAmc ? amcPrice : 0);
    final adv = (total * 0.2).round();

    return Scaffold(appBar: AppBar(title: const Text('Order Summary')),
      body: Column(children: [
        // STEP DOTS
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _stepDot(true, true), _stepDot(false, false), _stepDot(false, false),
        ])),
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          // ITEMS
          sectionHeader('Order Items', icon: Icons.shopping_bag),
          ...s.cart.map((item) => cardWidget(child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: C.g100, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.solar_power, size: 24, color: C.g300)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${item['brand']} • Qty: ${item['qty']}', style: const TextStyle(fontSize: 11, color: C.g500)),
            ])),
            Text(fmt(item['price'] * item['qty']), style: const TextStyle(fontWeight: FontWeight.w700, color: C.orange)),
          ]))),

          // FINANCING
          sectionHeader('Financing', icon: Icons.account_balance),
          cardWidget(color: C.g900, borderColor: Colors.transparent, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('NetZero Green Loan', style: TextStyle(color: C.white, fontWeight: FontWeight.w600, fontSize: 13)),
              Text('0% for 12 months', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ]),
            badge('Pre-approved', bg: C.greenLt, fg: const Color(0xFF065F46)),
          ])),

          // SUBSIDY
          if (sub > 0) cardWidget(color: C.greenLt, borderColor: C.green.withOpacity(0.15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PM Surya Ghar Subsidy', style: TextStyle(fontSize: 11)),
              Text(fmt(sub), style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
            ]),
            const Text('Applied ✓', style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.w600)),
          ])),

          // AMC TOGGLE
          GestureDetector(
            onTap: () => setState(() => s.amcToggle = !s.amcToggle),
            child: cardWidget(child: Row(children: [
              Container(width: 44, height: 24,
                decoration: BoxDecoration(color: addAmc ? C.orange : C.g300, borderRadius: BorderRadius.circular(999)),
                child: AnimatedAlign(alignment: addAmc ? Alignment.centerRight : Alignment.centerLeft, duration: const Duration(milliseconds: 200),
                  child: Container(width: 20, height: 20, margin: const EdgeInsets.all(2), decoration: const BoxDecoration(color: C.white, shape: BoxShape.circle)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Comprehensive AMC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const Text('Covers cleaning, repairs & monitoring', style: TextStyle(fontSize: 11, color: C.g500)),
              ])),
              Text('${fmt(amcPrice)}/yr', style: const TextStyle(fontWeight: FontWeight.w700, color: C.orange)),
            ])),
          ),

          // PRICE BREAKDOWN
          sectionHeader('Price Breakdown', icon: Icons.receipt),
          cardWidget(child: Column(children: [
            infoRow('Subtotal', fmt(s.cartTotal())),
            infoRow('GST (5%)', fmt(gst)),
            if (sub > 0) infoRow('Subsidy', '-${fmt(sub)}', valueColor: C.green),
            if (addAmc) infoRow('AMC (1 yr)', fmt(amcPrice)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(fmt(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.orange)),
            ]),
          ])),

          // ADDRESS
          sectionHeader('Delivery Address', icon: Icons.location_on),
          cardWidget(child: Row(children: [
            const Icon(Icons.location_on, size: 18, color: C.orange),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.user['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(s.user['address'], style: const TextStyle(fontSize: 11, color: C.g500)),
              Text('PIN: ${s.user['pin']}', style: const TextStyle(fontSize: 11, color: C.g500)),
            ])),
            GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditScreen())),
              child: const Text('Edit', style: TextStyle(fontSize: 11, color: C.orange, fontWeight: FontWeight.w600))),
          ])),

          // TIMELINE
          sectionHeader('Delivery Timeline', icon: Icons.local_shipping),
          ...['Site Survey: 3-5 days', 'Installation: 15-30 days', 'Go Solar: ~7 days'].map((t) =>
            Padding(padding: const EdgeInsets.only(bottom: 8, left: 12), child: Row(children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: C.orange, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(t, style: const TextStyle(fontSize: 12, color: C.g500)),
            ]))),
        ])),

        // PAY BUTTON
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.g200))),
          child: btnPrimary('Pay ${fmt(adv)} (20% Advance)', icon: Icons.credit_card, onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPayScreen(amt: adv, total: total))))),
      ]));
  }

  Widget _stepDot(bool on, bool done) {
    return Container(width: on ? 24 : 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(color: done ? C.green : (on ? C.orange : C.g300), borderRadius: BorderRadius.circular(4)));
  }
}

class CheckoutPayScreen extends StatelessWidget {
  final int amt;
  final int total;
  const CheckoutPayScreen({super.key, required this.amt, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Payment')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Column(children: [
          const Text('Amount Due', style: TextStyle(fontSize: 12, color: C.g500)),
          Text(fmt(amt), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: C.orange)),
          Text('of ${fmt(total)} total', style: const TextStyle(fontSize: 12, color: C.g500)),
        ])),
        const SizedBox(height: 24),
        sectionHeader('Payment Method', icon: Icons.payment),
        ...[['UPI / Google Pay', Icons.phone_android], ['Credit / Debit Card', Icons.credit_card], ['Net Banking', Icons.account_balance]].map((m) =>
          Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.g300, width: 2))),
              const SizedBox(width: 12),
              Icon(m[1] as IconData, size: 18, color: C.g500), const SizedBox(width: 8),
              Text(m[0] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ]))),
        const SizedBox(height: 32),
        btnPrimary('Pay Securely', icon: Icons.lock, onTap: () {
          showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: C.orange)));
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.pop(context); // close dialog
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CheckoutConfirmScreen()));
          });
        }),
      ]));
  }
}

class CheckoutConfirmScreen extends StatelessWidget {
  const CheckoutConfirmScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    s.lastOrderId ??= 'ORD-2026-${(1000 + Random().nextInt(9000))}';
    return Scaffold(
      body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle, size: 64, color: C.green),
        const SizedBox(height: 16),
        const Text('Order Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(s.lastOrderId!, style: const TextStyle(fontSize: 13, color: C.g500)),
        const SizedBox(height: 20),
        cardWidget(child: Column(children: [
          infoRow('Project', s.project['name']),
          infoRow('System', s.project['size']),
          infoRow('EPC Partner', (s.project['epc'] as Map)['name']),
          infoRow('Est. Installation', '15-30 days'),
        ])),
        const SizedBox(height: 12),
        btnPrimary('Track My Project', icon: Icons.assignment, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()))),
        const SizedBox(height: 8),
        btnSecondary('Continue Shopping', icon: Icons.shopping_bag, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()))),
      ])))),
    );
  }
}

// ─────────────────────────────────────────────
// CART
// ─────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override State<CartScreen> createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final s = Store();
    if (s.cart.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('My Cart')),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.shopping_cart, size: 48, color: C.g300),
          const SizedBox(height: 12),
          const Text('Your cart is empty', style: TextStyle(color: C.g500)),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 48), child: btnPrimary('Browse Products', icon: Icons.shopping_bag, onTap: () => Navigator.pop(context))),
        ])));
    }
    final gst = (s.cartTotal() * 0.05).round();
    final sub = s.cart.fold<int>(0, (sum, x) => sum + ((x['subsidy'] ?? 0) as int));
    final total = s.cartTotal() + gst - sub;

    return Scaffold(appBar: AppBar(title: Text('My Cart (${s.cartCount()})')),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          ...s.cart.map((item) => cardWidget(child: Row(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: C.g100, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.solar_power, size: 28, color: C.g300)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${item['brand']}', style: const TextStyle(fontSize: 11, color: C.g500)),
              const SizedBox(height: 4),
              Text(fmt(item['price']), style: const TextStyle(fontWeight: FontWeight.w700, color: C.orange)),
            ])),
            Column(children: [
              GestureDetector(onTap: () { s.removeCart(item['id']); setState(() {}); },
                child: const Icon(Icons.delete_outline, size: 16, color: C.red)),
              const SizedBox(height: 8),
              Row(mainAxisSize: MainAxisSize.min, children: [
                _qtyBtn(Icons.remove, () { s.updateQty(item['id'], -1); setState(() {}); }),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item['qty']}', style: const TextStyle(fontWeight: FontWeight.w600))),
                _qtyBtn(Icons.add, () { s.updateQty(item['id'], 1); setState(() {}); }),
              ]),
            ]),
          ]))),
          const SizedBox(height: 12),
          cardWidget(child: Column(children: [
            infoRow('Subtotal', fmt(s.cartTotal())),
            infoRow('GST (5%)', fmt(gst)),
            if (sub > 0) infoRow('Subsidy', '-${fmt(sub)}', valueColor: C.green),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(fmt(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.orange)),
            ]),
          ])),
        ])),
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.g200))),
          child: btnPrimary('Proceed to Checkout', icon: Icons.arrow_forward, onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutSummaryScreen())))),
      ]));
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(width: 28, height: 28,
      decoration: BoxDecoration(border: Border.all(color: C.g300), borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, size: 14)));
  }
}

// ─────────────────────────────────────────────
// PROJECT SCREENS
// ─────────────────────────────────────────────
class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    final p = s.project;
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('My Projects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      const Text('Track your solar installation', style: TextStyle(fontSize: 13, color: C.g500)),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectTimelineScreen())),
        child: cardWidget(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(p['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            badge('In Progress', bg: C.amberLt, fg: const Color(0xFF92400E)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Text(p['size'], style: const TextStyle(fontSize: 12, color: C.g500)),
            const Text(' • ', style: TextStyle(color: C.g300)),
            Text('Day ${p['days']}', style: const TextStyle(fontSize: 12, color: C.g500)),
          ]),
          const SizedBox(height: 8),
          progressBar(p['pct'] / 100),
          const SizedBox(height: 4),
          Text('${p['pct']}% complete', style: const TextStyle(fontSize: 11, color: C.g500)),
        ])),
      ),
      const SizedBox(height: 8),
      Center(child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScheduleScreen())),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.account_balance_wallet, size: 14, color: C.orange), const SizedBox(width: 4),
          const Text('Payment Schedule', style: TextStyle(fontSize: 13, color: C.orange, fontWeight: FontWeight.w600)),
        ]))),
      const SizedBox(height: 20),
      sectionHeader('Recommended for You', action: 'See All'),
      SizedBox(height: 200, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => ProductCard(product: s.products[i], width: 156))),
    ]);
  }
}

class ProjectTimelineScreen extends StatelessWidget {
  const ProjectTimelineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    final ms = s.project['milestones'] as List;
    return Scaffold(appBar: AppBar(title: const Text('Project Timeline')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        cardWidget(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.project['id'], style: const TextStyle(fontSize: 11, color: C.g500)),
            Text(s.project['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
          badge('Day ${s.project['days']}', bg: C.orangeLt, fg: C.orangeDk),
        ])),
        const SizedBox(height: 16),
        ...ms.asMap().entries.map((e) {
          final m = e.value;
          final done = m['status'] == 'done';
          final active = m['status'] == 'active';
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MilestoneDetailScreen(idx: e.key))),
            child: Container(
              padding: const EdgeInsets.only(left: 28, bottom: 24),
              decoration: BoxDecoration(border: e.key < ms.length - 1 ? Border(left: BorderSide(color: done ? C.green : (active ? C.orange : C.g200), width: 2)) : null),
              child: Stack(clipBehavior: Clip.none, children: [
                Positioned(left: -37, top: 0, child: Container(width: 16, height: 16,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: done ? C.green : (active ? C.orange : C.white),
                    border: Border.all(color: done ? C.green : (active ? C.orange : C.g300), width: 2),
                    boxShadow: active ? [BoxShadow(color: C.orange.withOpacity(0.15), blurRadius: 8, spreadRadius: 4)] : null),
                  child: done ? const Icon(Icons.check, size: 10, color: C.white) : (active ? const Icon(Icons.sync, size: 10, color: C.white) : null))),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: done ? const Color(0xFF065F46) : (active ? C.orangeDk : C.black))),
                  Text('${m['act'] ?? 'Exp: ${m['exp']}'} • ${m['who']}', style: const TextStyle(fontSize: 11, color: C.g500)),
                ]),
              ]),
            ),
          );
        }),
      ]));
  }
}

class MilestoneDetailScreen extends StatelessWidget {
  final int idx;
  const MilestoneDetailScreen({super.key, required this.idx});
  @override
  Widget build(BuildContext context) {
    final m = (Store().project['milestones'] as List)[idx];
    return Scaffold(appBar: AppBar(title: Text(m['name'])),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        badge(m['status'] == 'done' ? 'Completed' : (m['status'] == 'active' ? 'In Progress' : 'Pending'),
          bg: m['status'] == 'done' ? C.greenLt : (m['status'] == 'active' ? C.amberLt : C.g100),
          fg: m['status'] == 'done' ? const Color(0xFF065F46) : (m['status'] == 'active' ? const Color(0xFF92400E) : C.g500)),
        const SizedBox(height: 16),
        cardWidget(child: Column(children: [
          infoRow('Expected', m['exp']),
          infoRow('Actual', m['act'] ?? 'TBD'),
          infoRow('Responsible', m['who']),
        ])),
        const SizedBox(height: 8),
        Text(m['desc'], style: const TextStyle(fontSize: 13, color: C.g500, height: 1.5)),
      ])));
  }
}

class PaymentScheduleScreen extends StatelessWidget {
  const PaymentScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final payments = Store().project['payments'] as List;
    return Scaffold(appBar: AppBar(title: const Text('Payment Schedule')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ...payments.map((p) {
          final paid = p['status'] == 'paid';
          final due = p['status'] == 'due';
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: paid ? C.green.withOpacity(0.04) : (due ? C.orangeLt : C.white),
              border: Border.all(color: paid ? C.green : (due ? C.orange : C.g200)),
              borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: paid ? C.greenLt : (due ? C.orangeLt : C.g100)),
                child: Icon(paid ? Icons.check : (due ? Icons.warning_amber : Icons.schedule), size: 16,
                  color: paid ? C.green : (due ? C.orange : C.g500))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['stage'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(fmt(p['amt']), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                if (p['date'] != null) Text(p['date'], style: const TextStyle(fontSize: 11, color: C.g500)),
              ])),
              if (due) GestureDetector(onTap: () => showToast(context, 'Payment flow'),
                child: const Text('Pay Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.orange)))
              else if (paid) Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check_circle, size: 12, color: C.green), const SizedBox(width: 4),
                const Text('Paid', style: TextStyle(fontSize: 11, color: C.green, fontWeight: FontWeight.w600))])
              else const Text('Upcoming', style: TextStyle(fontSize: 11, color: C.g500)),
            ]),
          );
        }),
      ]));
  }
}

// ─────────────────────────────────────────────
// MONITOR SCREEN (FULL WIREFRAME)
// ─────────────────────────────────────────────
class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    final m = s.monitor;
    final a = s.amc;
    final roiPct = ((m['roi']['saved'] / m['roi']['invested']) * 100).round().clamp(0, 100);

    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [const Icon(Icons.wb_sunny, size: 22, color: C.orange), const SizedBox(width: 8),
        const Text('My Plant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))]),
      const SizedBox(height: 4),
      Text(s.project['name'], style: const TextStyle(fontSize: 13, color: C.g500)),
      const SizedBox(height: 16),

      // LIVE GENERATION
      Container(padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Text('${m['kw']}', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700, color: C.orange, height: 1)),
          const Text('kW', style: TextStyle(fontSize: 16, color: C.g500)),
          const SizedBox(height: 6),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('Generating Now', style: TextStyle(fontSize: 12, color: C.green, fontWeight: FontWeight.w600)),
          ]),
        ])),
      const SizedBox(height: 12),
      btnGhost('View Detailed Analytics', icon: Icons.bar_chart, small: true, onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()))),
      const SizedBox(height: 16),

      // TODAY'S SUMMARY
      Row(children: [
        statBox('${m['todayKwh']}', 'kWh', 'Generated'),
        const SizedBox(width: 8),
        statBox('${m['self']}', 'kWh', 'Self Used'),
        const SizedBox(width: 8),
        statBox('${m['grid']}', 'kWh', 'Exported'),
      ]),
      const SizedBox(height: 16),

      // SAVINGS TICKER
      sectionHeader('Savings', icon: Icons.account_balance_wallet),
      Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: C.orangeLt, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.orange.withOpacity(0.15))),
        child: Row(children: [
          _savCol('Today', fmt(m['savToday'])),
          Container(width: 1, height: 28, color: C.orange.withOpacity(0.2)),
          _savCol('This Month', fmt(m['savMonth'])),
          Container(width: 1, height: 28, color: C.orange.withOpacity(0.2)),
          _savCol('Since Install', fmt(m['savSinceInstall'])),
        ])),

      // SYSTEM HEALTH
      sectionHeader('System Health', icon: Icons.shield),
      Row(children: [
        _healthChip(Icons.wb_sunny, 'Panels ✓'),
        const SizedBox(width: 8),
        _healthChip(Icons.power, 'Inverter ✓'),
        const SizedBox(width: 8),
        _healthChip(Icons.bolt, 'Grid ✓'),
      ]),
      const SizedBox(height: 12),

      // BATTERY
      cardWidget(child: Column(children: [
        Row(children: [
          const Icon(Icons.battery_charging_full, size: 18, color: C.orange),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Battery', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${m['battery']['pct']}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            progressBar(m['battery']['pct'] / 100, color: m['battery']['pct'] > 50 ? C.green : C.amber),
            const SizedBox(height: 4),
            Text('${m['battery']['status']} · Health: ${m['battery']['health']}', style: const TextStyle(fontSize: 11, color: C.g500)),
          ])),
        ]),
        const SizedBox(height: 8),
        if ((m['alerts'] as List).isEmpty)
          Row(children: [const Icon(Icons.check_circle, size: 12, color: C.green), const SizedBox(width: 4),
            const Text('No active alerts', style: TextStyle(fontSize: 11, color: C.green))]),
      ])),

      // MY INSTALLED SYSTEM
      sectionHeader('My Installed System', icon: Icons.memory),
      cardWidget(child: Column(children: [
        infoRow('System', '${m['system']['capacity']} Rooftop Solar'),
        infoRow('Brand', m['system']['brand']),
        infoRow('Panels', m['system']['panels']),
        infoRow('Inverter', m['system']['inverter']),
        infoRow('Installed', m['system']['installedDate']),
        infoRow('Warranty', m['system']['warranty']),
      ])),

      // MONTHLY SAVINGS TABLE
      sectionHeader('Monthly Savings', icon: Icons.table_chart),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
        headingRowColor: WidgetStateColor.resolveWith((_) => C.g50),
        columnSpacing: 16, dataRowMinHeight: 36, dataRowMaxHeight: 36, headingRowHeight: 36,
        columns: const [
          DataColumn(label: Text('Mon', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
          DataColumn(label: Text('Gen.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
          DataColumn(label: Text('Used', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
          DataColumn(label: Text('Exp.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
          DataColumn(label: Text('Savings', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
          DataColumn(label: Text('Cumul.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.g500))),
        ],
        rows: (m['monthly'] as List).map<DataRow>((r) => DataRow(cells: [
          DataCell(Text(r['mon'], style: const TextStyle(fontSize: 11))),
          DataCell(Text('${r['gen']}', style: const TextStyle(fontSize: 11))),
          DataCell(Text('${r['consumed']}', style: const TextStyle(fontSize: 11))),
          DataCell(Text('${r['exported']}', style: const TextStyle(fontSize: 11))),
          DataCell(Text(fmt(r['savings']), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.green))),
          DataCell(Text(fmt(r['cumulative']), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
        ])).toList(),
      )),
      const SizedBox(height: 16),

      // ROI TRACKER
      sectionHeader('ROI Tracker', icon: Icons.trending_up),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Payback Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('$roiPct%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.orange)),
          ]),
          const SizedBox(height: 8),
          progressBar(roiPct / 100),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${fmt(m['roi']['saved'])} saved', style: const TextStyle(fontSize: 11, color: C.g500)),
            Text('Target: ${fmt(m['roi']['invested'])}', style: const TextStyle(fontSize: 11, color: C.g500)),
          ]),
          const Divider(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Projected Payback', style: TextStyle(fontSize: 12, color: C.g500)),
            Text("${m['roi']['projectedDate']} (~${m['roi']['paybackYears']} yrs)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ])),
      const SizedBox(height: 12),
      btnSecondary('View Full ROI Report', icon: Icons.download, small: true, onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RoiScreen()))),
      const SizedBox(height: 16),

      // ENVIRONMENTAL IMPACT
      sectionHeader('Environmental Impact', icon: Icons.eco),
      Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: C.greenLt, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.green.withOpacity(0.15))),
        child: Row(children: [
          _envCol(Icons.eco, 'CO₂ Saved', '${m['co2']} kg'),
          _envCol(Icons.park, 'Trees Equiv.', '${m['trees']}'),
          _envCol(Icons.water_drop, 'Water Saved', '${m['waterSaved']} L'),
        ])),
      btnGhost('Share My Green Impact', icon: Icons.share, small: true, onTap: () => showToast(context, 'Impact shared!')),
      const SizedBox(height: 16),

      // REFERRAL
      sectionHeader('Referral Program', icon: Icons.card_giftcard),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.orangeLt, Color(0xFFFED7AA)]),
          border: Border.all(color: C.orange.withOpacity(0.2), width: 1.5), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.card_giftcard, size: 18, color: C.orange), const SizedBox(width: 6),
            const Text('Refer & Earn ₹5,000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 4),
          const Text('Share your solar experience and earn rewards', style: TextStyle(fontSize: 12, color: C.g500)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(color: C.white, border: Border.all(color: C.orange, width: 1.5, strokeAlign: BorderSide.strokeAlignCenter), borderRadius: BorderRadius.circular(8)),
            child: Text('SOLAR${s.user['phone'].toString().substring(6)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.orange, letterSpacing: 1))),
          const SizedBox(height: 10),
          btnPrimary('View My Referrals', icon: Icons.arrow_forward, small: true, onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen()))),
        ])),
      const SizedBox(height: 16),

      // AMC MANAGEMENT
      sectionHeader('AMC Management', icon: Icons.build),
      if (a['active'] == true) ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(12),
            border: const Border(left: BorderSide(color: C.green, width: 3), top: BorderSide(color: C.g200), right: BorderSide(color: C.g200), bottom: BorderSide(color: C.g200))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              badge('Active', icon: Icons.check_circle),
              Text('${a['plan']} Plan', style: const TextStyle(fontSize: 11, color: C.g500)),
            ]),
            const SizedBox(height: 8),
            infoRow('Coverage', a['coverage']),
            infoRow('Start', a['start']),
            infoRow('Expiry', a['expiry']),
            Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Visits Remaining', style: TextStyle(fontSize: 11, color: C.g500)),
              Text('${a['remaining']} of ${a['visits']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: C.orange)),
            ])),
            btnPrimary('Schedule Maintenance', icon: Icons.calendar_today, small: true, onTap: () => showToast(context, 'Maintenance request submitted!')),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('Maintenance History', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...(a['history'] as List).map((h) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: h['status'] == 'Completed' ? C.green : C.amber, width: 3),
              top: BorderSide(color: C.g200), right: BorderSide(color: C.g200), bottom: BorderSide(color: C.g200))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${h['type']} Visit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              badge(h['status'], bg: h['status'] == 'Completed' ? C.greenLt : C.amberLt,
                fg: h['status'] == 'Completed' ? const Color(0xFF065F46) : const Color(0xFF92400E)),
            ]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.calendar_today, size: 11, color: C.g500), const SizedBox(width: 4),
              Text('${h['date']}${h['tech'] != null ? ' · ${h['tech']}' : ''}', style: const TextStyle(fontSize: 11, color: C.g500))]),
            const SizedBox(height: 4),
            Text(h['summary'], style: const TextStyle(fontSize: 11, color: C.g500)),
          ]),
        )),
      ] else
        cardWidget(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('No Active AMC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('Protect your solar investment with an AMC', style: TextStyle(fontSize: 11, color: C.g500)),
          const SizedBox(height: 8),
          btnPrimary('Explore AMC Plans', icon: Icons.shield, small: true, onTap: () => showToast(context, 'AMC plans coming soon!')),
        ])),

      const SizedBox(height: 32),
    ]);
  }

  Widget _savCol(String label, String value) {
    return Expanded(child: Column(children: [
      Text(label, style: const TextStyle(fontSize: 11, color: C.g500)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: C.orange)),
    ]));
  }

  Widget _healthChip(IconData icon, String label) {
    return Expanded(child: Container(padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: C.greenLt, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 14, color: const Color(0xFF065F46)), const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
      ])));
  }

  Widget _envCol(IconData icon, String label, String value) {
    return Expanded(child: Column(children: [
      Icon(icon, size: 12, color: const Color(0xFF065F46)),
      Text(label, style: const TextStyle(fontSize: 11)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]));
  }
}

// ─────────────────────────────────────────────
// ANALYTICS
// ─────────────────────────────────────────────
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = Store().monitor;
    final d = (m['weekly'] as List).cast<double>();
    final mx = d.reduce(max);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final total = d.reduce((a, b) => a + b);

    return Scaffold(appBar: AppBar(title: const Text('Analytics')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        chipRow(['Day', 'Week', 'Month', 'Year'], 'Week', (v) => showToast(context, '$v view selected')),
        const SizedBox(height: 16),

        // BAR CHART
        Container(height: 180, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) => Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(d[i].toStringAsFixed(1), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: C.g500)),
              const SizedBox(height: 4),
              Container(height: (d[i] / mx) * 100, decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [C.orange, C.orangeDk]),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
              const SizedBox(height: 4),
              Text(days[i], style: const TextStyle(fontSize: 9, color: C.g300)),
            ]),
          ))))),
        const SizedBox(height: 16),

        Row(children: [
          statBox(total.toStringAsFixed(1), 'kWh', 'This Week'),
          const SizedBox(width: 8),
          statBox((total / 7).toStringAsFixed(1), 'kWh', 'Daily Avg'),
        ]),
        const SizedBox(height: 16),

        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.greenLt, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [Row(children: [const Icon(Icons.eco, size: 12), const SizedBox(width: 4), const Text('CO₂', style: TextStyle(fontSize: 11))]),
              Text('${m['co2']} kg', style: const TextStyle(fontWeight: FontWeight.w700))]),
            Column(children: [Row(children: [const Icon(Icons.park, size: 12), const SizedBox(width: 4), const Text('Trees', style: TextStyle(fontSize: 11))]),
              Text('${m['trees']}', style: const TextStyle(fontWeight: FontWeight.w700))]),
          ])),
        const SizedBox(height: 16),
        btnGhost('Share Green Impact', icon: Icons.share, onTap: () => showToast(context, 'Impact shared!')),
      ]));
  }
}

// ─────────────────────────────────────────────
// ROI
// ─────────────────────────────────────────────
class RoiScreen extends StatelessWidget {
  const RoiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = Store().monitor;
    return Scaffold(appBar: AppBar(title: const Text('Savings & ROI')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: C.g50, border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Row(children: [const Icon(Icons.trending_up, size: 16, color: C.orange), const SizedBox(width: 4),
              const Text('Payback Progress', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
            const SizedBox(height: 12),
            progressBar(0.15),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${fmt(2340)} saved', style: const TextStyle(fontSize: 11, color: C.g500)),
              Text('Target: ${fmt(87000)}', style: const TextStyle(fontSize: 11, color: C.g500)),
            ]),
          ])),
        const SizedBox(height: 16),
        const Text('Monthly Breakdown', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: WidgetStateColor.resolveWith((_) => C.g50),
          columns: const [DataColumn(label: Text('Month')), DataColumn(label: Text('Gen.')), DataColumn(label: Text('Export')), DataColumn(label: Text('Savings'))],
          rows: (m['monthly'] as List).map<DataRow>((r) => DataRow(cells: [
            DataCell(Text(r['mon'])), DataCell(Text('${r['gen']} kWh')), DataCell(Text('${r['exported']} kWh')),
            DataCell(Text(fmt(r['savings']), style: const TextStyle(fontWeight: FontWeight.w600))),
          ])).toList(),
        )),
        const SizedBox(height: 16),
        cardWidget(child: Column(children: [
          Row(children: [const Icon(Icons.receipt, size: 16), const SizedBox(width: 4),
            const Text('Investment Summary', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 8),
          infoRow('Total Cost', fmt(165000)),
          infoRow('Subsidy', '-${fmt(78000)}', valueColor: C.green),
          infoRow('Net Investment', fmt(87000)),
          const Divider(),
          infoRow('Saved to Date', fmt(6660), valueColor: C.orange),
        ])),
        const SizedBox(height: 16),
        btnSecondary('Download Report', icon: Icons.download, onTap: () => showToast(context, 'Report downloaded!')),
      ]));
  }
}

// ─────────────────────────────────────────────
// PROFILE & SETTINGS
// ─────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Center(child: Container(width: 56, height: 56,
        decoration: const BoxDecoration(color: C.orange, shape: BoxShape.circle),
        child: Center(child: Text(s.user['name'][0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.white))))),
      const SizedBox(height: 8),
      Center(child: Text(s.user['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
      Center(child: Text(s.user['email'], style: const TextStyle(fontSize: 12, color: C.g500))),
      const SizedBox(height: 20),
      contentListItem(icon: Icons.person, title: 'Account Details', subtitle: 'Name, email, phone, address',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditScreen()))),
      contentListItem(icon: Icons.settings, title: 'Settings', subtitle: 'Notifications, privacy, language',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
      contentListItem(icon: Icons.help_outline, title: 'Help & Support', subtitle: 'FAQs, raise a ticket, contact',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()))),
      contentListItem(icon: Icons.chat_bubble_outline, title: 'Feedback', subtitle: 'Rate your experience',
        onTap: () => showToast(context, 'Feedback submitted!')),
      contentListItem(icon: Icons.card_giftcard, title: 'Referral Program', subtitle: 'Earn ₹5,000 per referral',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen()))),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () {
          s.user['loggedIn'] = false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
        style: ElevatedButton.styleFrom(backgroundColor: C.redLt, foregroundColor: C.red),
        child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.logout, size: 18), const SizedBox(width: 8), const Text('Logout')]),
      )),
      const SizedBox(height: 12),
      const Center(child: Text('Aerem D2C v1.0.0', style: TextStyle(fontSize: 11, color: C.g500))),
    ]);
  }
}

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    return Scaffold(appBar: AppBar(title: const Text('Account Details')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Container(width: 56, height: 56,
          decoration: const BoxDecoration(color: C.orange, shape: BoxShape.circle),
          child: Center(child: Text(s.user['name'][0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.white))))),
        const SizedBox(height: 16),
        _field('FULL NAME', s.user['name']),
        _field('EMAIL', s.user['email']),
        _field('PHONE', '+91 ${s.user['phone']}', readOnly: true, suffix: badge('Verified', icon: Icons.check_circle)),
        _field('ADDRESS', s.user['address']),
        _field('PIN CODE', s.user['pin']),
        const SizedBox(height: 12),
        btnPrimary('Save Changes', icon: Icons.save, onTap: () { showToast(context, 'Profile updated!'); Navigator.pop(context); }),
      ]));
  }

  Widget _field(String label, String value, {bool readOnly = false, Widget? suffix}) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: TextField(controller: TextEditingController(text: value), readOnly: readOnly,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.g300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.orange)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
        if (suffix != null) ...[const SizedBox(width: 8), suffix],
      ]),
    ]));
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final st = Store().user['settings'] as Map;
    return Scaffold(appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Notifications', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _toggle('Push Notifications', st['push'] ?? true, (v) => setState(() => st['push'] = v)),
        _toggle('Email Notifications', st['email'] ?? true, (v) => setState(() => st['email'] = v)),
        _toggle('SMS Notifications', st['sms'] ?? false, (v) => setState(() => st['sms'] = v)),
        const Divider(height: 32),
        const Text('Preferences', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('LANGUAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        DropdownButtonFormField(value: 'English',
          items: ['English', 'हिन्दी', 'मराठी'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {}, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const Divider(height: 32),
        contentListItem(icon: Icons.description, title: 'Terms & Conditions', subtitle: ''),
        contentListItem(icon: Icons.lock, title: 'Privacy Policy', subtitle: ''),
        const SizedBox(height: 20),
        const Center(child: Text('Aerem D2C v1.0.0', style: TextStyle(fontSize: 11, color: C.g500))),
        const SizedBox(height: 8),
        Center(child: GestureDetector(
          onTap: () => showToast(context, 'Account deletion requested'),
          child: const Text('Delete Account', style: TextStyle(fontSize: 13, color: C.red, fontWeight: FontWeight.w600)))),
      ]));
  }

  Widget _toggle(String label, bool value, Function(bool) onChanged) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Switch(value: value, onChanged: onChanged, activeColor: C.orange),
      ]));
  }
}

// ─────────────────────────────────────────────
// SUPPORT
// ─────────────────────────────────────────────
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search, size: 16, color: C.g500), hintText: 'Search FAQs...',
          filled: true, fillColor: C.g50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.g200)))),
        const SizedBox(height: 16),
        ...[
          ['How long does installation take?', 'Typically 15-30 days from order confirmation to commissioning.'],
          ['How does the subsidy work?', 'Under PM Surya Ghar Yojana, get up to ₹78,000 for systems up to 3kW.'],
          ['What if my system underperforms?', 'AeROC monitors 24/7. If generation drops below 85%, you\'ll get an alert.'],
          ['How do I make payments?', 'Staged payments: 20% advance, 70% before installation, 10% after commissioning.'],
        ].map((faq) => _faqItem(faq[0], faq[1])),
        const Divider(height: 32),
        const Text('Raise a Ticket', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('ISSUE TYPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        DropdownButtonFormField(items: ['Installation', 'Payment', 'Subsidy', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {}, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 16),
        const Text('DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.g500, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Describe your issue...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height: 16),
        btnPrimary('Submit Ticket', icon: Icons.send, onTap: () => showToast(context, 'Ticket submitted: TKT-${1000 + Random().nextInt(9000)}')),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: btnSecondary('Call', icon: Icons.phone, small: true, onTap: () => showToast(context, 'Calling...'))),
          const SizedBox(width: 8),
          Expanded(child: btnSecondary('WhatsApp', icon: Icons.chat, small: true, onTap: () => showToast(context, 'Opening WhatsApp...'))),
        ]),
      ]));
  }

  Widget _faqItem(String q, String a) {
    return StatefulBuilder(builder: (context, setState) {
      bool open = false;
      return Container(margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(border: Border.all(color: C.g200), borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          InkWell(onTap: () => setState(() => open = !open),
            child: Padding(padding: const EdgeInsets.all(12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(q, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                Icon(open ? Icons.expand_less : Icons.expand_more, size: 16, color: C.g300),
              ]))),
          if (open) Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(a, style: const TextStyle(fontSize: 12, color: C.g500, height: 1.5))),
        ]));
    });
  }
}

// ─────────────────────────────────────────────
// REFERRAL
// ─────────────────────────────────────────────
class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Store();
    return Scaffold(appBar: AppBar(title: const Text('Refer & Earn')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.g900, Color(0xFF262626)]), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            const Text('₹5,000', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: C.orange)),
            Text('per successful referral', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
          ])),
        const SizedBox(height: 16),
        const Center(child: Text('Your Referral Code', style: TextStyle(fontSize: 12, color: C.g500))),
        const SizedBox(height: 8),
        Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.orangeLt, Color(0xFFFED7AA)]),
            border: Border.all(color: C.orange, width: 1.5, strokeAlign: BorderSide.strokeAlignCenter), borderRadius: BorderRadius.circular(8)),
          child: Text(s.user['referralCode'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.orange, letterSpacing: 1)))),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: btnPrimary('WhatsApp', icon: Icons.chat, small: true, onTap: () => showToast(context, 'Shared!'))),
          const SizedBox(width: 8),
          Expanded(child: btnSecondary('SMS', icon: Icons.smartphone, small: true, onTap: () => showToast(context, 'SMS sent!'))),
          const SizedBox(width: 8),
          Expanded(child: btnGhost('Copy', icon: Icons.copy, small: true, onTap: () {
            Clipboard.setData(ClipboardData(text: s.user['referralCode']));
            showToast(context, 'Copied!');
          })),
        ]),
        const SizedBox(height: 20),
        const Text('How it Works', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...['Share your code with friends', 'They get ₹2,000 off their purchase', 'You earn ₹5,000 once installed'].asMap().entries.map((e) =>
          cardWidget(child: Row(children: [
            badge('${e.key + 1}', bg: C.orangeLt, fg: C.orangeDk), const SizedBox(width: 12),
            Text(e.value, style: const TextStyle(fontSize: 12)),
          ]))),
        const SizedBox(height: 12),
        const Text('Your Referrals', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...s.referrals.map((r) => cardWidget(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(r['status'] == 'installed' ? 'Installed ✓' : 'Pending', style: const TextStyle(fontSize: 11, color: C.g500)),
          ]),
          r['reward'] > 0 ? Text(fmt(r['reward']), style: const TextStyle(fontWeight: FontWeight.w700, color: C.green))
            : badge('Pending', bg: C.amberLt, fg: const Color(0xFF92400E)),
        ]))),
      ]));
  }
}

// ─────────────────────────────────────────────
// NOTIFICATIONS
// ─────────────────────────────────────────────
class NotifsScreen extends StatefulWidget {
  const NotifsScreen({super.key});
  @override State<NotifsScreen> createState() => _NotifsState();
}

class _NotifsState extends State<NotifsScreen> {
  String _cat = 'All';
  @override
  Widget build(BuildContext context) {
    final s = Store();
    final filtered = _cat == 'All' ? s.notifs : s.notifs.where((n) => n['cat'] == _cat).toList();
    return Scaffold(appBar: AppBar(title: const Text('Notifications')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: chipRow(['All', 'Project', 'Payment', 'Offers'], _cat, (v) => setState(() => _cat = v))),
        Expanded(child: filtered.isEmpty
          ? const Center(child: Text('No notifications', style: TextStyle(color: C.g500)))
          : ListView.builder(itemCount: filtered.length, itemBuilder: (_, i) {
              final n = filtered[i];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(bottom: const BorderSide(color: C.g100),
                    left: !(n['read'] as bool) ? const BorderSide(color: C.orange, width: 3) : BorderSide.none)),
                child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: const BoxDecoration(color: C.orangeLt, shape: BoxShape.circle),
                    child: Icon(n['icon'] as IconData, size: 18, color: C.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(n['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(n['desc'], style: const TextStyle(fontSize: 11, color: C.g500)),
                    const SizedBox(height: 4),
                    Text(n['time'], style: const TextStyle(fontSize: 10, color: C.g300)),
                  ])),
                ]),
              );
            })),
      ]));
  }
}

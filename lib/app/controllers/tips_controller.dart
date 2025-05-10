import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/tip.dart';

class TipsController extends GetxController {
  final _box = GetStorage();

  final Duration reappearAfter = const Duration(minutes: 5);

  RxMap<String, int> marcados = <String, int>{}.obs;

  final List<Tip> allTips = [
    Tip(id: 'cuello',  text: 'Estira el cuello cada 2 h', icon: Icons.accessibility_new),
    Tip(id: 'agua',    text: 'Toma un vaso de agua', icon: Icons.local_drink),
    Tip(id: 'vista',   text: 'Mira a lo lejos durante 20 s', icon: Icons.remove_red_eye),
    Tip(id: 'postura', text: 'Corrige tu postura', icon: Icons.chair),
    Tip(id: 'caminar', text: 'Camina 5 min cada hora', icon: Icons.directions_walk),
  ];

  @override
  void onInit() {
    super.onInit();

    final dynamic raw = _box.read('tips_marcados');
    if (raw is Map) {
      raw.forEach((key, value) {
        final k = key.toString();
        final v = value is int
            ? value
            : int.tryParse(value.toString()) ?? 0;
        if (v > 0) {
          marcados[k] = v;
        }
      });
    }

    _purgeExpired();
  }

  void marcarComoLeido(String id) {
    marcados[id] = DateTime.now().millisecondsSinceEpoch;
    _save();
  }

  void noMeInteresa(String id) {
    marcados[id] = DateTime.now().millisecondsSinceEpoch;
    _save();
  }

  void _save() {
    _box.write('tips_marcados', marcados);
  }

  void _purgeExpired() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expired = marcados.entries
        .where((e) => e.value + reappearAfter.inMilliseconds < now)
        .map((e) => e.key)
        .toList();

    if (expired.isNotEmpty) {
      for (var id in expired) {
        marcados.remove(id);
      }
      _save();
    }
  }

  List<Tip> get tipsVisibles {
    _purgeExpired();
    return allTips.where((t) => !marcados.containsKey(t.id)).toList();
  }

  void resetTips() {
    marcados.clear();
    _save();
  }
}

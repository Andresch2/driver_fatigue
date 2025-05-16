import 'package:get/get.dart';

import '../data/models/tip.dart';

class TipsController extends GetxController {
  final RxList<Tip> tipsVisibles = <Tip>[].obs;

  @override
  void onInit() {
    super.onInit();
    tipsVisibles.assignAll([
      Tip(
        id: 'concentracion',
        title: 'Pérdida de concentración',
        text: 'En un episodio de este tipo, la pérdida de concentración es una de las señas más '
            'reconocibles, la cual puede ir acompañada de otros elementos como picor de ojos, '
            'visión borrosa o parpadeo continuado. Todos estos aspectos dan como resultado que '
            'el conductor presente incomodidad y, por ello, necesite estar acomodándose '
            'constantemente en el asiento.',
        imagePath: 'assets/images/concentracion.png',
      ),
      Tip(
        id: 'deshidratacion',
        title: 'Deshidratación',
        text: 'La deshidratación es, por su parte, otro de los síntomas asociados a la fatiga '
            'y somnolencia.',
        imagePath: 'assets/images/deshidratacion.png',
      ),
      Tip(
        id: 'paradas',
        title: 'Para cada 2 horas',
        text: 'En largos recorridos es vital que, al menos, efectúes paradas cada 2 horas o al '
            'menor síntoma de cansancio. Procura que cada parada dure, como mínimo, 15 minutos.',
        imagePath: 'assets/images/paradas.png',
      ),
      Tip(
        id: 'agua',
        title: 'Bebe agua o refresco',
        text: 'En carretera, la hidratación es fundamental, sobre todo en verano. Ten siempre a '
            'mano un refresco y bebe con frecuencia aunque no sientas sed.',
        imagePath: 'assets/images/agua.png',
      ),
      Tip(
        id: 'estiramientos',
        title: 'Realiza estiramientos',
        text: 'Cada vez que te bajes del coche, realiza ejercicios de estiramiento de articulaciones.',
        imagePath: 'assets/images/estiramientos.png',
      ),
      Tip(
        id: 'comidas',
        title: 'Evita comidas abundantes',
        text: 'Existen alimentos para combatir el cansancio, sobre todo aquellos que son ricos en '
            'fibra y minerales como el aguacate o el plátano. También hay otros como el cacao, '
            'que tienen propiedades estimulantes.',
        imagePath: 'assets/images/comidas.png',
      ),
      Tip(
        id: 'cierre',
        title: 'Consejo final',
        text: 'Saber cómo combatir el cansancio te ayudará a sentirte mejor mientras conduces, '
            'y esto facilitará que puedas llegar a tu destino sin ningún sobresalto.',
        imagePath: 'assets/images/agua.png',
      ),
    ]);
  }
}

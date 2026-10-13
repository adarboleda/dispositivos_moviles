import 'package:flutter/material.dart';

/// Paleta inspirada en el diseño "Travo".
class TravoColores {
  static const morado = Color(0xFF6155CC);
  static const moradoClaro = Color(0xFF8F67E8);
  static const fondo = Color(0xFFF3F2FB);
  static const texto = Color(0xFF313131);
  static const textoSuave = Color(0xFF838383);
  static const naranja = Color(0xFFFE9C5E);
  static const rosa = Color(0xFFF77777);
  static const turquesa = Color(0xFF3EC8BC);
  static const amarillo = Color(0xFFFFC107);
  static const verde = Color(0xFF2BB673);
  static const error = Color(0xFFE5484D);

  static const degradado = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [moradoClaro, morado],
  );

  /// Colores de acento para los íconos del menú (fondo pastel + ícono).
  static const acentos = [naranja, rosa, turquesa, moradoClaro, amarillo];
}

ThemeData temaTravo() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: TravoColores.morado,
      primary: TravoColores.morado,
      secondary: TravoColores.naranja,
      error: TravoColores.error,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: TravoColores.fondo,
  );

  final pildora = RoundedRectangleBorder(borderRadius: BorderRadius.circular(30));
  const textoBoton = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: TravoColores.texto,
      displayColor: TravoColores.texto,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: TravoColores.textoSuave, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: TravoColores.morado, fontWeight: FontWeight.w600),
      prefixStyle: const TextStyle(color: TravoColores.texto, fontWeight: FontWeight.w600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEAE8F5)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: TravoColores.morado, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: TravoColores.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: TravoColores.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TravoColores.morado,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFCFCBEF),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 52),
        shape: pildora,
        textStyle: textoBoton,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: TravoColores.morado,
        backgroundColor: const Color(0xFFE9E6FA),
        side: BorderSide.none,
        minimumSize: const Size(0, 52),
        shape: pildora,
        textStyle: textoBoton,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: TravoColores.naranja,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: StadiumBorder(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE9E6FA),
      labelStyle: const TextStyle(color: TravoColores.morado, fontWeight: FontWeight.w600),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: const TextStyle(
        color: TravoColores.morado,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      dataTextStyle: const TextStyle(color: TravoColores.texto, fontSize: 14),
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF1EFFC)),
      dividerThickness: 0.6,
      horizontalMargin: 14,
      columnSpacing: 22,
    ),
  );
}

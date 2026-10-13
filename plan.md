```markdown
# Plan: App Flutter para NRC 36873 (ejercicios 6 al 10)

## Contexto
Tarea de la materia "Resolución de Problemas 1.1 - Creación y ejecución de una Activity". Hay que desarrollar UNA sola aplicación móvil en Flutter y Dart que resuelva los ejercicios 6 al 10 de mi NRC (36873). La app debe tener:
- Una pantalla principal (menú) desde la que se accede a cada ejercicio en una pantalla independiente.
- Navegación con el sistema de rutas de Flutter (rutas nombradas), con retorno al menú.
- Estructura organizada: `main.dart` separado, lógica de los ejercicios separada, y pantallas separadas.

Trabaja en español (comentarios, nombres de texto de la UI y mensajes).

## Convenciones de código (seguir el estilo de mis archivos existentes)
Mis archivos actuales son `main.dart`, `area_terreno.dart`, `calculadora_pantalla.dart` y `calculadora_logica.dart`. Respeta este patrón:
- La lógica va en una clase pura de Dart dentro de `logica/`, sin depender de Flutter. Ejemplo de referencia: `CalculadoraLogica` en `logica/calculadora_logica.dart`.
- La pantalla es un `StatefulWidget` con `TextEditingController` para cada campo, con `dispose()`, y un método por acción que lee los campos, llama a la lógica y hace `setState`. Ejemplo de referencia: `CalculadoraPantalla`.
- Comentarios `// LOGICA` y `// Diseño` dentro de las pantallas.
- AppBar con `backgroundColor: Colors.blue`, campos con `OutlineInputBorder`, y `SingleChildScrollView` + `Column` con `CrossAxisAlignment.stretch`.
- Para dinero y decimales, mostrar con `toStringAsFixed(2)`, no con `toString()`.
- Los nombres de clases de pantalla terminan en `Pantalla` y los de lógica en `Logica`.

## Estructura de carpetas (crear)
```
lib/
├── main.dart                     # MyApp: MaterialApp con routes y home = MenuPrincipal
├── rutas.dart                    # final rutas = { '/ej06': (_) => ..., ... }
├── menu/
│   └── menu_principal.dart       # Lista de los 5 ejercicios (cards) que navegan con pushNamed
├── logica/
│   ├── impuesto_logica.dart      # ej. 6
│   ├── banco_logica.dart         # ej. 7 (incluye modelo Cliente)
│   ├── ahorro_logica.dart        # ej. 8
│   ├── adivina_logica.dart       # ej. 9
│   └── intervalo_logica.dart     # ej. 10
├── Pantallas/                    # Usar el mismo nombre de carpeta en todo el proyecto (ver nota)
│   ├── impuesto_pantalla.dart
│   ├── banco_pantalla.dart
│   ├── ahorro_pantalla.dart
│   ├── adivina_pantalla.dart
│   └── intervalo_pantalla.dart
└── (existentes) calculadora_logica.dart, calculadora_pantalla.dart, area_terreno.dart
test/
└── logica_test.dart
```
Nota: hoy existe `logica/` (minúscula) y `Pantallas/` (mayúscula), y `main.dart` importa `Pantallas/calculadora_pantalla.dart`. Unifica todo en minúsculas (`pantallas/`) y actualiza los imports, o deja `Pantallas/` tal como está. Elige una opción y aplícala en todo el proyecto.

Los archivos de Calculadora y Área de terreno no forman parte de los ejercicios 6 al 10. Mantenlos como referencia de estilo. Incluirlos en el menú es opcional y no debe afectar a los ejercicios asignados.

## Menú y rutas
- `main.dart`: `MaterialApp(debugShowCheckedModeBanner: false, title: 'Ejercicios NRC 36873', theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)), home: const MenuPrincipal(), routes: rutas)`.
- `rutas.dart`: un `Map<String, WidgetBuilder>` con `/ej06`, `/ej07`, `/ej08`, `/ej09`, `/ej10`.
- `menu_principal.dart`: AppBar "Ejercicios NRC 36873" y una lista de cards con id, título y descripción corta. Al tocar una card, `Navigator.pushNamed(context, ruta)`. Recorre una lista de registro para que agregar un ejercicio sea agregar una línea.
- Cada pantalla de ejercicio regresa con el botón atrás del AppBar.

## Ejercicio 6: impuesto por categoría de vehículo
Enunciado: el gerente de una compañía automotriz quiere determinar el impuesto que va a pagar por cada uno de los automóviles que posee, además del total por cada categoría y el total de todos los vehículos. Clasificación: clave 1 paga 10% del valor, clave 2 paga 7%, clave 3 paga 5%.

- Lógica (`ImpuestoLogica`): `static const tasas = {1: 0.10, 2: 0.07, 3: 0.05}`, método `impuesto(double valor, int clave)`, y acumuladores por clave y total general.
- Pantalla: campo para N (número de vehículos). Luego un formulario por vehículo con valor y clave. Al calcular, tabla con el impuesto de cada vehículo, subtotal por clave y total general.
- Validación: clave fuera de 1 a 3 y valores negativos o vacíos se muestran como error, sin romper el cálculo.

## Ejercicio 7: banco "Bandido de peluche" (el más complejo)
Enunciado: el banco quiere calcular para cada uno de sus N clientes su saldo actual, su pago mínimo y su pago para no generar intereses. Quiere también el monto ganado por concepto de intereses con los clientes morosos. Datos por cliente: saldo anterior, monto de las compras y pago depositado en el corte anterior. Pago mínimo = 15% del saldo actual. Pago para no generar intereses = 85% del saldo actual. El saldo actual debe incluir 12% de intereses causados por no hacer el pago mínimo, y $200 de multa por el mismo motivo.

Criterio propuesto (confirmar con el docente y dejar comentado en el código como supuesto):
1. `base = saldoAnterior - pagoDepositado + compras`
2. Moroso si `pagoDepositado < pagoMinimoAnterior`. Si no hay corte anterior, usar 15% del saldo anterior como pago mínimo de referencia.
3. Si es moroso: `interes = 0.12 × base` y `multa = 200`. Si no es moroso, ambos son 0.
4. `saldoActual = base + interes + multa`
5. `pagoMinimo = 0.15 × saldoActual`
6. `pagoSinIntereses = 0.85 × saldoActual`
7. El total de intereses ganados suma solo el `interes` de los clientes morosos.

- Lógica (`BancoLogica` + clase `Cliente` con los tres datos de entrada): método `calcular(Cliente c)` que devuelve un resultado con saldo actual, pago mínimo, pago sin intereses, si es moroso e interés. Método para el total de intereses de una lista.
- Pantalla: campo para N, luego un formulario por cliente (saldo anterior, compras, pago). Tabla de resultados y total de intereses al final.
- Este ejercicio exige diagrama de flujo y pseudocódigo. Esos entregables se hacen fuera de la app, pero la lógica debe reflejar exactamente esos pasos.

## Ejercicio 8: ahorro anual con depósitos variables
Enunciado: determinar cuánto ahorrará una persona en un año si al final de cada mes deposita cantidades variables, y saber cuánto lleva ahorrado cada mes.

- Lógica (`AhorroLogica`): recibe `List<double>` de 12 depósitos, devuelve la lista de saldos acumulados por mes y el total.
- Pantalla: 12 campos numéricos etiquetados con el nombre del mes. Botón "Calcular". Tabla con mes, depósito y saldo acumulado, y el total ahorrado al final.

## Ejercicio 9: adivina el número
Enunciado: la app genera un número aleatorio del 1 al 100. El usuario va introduciendo números y la app responde si el número secreto es mayor o menor, junto con los intentos que le quedan (10 intentos). El programa termina al acertar (indicando en cuántos intentos) o al agotar los intentos (mostrando el número secreto).

- Lógica (`AdivinaLogica`): constructor que recibe un `Random` opcional (para pruebas), genera el número secreto de 1 a 100, lleva el contador de intentos (máximo 10) y el método `intentar(int n)` devuelve un estado: `mayor`, `menor`, `acierto` o `sinIntentos`. Expón también los intentos usados y el número secreto para mostrarlo al final.
- Pantalla: campo numérico (solo enteros del 1 al 100, con validación), botón "Probar", texto con la pista ("El número es mayor/menor"), contador "Te quedan X intentos", y al terminar, mensaje de acierto con el número de intentos o de derrota con el número secreto. Botón "Nuevo juego" que reinicia la lógica.

## Ejercicio 10: intervalo y sumatoria
Enunciado: pedir límite inferior y superior de un intervalo. Si el inferior es mayor que el superior, volver a pedirlos. Luego introducir números hasta introducir 0. Al terminar, mostrar: la suma de los números dentro del intervalo abierto, cuántos números están fuera del intervalo, y si se introdujo algún número igual a alguno de los límites.

- Lógica (`IntervaloLogica`): método `analizar(double lo, double hi, List<double> numeros)` que devuelve suma (estrictamente entre lo y hi), cantidad fuera (menor que lo o mayor que hi) y bandera de igualdad con algún límite. Método `validarLimites(lo, hi)` que devuelve error si `lo > hi`. El 0 es centinela y no se incluye en la lista.
- Pantalla: dos campos para los límites con botón "Aceptar". Si `lo > hi`, mostrar error y mantener al usuario en ese paso. Luego un campo para ingresar números uno por uno con botón "Agregar" y una lista de lo ingresado. Al ingresar 0, mostrar los tres resultados.
- Decisión: el 0 se usa como fin de entrada y no cuenta como dato. Dejarlo comentado en el código.

## Ajustes a código existente (hacerlos si el tiempo lo permite)
1. `calculadora_pantalla.dart`: la validación de números está repetida en las cuatro operaciones. Extraer un método `_leerNumeros()` que devuelva `null` si algún campo no es válido.
2. `calculadora_pantalla.dart`: usar `toStringAsFixed(2)` en lugar de `toString()` para evitar decimales como `0.30000000000000004`.
3. `calculadora_logica.dart`: la división entre cero devuelve `Infinity`. Que la lógica devuelva `null` cuando `b == 0`, y la pantalla muestre el mensaje.
4. `calculadora_logica.dart`: eliminar los alias duplicados `multiplicar` y `dividir`.
5. `area_terreno.dart`: mover la lógica (`area`, `perimetro`, `valor`) a `logica/area_logica.dart`, siguiendo el mismo patrón que la calculadora. Corregir `State<StatefulWidget>` a `State<AreaPantalla>`.
6. `area_terreno.dart`: sacar el precio `500` a una constante con nombre, por ejemplo `precioPorM2`.

## Pruebas (`test/logica_test.dart`)
Probar solo la lógica, sin UI. Ejecutar con `flutter test`.
- Ej. 6: valor 100000 con clave 1 da impuesto 10000. Clave inválida lanza error o se rechaza.
- Ej. 7: un cliente moroso y uno no moroso con valores conocidos. Verificar saldo, pagos y total de intereses.
- Ej. 8: depósitos del 1 al 12 dan total 78 y el saldo de marzo es 6.
- Ej. 9: con número secreto fijo (inyectando un `Random` con semilla o un valor forzado), probar `mayor`, `menor`, `acierto` y `sinIntentos` después de 10 intentos.
- Ej. 10: `lo = 5`, `hi = 10`, números `[3, 5, 7, 10, 12]` dan suma 7, fuera 2 y bandera de límite verdadera. `lo = 10`, `hi = 5` devuelve error.
- Calculadora: división entre cero devuelve `null`.

## Orden de trabajo
1. Crear carpetas, `main.dart`, `rutas.dart` y `menu_principal.dart` con las 5 rutas. Cada pantalla muestra "Pendiente". Verificar que la navegación ida y vuelta funciona.
2. Ej. 6 y 8: lógica, pruebas y pantalla.
3. Ej. 10 y 9: lógica, pruebas y pantalla.
4. Ej. 7: lógica, pruebas y pantalla, con el criterio de morosidad marcado como supuesto.
5. Ajustes de la sección "Ajustes a código existente".
6. Verificar que la app compila (`flutter analyze` sin errores) y probar cada ejercicio en emulador o dispositivo.
7. Al final, resumir qué archivos se crearon y qué supuestos se tomaron, para el reporte.

## Entregables fuera de la app
- Ej. 7: diagrama de flujo y pseudocódigo.
- Capturas de pantalla del menú y de cada ejercicio para el reporte.
- Consultar al docente el criterio de morosidad del ej. 7 y si los ejercicios 6, 8, 9 y 10 también requieren diagramas.

## Criterios de aceptación
- La app compila y ejecuta sin errores.
- El menú principal navega a cada uno de los 5 ejercicios y regresa.
- Cada ejercicio cumple su enunciado, con validación de entradas.
- La lógica está separada de las pantallas y tiene pruebas que pasan.
- El código sigue el estilo de los archivos existentes.
```
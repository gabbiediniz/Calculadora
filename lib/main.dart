import 'dart:math';

import 'package:calculadora_da_gabi/firebase_options.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Firebase.initializeApp(
    options: Defafirebase init hostingultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora da Gabi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade500),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController primeiroNumeroController = TextEditingController();
  TextEditingController segundoNumeroController = TextEditingController();

  double primeiroNumero = 0;
  double segundoNumero = 0;
  double result = 0;

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 10));

  static const List<Color> _colorSetParty = [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '> Calculadora da Gabi <',
          style: GoogleFonts.permanentMarker(
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConfettiWidget(
                  blastDirection: pi,
                  blastDirectionality: BlastDirectionality.explosive,
                  canvas: Size.infinite,
                  child: null,
                  colors: _colorSetParty,
                  confettiController: _confettiController,
                  createParticlePath: (Size size) {
                    double degToRad(double deg) => deg * (pi / 180.0);

                    const numberOfPoints = 5;
                    final halfWidth = size.width / 2;
                    final externalRadius = halfWidth;
                    final internalRadius = halfWidth / 2.5;
                    final degreesPerStep = degToRad(360 / numberOfPoints);
                    final halfDegreesPerStep = degreesPerStep / 2;
                    final path = Path();
                    final fullAngle = degToRad(360);

                    path.moveTo(size.width, halfWidth);

                    for (double step = 0;
                        step < fullAngle;
                        step += degreesPerStep) {
                      path.lineTo(halfWidth + externalRadius * cos(step),
                          halfWidth + externalRadius * sin(step));
                      path.lineTo(
                          halfWidth +
                              internalRadius * cos(step + halfDegreesPerStep),
                          halfWidth +
                              internalRadius * sin(step + halfDegreesPerStep));
                    }
                    path.close();
                    return path;
                  },
                  displayTarget: false,
                  emissionFrequency: 0.02,
                  gravity: 0.2,
                  maximumSize: const Size(30, 15),
                  minimumSize: const Size(20, 10),
                  maxBlastForce: 20,
                  minBlastForce: 5,
                  numberOfParticles: 10,
                  particleDrag: 0.05,
                  strokeColor: Colors.black,
                  strokeWidth: 0,
                  shouldLoop: false,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.3),
                      child: TextField(
                        controller: primeiroNumeroController,
                        onChanged: (valorDigitado) {
                          if (valorDigitado.contains('.')) {
                            primeiroNumeroController.text =
                                primeiroNumeroController.text
                                    .replaceAll('.', ',');

                            primeiroNumeroController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: primeiroNumeroController.text.length),
                            );
                          }

                          if (valorDigitado.contains(',')) {
                            valorDigitado = valorDigitado.replaceAll(',', '.');
                          }

                          setState(() {
                            primeiroNumero = double.tryParse(
                                  primeiroNumeroController.text
                                      .replaceAll(',', '.'),
                                ) ??
                                0.0;
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^\-?\d*[.,]?\d*)')),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o primeiro número',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.3),
                      child: TextField(
                        controller: segundoNumeroController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^\-?\d*[.,]?\d*)')),
                        ],
                        onTap: () {
                          segundoNumeroController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: segundoNumeroController.text.length),
                          );
                        },
                        onChanged: (valorDigitado) {
                          if (valorDigitado.contains('.')) {
                            segundoNumeroController.text =
                                segundoNumeroController.text
                                    .replaceAll('.', ',');

                            segundoNumeroController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: segundoNumeroController.text.length),
                            );
                          }

                          if (valorDigitado.contains(',')) {
                            valorDigitado = valorDigitado.replaceAll(',', '.');
                          }

                          setState(() {
                            segundoNumero = double.tryParse(
                                  segundoNumeroController.text
                                      .replaceAll(',', '.'),
                                ) ??
                                0.0;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o segundo número',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = primeiroNumero + segundoNumero;
                          _confettiController.play();
                        });
                      },
                      child: const Text('Exibir Soma (+)'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            result = primeiroNumero - segundoNumero;
                            _confettiController.play();
                          });
                        },
                        child: const Text('Exibir Subtração (-)')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            result = primeiroNumero * segundoNumero;
                            _confettiController.play();
                          });
                        },
                        child: const Text('Exibir Multiplicação (*)')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            result = primeiroNumero / segundoNumero;
                            _confettiController.play();
                          });
                        },
                        child: const Text('Exibir Divisão (/)')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = 0;
                          primeiroNumero = 0;
                          segundoNumero = 0;

                          primeiroNumeroController.clear();
                          segundoNumeroController.clear();

                          _confettiController.stop();
                        });
                      },
                      child: const Icon(Icons.delete_forever_rounded),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Resultado: ${result.toDouble().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

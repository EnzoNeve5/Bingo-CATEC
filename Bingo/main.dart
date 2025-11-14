import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BingoApp());
}

class BingoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bingo',
      home: BingoCard(),
    );
  }
}

class BingoCard extends StatefulWidget {
  @override
  _BingoCardState createState() => _BingoCardState();
}

class _BingoCardState extends State<BingoCard> {
  static const int rows = 5;
  static const int cols = 5;

  List<List<int>> card = [];
  Set<int> markedNumbers = {};

  @override
  void initState() {
    super.initState();
    generateCard();
  }

  void generateCard() {
    final rand = Random();
    Set<int> numbersInCard = {};

    List<int> generateUniqueNumbers(int min, int max, int count) {
      Set<int> set = {};
      while (set.length < count) {
        set.add(rand.nextInt(max - min + 1) + min);
      }
      return set.toList();
    }

    card = List.generate(cols, (col) {
      int start = col * 15 + 1;
      int end = start + 14;
      List<int> colNumbers = generateUniqueNumbers(start, end, rows);
      colNumbers.sort(); // Ordena os números em ordem crescente
      return colNumbers;
    });

    card = List.generate(rows, (row) => List.generate(cols, (col) => card[col][row]));

    // Define o centro como espaço livre (0)
    card[2][2] = 0;

    markedNumbers.clear();
    // Marca o espaço livre automaticamente
    markedNumbers.add(0);

    setState(() {});
  }

  void toggleMark(int number) {
    if (number == 0) return; // Não permite desmarcar o espaço livre
    setState(() {
      if (markedNumbers.contains(number)) {
        markedNumbers.remove(number);
      } else {
        markedNumbers.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartela de Bingo'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade400,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: (rows + 1) * cols, // Adiciona uma linha extra para os cabeçalhos
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (_, index) {
                  int row = index ~/ cols;
                  int col = index % cols;

                  if (row == 0) {
                    // Cabeçalho com B I N G O
                    String letter = ['B', 'I', 'N', 'G', 'O'][col];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    // Números da cartela
                    int actualRow = row - 1;
                    int number = card[actualRow][col];
                    bool isMarked = markedNumbers.contains(number);

                    return GestureDetector(
                      onTap: () => toggleMark(number),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isMarked ? Colors.orange : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          number == 0 ? 'FREE' : number.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: generateCard,
            child: Text('Gerar Nova Cartela'),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
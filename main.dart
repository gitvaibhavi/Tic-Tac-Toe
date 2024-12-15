// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'game.dart'; // Import the TicTacToeGame class

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Arial'),
      home: const TicTacToeHome(),
    );
  }
}

class TicTacToeHome extends StatefulWidget {
  const TicTacToeHome({super.key});

  @override
  _TicTacToeHomeState createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  final TicTacToeGame _game = TicTacToeGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGameStatus(),
            const SizedBox(height: 20),
            _buildBoard(),
            const SizedBox(height: 30),
            _buildRestartButton(),
          ],
        ),
      ),
    );
  }

  // Build the current game status (Player Turn, Winner, Draw)
  Widget _buildGameStatus() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        _game.winner == ''
            ? 'Player ${_game.currentPlayer}\'s Turn'
            : _game.isDraw
                ? 'It\'s a Draw!'
                : 'Winner: ${_game.winner}',
        key: ValueKey<String>(_game.winner),
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2),
      ),
    );
  }

  // Build the 3x3 grid with unique cell styles
  Widget _buildBoard() {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_game.makeMove(row, col)) {}
                });
              },
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCellColor(row, col),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _game.board[row][col],
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(row, col),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  // Get the cell color based on the game state
  Color _getCellColor(int row, int col) {
    if (_game.board[row][col] == 'X') {
      return Colors.redAccent.withOpacity(0.6);
    } else if (_game.board[row][col] == 'O') {
      return Colors.greenAccent.withOpacity(0.6);
    }
    return Colors.grey[300]!;
  }

  // Get text color based on the player (X or O)
  Color _getTextColor(int row, int col) {
    return _game.board[row][col] == 'X'
        ? Colors.white
        : _game.board[row][col] == 'O'
            ? Colors.black
            : Colors.transparent;
  }

  // Restart the game button
  Widget _buildRestartButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purpleAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 10,
      ),
      child: const Text(
        'Restart Game',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Reset the game
  void _resetGame() {
    setState(() {
      _game.resetGame();
    });
  }
}

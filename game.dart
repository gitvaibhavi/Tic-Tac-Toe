import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

class TicTacToeGame {
  List<List<String>> board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  String currentPlayer = 'X';
  String winner = '';
  bool isDraw = false;
  int xScore = 0;
  int oScore = 0;

  Timer? _turnTimer;
  static const int timeLimit = 10; // 10 seconds per turn
  int remainingTime = timeLimit;

  // Reset the board
  void resetGame() {
    board = [
      ['', '', ''],
      ['', '', ''],
      ['', '', ''],
    ];
    currentPlayer = 'X';
    winner = '';
    isDraw = false;
    remainingTime = timeLimit;
    _startTurnTimer();
  }

  // Start the turn timer
  void _startTurnTimer() {
    _turnTimer?.cancel();
    remainingTime = timeLimit;
    // ignore: prefer_const_constructors
    _turnTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        _handleTimeout();
      }
    });
  }

  // Handle timeout (if player doesn't make a move in time)
  void _handleTimeout() {
    if (kDebugMode) {
      print('$currentPlayer\'s turn timed out!');
    }
    _nextTurn();
  }

  // Make a move
  bool makeMove(int row, int col) {
    if (board[row][col] == '' && winner == '' && !isDraw) {
      board[row][col] = currentPlayer;
      if (_checkWinner()) {
        winner = currentPlayer;
        _updateScore();
      } else if (_checkDraw()) {
        isDraw = true;
        _nextTurn(); // Restart the game automatically if it's a draw
      } else {
        _nextTurn();
      }
      return true;
    }
    return false;
  }

  // Check for winner
  bool _checkWinner() {
    // Check rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '') return true;
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '') return true;
    }
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '') return true;
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '') return true;
    return false;
  }

  // Check for draw
  bool _checkDraw() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') return false; // There's an empty space
      }
    }
    return true; // All spaces are filled
  }

  // Update the score
  void _updateScore() {
    if (winner == 'X') {
      xScore++;
    } else if (winner == 'O') {
      oScore++;
    }
  }

  // Move to the next turn
  void _nextTurn() {
    if (_checkWinner() || _checkDraw()) {
      // No need to continue the game if there's a winner or draw
      resetGame(); // Automatically restart the game after a win or draw
    } else {
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      _startTurnTimer();
    }
  }

  // Get the current score
  String getScore() {
    return 'X: $xScore - O: $oScore';
  }

  // AI Move (for simple AI, making random moves)
  void aiMove() {
    if (currentPlayer == 'O') {
      List<List<int>> availableMoves = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            availableMoves.add([i, j]);
          }
        }
      }
      if (availableMoves.isNotEmpty) {
        var move = availableMoves[Random().nextInt(availableMoves.length)];
        makeMove(move[0], move[1]);
      }
    }
  }
}

import random
import numpy
from scipy import stats
import math
import copy
from warnings import filterwarnings
# for max_value
filterwarnings("ignore")


class Teeko2Player:
    """ An object representation for an AI game player for the game Teeko2.
    """
    board = [[' ' for j in range(5)] for i in range(5)]
    pieces = ['b', 'r']

    def __init__(self):
        """ Initializes a Teeko2Player object by randomly selecting red or black as its
        piece color.
        """
        self.my_piece = random.choice(self.pieces)
        self.opp = self.pieces[0] if self.my_piece == self.pieces[1] else self.pieces[1]

    def make_move(self, state):
        """ Selects a (row, col) space for the next move. You may assume that whenever
        this function is called, it is this player's turn to move.

        Args:
            state (list of lists): should be the current state of the game as saved in
                this Teeko2Player object. Note that this is NOT assumed to be a copy of
                the game state and should NOT be modified within this method (use
                place_piece() instead). Any modifications (e.g. to generate successors)
                should be done on a deep copy of the state.

                In the "drop phase", the state will contain less than 8 elements which
                are not ' ' (a single space character).

        Return:
            move (list): a list of move tuples such that its format is
                    [(row, col), (source_row, source_col)]
                where the (row, col) tuple is the location to place a piece and the
                optional (source_row, source_col) tuple contains the location of the
                piece the AI plans to relocate (for moves after the drop phase). In
                the drop phase, this list should contain ONLY THE FIRST tuple.

        Note that without drop phase behavior, the AI will just keep placing new markers
            and will eventually take over the board. This is not a valid strategy and
            will earn you no points.
        """

        
        # determine next state
        next, _ = self.max_value(state,0)
        successors = self.succ(state)
        phase, count = self.drop_phase(state)
        curr = []
        if phase:
            # check if board empty
            if count == 25:
                return [(2,2)]
            else:
                for succ in successors:
                    if succ[0] == next:
                        curr = succ
                        break
                # return the move of the pieces
                return [curr[1]]
        else:
            for succ in successors:
                if succ[0] == next:
                    curr = succ
                    break
                # return the move and original source
            return [curr[1], curr[2]]


    # returns true if drop phase
    def drop_phase(self, board):
        count = 0

        for i in range(5):
            for j in range (5):
                if board[i][j] != ' ':
                    count = count + 1
        
        return (False, count) if count == 8 else (True, count)

    # swap pieces
    def swap(self,arr, p1, p2):
        arr[p1[0]][p1[1]], arr[p2[0]][p2[1]] = arr[p2[0]][p2[1]], arr[p1[0]][p1[1]]

    def succ(self, board):
        
        newBoard = copy.deepcopy(board)
        successors = []

        # drop phase case
        if self.drop_phase(board)[0]:
            for i in range(5):
                for j in range(5):
                    if board[i][j] == ' ':
                        newBoard = copy.deepcopy(board)
                        newBoard[i][j] = self.my_piece
                        successors.append((newBoard, (i, j),None))
        else:
            for i in range(5):
                for j in range(5):
                    if board[i][j] == self.my_piece:
                        
                        # right
                        if j + 1 < 5 and board[i][j + 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i,j+1))
                            successors.append(( newBoard,  (i, j + 1),  (i, j)))
                        
                        # left
                        if j - 1 >= 0 and board[i][j - 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i,j-1))
                            successors.append(( newBoard,(i, j - 1) , (i, j)))

                        # up
                        if i - 1 >= 0 and board[i - 1][j] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i-1,j))
                            successors.append(( newBoard,(i - 1, j),  (i, j)))

                        # down.
                        
                        if i + 1 < 5 and board[i + 1][j] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i+1,j))
                            successors.append(( newBoard, (i + 1, j), (i, j)))

                        # up right
                        
                        if i - 1 >= 0 and j + 1 < 5 and board[i - 1][j + 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i-1,j+1))
                            successors.append(( newBoard, (i - 1, j + 1), (i, j)))

                        # up left
                        if i - 1 >= 0 and j - 1 >= 0 and board[i - 1][j - 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i-1,j-1))
                            successors.append(( newBoard, (i - 1, j - 1),  (i, j)))
                        
                        # down right
                        
                        if i + 1 < 5 and j + 1 < 5 and board[i + 1][j + 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i+1,j+1))
                            successors.append((newBoard, (i + 1, j + 1),  (i, j)))
                        
                        # down left
                        
                        if i + 1 < 5 and j - 1 >= 0 and board[i + 1][j - 1] == ' ':
                            newBoard = copy.deepcopy(board)
                            self.swap(newBoard, (i, j), (i+1,j-1))
                            newBoard[i][j] = ' '
                            newBoard[i + 1][j - 1] = self.my_piece
                            successors.append(( newBoard,  (i + 1, j - 1),  (i, j)))
    
        return successors

    def heuristic_game_value(self, board):
        # check game over if val is non-zero
        res = self.game_value(board)
        if (res):
            return res

        piece = self.my_piece
        all_pieces = []
        # find all pieces
        for i in range(5):
            for j in range(5):
                if board[i][j] == piece:
                    all_pieces.append((i,j))

        # Run regression
        try:
            grad = stats.linregress(all_pieces).rvalue
        except RuntimeWarning:
            grad = math.inf

        # get r value

        return numpy.arctan(grad)/(math.pi/2)

    def max_value(self, board, depth):
        # check if game over
        val = self.game_value(board)
        if val:
            return board, val

        if depth >= 1:
            return board, self.heuristic_game_value(board)
        

        a = -math.inf
        successors = self.succ(board)

        for succ in successors:
            # recurr
            _, newA = self.max_value(succ[0], depth + 1)
            if newA > a:
                a = newA
                retState = succ[0]

        return retState, a



    def opponent_move(self, move):
        """ Validates the opponent's next move against the internal board representation.
        You don't need to touch this code.

        Args:
            move (list): a list of move tuples such that its format is
                    [(row, col), (source_row, source_col)]
                where the (row, col) tuple is the location to place a piece and the
                optional (source_row, source_col) tuple contains the location of the
                piece the AI plans to relocate (for moves after the drop phase). In
                the drop phase, this list should contain ONLY THE FIRST tuple.
        """
        # validate input
        if len(move) > 1:
            source_row = move[1][0]
            source_col = move[1][1]
            if source_row != None and self.board[source_row][source_col] != self.opp:
                self.print_board()
                print(move)
                raise Exception("You don't have a piece there!")
            if abs(source_row - move[0][0]) > 1 or abs(source_col - move[0][1]) > 1:
                self.print_board()
                print(move)
                raise Exception('Illegal move: Can only move to an adjacent space')
        if self.board[move[0][0]][move[0][1]] != ' ':
            raise Exception("Illegal move detected")
        # make move
        self.place_piece(move, self.opp)

    def place_piece(self, move, piece):
        """ Modifies the board representation using the specified move and piece

        Args:
            move (list): a list of move tuples such that its format is
                    [(row, col), (source_row, source_col)]
                where the (row, col) tuple is the location to place a piece and the
                optional (source_row, source_col) tuple contains the location of the
                piece the AI plans to relocate (for moves after the drop phase). In
                the drop phase, this list should contain ONLY THE FIRST tuple.

                This argument is assumed to have been validated before this method
                is called.
            piece (str): the piece ('b' or 'r') to place on the board
        """
        if len(move) > 1:
            self.board[move[1][0]][move[1][1]] = ' '
        self.board[move[0][0]][move[0][1]] = piece

    def print_board(self):
        """ Formatted printing for the board """
        for row in range(len(self.board)):
            line = str(row)+": "
            for cell in self.board[row]:
                line += cell + " "
            print(line)
        print("   A B C D E")

    def game_value(self, state):
        """ Checks the current board status for a win condition

        Args:
        state (list of lists): either the current state of the game as saved in
            this Teeko2Player object, or a generated successor state.

        Returns:
            int: 1 if this Teeko2Player wins, -1 if the opponent wins, 0 if no winner

        TODO: complete checks for diagonal and 3x3 square corners wins
        """
        # check horizontal wins
        for row in state:
            for i in range(2):
                if row[i] != ' ' and row[i] == row[i+1] == row[i+2] == row[i+3]:
                    return 1 if row[i]==self.my_piece else -1

        # check vertical wins
        for col in range(5):
            for i in range(2):
                if state[i][col] != ' ' and state[i][col] == state[i+1][col] == state[i+2][col] == state[i+3][col]:
                    return 1 if state[i][col]==self.my_piece else -1

        # TODO: check \ diagonal wins
        for col in range(2):
            for row in range(2):
                if state[col][row] == state[col+1][row+1] == state[col+2][row+2] == state[col+3][row+3] and state[col][row] != ' ':
                    return 1 if state[col][row] == self.my_piece else -1

        # TODO: check / diagonal wins
        for col in range(3,5):
            for row in range(2):
                if state[col][row] == state[col-1][row+1] == state[col-2][row+2] == state[col-3][row+3] and state[col][row] != ' ':
                    return 1 if state[col][row] == self.my_piece else -1
                
        # TODO: check 3x3 square corners wins
        # find all spots where 3x3 center can be
        for col in range(1,4):
            for row in range(1,4):
                # check center is empty
                if (state[col][row] == ' '):
                    if state[col-1][row-1] == state[col+1][row-1] \
                        == state[col+1][row+1] == state[col-1][row+1] != ' ':
                        return 1 if state[col-1][row-1] == self.my_piece else -1

        return 0 # no winner yet

############################################################################
#
# THE FOLLOWING CODE IS FOR SAMPLE GAMEPLAY ONLY
#
############################################################################
def main():
    print('Hello, this is Samaritan')
    ai = Teeko2Player()
    piece_count = 0
    turn = 0

    # drop phase
    while piece_count < 8 and ai.game_value(ai.board) == 0:

        # get the player or AI's move
        if ai.my_piece == ai.pieces[turn]:
            ai.print_board()
            move = ai.make_move(ai.board)
            ai.place_piece(move, ai.my_piece)
            print(ai.my_piece+" moved at "+chr(move[0][1]+ord("A"))+str(move[0][0]))
        else:
            move_made = False
            ai.print_board()
            print(ai.opp+"'s turn")
            while not move_made:
                player_move = input("Move (e.g. B3): ")
                while player_move[0] not in "ABCDE" or player_move[1] not in "01234":
                    player_move = input("Move (e.g. B3): ")
                try:
                    ai.opponent_move([(int(player_move[1]), ord(player_move[0])-ord("A"))])
                    move_made = True
                except Exception as e:
                    print(e)

        # update the game variables
        piece_count += 1
        turn += 1
        turn %= 2

    # move phase - can't have a winner until all 8 pieces are on the board
    while ai.game_value(ai.board) == 0:

        # get the player or AI's move
        if ai.my_piece == ai.pieces[turn]:
            ai.print_board()
            move = ai.make_move(ai.board)
            ai.place_piece(move, ai.my_piece)
            print(ai.my_piece+" moved from "+chr(move[1][1]+ord("A"))+str(move[1][0]))
            print("  to "+chr(move[0][1]+ord("A"))+str(move[0][0]))
        else:
            move_made = False
            ai.print_board()
            print(ai.opp+"'s turn")
            while not move_made:
                move_from = input("Move from (e.g. B3): ")
                while move_from[0] not in "ABCDE" or move_from[1] not in "01234":
                    move_from = input("Move from (e.g. B3): ")
                move_to = input("Move to (e.g. B3): ")
                while move_to[0] not in "ABCDE" or move_to[1] not in "01234":
                    move_to = input("Move to (e.g. B3): ")
                try:
                    ai.opponent_move([(int(move_to[1]), ord(move_to[0])-ord("A")),
                                    (int(move_from[1]), ord(move_from[0])-ord("A"))])
                    move_made = True
                except Exception as e:
                    print(e)

        # update the game variables
        turn += 1
        turn %= 2

    ai.print_board()
    if ai.game_value(ai.board) == 1:
        print("AI wins! Game over.")
    else:
        print("You win! Game over.")


if __name__ == "__main__":
    main()

import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

class Square extends React.Component {
    render() {
        return (
            <button className="square" onClick={this.props.onClick}>
                {this.props.value}
            </button>
        );
    }
}

class Board extends React.Component {
    renderSquare(i) {
        return <Square
            value={this.props.squares[i]}
            onClick={() => this.props.onSquareClick(i)}
        />;
    }

    render() {
        return (
            <div>
                <div className="board-row">
                    {this.renderSquare(0)}
                    {this.renderSquare(1)}
                    {this.renderSquare(2)}
                </div>
                <div className="board-row">
                    {this.renderSquare(3)}
                    {this.renderSquare(4)}
                    {this.renderSquare(5)}
                </div>
                <div className="board-row">
                    {this.renderSquare(6)}
                    {this.renderSquare(7)}
                    {this.renderSquare(8)}
                </div>
            </div>
        );
    }
}

class Game extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            history: [{
                squares: Array(9).fill(null),
                next: 'X',
                winner: null
            }],
        };
    }

    jumpTo(move) {
        this.setState({
            history: this.state.history.slice(0, move+1)
        });
    }

    onSquareClick(i) {
        const current = this.state.history[this.state.history.length - 1];
        if (current.winner) {
            alert('Game over!');
        } else if (current.squares[i]) {
            alert('Hey, that\'s taken.')
        } else {
            const squares = current.squares.slice();
            squares[i] = current.next;
            const winner = this.determineWinner(squares);
            const newEntry = {
                squares: squares,
                next: current.next === 'X' ? 'O' : 'X',
                winner: winner,
            };
            const history = this.state.history.concat(newEntry);
            this.setState({ history: history });
        }
    }

    determineWinner(sqaures) {
        function threeInLine(squares, p1, p2, p3) {
            if (squares[p1] != null
                && squares[p1] === squares[p2]
                && squares[p2] === squares[p3]) {
                return squares[p1];
            } else {
                return null;
            }
        }

        var winner;

        for (let r = 0; r < 3; r++) {
            let p1 = r * 3;
            let p2 = p1 + 1;
            let p3 = p2 + 1;
            winner = threeInLine(sqaures, p1, p2, p3);
            if (winner)
                return winner;
        }

        for (let c = 0; c < 3; c++) {
            let p1 = c;
            let p2 = p1 + 3;
            let p3 = p2 + 3;
            winner = threeInLine(sqaures, p1, p2, p3);
            if (winner)
                return winner;
        }

        winner = threeInLine(sqaures, 0, 4, 8);
        if (winner)
            return winner;

        winner = threeInLine(sqaures, 2, 4, 6);
        if (winner)
            return winner;

        return null;
    }

    render() {
        const history = this.state.history;
        const current = history[history.length - 1];
        const status = current.winner ? 'Winner: ' + current.winner : 'Next player: ' + current.next;
        const moves = history.map((step, move) => {
            console.log(step);
            const description = move > 0 ?
                'Go to move #' + move :
                'Start over';
            return (
                <li key={move}>
                    <button onClick={() => this.jumpTo(move)}>
                        {description}
                    </button>
                </li>);
        });


        return (
            <div className="game">
                <div className="game-board">
                    <div className="status">{status}</div>
                    <Board squares={current.squares} onSquareClick={(i) => this.onSquareClick(i)} />
                </div>
                <div className="game-info">
                    <div>History:</div>
                    <ol>{moves}</ol>
                </div>
            </div>
        );
    }
}

// ========================================

ReactDOM.render(
    <Game />,
    document.getElementById('root')
);


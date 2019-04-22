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
    constructor(props) {
        super(props);
        this.state = {
            next: 'X',
            squares: Array(9).fill(null),
            winner: null
        };
    }

    onSquareClick(i) {
        if (this.state.winner) {
            alert('Game over!');
        } else if (this.state.squares[i]) {
            alert('Hey, that\'s taken.')
        } else {
            const squares = this.state.squares.slice();
            squares[i] = this.state.next;
            this.setState(
                {
                    squares: squares,
                    next: this.state.next === 'X' ? 'O' : 'X',
                },
                () => {
                    const winner = this.determineWinner();
                    if (winner) {
                        this.setState({winner: winner});
                    }
                });
        }
    }

    threeInLine(p1, p2, p3) {
        if (this.state.squares[p1] != null
            && this.state.squares[p1] === this.state.squares[p2]
            && this.state.squares[p2] === this.state.squares[p3]) {
            return this.state.squares[p1];
        } else {
            return null;
        }
    }

    determineWinner() {
        var winner;

        for (let r = 0; r < 3; r++) {
            let p1 = r * 3;
            let p2 = p1 + 1;
            let p3 = p2 + 1;
            winner = this.threeInLine(p1, p2, p3);
            if (winner)
                return winner;
        }

        for (let c = 0; c < 3; c++) {
            let p1 = c;
            let p2 = p1 + 3;
            let p3 = p2 + 3;
            winner = this.threeInLine(p1, p2, p3);
            if (winner)
                return winner;
        }

        winner = this.threeInLine(0, 4, 8);
        if (winner)
            return winner;

        winner = this.threeInLine(2, 4, 6);
        if (winner)
            return winner;

        return null;
    }

    renderSquare(i) {
        return <Square
            value={this.state.squares[i]}
            onClick={() => this.onSquareClick(i)}
        />;
    }

    render() {
        const status = 'Next player: ' + this.state.next;

        return (
            <div>
                <div className="status">{status}</div>
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
    render() {
        return (
            <div className="game">
                <div className="game-board">
                    <Board />
                </div>
                <div className="game-info">
                    <div>Winner:</div>
                    <ol>{/* TODO */}</ol>
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


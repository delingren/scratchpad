import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Switch, Route, Link } from "react-router-dom";

function App() {
  return (
    <div>
      <Header />
      <Main />
    </div>
  );
}

function Main() {
  return (
    <main>
      <Switch>
        <Route exact path="/" component={Home} />
        <Route path="/roster" component={Roster} />
        <Route path="/schedule" component={Schedule} />
      </Switch>
    </main>
  );
}

function Home() {
  return <div>Home</div>;
}

function Roster() {
  return (
    <div>
      <h2>This is a roster page!</h2>
      <Switch>
        <Route exact path="/roster" component={FullRoster} />
        <Route path="/roster/:number" component={Player} />
      </Switch>
    </div>
  );
}

function Player(props) {
  const playerNumber = parseInt(props.match.params.number);
  console.log(`Roster page, player ${playerNumber}`);
  return <div>Player # {playerNumber}</div>;
}

function FullRoster() {
  var playerNumbers = [1, 2, 3, 4, 5];
  return (
    <div>
      <ul>
        {playerNumbers.map(n => (
          <li key={n}>
            <Link to={`roster/${n}`}>Player {n}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

function Schedule() {
  return <div>Schedule</div>;
}

class Header extends React.Component {
  render() {
    return (
      <header>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/roster">Roster</Link>
            </li>
            <li>
              <Link to="/schedule">Schedule</Link>
            </li>
          </ul>
        </nav>
      </header>
    );
  }
}

ReactDOM.render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
  document.getElementById("root")
);

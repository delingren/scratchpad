import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import ChartReactChartJS from "./App1";
import ChartCanvasJS from "./App2";
import PageViewRecharts from "./App3";

class PageViewChart extends React.Component {
  constructor(props) {
    super(props);
    this.changeChartType = this.changeChartType.bind(this);
  }

  changeChartType(e) {
    this.chartRef.setState({ type: e.target.value });
  }

  render() {
    const chart = <PageViewRecharts ref={node => (this.chartRef = node)} />;
    return (
      <div>
        <div>
          Choose a chart style:
          <select onChange={this.changeChartType}>
            <option value="Line">Line</option>
            <option value="Bar">Bar</option>
          </select>
        </div>
        <div>{chart}</div>
      </div>
    );
  }
}

//ReactDOM.render(<ChartReactChartJS />, document.getElementById('root'));
//ReactDOM.render(<ChartCanvasJS />, document.getElementById('root'));
ReactDOM.render(<PageViewChart />, document.getElementById("root"));

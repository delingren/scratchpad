// Use react-chartjs-2

import React from "react";
import { Line, Bar } from "react-chartjs-2";

import { getPageviewChartData } from "./samplePageView";

export default class PageViewChartjs2 extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: "Line"
    };
  }

  render() {
    const pageviewData = getPageviewChartData(24 * 60 * 60 * 1000);

    const chartData = {
      labels: pageviewData.map(dataPoint => dataPoint.x.toDateString()),
      datasets: [
        {
          data: pageviewData.map(dataPoint => dataPoint.y)
        }
      ]
    };

    var chartOptions = {
      title: {display: true, text: 'Page Views'},
      legend: { display: false }
    };

    var result;
    switch (this.state.type) {
      case "Line":
        result = (
          <Line
            data={chartData}
            width="1000"
            height="400"
            options={chartOptions}
          />
        );
        break;
      case "Bar":
      default:
        result = (
          <Bar
            data={chartData}
            width="1000"
            height="400"
            options={chartOptions}
          />
        );
    }

    return result;
  }
}

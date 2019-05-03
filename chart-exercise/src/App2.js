// Use canvasjs
// https://canvasjs.com

import React from "react";
import CanvasJSReact from "./canvasjs.react";
import { getPageviewChartData } from "./samplePageView";
var CanvasJSChart = CanvasJSReact.CanvasJSChart;

export default class ChartCanvasJS extends React.Component {
  render() {
    const options = {
      theme: "light2", // "light1", "dark1", "dark2"
      axisY: {
        includeZero: false
      },
      axisX: {
        title: "Page views",
      },
      data: [
        {
          type: "line",
          dataPoints: getPageviewChartData(12 * 60 * 60 * 1000)
        }
      ]
    };
    return (
      <div>
        <CanvasJSChart
          options={options}
          /* onRef={ref => this.chart = ref} */
        />
        {/*You can get reference to the chart instance as shown above using onRef. This allows you to access all chart properties and methods*/}
      </div>
    );
  }
}

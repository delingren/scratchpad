// Use recharts
// http://recharts.org/

import React from "react";
import {
  LineChart,
  BarChart,
  Line,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip
} from "recharts";

import { getPageviewChartData } from "./samplePageView";

export default class PageViewRecharts extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: "Line"
    };
  }

  render() {
    var result;
    switch (this.state.type) {
      case "Line":
        result = (
          <LineChart
            width={800}
            height={300}
            data={getPageviewChartData(12 * 60 * 60 * 1000).map(function(
              dataPoint
            ) {
              return { x: dataPoint.x.toDateString(), y: dataPoint.y };
            })}
          >
            <CartesianGrid />
            <XAxis dataKey="x" />
            <YAxis />
            <Tooltip />
            <Line dataKey="y" stroke="#8884d8" />
          </LineChart>
        );
        break;
      case "Bar":
      default:
        result = (
          <BarChart
            width={800}
            height={300}
            data={getPageviewChartData(12 * 60 * 60 * 1000).map(function(
              dataPoint
            ) {
              return { x: dataPoint.x.toDateString(), y: dataPoint.y };
            })}
          >
            <CartesianGrid />
            <XAxis dataKey="x" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="y" fill="#8884d8" />
          </BarChart>
        );
    }

    return result;
  }
}

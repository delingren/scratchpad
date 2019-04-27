import React from 'react';
import {
    LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';

import chartData from './data.json';

export default class FancyChart extends React.Component {
    render() {
        return (
            <LineChart width={800} height={300} data={chartData}>
                <CartesianGrid />
                <XAxis dataKey="x" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="basicClosed" dataKey="y" stroke="#880000" activeDot={{ stroke: 'red', r: 8 }} />
            </LineChart>);
    }
}

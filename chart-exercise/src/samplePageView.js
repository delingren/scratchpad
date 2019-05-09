import pageviews from "./pageviews.json";

export function getPageviewChartData(sampleRate) {
  const milliseconds = pageviews.times.map(Date.parse);
  const start = Math.floor(milliseconds[0] / sampleRate);
  let currentX = start;
  let currentY = 0;
  let chartData = [];
  for (let i = 0; i < milliseconds.length; i++) {
    const x = milliseconds[i] / sampleRate;
    if (x - currentX >= 1 || i === milliseconds.length - 1) {
      const currentDate = new Date((currentX + 1) * sampleRate);
      chartData.push({ x: currentDate, y: currentY });
      currentX = Math.floor(x);
      currentY = 0;
    }
    currentY++;
  }

  return chartData;
}

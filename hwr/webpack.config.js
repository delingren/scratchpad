// webpack config file for hacking react  http://www.hackingwithreact.com/read/1/1/begin-at-the-beginning-chapter-one
const { resolve } = require('path');
const webpack = require('webpack');

module.exports = {
  entry: [
    'webpack-dev-server/client?http://localhost:8080',
    'webpack/hot/only-dev-server',
    './index.js'
  ],

  output: {
    path: resolve(__dirname + '/dist'),
    publicPath: '/',
    filename: 'bundle.js'
  },

  context: resolve(__dirname + '/src'),

  devServer: {
    contentBase:resolve( __dirname + '/dist'),
    hot: true
  },

  module: {
		rules: [
			{
				test: /\.js?$/,
				use: [
					'react-hot-loader/webpack',
					'babel-loader?presets[]=react',
				],
				exclude: /node_modules/
			},
		],
	},
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ]
};
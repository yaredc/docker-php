const path = require('path');
const isDev = process.env.NODE_ENV === 'development';

module.exports = [{
  mode: process.env.NODE_ENV,
  devtool: isDev ? 'inline-source-map' : false,
  entry: './public/.ts/frontend.ts',
  module: {
    rules: [
      {test: /\.tsx?$/, use: 'ts-loader'}
    ]
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js']
  },
  output: {
    filename: 'frontend.js',
    path: path.resolve(__dirname, 'public', 'js')
  }
}];

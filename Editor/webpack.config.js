const path = require('path');

module.exports = {
  mode: 'production',
  optimization: {
    minimize: true,
    chunkIds: 'named'
  },
  entry: {
    app: './app/editor.js',
    'editor.worker': 'monaco-editor/editor/editor.worker.js',
    'json.worker': 'monaco-editor/language/json/json.worker.js',
    'css.worker': 'monaco-editor/language/css/css.worker.js',
    'html.worker': 'monaco-editor/language/html/html.worker.js',
    'ts.worker': 'monaco-editor/language/typescript/ts.worker.js'
  },
  output: {
    globalObject: 'self',
    filename: '[name].bundle.js',
    assetModuleFilename: '[name][ext]',
    path: path.resolve(__dirname, 'dist'),
    clean: true
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.ttf$/,
        type: 'asset/resource'
      }
    ]
  }
};
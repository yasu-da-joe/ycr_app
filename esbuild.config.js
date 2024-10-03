const esbuild = require('esbuild');
const sassPlugin = require('esbuild-sass-plugin').sassPlugin;
const postcss = require('postcss');
const autoprefixer = require('autoprefixer');
const watchMode = process.argv.includes('--watch');

const buildOptions = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outdir: 'app/assets/builds',
  sourcemap: true,
  plugins: [sassPlugin()],
  loader: {
    '.js': 'jsx',
    '.scss': 'css'
  },
};

async function runBuild() {
  if (watchMode) {
    const context = await esbuild.context(buildOptions);
    await context.watch();
    console.log('Watching for changes...');
  } else {
    await esbuild.build(buildOptions);
  }
}

runBuild().catch((error) => {
  console.error('Build failed:', error);
  process.exit(1);
});
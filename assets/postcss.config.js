const purgecss = require('@fullhuman/postcss-purgecss')({
  content: ["../**/*.html.eex", "../**/views/**/*.ex", "./js/**/*.js"],
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
})

const autoprefixer = require('autoprefixer')({
  grid: false
})

module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss"),
    autoprefixer,
    ...(process.env.NODE_ENV === "production" ? [purgecss] : [])
  ]
}

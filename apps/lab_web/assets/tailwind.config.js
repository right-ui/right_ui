const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')
const plugin = require('tailwindcss/plugin')

const generatePrefixClassPlugin = (prefix) => {
  return plugin(function ({ addVariant }) {
    addVariant(prefix, [`.${prefix} &`, `.${prefix}&`])
  })
}

module.exports = {
  content: ['../lib/*_web/**/*.*ex', '../../right_ui/**/*.*ex', './{global,lib,pages}/**/*.js'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['InterVariable', ...defaultTheme.fontFamily.sans],
        mono: ['JetBrains MonoVariable', ...defaultTheme.fontFamily.mono],
      },
      colors: {
        primary: colors.teal,
        neutral: colors.slate,
        info: colors.blue,
        success: colors.green,
        warning: colors.yellow,
        danger: colors.red,

        gray: colors.red, // prevent myself from using gray, use neutral instead.
        grey: colors.red, // prevent myself from using grey, use neutral instead.
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/line-clamp'),
    generatePrefixClassPlugin('phx-form-error'),
    generatePrefixClassPlugin('phx-no-feedback'),
  ],
}

const { colors } = require('tailwindcss/defaultTheme');

module.exports = {
  purge: [
    './app/javascript/**/*.vue',
    './app/javascript/**/*.vue',
    './app/javascript/**/*.vue',
    './app/views/**/*.html.erb',
  ],
  future: {
    removeDeprecatedGapUtilities: true,
  },
  theme: {
    colors: {
      primary: '#1E293B',
      primaryHover: '#475569',
      secondary: '#1F2937',
      secondaryHover: '#4B5563',
      danger: '#B91C1C',
      dangerHover: '#991B1B',
      success: '#15803D',
      successHover: '#166534',
      info: '#0369A1',
      infoHover: '#075985',
      warning: '#FACC15',
      warningHover: '#EAB308',
      white: colors.white,
      transparent: 'rgba(234, 231, 231, 0.477)',
      backgroundTransparent: 'rgba(0, 0, 0, 0.3)',
      woot: {
        50: '#E3F2FF',
        100: '#BBDDFF',
        200: '#8FC9FF',
        300: '#61B3FF',
        400: '#3FA3FF',
        500: '#1F93FF',
        600: '#2284F0',
        700: '#2272DC',
        800: '#2161CA',
        900: '#1F41AB',
      },
      green: {
        50: '#E6F8E6',
        100: '#C4EEC2',
        200: '#9DE29A',
        300: '#6FD86F',
        400: '#44CE4B',
        500: '#00C41D',
        600: '#00B412',
        700: '#00A200',
        800: '#009000',
        900: '#007000',
      },
      yellow: {
        50: '#FFFEE8',
        100: '#FFFAC5',
        200: '#FFF69E',
        300: '#FEF176',
        400: '#FCEC56',
        500: '#F9E736',
        600: '#FFDD3A',
        700: '#FFC532',
        800: '#FDAD2A',
        900: '#F9841B',
      },
      slate: {
        50: '#F4F6FB',
        100: '#C8D6E6',
        200: '#ABBACE',
        300: '#8C9EB6',
        400: '#7489A4',
        500: '#5D7592',
        600: '#506781',
        700: '#40546B',
        800: '#314155',
        900: '#1F2D3D',
        1000: '#252d34',
      },
      black: {
        50: '#F8F9FE',
        100: '#F2F3F7',
        200: '#E9EAEF',
        300: '#DADBDF',
        400: '#B6B7BB',
        500: '#96979C',
        600: '#6E6F73',
        700: '#3C4858',
        800: '#3C3D40',
        900: '#1B1C1F',
      },
      red: {
        50: '#FFEBEE',
        100: '#FFCCD1',
        200: '#F69898',
        300: '#EF6F6F',
        400: '#F94B4A',
        500: '#FF382D',
        600: '#F02B2D',
        700: '#DE1E27',
        800: '#D11320',
        900: '#C30011',
      },
      gray: {
        600: '#4B5563',
        800: '#1F2937',
        100: '#f8f8f8',
        50: '#F3F3F5',
      }
    },
    extend: {
      screens: {
        dark: { raw: '(prefers-color-scheme: dark)' },
      },
      width: {
        100: '25rem',
        80: '18.75rem'
      },
      height: {
        9: '2.1875rem'
      }
    },
  },
  variants: {},
  plugins: [
    // eslint-disable-next-line
    require('@tailwindcss/typography'),
  ],
};

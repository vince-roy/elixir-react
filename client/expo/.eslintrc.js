// https://docs.enpx expo lintxpo.dev/guides/using-eslint/
module.exports = {
  extends: ["expo", "prettier"],
  plugins: ["prettier"],
  rules: {
    "import/no-unresolved": "off",
    "prettier/prettier": "error",
  },
};

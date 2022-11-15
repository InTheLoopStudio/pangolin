module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    tsconfigRootDir: __dirname,
    project: [ "tsconfig.json" ],
    sourceType: "module",
    extraFileExtensions: [ ".cjs" ],
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    ".eslintrc.cjs",
  ],
  plugins: [ "@typescript-eslint", "import", ],
  rules: {
    quotes: [ "error", "double" ],
    indent: [ "error", 2 ],
    "object-curly-spacing": [ "error", "always" ],
    "array-bracket-spacing": [ "error", "always" ],
  },
};

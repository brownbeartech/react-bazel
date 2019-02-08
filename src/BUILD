package(default_visibility = ["//visibility:public"])

load("@build_bazel_rules_nodejs//:defs.bzl", "nodejs_binary", "rollup_bundle")

load(":custom_rollup_bundle.bzl", "custom_rollup_bundle")

exports_files([
    "rollup.config.js",
])

filegroup(
    name = "files",
    srcs = glob(["*.js"]),
)

nodejs_binary(
    name = "rollup",
    entry_point = "rollup/bin/rollup",
    data = [
        "@npm//is-builtin-module",
        "@npm//rollup",
        "@npm//rollup-plugin-babel",
        "@npm//rollup-plugin-commonjs",
        "@npm//rollup-plugin-includepaths",
        "@npm//rollup-plugin-node-resolve",
        "@npm//rollup-plugin-sourcemaps",
        "@npm//rollup-plugin-replace",
        "@npm//@babel/plugin-external-helpers",
        "@npm//@babel/plugin-transform-react-jsx",
        "@npm//@babel/plugin-transform-runtime",
        "@npm//@babel/core",
        "@npm//@babel/preset-react",
    ],
)

custom_rollup_bundle(
    name = "bundle",
    entry_point = "src/main",
    deps = [
        ":files",
        "@npm//react",
        "@npm//react-dom",
    ],
    plugins = [
        #"require('rollup-plugin-replace').call(this, {'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)})",
        #"require('@babel/core').transform('code', {presets: ['@babel/preset-react']})",
        #"require('@babel/core').transform('code', {plugins: ['@babel/plugin-transform-react-jsx']})",
        #"require('rollup-plugin-babel').call(this, {exclude: 'node_modules/**', presets: [['@babel/preset-react',{modules: false}]]})",
        #"require('rollup-plugin-commonjs').call(this, {namedExports: {'react': ['Children', 'Component', 'PropTypes', 'createElement'], 'react-dom': ['render']}})",
        #"require('rollup-plugin-babel').call(this, {plugins: [require('@babel/plugin-transform-react-jsx')]})",
        #"require('rollup-plugin-commonjs').call(this, {include: 'external/npm/node_modules/**', namedExports: {'react': ['Children', 'Component', 'PropTypes', 'createElement'], 'react-dom': ['render']}})",
        #"require('rollup-plugin-commonjs').call()",
        "require('@babel/core').transform('code', {presets: [require('@babel/preset-react')]})",
    ],
)

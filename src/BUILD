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
        "@npm//@babel/plugin-transform-react-jsx",
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
        "require('rollup-plugin-babel').call(this, {presets: [require('@babel/preset-react')]})",
    ],
)

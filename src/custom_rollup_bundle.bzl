load(
    "@build_bazel_rules_nodejs//internal/rollup:rollup_bundle.bzl",
    "ROLLUP_ATTRS",
    "ROLLUP_DEPS_ASPECTS",
    "ROLLUP_OUTPUTS",
    "run_rollup",
    "run_sourcemapexplorer",
    "run_uglify",
    "write_rollup_config",
)
load("@build_bazel_rules_nodejs//internal:collect_es6_sources.bzl", collect_es2015_sources = "collect_es6_sources")

# Borrowed from bazelbuild/rules_nodejs
def _run_tsc(ctx, input, output):
    args = ctx.actions.args()
    args.add("--target", "es5")
    args.add("--allowJS")
    args.add(input)
    args.add("--outFile", output)

    ctx.action(
        executable = ctx.executable._tsc,
        inputs = [input],
        outputs = [output],
        arguments = [args],
    )

# Borrowed from bazelbuild/rules_nodejs, with the addition of a pipe in for plugins
def _custom_rollup_bundle(ctx):
    rollup_config = write_rollup_config(ctx, ctx.attr.plugins)
    run_rollup(ctx, collect_es2015_sources(ctx), rollup_config, ctx.outputs.build_es6)
    _run_tsc(ctx, ctx.outputs.build_es6, ctx.outputs.build_es5)
    source_map = run_uglify(ctx, ctx.outputs.build_es5, ctx.outputs.build_es5_min)
    run_uglify(ctx, ctx.outputs.build_es5, ctx.outputs.build_es5_min_debug, debug = True)
    umd_rollup_config = write_rollup_config(ctx, ctx.attr.plugins, filename = "_%s_umd.rollup.conf.js", output_format = "umd")
    run_rollup(ctx, collect_es2015_sources(ctx), umd_rollup_config, ctx.outputs.build_umd)
    cjs_rollup_config = write_rollup_config(ctx, ctx.attr.plugins, filename = "_%s_cjs.rollup.conf.js", output_format = "cjs")
    run_rollup(ctx, collect_es2015_sources(ctx), cjs_rollup_config, ctx.outputs.build_cjs)
    run_sourcemapexplorer(ctx, ctx.outputs.build_es5_min, source_map, ctx.outputs.explore_html)

    files = [ctx.outputs.build_es5_min, source_map]
    return DefaultInfo(files = depset(files), runfiles = ctx.runfiles(files))

custom_rollup_bundle = rule(
    implementation = _custom_rollup_bundle,
    attrs = dict(ROLLUP_ATTRS, **{
        "plugins": attr.string_list(doc = """provide a list of rollup plogins here"""),
        "_rollup": attr.label(
            executable = True,
            cfg = "host",
            default = Label("//src:rollup"),
        ),
        "_rollup_config_tmpl": attr.label(
            default = Label("//src:rollup.config.js"),
            allow_single_file = True,
        ),
    }),
    outputs = ROLLUP_OUTPUTS,
)
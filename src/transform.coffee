fs = require 'fs'
math = require 'mathjs'

die = ->
    console.error "error:", arguments...
    process?.exit(1)

scale = (factor, m) ->
    frac = m[2].replace /// ^/ ///, '1/' # no numerator implies 1
    if frac is ''
        frac = 1 # no fraction at all is identity
    expr = "#{factor} * #{frac}"
    try
        r = math.fraction(math.evaluate(expr)).toFraction()
        #console.warn m[0], expr, r
        if r is '1'
            r = ''
        return m[1] + r
    catch e
        console.error 'scale error:', m[0], expr, e.message
        return m[0]

module.exports =
    scaleL: (abc, factor) ->
        abc or die "scaleL abc string is missing"
        factor or die "scaleL factor is missing"

        for line in abc.split(/\n/)
            if m = line.match /// ^ (\s* L: \s* )(.*) ///i
                console.log m[1] + math.fraction(math.evaluate("#{m[2]} / #{factor}")).toFraction()
            else if line.match(/\S/) and not line.match(/// ^ \s* ( % | \w+: | \# ) ///)
                console.log line.replace /// ([ abcdefg ] [,']? ) ([ \d / ]*) ///gi, (m...) -> scale factor, m
            else
                console.log line

unless module.parent
    [f, args...] = process.argv.slice(2)
    f or die "first arg must be a function name"
    switch f
        when 'scaleL' then module.exports.scaleL fs.readFileSync('/dev/stdin').toString(), args...
        else die "unknown function: #{f}"

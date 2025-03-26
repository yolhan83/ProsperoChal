module ProsperoChal
    using CUDA,BenchmarkTools
    const T = Float16
    const device = CUDA.cu # use identity for cpu

    function parseit(filename)
        prog = String[]
        push!(prog, "function(x,y) ")
        for line in eachline(filename)
            (length(line) == 0 || line[1]=='#') && continue
            parts = split(line, ' ')
            var = parts[1]
            op = parts[2]
    
            if length(parts) > 2
                arg1 = parts[3]
            end
            if length(parts) > 3
                arg2 = parts[4]
            end
    
            if op=="const"
                push!(prog, string(var, '=', arg1))
            elseif op=="var-x"
                push!(prog, string(var, "=x"))
            elseif op=="var-y"
                push!(prog, string(var, "=y"))
            elseif op=="mul"
                push!(prog, string(var, '=',arg1,'*',arg2))
            elseif op=="add"
                push!(prog, string(var, '=',arg1,'+',arg2))
            elseif op=="sub"
                push!(prog, string(var, '=',arg1,'-',arg2))
            elseif op=="neg"
                push!(prog, string(var, "= -",arg1))
            elseif op=="max"
                push!(prog, string(var, "=ifelse(", arg1, ">", arg2, ",", arg1, ", ", arg2, ")"))
            elseif op=="min"
                push!(prog, string(var, "=ifelse(", arg1, ">", arg2, ",", arg2, ", ", arg1, ")"))
            elseif op=="square"
                push!(prog, string(var, '=', arg1, '*', arg1))
            elseif op=="sqrt"
                push!(prog, string(var, "=sqrt(",arg1,")"))
            else
                error("unknown op: $op /$line/")
            end
        end
        push!(prog, "end")
        pp = Meta.parse(join(prog, ';'))
        @eval $pp
    end
    const FUN = parseit("prospero.vm")
    function (@main)(ARGS)
        image_size = ARGS[1]
        image_size = parse(Int, image_size)
        space = range(-1.0f0, 1.0f0, image_size)
        x = T[space[j] for i in 1:image_size, j in 1:image_size]  |> device
        y = T[-space[i] for i in 1:image_size, j in 1:image_size] |> device
        out =  FUN.(x,y')
        img = ifelse.(out .< 0, UInt8(255), UInt8(0)) |> collect
        img = permutedims(img)
        open("out.ppm", "w") do f
            write(f, "P5\n$(image_size) $(image_size)\n255\n")
            write(f, vec(img))
        end
        nothing
        return nothing
    end
    function bench_proper(ARGS)
        b = @benchmark main($ARGS)
        display(b)
        return nothing
    end
    function profile_cuda(ARGS)
        display(CUDA.@profile main(ARGS))
        return nothing
    end
    export main, bench_proper, profile_cuda
end # module ProsperoChal

module ProsperoChal
    using CUDA,BenchmarkTools
    const T = Float16
    const device = CUDA.cu # use identity for cpu
    const matType = CuMatrix{T} # use Matrix{T} for cpu

    """
        Will broadcast the operation inplace if possible, otherwise will create a new array
        This is the version for two arguments operations
    """
    function double_broadcast_op!(v,op,name,args)
        if haskey(v,name)
            broadcast!(op,v[name],v[args[1]],v[args[2]])
        else
            v[name] = broadcast(op,v[args[1]],v[args[2]])
        end
        return nothing
    end
    """
        Will broadcast the operation inplace if possible, otherwise will create a new array
        This is the version for one arguments operations
    """
    function single_broadcast_op!(v,op,name,args)
        if haskey(v,name)
            broadcast!(op,v[name],v[args[1]])
        else
            v[name] = broadcast(op,v[args[1]])
        end
        return nothing
    end
    """
        Will copy the array inplace if possible, otherwise will create a new array
    """
    function copytoifexists!(v,name,x)
        if haskey(v,name)
            copyto!(v[name],x)
        else
            v[name] = x
        end
        return nothing
    end
    """
        Will change the constant matrix inplace if possible, otherwise will create a new array
    """
    function const_change!(v,name,c)
        if haskey(v,name)
            v[name] .= c
        else
            v[name] = [c;;] |> device
        end
        return nothing
    end
    """
        Will process the operation depending on the operator
    """
    function process_op!(v,op,name,args,x,y)
        if op == "var-x"
            copytoifexists!(v,name,x)
        elseif op == "var-y"
            copytoifexists!(v,name,y)
        elseif op == "const"
            const_change!(v,name,parse(T, args[1]))
        elseif op == "add"
            double_broadcast_op!(v,+,name,args) # v[args[1]] .+ v[args[2]]
        elseif op == "sub"
            double_broadcast_op!(v,-,name,args) #v[args[1]] .- v[args[2]]
        elseif op == "mul"
            double_broadcast_op!(v,*,name,args) #v[args[1]] .* v[args[2]]
        elseif op == "max"
            double_broadcast_op!(v,max,name,args) #max.(v[args[1]], v[args[2]])
        elseif op == "min"
            double_broadcast_op!(v,min,name,args) #min.(v[args[1]], v[args[2]])
        elseif op == "neg"
            single_broadcast_op!(v,-,name,args) #-v[args[1]]
        elseif op == "square"
            single_broadcast_op!(v,x->x^2,name,args) #v[args[1]].^2
        elseif op == "sqrt"
            single_broadcast_op!(v,sqrt,name,args) #sqrt.(v[args[1]])
        else
            error("unknown opcode '$op'")
        end
        return nothing
    end
    function (@main)(ARGS)
        file, image_size = ARGS
        image_size = parse(Int, image_size)
        space = range(-1.0f0, 1.0f0, image_size)
        x = T[space[j] for i in 1:image_size, j in 1:image_size]  |> device
        y = T[-space[i] for i in 1:image_size, j in 1:image_size] |> device
        v = Dict{String, matType}()
        final_key = ""
        for line in eachline(file)
            if startswith(line, "#")
                continue
            end
            tokens = split(line)
            name = tokens[1]  
            op = tokens[2]   
            args = @view(tokens[3:end])
            final_key = name  
            process_op!(v,op,name,args,x,y)
        end
        out = v[final_key]
        img = ifelse.(out .< 0, UInt8(255), UInt8(0)) |> collect
        img = permutedims(img)
        open("out.ppm", "w") do f
            write(f, "P5\n$(image_size) $(image_size)\n255\n")
            write(f, vec(img))
        end
        return nothing
    end
    function bench_proper(ARGS)
        b = @benchmark main(ARGS)
        display(b)
        return nothing
    end
    function profile_cuda(ARGS)
        display(CUDA.@profile main(ARGS))
        return nothing
    end
    export main, bench_proper, profile_cuda
end # module ProsperoChal

function create_networks(n)
    M = []
    graphs = []
    partitions = lvl2_leaf_partition(n)
    for part in partitions
        push!(M, [hybrid_vertex_mod_sym(part), part])
    end

    counter = 0
    types = [1]
    for m in M
        for (i, rec_vert) in enumerate(m[1])
            print(rec_vert, m[2], "\n")
            G = draw_network(rec_vert, m[2])
            name = string.(n)*"_"*string(counter + 1)
            G_stats = [m[2], rec_vert]
            push!(graphs, [G, name, G_stats])
            counter = counter + 1
        end
        push!(types, counter)
    end
    return graphs, types
end

function create_matrix_comparison(n)
    graphs, types = create_networks(n)
    println("We have ", length(graphs), " different networks")
    println("Starting analyzing graphs")
    [print_stats(g[1], g[2], g[3]) for g in graphs]
    println("Starting comparing")
    results = compare_networks(graphs)

    Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_data", results)

    Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_types_data", types)

    display(results)

    return results, types
end

function display_matrix(n)
    return Oscar.load("dir_project_data/network_data/"*string(n)*"_leaves_data")
end

function display_in_types(n)
    my_matrix = Oscar.load("dir_project_data/network_data/"*string(n)*"_leaves_data")
    types = Oscar.load("dir_project_data/network_data/"*string(n)*"_leaves_types_data")
    for i in 1:length(types)-1
        display(my_matrix[types[i] + 1 : types[i+1], types[i] + 1:types[i+1]])
    end
end

function network_polynomials(n)
    ideal_stats = deserialize("dir_project_data/ideal_stats")
    list_of_n_leaves = [v for (k, v) in ideal_stats if startswith(k, string(n))]
    polys = []
    for l in list_of_n_leaves
        my_ideal = Oscar.load("dir_project_data/ideals/"*l[1])
        push!(polys, [l[1], generators(my_ideal)])
    end 
    return polys
end

function network_dimensions(n)
    ideal_stats = deserialize("dir_project_data/ideal_stats")

    list_of_n_leaves = [(k, v) for (k, v) in ideal_stats if startswith(k, string(n))]

    dims = Dict{Int, Vector{String}}()

    for (k, v) in list_of_n_leaves
        push!(get!(dims, v[2], String[]), k)
    end

    return dims
end

function network_degrees(n)
    ideal_stats = deserialize("dir_project_data/ideal_stats")

    list_of_n_leaves = [(k, v) for (k, v) in ideal_stats if startswith(k, string(n))]

    degs = Dict{Int, Vector{String}}()

    for (k, v) in list_of_n_leaves
        push!(get!(degs, v[2], String[]), k)
    end

    return degs
end

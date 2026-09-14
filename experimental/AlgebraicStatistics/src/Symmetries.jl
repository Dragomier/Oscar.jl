function how_many_ideals(my_matrix)
    how_many_networks = size(my_matrix, 1)
    flags = fill(false, how_many_networks)
    ideals = Dict()
    counter = 1
    
    for i in 1:how_many_networks
        if !flags[i]
            flags[i] = true
            ideals[counter] = [i]
            for j in i+1:how_many_networks
                if !flags[j] && my_matrix[i, j] == 0
                    flags[j] = true
                    push!(ideals[counter], j)
                end
            end
            counter = counter + 1
        end
    end
    return ideals
end

function create_ideal(M)
    phi = parametrization(M)
    H = components_of_kernel(4, phi, show_progress = true)
    return Oscar.ideal(reduce(vcat, collect(values(H))))
end

function check_quartics(graphs, n_1, n_2)
    M_1 = graphs[n_1][1]
    M_2 = graphs[n_2][1]
    I_1 = create_ideal(M_1)
    I_2 = create_ideal(M_2)
    bool_1 = check_polynomials(I_1, M_2)
    print(bool_1)
    bool_2 = check_polynomials(I_2, M_1)
    print(bool_2)
    if bool_1 && bool_2
        return true
    else
        return false
    end
end

# dimensions = [check_real_dimension(graphs[i][1]) for i in 1:length(graphs)]

# for i in 45:length(graphs)
#     M = graphs[i][1]
#     name = graphs[i][2]
#     phi = parametrization(M)
#     H = components_of_kernel(2, phi, show_progress = true)
#     I = Oscar.ideal(reduce(vcat, collect(values(H))))
#     Oscar.save("dir_project_data/ideals/"*name, I)
#     println("saved")
# end
    
function print_long_values(dict)
    for (_, values) in dict
        for value in values
                println(graphs[value][3])
        end
            println("\n\n\n\n\n")
    end
end

# ideal_stats = deserialize("dir_project_data/ideal_stats")
# for i in 1:length(ideal_stats)
#     ideal_stats["7_"*string(i)] = ["7_"*string(i), -1, -1, false]
# end
# serialize("dir_project_data/ideal_stats", ideal_stats)

#########################################################################################

function calculate_symmetries(M)

    my_edges = collect(edges(M.phylo_model.graph.graph))
    G = graph_from_edges(Directed, my_edges)

    my_leaves = leaves(G)

    leaf_edges = [e for e in edges(G) if dst(e) in my_leaves]
    internal_verts = [src(e) for e in leaf_edges]

    P = collect(permutations(internal_verts))
    graphs = []

    for p in P
        my_G = copy(G)
        # usuń wszystkie krawędzie
        for e in leaf_edges
            rem_edge!(my_G, e)
        end

        # nowe krawędzie
        new_leaf_edges = [(p[i], my_leaves[i]) for i in 1:length(my_leaves)]

        for (u, v) in new_leaf_edges
            add_edge!(my_G, u, v)
        end

        N = phylogenetic_network(my_G)
        M = cavender_farris_neyman_model(N)

        push!(graphs, M)
    end

    return graphs, P
end

function make_graphs(perm)
    graphs = []
    counter = 1
    for g in perm
        push!(graphs, [g, "test26_"*string(counter), [[2,2,1], [0,0]]])
        counter = counter + 1
    end

    return graphs
end

# for i in 1:5
#     cand = []
#     for i in 23:28
#         M = graphs[i][1]
#         perm, P = calculate_symmetries(M)
#         numb = rand(1:120, 3)
#         print(i, " ", numb, "\n")
#         perm = perm[numb]
#         push!(cand, make_graphs(perm))
#     end
#     M = compare_networks(reduce(vcat, cand))
#     if count(==(0), M) == 18
#         println("true")
#     else
#         println("false")
#     end
# end

# phi = parametrization(test[3][1])
# H = components_of_kernel(2, phi, show_progress = true)
# S, x = model_ring(test[3][1])
# I_3 = ideal([gens(S)[1] - gens(S)[1]])
# if !isempty(H)
#     I_3 = Oscar.ideal(reduce(vcat, collect(values(H))))
# end

function generator_statistics(G)
    degrees = [total_degree(f) for f in G]
    nterms = [length(terms(f)) for f in G]

    return (
        number = length(G),
        degrees = Dict(d => count(==(d), degrees)
                       for d in unique(degrees)),
        terms = Dict(k => count(==(k), nterms)
                     for k in unique(nterms))
    )
end

function count_variables(generators)
    R = parent(first(generators))
    vars = gens(R)

    counts = Dict(v => 0 for v in vars)

    for f in generators
        for v in vars
            if degree(f, v) > 0
                counts[v] += 1
            end
        end
    end

    return counts
end

# R = parent(first(gens(I_3)));
# v = ones(Int, 16);
# S, y = grade(R, v);
# phi = hom(R, S, y);
#  f_new = [phi(f) for f in gens(I_3)];
# I_3g = ideal(S, f_new);
# F = free_resolution(I_3g);
# betti_table(F)

# graphs, types = create_networks(5)
# perms, p = calculate_symmetries(graphs[24][1])
# test = make_graphs(perms)
# compare_networks(test)

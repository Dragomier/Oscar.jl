n = 6
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
        name = string.(n)*"_"*string(m[2])*"_ideal_"*string(i)
        push!(graphs, [G, name])
        counter = counter + 1
    end
    push!(types, counter)
end

results = compare_networks(graphs)

Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_data", results)

Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_types_data", types)

types = Oscar.load("dir_project_data/network_data/4_leaves_types_data")

for i in 1:length(types)-1
    display(results[types[i] + 1 : types[i+1], types[i] + 1:types[i+1]])
end

types

function calculate_blocks(A)
    n = size(A, 1)
    block_size = 10

    result = similar(A)

    for i in 1:block_size:n
        for j in i:block_size:n
            results = compare_networks(graphs[i:i+block_size-1, j:j+block_size-1])

            result[i:i+block_size-1, j:j+block_size-1] = calculated_block
        end
    end

    return result
end

results = Oscar.load("dir_project_data/network_data/5_leaves_data")
for i in 2:size(results, 1)
    for j in 1:i-1
        results[i, j] = results[j, i]
    end
end

Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_data", results)

display(results)
print(types[4])

graphs[11][1].phylo_model.graph.graph
graphs[13][1].phylo_model.graph.graph

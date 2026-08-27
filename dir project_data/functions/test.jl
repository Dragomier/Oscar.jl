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
        name = string.(n)*"_"*string(i)
        G_stats = [m[2], rec_vert]
        push!(graphs, [G, name, G_stats])
        counter = counter + 1
    end
    push!(types, counter)
end

[print_stats(g[1], g[2]) for g in graphs]

println(length(graphs))

results = compare_networks(graphs)

Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_data", results)

Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_types_data", types)

types = Oscar.load("dir_project_data/network_data/5_leaves_types_data")

for i in 1:length(types)-1
    display(my_matrix[types[i] + 1 : types[i+1], types[i] + 1:types[i+1]])
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

results = Oscar.load("dir_project_data/network_data/4_leaves_data")


Oscar.save("dir_project_data/network_data/"*string(n)*"_leaves_data", results)

display(results)
print(types[4])

graphs[11][1].phylo_model.graph.graph
graphs[10][1].phylo_model.graph.graph

stats = deserialize("dir_project_data/stats")

my_ideal = stats["4_Any[2, 1, 1]_ideal_3"]

println(my_ideal[1])

my_matrix = Oscar.load("dir_project_data/network_data/5_leaves_data")
display(my_matrix)

list_of_5_leaves = [v for (k, v) in stats if startswith(k, "5")]

dims = [s[2] for s in list_of_5_leaves]

my_matrix = Oscar.load("dir_project_data/network_data/5_leaves_data")


for i in 2:size(my_matrix, 1)
    for j in 1:i-1
        my_matrix[i, j] = my_matrix[j, i]
    end
end

display(my_matrix)

my_matrix_5 = Oscar.load("dir_project_data/network_data/5_leaves_data")
display(my_matrix)


function create_ideals_catalogue(matrix, stats, graphs, n_leaves)
    flags = fill(false, size(matrix, 1)) 
    catalogue = Dict()

    for i in 1:size(matrix, 1)
        if !flags[i]
            name = graphs[i][2]
            my_ideal = stats[name]
            if my_ideal[2] == 0
                catalogue[0] = [name]
            
        for j in i+1:size(matrix, 1)

            if !flags[j]
                if matrix[i,j]

                else
            end
        end
    end
end 




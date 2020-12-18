# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:percent
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.7.1
#   kernelspec:
#     display_name: Julia 1.5.2
#     language: julia
#     name: julia-1.5
# ---

# %%
ex1 = "16
10
15
5
1
11
7
19
6
12
4"
ex1 = parse.(Int, split(ex1, '\n'));

# %%
ex2 = "28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3"
ex2 = parse.(Int, split(ex2, '\n'));

# %%
input = "77
58
25
92
14
154
105
112
147
63
84
109
24
129
49
102
130
128
134
88
95
70
80
4
153
17
145
122
39
117
93
65
3
2
139
101
148
37
27
1
87
64
23
59
42
146
43
151
116
46
115
118
131
94
19
33
12
107
10
7
73
78
53
11
135
79
60
32
141
31
140
98
136
72
38
152
30
74
106
50
13
26
155
67
20
66
91
56
34
125
52
51
18
108
57
81
119
71
144"
input = parse.(Int, split(input, '\n'));

# %% [markdown]
# # Part 1

# %%
function silly_solution(input)
    copy = input
    # add 0 as that's the outlet
    push!(copy, 0)
    # then we sort
    sort!(copy)
    diffs = []
    for index in 2:length(copy)
        [push!(diffs, i) for i in 1:3  if copy[index] - copy[index-1] == i]
    end
    ones = count(==(1), diffs, dims=1)[1]
    threes = count(==(3), diffs, dims=1)[1] + 1 
    #+1 because our adapter is always one higher
    print(ones, " one diffs, ", threes, " three diffs; product: ", ones*threes)
    return ones, threes
end

# %%
function threes_and_ones(input)
    input = cat(0, input, maximum(input)+3; dims = 1)
    input = sort(input)
    diffs = input[2:end]-input[1:end-1]
    ones = count(==(1), diffs, dims=1)[1]
    threes = count(==(3), diffs, dims=1)[1] 
    print(ones, " one diffs, ", threes, " three diffs; product: ", ones*threes)
    return ones, threes
end

# %%
threes_and_ones(ex1)

# %%
threes_and_ones(ex2)

# %%
threes_and_ones(input)

# %% [markdown]
# # Part 2

# %%
using Printf

# %%
function count_contigs_arrays_wrong(c,n)
    # c is the min length of contiguous arrays to search for
    # n is the length of the array to search in 
    count = 0 # <- equivalent to factoring out
    for i in c:n
        count += (n-i)^2 + 1
        @printf("count contig %s in %s, count: %s\n", i, n, (n-i)^2 + 1)
    end
    count
end

# %%
count_contigs_arrays_wrong(3, 6)

# %%
function count_contig_arrays(n)
    if n == 0
        return 1
    elseif n == 1
        return 1
    elseif n == 2
        return 2
    else 
        return count_contig_arrays(n-1) + count_contig_arrays(n-2) + count_contig_arrays(n-3)
    end
end

# %%
count_contig_arrays(4)

# %%
function arrangements(input)
    input = cat(0,input, maximum(input)+3; dims = 1)
    input = sort(input)
    print(input, '\n')
    # can count number of contiguous ones and to the product of the length of the contigous ones - 2
    diffs = [1] # first diff will always be reachable
    diffs = cat(diffs, input[2:end]-input[1:end-1]; dims = 1)
    # find 3s
    print(diffs,'\n')
    threes = findall(==(3), diffs)
    print(threes, '\n')
    threes = cat(1, threes; dims = 1) # gotta count diff from the first one
    print(threes, '\n')
    # you cannot actually change all the ones that are not next to 3s, imagine 3 1 1 1 1 1 1 3
    # if you were to remove the three pointed at                                   ^ ^ ^
    # then the ones right before and after could not be linked                               
    # if you change certain ones there won't be a way to connect one of the 3s
    changeable_ones = threes[2:end] - threes[1:end-1] .- 2 # .- is dotwise substraction
    # we don't care about contiguous 3 and they also return in -1s
    print(changeable_ones,'\n')
    filter!(e->e!=-1,changeable_ones)
    print(changeable_ones,'\n')
    # 2^sum(changeable_ones) <-- too broad
    result = 1
    for i in changeable_ones
       if i == 3
        result *= 2^i - 1
        else
        result *= 2^i
        end
       # i = 2, -0
       # i = 3, -1 (-1)
       # i = 4, -3 (-2)
       # i = 5, -8 (-5)
       # i = 6, -20 (-12)
       # i = 7, -39 (-19)
    end
    result
end

# %%
arrangements(ex1)

# %%
arrangements(ex2)

# %%
arrangements(input)

# %%
using Plots: plot

# %% [markdown]
# So I'm kinda mad at myself for having spent so many days at the relationships between the iput length and the count of possible sub arrays. In the end the long long input only has 3 contiguous changeable ones at most hence I can just use a lookup table, well basically I know that for 3 continuous ones there are 7 (2^3 -1) possible valid arrangements instead of 8, if it's 2 continuous ones it's just 2

# %%
plot([1:7], [2^i for i in 1:7],label =  "original exponent")
plot!([1:7], [2, 4, 7, 13, 24, 44, 89], label = "Number of valid changes") # actual value
plot!([1:7], [0, 0, 1, 3, 8, 20, 39], label = "Difference") # diff

# %%

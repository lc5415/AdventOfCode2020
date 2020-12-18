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
ex1 = "939
7,13,x,x,59,x,31,19"
ex1 = split(ex1, '\n');

# %%
input = "1000509
17,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,739,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,971,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,19";
input = split(input, '\n');



# %% [markdown]
# ## Part 1

# %%
function best_bus(input)
    min_time = parse(Int, input[1])
    buses = split(input[2], ',')
    filter!(e->e!="x",buses)
    buses = parse.(Int, buses)
    
    shortest_time = []
    for b in buses
        push!(shortest_time, b*ceil(min_time/b))
    end
    
    best_bus_index = shortest_time.==minimum(shortest_time)
    
    best_time_diff = shortest_time[best_bus_index][1] - min_time
    best_bus = buses[best_bus_index]
    
    return best_time_diff*best_bus[1]
end

# %%
best_bus(ex1)

# %%
best_bus(input)

# %% [markdown]
# ## Part 2

# %%
function find_min_bf(input; ref = "max")

    buses = split(input[2], ',')
    buses[buses.=="x"] .= "0"
    buses = parse.(Int, buses)

    if ref == "max"
        ref_num = maximum(buses)
        ref = findall(==(ref_num), buses)[1]
    else
        ref_num = buses[ref]
    end
    print(ref)
    target = (1:length(buses)).-ref
    target = target[buses.!=0]
    buses = buses[buses.!=0]
    

    print("b:", buses, "\nt:", target, '\n')

    round = 1
    ref = findall(==(ref_num), buses)[1]
    print(ref_num, '\t', ref)
 
    while true
        base = ref_num*round
        temp_res = []#[base]
        #print(base, '\n')
        for bi in 1:length(buses)
            if target[bi] < 0
                push!(temp_res, buses[bi]*floor(base/buses[bi]))
            else
                push!(temp_res, buses[bi]*ceil(base/buses[bi]))
            end
            
            if (temp_res[bi]-base) != target[bi]
                # early break, no need to compute the rest
                break
            end
        end

        if length(temp_res) != length(buses) 
            round +=1
            continue 
        else
            diff = temp_res[2:end] .- temp_res[ref]
            #print("diff: ",diff, "\t temp_res: ", temp_res, "\ttarg: ", target, "\n")
            if diff == target[2:end]
                print(temp_res, '\n')
                break
            end
            round +=1
        end
    end

    ref_num*round + target[1]
end

# %%
find_min_bf(["1", "17,x,13,19"], ref = 1)


# %%
@time find_min_bf(["1", "67,7,59,61"])

# %%
@time find_min_bf(["1", "67,7,59,61"], ref = 2)

# %%
@time find_min_bf(ex1, ref = 1)

# %%
@time find_min_bf(ex1, ref = "max")

# %% [markdown]
# Could also use the largest number as my base number and that way I would need to do much less compute. Definitely do that and run benchmark.

# %% [markdown]
# ### I can try and optimise brute force but it is still brute force

# %% [raw]
# @time find_min(input, ref = "max") ## <- dead

# %%
17*13*19

# %% [markdown]
# ## "Smarter" but not faster version

# %%
function find_min_bf_smart(input)

    buses = split(input[2], ',')
    buses[buses.=="x"] .= "0"
    buses = parse.(Int, buses)
    
    target = (1:length(buses)).-1
    target = target[buses.!=0]
    buses = buses[buses.!=0]
    
    round = 1
    ref_num = buses[1]
    while true
        base = ref_num*round
        temp_res = (base .+ target) .% buses
        if all(temp_res .== 0)
            break
        end
        round +=1
    end

    ref_num*round
end

# %%
@time find_min_bf_smart(["1", "17,x, 13,19"])

# %%
@time find_min_bf_smart(ex1) #### <-- this is not good enough

# %%
3417 % (13*17*19) # sad me

# %% [markdown]
# __`invmod` docs:__ Take the inverse of x modulo m: y such that $x y = 1 \pmod m$, with $div(x,y) = 0$. This is undefined for $m = 0$, or if $gcd(x,m) \neq 1$.
#
#

# %%
if mod(5, 3) == 5%3 
    print(5%3)
end

# %%
invmod(2,5)

# %% [markdown]
# ## Hopefully the solution

# %% [markdown]
# Given the following problem:
#
# $$
# x \equiv a_1 \bmod n_1 \\
# x \equiv a_2 \bmod n_2 \\ 
# ...\\
# x \equiv a_k \bmod n_k
# $$
#
# We first know that:
# x must belong to the series $a_1+k\cdot n_1$, where k is a natural number.
# To better understand this, let's set the example:
#
# $$
# x \equiv 0 \bmod 17 \\
# x +2 \equiv 0 \bmod 13 \\ 
# x +3 \equiv 0 \bmod 19
# $$
# which is equivalent to:
# $$
# x \equiv 0 \bmod 17 \\
# x \equiv 11 \bmod 13 \\ 
# x \equiv 16 \bmod 19
# $$
#
# We then proceed to solve the first two congruences and find the solution $x_1$. We know that $x_1$ must belong to the aritmethic series $a_1+k\cdot n_1$ and also that $a_1+k\cdot n_1 \equiv a_2 \bmod n_2$. Once we find the right k and hence to the right $x_1$ we know that x belongs to the series $x_1+k_1*n_1*n_2$, where k_1 belongs to the natural numbers too. We know this becauase all the members of this series satisfy:
# $$
# x_1 \equiv a_1 \bmod n_1 \\
# x_1 \equiv a_2 \bmod n_2 \\
# k_1*n_1*n_2 \equiv n_2 \equiv a_1 \bmod n_1 \\
# k_1*n_1*n_2 \equiv  n_1\equiv a_2 \bmod n_2
# $$
#
# Plugging in numbers, $x_1$ is 102 $(17*6$ or $13*8 +2$ $(102\%13 \equiv 2)$
# $$
# 102 \equiv 0 \bmod 17 \\
# 102 \equiv 11 \bmod 13 \\
# k_1*17*13 \equiv 0 \bmod 17 \\
# k_1*17*13 \equiv  0 \bmod 13
# $$
#
# We know that the number in that series will satisfy the previous congruences hence we only need to evaluate number in that series and do this over and over again for the consequent congruences.

# %%
function find_min_smart(input)

    buses = split(input[2], ',')
    buses[buses.=="x"] .= "0"
    buses = parse.(Int, buses)
    
    target = (1:length(buses)).-1
    target = target[buses.!=0]
    buses = buses[buses.!=0]
    
    base = 0
    multiplier = buses[1]
    tsol = 0
    for iter in 2:length(buses)
        round = 0
        while true
            tsol = base + round*multiplier
            #print(tsol, '\n')
            if (tsol + target[iter]) % buses[iter] == 0
                base = tsol
                multiplier *= buses[iter]
                #print(tsol, "\t", tsol%buses[iter], "\n\n")
                break
            end
            
            round +=1
        end    
    end
    # x_1 = a_1, a_1 + (1:k)*n_1
    # x_2 = x_1, x_1 + (1:k)*n_1*n2
    # x_3 = x_2, x_2 + (1:k)*n_1*n_2*n_3
    tsol
end

# %%
find_min_smart(["1", "17,x,13,19"])

# %%
@time find_min_smart(ex1)

# %%
@time find_min_smart(input)

# %%

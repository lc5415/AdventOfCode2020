ex1 = "0,3,6"
input = "16,1,0,18,12,14,19"

ex1 = parse.(Int, split(ex1, ','))
input = parse.(Int, split(input, ','))

# %% PART 1

function elf_game(start; end_num = 2020)
    board = copy(start)
    round = length(board)+1
    while round <= end_num # 2020
        prev = board[round-1]
        if count(==(prev), board) < 2
            push!(board, 0)
        else
            last = findall(==(prev), board)[end-1:end]
            push!(board,diff(last)[1])
        end
        round += 1
    end
    board
end

@assert elf_game(ex1)[end] == 436
@show elf_game(input)

# %% PART 2
# The trick here is that an array is inefficient, instead we can use
# a dict having as key the numbers and as value the last position it was
# seen in
function elf_game_opti(start; end_num = 2020)
    prev = start[end]
    # create dict with val as key and second_to_last, last_index and count as vals
    board = Dict(start[ind] => [ind, ind, 1] for ind in 1:length(start))
    round = length(board)+1
    while round <= end_num # 2020
        second_to_last, last, count = board[prev]
        if count < 2 # 1 then write 0
            # weird thing here
            board[0] = [board[0][2], round, board[0][3]+1]
            prev = 0
        else # otherwise write diff
            prev = last - second_to_last
            if prev in keys(board)
                board[prev] = [board[prev][2], round, board[prev][3]+1]
            else
                board[prev] = [round, round, 1]
            end

        end
        round += 1
    end
    prev
end

@time @assert elf_game_opti(ex1, end_num = 2020) == 436

@assert elf_game_opti(ex1, end_num = 30000000) == 175594

@show elf_game_opti(input, end_num = 30000000)

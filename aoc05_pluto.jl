### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ e99c8562-36eb-11eb-116a-93788694f808
md"I wanna make an ordered set and then split it recurrently base on the items in the seats string"

# ╔═╡ 2dbccca2-36ec-11eb-2040-eb462bbeaa70
seats = Array(0:127)

# ╔═╡ 39f0f016-36ec-11eb-359e-49d27d76a3a8
function half(array; lower::Bool = true)
	lower ? array[1:Int(end/2)] : array[Int(end/2):end]
end

# ╔═╡ ccdc81d0-36f4-11eb-1913-19a4a1c60db8
function half_positional(array, lower::Bool = true)
	lower ? array[1:Int(end/2)] : array[Int(end/2):end]
end

# ╔═╡ bdc2f3e2-36ee-11eb-34ca-273c041a78c9
md"Ternary operators are cool, alternatively inline `if (condition) action else action` works too [so](https://stackoverflow.com/questions/39790031/does-julia-have-a-ternary-conditional-operator/39790132)"

# ╔═╡ c7a4a70e-36ec-11eb-3af0-0f0e333b5f3d
half(seats)

# ╔═╡ e2567274-36ee-11eb-1d4e-9583e0581673
half(seats, false)

# ╔═╡ 010d589e-36f5-11eb-39ad-fb3d054412c8
md"Julia handles positional and optional arguments in a peculiar way, all arguments specified after a semi-colon (;) are optional and are give a default value. The tradeoff here is explainability vs. typing, optional arguments are not positional hence the name of the parameter/argument needs to be typed if an optional argument is passed [Julia Docs](https://docs.julialang.org/en/v1/manual/functions/#Keyword-Arguments)"

# ╔═╡ f219d46e-36f4-11eb-1651-c9199bd4d5f9
half_positional(seats, false)

# ╔═╡ e1064ad4-36f3-11eb-274d-85e1587c9812
half(seats, lower = false) ## what the fuck

# ╔═╡ 61ab7882-36f0-11eb-05fe-152865e8f96c
seat = "FBFBBFFRLR"

# ╔═╡ 65478686-36f0-11eb-0506-f9f0cee335ed
chop(seat, head = 1, tail = 0)

# ╔═╡ 99016282-36f0-11eb-305f-9517339b73a5
length(seat)

# ╔═╡ 2a9c87a4-36f1-11eb-0c55-797bcfa9490f
seat[1:7]

# ╔═╡ 3ff921b8-36f1-11eb-36e5-116818dcd26c
seat[8:end]

# ╔═╡ 92a4d27a-36f3-11eb-29bf-1b33004f8040
typeof("R")

# ╔═╡ 96955530-36f3-11eb-2aa6-99ad08e23ce1
typeof('R')

# ╔═╡ 9a6f70e6-36f3-11eb-20e7-97349ac7cf54
half(half(0:127))

# ╔═╡ 031680cc-36f8-11eb-3803-551ce07627cf
"L"=='L'

# ╔═╡ 46403500-36f8-11eb-0737-6d5ac7044dc2
md"Strings not equal to chars, noob problem coming from python and R"

# ╔═╡ ab3f19f8-36f8-11eb-30a2-453173eb5768
md"I'm a __noooob__, this was just a binary problem, I could have converted 'F's and 'R's into 1s and 'B's and 'L's into 0 separately and convert those binary numbers into integers :("

# ╔═╡ Cell order:
# ╠═e99c8562-36eb-11eb-116a-93788694f808
# ╠═2dbccca2-36ec-11eb-2040-eb462bbeaa70
# ╠═39f0f016-36ec-11eb-359e-49d27d76a3a8
# ╠═ccdc81d0-36f4-11eb-1913-19a4a1c60db8
# ╟─bdc2f3e2-36ee-11eb-34ca-273c041a78c9
# ╠═c7a4a70e-36ec-11eb-3af0-0f0e333b5f3d
# ╠═e2567274-36ee-11eb-1d4e-9583e0581673
# ╟─010d589e-36f5-11eb-39ad-fb3d054412c8
# ╠═f219d46e-36f4-11eb-1651-c9199bd4d5f9
# ╠═e1064ad4-36f3-11eb-274d-85e1587c9812
# ╠═61ab7882-36f0-11eb-05fe-152865e8f96c
# ╠═65478686-36f0-11eb-0506-f9f0cee335ed
# ╠═99016282-36f0-11eb-305f-9517339b73a5
# ╠═2a9c87a4-36f1-11eb-0c55-797bcfa9490f
# ╠═3ff921b8-36f1-11eb-36e5-116818dcd26c
# ╠═92a4d27a-36f3-11eb-29bf-1b33004f8040
# ╠═96955530-36f3-11eb-2aa6-99ad08e23ce1
# ╠═9a6f70e6-36f3-11eb-20e7-97349ac7cf54
# ╠═031680cc-36f8-11eb-3803-551ce07627cf
# ╟─46403500-36f8-11eb-0737-6d5ac7044dc2
# ╟─ab3f19f8-36f8-11eb-30a2-453173eb5768

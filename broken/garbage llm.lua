function initweights()
	weights = {}
	for i = 1, 256 do
		weights[i] = 0
	end
end 
function predict(str)
    local toret = 0
    for i = 1, #str do
        toret = toret + (string.byte(str, i, i) * weights[i])
    end

    local asciiValue = math.floor(33 + math.fmod(toret, 93))
    if asciiValue < 33 then
        asciiValue = asciiValue + 93
    end

    return string.char(asciiValue)
end

function test()
    str = "Lorem Ipsum motherfucker IDK wtf is this"
    num = math.random(#str)
    predictedchar = predict(string.sub(str, 1, num))
    correctchar = string.sub(str, num, num+1)
    
    if predictedchar and correctchar then
       local score = math.abs(predictedchar:byte() - correctchar:byte())
       return score * score
    else
        return 0
    end
end
function demo(str)
	for i = 1,100 do
		str = str .. predict(str)
	end
	print(str)
end

function train()
	epoch = 0
	while true do
		prescore = test()
		for i,v in ipairs(weights) do

			postscore = test()

			diff = prescore -postscore
			gradient = diff / math.abs(diff)
			weights[i] = weights[i] + gradient
		end
		epoch = epoch + 1
		print("Epoch #" .. epoch)
		demo("suck my")
	end

end
initweights()
train()

function initweights()
	weights = {}
	for i = 1, 768 do
		weights[i] = 0
	end
end 
function predict(str)
    if #str >= 256 then
	return ' '
    end  

    local toret = {}
    
    for i = 1, #str do
	toret[i] = 0
    end

    for i = 1, #str do
        toret[i] = toret[i] + math.floor(string.byte(str, i, i) * weights[i])
    end

    local toret2 = {}

    for i = 1, #toret do
	toret2[i] = 0
    end

    for i = 1, #toret do
        toret2[i] = toret2[i] + math.floor(toret[i] * weights[i])
    end
    
    local toret3 = 0

    for i = 1, #toret2 do
        toret3 = toret3 + math.floor(toret2[i] * weights[256 + i])
    end

    local asciiValue = 33 + math.fmod(toret3, 93)
    
    if asciiValue < 33 then
        asciiValue = asciiValue + 93
    end

    return string.char(asciiValue)
end

function test(str)
    num = math.random(#str - 1)
    predictedchar = predict(string.sub(str, 1, num))
    correctchar = string.sub(str, num+1, num+1)
    
    if predictedchar and correctchar then
       local score = math.abs(predictedchar:byte() - correctchar:byte())
	if predictedchar == string.sub(str, num, num) then
		score = score - 400
	end


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
	traindata = {"Lorem Ipsum motherf*cker, IDK why it AINT F*CKING WORKING(suck my c*ck n*gg*).","S*ck, my d*ck."}
	epoch = 0
	while true do
		prescore = test(traindata[math.random(#traindata)])
		for i,v in ipairs(weights) do

			postscore = test(traindata[math.random(#traindata)])

			diff =prescore - postscore 
			if diff ~= 0 then
				gradient = diff / math.abs(diff)
				weights[i] = weights[i] + (diff * .001)
			end

			prescore = test(traindata[math.random(#traindata)])
		end
		epoch = epoch + 1
		print("Epoch #" .. epoch)
		demo("suck my")
	end

end
initweights()
train()

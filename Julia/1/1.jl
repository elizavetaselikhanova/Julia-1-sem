# Задача 1. Робот находится в произвольной клетке огранниченого прямоугольного поля без внутренних перегородок и маркеров. 
# Итог: робот - в исходном положении в центре прямого креста из маркеров, раставленных вплоть до внешней рамки

#Перед запуском следует ввести в терминал:
# 1. using HorizonSideRobots
# 2. include("1.jl")
# 3. r=Robot("1.sit", animate=true)

function cross!(robot) #Создаем крест по условию

for side in(Nord, Ost, Sud, West)
    put_and_back!(robot, side)
end

end

function put_and_back!(robot, side) #функция, которая ставит маркеры и робот возвращается назад
    num_steps = 0
    while(!isborder(robot,side))
        move!(robot, side)
        putmarker!(robot)
        num_steps+=1
    end

    for _i in 1:num_steps
        move!(robot, inverse(side))
    end

end

function solve!(robot)
    purmarker!(robot)
    cross!(robot)
end

inverse(side::HorizonSide) = HorizonSide((Int(side) +2)%4)
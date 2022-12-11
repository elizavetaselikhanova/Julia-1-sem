# Задача 2. Робот в произвольной поля (без внутренних перегородок и маркеров)
# Итог: Робот в исходном положении, и все клетки по периметру внешней рамки промаркированы

#Перед запуском следует ввести в терминал:
# 1. >julia
# 2. using HorizonSideRobots
# 3. include("2.jl")
# 4. r=Robot("2.sit",animate=true)
# 5. solve!(r)

function find_corner!(robot) #Функция, которая ищет угол или углы

num_steps_Sud=0
num_steps_West=0

   while(!isborder(robot, Sud)) #Счет шагов по направлению в Юг
    move!(robot, Sud)
    num_steps+=1
   end

    while(!isborder(robot, Sud)) #Аналогично - счет шагов по направлению в Восток
    move!(robot, Sud)
    num_steps+=1
   end

 return num_steps_Sud, num_steps_West
end

function perimetr!(robot) #Ставим маркеры по периметру

    for side in(Nord, Ost, Sud, West)
        while(!isborder(robot,side))
            move!(robot,side)
            putmarker!(robot)

        end
    end
end

function go_home!(robot, num_Steps1, num_Steps2) #Функция, возвращащая робота домой
    for _i in 1:num_Steps2
        move!(robot, Ost)
    end

    for _i in 1:num_Steps1
        move!(robot, Nord)
    end
end

function solve!(robot)
    num_steps_Sud, num_steps_West = find_corner!(robot)
    perimetr!(robot)
    go_home!(robot, num_steps_Sud, num_steps_West)
end
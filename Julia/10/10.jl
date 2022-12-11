#Задача 10. Робот в проивзольной клетке ограниченного прямоугольного поля (без внутренних перегородок)
#Итог: Робот в исходном положении, и на всем прое расставлены маркеры в шахматном порядке с клетками размера N*N(N - параметр функции), начиная с юго-западного угла

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("10.jl")
#r=Robot("10.sit",animate=true)
#solve!(r,3)

function find_corner!(robot) #Функция, направляющая робота в угол и считающая шаги
    num_steps_Sud=0
    num_steps_West=0
    while (!isborder(robot,Sud))
        move!(robot,Sud)
        num_steps_Sud+=1
    end
    while (!isborder(robot,West))
        move!(robot,West)
        num_steps_West+=1
    end
    return num_steps_Sud, num_steps_West
end

function go_to_home!(robot,num_steps_Sud,num_steps_West) #Возвращает робота обратно(домой)
    for _i in 1:num_steps_Sud
        move!(robot,Nord)
    end
    for _i in 1:num_steps_West
        move!(robot,Ost)
    end
end

function chess!(robot,N) #Рисовать
if (N>11)
    printf("hello world")
    return
end
while (!isborder(robot,Nord))
        for _i in 1:N #Рисуем N строк 
            while (!isborder(robot,Ost))
                point!(robot,N)
                moving!(robot,N)
            end
            while (!isborder(robot,West))
                move!(robot,West)
            end
                try_move!(robot,Nord)
        end

        for _i in 1:N
            while (!isborder(robot,Ost))
                moving!(robot,N)
                point!(robot,N)
            end
            while (!isborder(robot,West))
                move!(robot,West)
            end
            try_move!(robot,Nord)
        end
end
end

function point!(robot,N) #Рисуем часть точки
        for _i in 1:N
            putmarker!(robot)
            if (try_move!(robot,Ost)==false)
                return
            end
        end
end

function moving!(robot,N) #Расстояние между частями точки
    for _i in 1:N
        try_move!(robot,Ost)
    end
end

function try_move!(robot,side)
    if (!isborder(robot,side))
        move!(robot,side)
        return true
    else
        return false
    end
end

function go_to_corner!(robot)
    while (!isborder(robot,Sud))
        move!(robot,Sud)
    end

    while (!isborder(robot,West))
        move!(robot,West)
    end
end

function solve!(robot,N::Int)
   num_steps_Sud,num_steps_West=find_corner!(robot)
   chess!(robot,N)
   go_to_corner!(robot)
   go_to_home!(robot,num_steps_Sud,num_steps_West)
end
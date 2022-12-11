#Задача 9. Робот в проивзольной клетке ограниченного прямоугольного поля (без внутренних перегородок)
#Итог: Робот в исходном положении, на всем поле расставлены маркеры в шахматном порядке, причем так, чтобы в клетке с роботом находился маркер

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("9.jl")
#r=Robot("9.sit",animate=true)
#solve!(r)


function find_corner!(robot) #Функция, позволяющая идти в угол и находить начальные координаты
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

function go_to_corner!(robot) #Функция, с помощью которой робот идет в угол
    while (!isborder(robot,Sud))
        move!(robot,Sud)
    end
    while (!isborder(robot,West))
        move!(robot,West)
    end
end


function go_to_home!(robot,num_steps_Sud,num_steps_West) #Функция, возвращаюшая робота обратно(домой)
    for _i in 1:num_steps_Sud
        move!(robot,Nord)
    end
    for _i in 1:num_steps_West
        move!(robot,Ost)
    end
end

function chess!(robot,coord_y,coord_x) #Проверка четности
    if ( (coord_x+coord_y)%2==1 )
        move!(robot,Ost)
    end
end

function snake!(robot) #Змейка
i=0  #Счётчик чётности (каждые 2 шага - ставит маркер)
    side=Ost
    while ( !isborder(robot,Nord) || !isborder(robot,inverse(side)))
        i+=along!(robot,side)
         if (!isborder(robot,Nord))
             move!(robot,Nord)
             i+=1
         end
        if (i%2==0)
            putmarker!(robot)
        else
            move!(robot,inverse(side))
            i+=1
        end
        side=inverse(side)
    end
end

function along!(robot,side) #Идёт и ставит за собой маркеры
    i=0
    while (!isborder(robot,side))
        if (i%2==0)
            putmarker!(robot)
        end
        move!(robot,side)
        i+=1
    end
    if (i%2==0)
        putmarker!(robot)
    end
    return i
end

function solve!(robot)
   num_steps_Sud, num_steps_West=find_corner!(robot)
   chess!(robot,num_steps_Sud,num_steps_West)
   snake!(robot)
   go_to_corner!(robot)
   go_to_home!(robot,num_steps_Sud,num_steps_West)
end

inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
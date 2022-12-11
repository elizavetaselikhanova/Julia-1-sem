#Задача 12. Отличается от предыдущей задачи тем, что если в перегородке имеются разрывы не более 
#одной клетки каждыйй, то такая перегородка считается одной перегородкой.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("12.jl")
#r=Robot("12.sit",animate=true)
#solve!(r)

function snake!(robot)  #Робот идет и делает проверку
    side=Ost
    k=0
    while ( !isborder(robot,Nord) || !isborder(robot,inverse(side)))
        k+=along_check!(robot,side)
        move!(robot,Nord)
        side=inverse(side)
    end
    return k
end

function check!(robot,side)::Int #Функция, проверяющая перегородки
    k=0   
    if (isborder(robot,Nord))
        while (isborder(robot,Nord))
            move!(robot,side)
        end
        try_move!(robot,side)
        if (!isborder(robot,Nord))
            k=1
        else
            k=0
        end
    end
    return k
end

function try_move!(robot,side)
    if (!isborder(robot,side))
        move!(robot,side)
    end
end

function along_check!(robot,side) #функция along с проверкой
    k=0
    while (!isborder(robot,side))
        move!(robot,side)
        k+=check!(robot,side)
    end
    return k
end


function find_corner!(robot) #Робот идет в угол и считает шаги
    num_steps_Sud=0
    num_steps_West=0
       while (!isborder(robot,West))
           move!(robot,West)
           num_steps_West+=1
       end
       while (!isborder(robot,Sud))
           move!(robot,Sud)
           num_steps_Sud+=1
       end
       return num_steps_Sud,num_steps_West
   end
   
   function go_to_corner!(robot) #Робото идет в угол 
       while (!isborder(robot,West))
           move!(robot,West)
       end
       while (!isborder(robot,Sud))
           move!(robot,Sud)
       end
   end
   
   function go_home!(robot,num_steps_Sud,num_steps_West) #Робот возвращается обратно(домой)
   
       for _i in 1:num_steps_Sud
           move!(robot,Nord)
       end
       for _i in 1:num_steps_West
           move!(robot,Ost)
       end
   end

function solve!(robot)
    num_steps_Sud,num_steps_West=find_corner!(robot)
    num_borders=0
    num_borders+=snake!(robot)
    go_to_corner!(robot)
    go_home!(robot,num_steps_Sud,num_steps_West)
    return num_borders
end

inverse(side::HorizonSide) = HorizonSide((Int(side) +2)% 4)
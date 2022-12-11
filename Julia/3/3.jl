#Задача 3. Робот в произвольной клетке ограниченного произвольного поля
#Итог: Робот в исходном положении и все клетки поля промаркированы

#Перед запуском следует ввести в терминал:
# 1. >julia
# 2. using HorizonSideRobots
# 3. include("3.jl")
# 4. r=Robot("3.sit",animate=true)
# 5. solve!(r)

function find_corner!(robot) # Функция, которая позволяет искать угол
   
    num_steps_Sud=0
    num_steps_West=0
    
        while (!isborder(robot,Sud)) #Считает кол-во шагов на Юг
            move!(robot,Sud)
            num_steps_Sud+=1
        end
    
        while (!isborder(robot,West)) #Считает кол-во шагов на Запад
            move!(robot,West)
            num_steps_West+=1
        end
     return num_steps_Sud, num_steps_West
end


function markers!(robot) #Маркеры

    putmarker!(robot)
    side=Ost

    while ( !isborder(robot,Nord) && !isborder(robot,side))

        along!(robot,side)
        move!(robot,Nord)
        putmarker!(robot)
        side=inverse(side)
        
    end

    along!(robot,side)

end

function along!(robot,side) #Ставит маркеры до упора
    while (!isborder(robot,side))
        move!(robot,side)
        putmarker!(robot)
    end

end

function go_to_corner!(robot)   #Снова ищем угол

    while (!isborder(robot,Sud))
        move!(robot,Sud)
    end

    while (!isborder(robot,West))
        move!(robot,West)
    end

end

function go_home!(robot, num_Steps1, num_steps2) #Функция возвращения домой

    for _i in 1:num_steps2
        move!(robot,Ost)
    end
    
    for _i in 1:num_Steps1
         move!(robot,Nord)
    end
    
 end

function !(robot)
    num_steps_Sud,num_steps_West=find_corner!(robot)
    all_in_markers!(robot)
    go_to_corner!(robot)
    go_home!(robot, num_steps_Sud, num_steps_West)
end

inverse(side::HorizonSide) = HorizonSide((Int(side) +2)% 4)
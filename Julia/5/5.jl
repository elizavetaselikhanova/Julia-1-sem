#Задача 5.На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. РОбот в произвольной клетке поля между вешней и внутренней перегородкой
#Итог: Робот в исходном положении и по всему периметру внутренней, как внутренней, так и внешней, перегородки поставлены маркеры.

#Перед запуском ввести в терминал:
# 1. Julia
# 2. using HorizonSideRobots
# 3. include("5.jl")
# 4. r=Robot("5.sit",animate=true)
# solve++

function find_corner!(robot) #Функция, ищущая угол

    num_steps_Sud=0
    num_steps_West=0
    
        while (!isborder(robot,Sud)) #Счет шагов на Юг
            move!(robot,Sud)
            num_steps_Sud+=1
        end
    
        while (!isborder(robot,West)) #Счет шагов на Запад
            move!(robot,West)
            num_steps_West+=1
        end
    
     return num_steps_Sud, num_steps_West
end

function perimetr!(robot) #Ставит маркеры по периметру
    
        for side in(Nord,Ost,Sud,West)
    
            while (!isborder(robot,side))
                move!(robot,side)
                putmarker!(robot)
            end
    
        end
    
end

function find2_corner!(robot) #Ищем угол во второй раз

        while (!isborder(robot,Sud))
            move!(robot,Sud)
        end
    
        while (!isborder(robot,West))
            move!(robot,West)
        end
    
end

function go_home!(robot, num_Steps1, num_steps2) #Функция возвращения робота обратно(домой)

        for _i in 1:num_steps2
            move!(robot,Ost)
        end
    
        for _i in 1:num_Steps1
            move!(robot,Nord)
        end
    
end

function find_frame!(robot) #Функция поиска рамки
    side=Ost
    while (!isborder(robot,Nord))
        along_check!(robot,side)
        if !isborder(robot,Nord)
         move!(robot,Nord)
        end
        side=inverse(side)
    end
end

function along_check!(robot,side) # Робот двигается, до тех пор, пока 'вверху' нет ничего
    while (!isborder(robot,side))
        if !isborder(robot,Nord)
             move!(robot,side)
        else
            return
        end
    end
end

function along_frame!(robot) #Маркеры вокруг рамки
    frame_side=Nord
    for _i in 1:5
        while (isborder(robot,frame_side))
            putmarker!(robot)
            move!(robot, right(frame_side))
        end
        frame_side=left(frame_side)
        putmarker!(robot)
        move!(robot,right(frame_side))
    end

end

function solve!(robot)
num_steps_Sud,num_steps_West=find_corner!(robot)
find_frame!(robot)
along_frame!(robot)
find_corner!(robot)
perimetr!(robot)
go_home!(robot, num_steps_Sud, num_steps_West)
end

right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))
left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
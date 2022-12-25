#Задача 18. Решить предыдущую задачу, но при дополнительном условии:
#а) на поле имеются внутренние изолированные прямолинейные перегородки конечной длины (только прямолинейных, прямоугольных перегородок нет);
#б) некоторые из прямолинейных перегородок могут быть полубесконечными.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("18.jl")
#r=Robot("18.1.sit",animate=true)
#solve_1!(r)
#r=Robot("18.2.sit",animate=true)
#solve_2!(r)

# a
function spiral_1!(stop_condition::Function, robot) #Робот идет по спирали и ищет маркер.
    n=0 #счетчик шагов
    side=Nord
    while !stop_condition()
        n+=1
        for _i in 1:2 #2 раза выполняется код ниже
        along_1!(robot,side,n,stop_condition)
        side=left(side)
        end
    end
end

function along_1!(robot,side,n,stop_condition::Function) #Робот делает n шагов (проверяет n раз маркер и идет).
    for _i in 1:n
        if (!stop_condition())
            wall_recursion!(robot,side)
        end
    end
end


function wall_recursion!(robot,side) #Рекурсивный способ обхода стены.
    if (isborder(robot,side))
        move!(robot,right(side))
        wall_recursion!(robot,side)
        move!(robot,inverse(right(side)))
    else
        move!(robot,side)
    end

end

# b
function  shuttle!(stop_condition::Function, robot, side) #Функция челнок(шаг вправо, шаг влево, два вправо, возвращение на позицию, два влево)
    n=0 
    start_side=side #начальная сторона
while !stop_condition() #если робот наткнется сразу на маркер, конец программы
 n += 1
 along_shuttle!(robot, right(side), n,()->!isborder(robot,start_side))
 side = inverse(side)
 if (stop_condition())
    break
 end
 along_shuttle!(robot,right(side),2n,()->!isborder(robot,start_side))
 side=inverse(side)
 if (stop_condition())
    break
 end
 along_shuttle!(robot,right(side),n,()->!isborder(robot,start_side))
end
if (n!=0)
    move!(robot,start_side)
    for _i in 1:n
        move!(robot,(right(side)))
    end
end
if (n==0)
    move!(robot,start_side)
end
end

function  along_shuttle!(robot, side, n,stop_condition::Function) #н шагов и ищет пустое место(выход)   
for _i in 1:n
    if (!stop_condition())
    move!(robot,side)
    end
end
end


function spiral_2!(stop_condition::Function, robot) #Вторая спираль
n=0
side=Nord
while !stop_condition()
    n+=1
    for _i in 1:2
    along!(robot,side,n,stop_condition)
    side=left(side)
    end
end
end

function along!(robot,side,n,stop_condition::Function) #Через шаттл. Делает n шагов и если стена то вызывает шаттл.
for _i in 1:n
    if !stop_condition()
    shuttle!(()->!isborder(robot,side),robot,side)
    end
end
end

function solve_1!(robot)
spiral_1!(()->ismarker(robot),robot)
end

function solve_2!(robot)
spiral_2!(()->ismarker(robot),robot)
end

right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))
left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))

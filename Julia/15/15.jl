#Решить задачу 7 с использованием обобщенной функции.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("15.jl")
#r=Robot("15.sit",animate=true)
#solve!(r)

function cross!(robot) #Функция, ставящая крест
    putmarker!(robot)
        for (side1,side2) in  ( (Nord,Ost),(Nord,West),(Sud,Ost),(Sud,West) )
        diagonal_along!(robot,side1,side2)
        end
end


function diagonal_along!(robot, side1, side2) #Робот идет по диагонали и ставет маркеры
  x=y=0
  while try_move_along!(robot,side1,side2)
    x+=1
  end
  for i in 1:x
    move_recursion!(robot,inverse(side1))
    move_recursion!(robot,inverse(side2))
  end
end


function try_move_along!(robot,side1,side2) #Диагональный along 
    if (try_move!(robot,side1))
        if (try_move!(robot,side2))
            putmarker!(robot)
            return true
        else
            move!(robot,inverse(side1))
        end
    end
    if (try_move!(robot,side2))
        if (try_move!(robot,side1))
             putmarker!(robot)
                return true
        else
            move!(robot,inverse(side2))
            return false
        end
    else
        return false
    end
       
end


function move_recursion!(robot,side) #Рекурсивный способ обхода стены
    if (isborder(robot,side))
        move!(robot,right(side))
        move_recursion!(robot,side)
        move!(robot,inverse(right(side)))
    else
        move!(robot,side)
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


function solve!(robot)
   cross!(robot)
end


inverse(side::HorizonSide) = HorizonSide((Int(side) +2)% 4)
right(side::HorizonSide) = HorizonSide((Int(side) +3)% 4)
left(side::HorizonSide) = HorizonSide((Int(side) +1)% 4)
#Задача 20. Написать рекурсивную функцию, перемещающую робота до упора в заданном направлении, ставящую возле перегородки маркер и возвращающую робота в исходное положение.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("20.jl")
#r=Robot("20.sit",animate=true)
#moving_recursion!(r,Ost)

function moving_recursion!(robot,side)  #Рекурсивным методом идет до стены, ставит маркер и идет обратно.
    if (isborder(robot, side))
        putmarker!(robot)
    else
        move!(robot, side)
        moving_recursion!(robot, side)
        move!(robot, inverse(side))
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side) +2)% 4)

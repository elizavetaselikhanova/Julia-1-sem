#Задача 19. Написать рекурсивную функцию, перемещающую робота до упора в заданном направлении.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("19.jl")
#r=Robot("19.sit",animate=true)
#solve!(r,Ost)

function move_recursion!(robot,side) #Идет рекурсивно и до упора
    if (!isborder(robot,side))
        move!(robot,side)
        move_recursion!(robot,side)
    end
end


function solve!(robot,side)
   move_recursion!(robot,side)
end
#Задача 17. Решить предыдущую задачу 8 с использованием обобщенной программы. 

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("17.jl")
#r=Robot("17.sit",animate=true)
#solve!(r)

function spiral!(stop_condition::Function, robot) #идет по спирали и ищет маркеры
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
 
 function along!(robot,side,n,stop_condition::Function) #Шаг, ищет маркер и так далее
    for _i in 1:n
        if !stop_condition()
        move!(robot,side)
        end
    end
 end
 
 
 function solve!(robot)
 spiral!(()->ismarker(robot),robot)
 end
 
 left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))
